`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2017 11:01:57 PM
// Design Name: 
// Module Name: xycounter
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


module xycounter #(parameter width=2, height=2) (
    input wire clock,
    input wire enable,
    output logic [$clog2(width)-1:0] x = 0,
    output logic [$clog2(height)-1:0] y = 0
    );
    
    always_ff @(posedge clock) begin
        if(enable)
            x <= x==(width-1) ? 0 : x+1;
        if(enable)
            y <= (x==(width-1)) ? (y==(height-1) ? 0 : y+1) : y;
    end
endmodule
