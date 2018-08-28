`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2017 12:07:07 AM
// Design Name: 
// Module Name: counter4digit
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


module counter8(
    input wire clock,
    output wire [31:0] value
    );
        
    logic [50:0] totalValue = 0;
    always_ff @(posedge clock) begin
        totalValue <= totalValue + 1;
    end   
    assign value = totalValue[50:19];
endmodule
