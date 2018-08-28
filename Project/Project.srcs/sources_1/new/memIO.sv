`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2017 11:43:07 AM
// Design Name: 
// Module Name: memIO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memIO #(
    parameter Nloc = 64,
    parameter Dbits = 32, 
    parameter dmem_init = "...  .mem",
    parameter smem_init = "...  .mem")(
    
    input wire clk, 
    input wire mem_wr, 
    
    input wire [31:0] mem_addr, 
    input wire [31:0] mem_writedata, 
    output wire [31:0] mem_readdata, 
    input wire [10:0] screen_addr,
    output wire [3:0] charcode,
   
    input wire [31:0] keyb_char,
    //Accel
    input wire [8:0] accelX,
    input wire [8:0] accelY,
    //Sound
    output logic [31:0] period = 0,
    output wire audEn,
        
    output logic [15:0] lights = 0
    );
    
    wire dmem_wr, smem_wr, lights_wr, sound_wr;
    
    wire [31:0] temp_mem_readdata, to_mips_charcode;
    wire [31:0] accel;
    assign accel = {7'b0, accelX, 7'b0, accelY};
    
    assign mem_readdata = (mem_addr[17:16] == 2'b11) ? (
                         (mem_addr[3:2] == 2'b01) ? accel : 
                         (mem_addr[3:2] == 2'b00) ? keyb_char :
                         32'b0):
                         (mem_addr[17:16] == 2'b10) ? to_mips_charcode :
                         (mem_addr[17:16] == 2'b01) ? temp_mem_readdata :
                         32'b0;
                         
    assign dmem_wr = (mem_wr && mem_addr[16] && ~mem_addr[17]) ? 1'b1 : 1'b0;
    assign smem_wr = (mem_wr && mem_addr[17] && ~mem_addr[16]) ? 1'b1 : 1'b0;
    assign lights_wr = (mem_wr && mem_addr[16] && mem_addr[17] && mem_addr[2] && mem_addr[3]) ? 1'b1 : 1'b0;
    assign sound_wr = (mem_wr && mem_addr[16] && mem_addr[17] && ~mem_addr[2] && mem_addr[3]) ? 1'b1 : 1'b0;
    
    screenmem #(1200, 4, smem_init) scrmem(clk, smem_wr, screen_addr, mem_addr, mem_writedata, charcode, to_mips_charcode);
    dmem #(Nloc, Dbits, dmem_init) datamem(clk, dmem_wr, mem_addr, mem_writedata, temp_mem_readdata);
    
    always_ff @(posedge clk)
       if(lights_wr)
          lights <= mem_writedata[15:0];
    
    always_ff @(posedge clk)
       if(sound_wr)
          period <= mem_writedata;
    assign audEn = |period;
    
endmodule
