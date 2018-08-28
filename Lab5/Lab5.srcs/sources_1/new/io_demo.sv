`timescale 1ns / 1ps
`default_nettype none

module io_demo(
    input wire clock,
    
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
    
    output logic [15:0] LED
    );
    
    wire [31:0] keyb_char;
    keyboard keyb(clock, ps2_clk, ps2_data, keyb_char);
    
    assign audEn = 1;
    // These are periods (in units of 10 ns) for the notes on the normal C4 scale,
    //   i.e.:  C4, D4, E4, F4, G4, A4, B4, C5
    wire [31:0] notes_periods[0:7] = {382219, 340530, 303370, 286344, 255102, 227273, 202478, 191113};
    
    // cycle through note 0 to 7, over and over, in approx. 1 sec increments
    wire [31:0] period;
    
    assign period = 
                    keyb_char == 32'h0000001C ? notes_periods[3'b000]
                  : keyb_char == 32'h0000001B ? notes_periods[3'b001]
                  : keyb_char == 32'h00000023 ? notes_periods[3'b010]
                  : keyb_char == 32'h0000002B ? notes_periods[3'b011]
                  : keyb_char == 32'h00000034 ? notes_periods[3'b100]
                  : keyb_char == 32'h00000033 ? notes_periods[3'b101]
                  : keyb_char == 32'h0000003B ? notes_periods[3'b110]
                  : keyb_char == 32'h00000042 ? notes_periods[3'b111]
                  : 32'h00000000;
    
    montek_sound_Nexys4 snd(
       clock,             // 100 MHz clock
       period,          // sound period in tens of nanoseconds
                        // period = 1 means 10 ns (i.e., 100 MHz)      
       audPWM);
       
    wire [8:0] accelX, accelY;
    wire [11:0] accelTmp;
    accelerometer accel(clock, aclSCK, aclMOSI, aclMISO, aclSS, accelX, accelY, accelTmp);
    
    assign LED = accelY < 9'd32 ? 16'b0000000000000001
               : accelY < 9'd64 ? 16'b0000000000000010
               : accelY < 9'd96 ? 16'b0000000000000100
               : accelY < 9'd128 ? 16'b0000000000001000
               : accelY < 9'd160 ? 16'b0000000000010000
               : accelY < 9'd192 ? 16'b0000000000100000
               : accelY < 9'd224 ? 16'b0000000001000000
               : accelY < 9'd256 ? 16'b0000000010000000
               : accelY < 9'd288 ? 16'b0000000100000000
               : accelY < 9'd320 ? 16'b0000001000000000
               : accelY < 9'd352 ? 16'b0000010000000000
               : accelY < 9'd384 ? 16'b0000100000000000
               : accelY < 9'd416 ? 16'b0001000000000000
               : accelY < 9'd448 ? 16'b0010000000000000
               : accelY < 9'd480 ? 16'b0100000000000000
               : 16'b1000000000000000;
 
endmodule
