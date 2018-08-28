`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2017 03:05:00 PM
// Design Name: 
// Module Name: comparision
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


module comparator(
    input wire FlagN, FlagC, FlagV, bool0,
    output wire comparison
    );
    
    assign comparison = bool0 ? ~FlagC : (FlagN ^ FlagV);
    
endmodule
