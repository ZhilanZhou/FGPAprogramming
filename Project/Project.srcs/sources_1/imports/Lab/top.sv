//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 11/3/2017 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter imem_init="imem1.mem", 	        // use this line for synthesis/board deployment
    //parameter imem_init="imem_etchasketch.mem",
    //parameter imem_init="imem_screentest.mem",  // use this line for simulation/testing
    parameter dmem_init="dmem1.mem",          // file to initialize data memory
    //parameter dmem_init="dmem_etchasketch.mem",
    parameter smem_init="smem.mem", 	        // file to initialize screen memory
    parameter bmem_init="bmem.mem" 	        // file to initialize bitmap memory
)(
    input wire clk, reset,
    				// add I/O signals here
    input wire X[0],
    // UART pins
    input wire UART_RX,
    output wire UART_TX,
    input wire UART_CTS,
    output wire UART_RTR,
    
    //Keyboard
    input wire ps2_data,
    input wire ps2_clk,
        
    //Accel
    output wire aclSCK,
    output wire aclMOSI,
    input wire aclMISO,
    output wire aclSS,
    
    //Sound
    output wire audPWM,
    output wire audEn,
        
    output wire [15:0] LED,
    
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue,
    output wire hsync,
    output wire vsync						// incl. VGA signals
);
   wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr;
   wire mem_wr;
   wire clk100, clk50, clk25, clk12;

   wire [10:0] smem_addr;
   wire [3:0] charcode;
   wire [31:0] keyb_char;
   wire [31:0] period;
   wire [8:0] accelX, accelY;
   wire [11:0] accelTmp;
   wire enable = 1'b1;			// we will use this later for debugging

   // Uncomment *only* one of the following two lines:
   //    when synthesizing, use the first line
   //    when simulating, get rid of the clock divider, and use the second line
   //
   clockdivider_Nexys4 clkdv(clk, clk100, clk50, clk25, clk12);   // use this line for synthesis/board deployment
   //assign clk100=clk; assign clk50=clk; assign clk25=clk; assign clk12=clk;  // use this line for simulation/testing

   // For synthesis:  use an appropriate clock frequency(ies) below
   //   clk100 will work for hardly anyone
   //   clk50 or clk 25 should work for the vast majority
   //   clk12 should work for everyone!  I'd say use this!
   //
   // Use the same clock frequency for the MIPS and data memory/memIO modules
   // The VGA display and 8-digit display should keep the 100 MHz clock.
   // For example:
   
   wire wr_imem;
   wire [2:0] p_state;
   wire [31:0] addr_imem, data_imem;
   
   mips mips(clk12, reset, enable, pc, instr, mem_wr, mem_addr, mem_writedata, mem_readdata);
   imem #(.Nloc(256), .Dbits(32), .initfile(imem_init)) imem(clk12, pc[31:0], instr, wr_imem, addr_imem, data_imem);
   
   programloader p(clk12, X[0], UART_RX, UART_TX, UART_CTS, UART_RTR, wr_imem, addr_imem, data_imem, p_state);
   memIO #(.Nloc(1024), .Dbits(32), .dmem_init(dmem_init), .smem_init(smem_init)) memIO(clk12, mem_wr, mem_addr, mem_writedata, mem_readdata, smem_addr, charcode, keyb_char, accelX, accelY, period, audEn, LED);
   vgadisplaydriver #(bmem_init) display(clk100, charcode, smem_addr, red, green, blue, hsync, vsync);
   
   keyboard keyboard(clk100, ps2_clk, ps2_data, keyb_char);
   
   accelerometer accel(clk100, aclSCK, aclMOSI, aclMISO, aclSS, accelX, accelY, accelTmp);
   
   montek_sound_Nexys4 snd(
          clk100,             // 100 MHz clock
          period,          // sound period in tens of nanoseconds
                           // period = 1 means 10 ns (i.e., 100 MHz)      
          audPWM);
   

endmodule