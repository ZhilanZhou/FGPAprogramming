`timescale 1ns / 1ps
`default_nettype none


module counter8digit(
    input wire clock,
    output wire [7:0] segments,
    output wire [7:0] digitselect
    );
    
    wire [31:0] value;
    counter8 C(clock, value);
    display8digit D(value, clock, segments, digitselect);
endmodule
