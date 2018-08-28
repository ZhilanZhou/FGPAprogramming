`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2017 12:24:00 AM
// Design Name: 
// Module Name: counter
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


module counter(
    input wire clock,
    output wire [15:0] value
    );
        
    logic [38:0] totalValue = 0;
    always_ff @(posedge clock) begin
        totalValue <= totalValue + 1;  
    end   
    assign value = totalValue[38:23];
endmodule
