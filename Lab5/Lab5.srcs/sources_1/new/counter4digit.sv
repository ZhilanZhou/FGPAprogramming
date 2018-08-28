`timescale 1ns / 1ps
`default_nettype none


module counter4digit(
    input wire clock,
    output wire [7:0] segments,
    output wire [7:0] digitselect
    );
    
    wire [15:0] value;
    counter C(clock, value);
    display4digit D(value, clock, segments, digitselect);
    
endmodule
