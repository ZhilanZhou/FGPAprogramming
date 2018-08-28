`timescale 1ns / 1ps
`default_nettype none

module hexcounterdisplay(
    input wire clock,
    output logic [7:0] segments,
    output logic [7:0] digitselect = ~(8'b0000_0001)
);

    logic [3:0] value;
    counter1second C(clock, value);
    hexto7seg H(value, segments);
    
endmodule