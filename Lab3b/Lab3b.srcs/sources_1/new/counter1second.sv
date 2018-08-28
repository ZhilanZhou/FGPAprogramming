`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2017 05:02:24 PM
// Design Name: 
// Module Name: counter1second
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


module counter1second(
    input wire clock,
    output logic [3:0] value = 0
    );
    
    logic [31:0] totalValue = 0;
    always_ff @(posedge clock) begin
        totalValue <= totalValue + 1;
        value <= totalValue[30:27];
    end
    endmodule
