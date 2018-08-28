`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2017 03:04:03 PM
// Design Name: 
// Module Name: datapath
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


module datapath #(             
   parameter Nloc = 32,        
   parameter Dbits = 8         
)(
   input wire clock,
   input wire RegWrite,
   input wire [$clog2(Nloc)-1 : 0] ReadAddr1,
   input wire [$clog2(Nloc)-1 : 0] ReadAddr2,
   input wire [$clog2(Nloc)-1 : 0] WriteAddr,
   input wire [4:0] ALUFN,
   input wire [Dbits-1 : 0] WriteData,		
   output wire [Dbits-1 : 0] ReadData1,
   output wire [Dbits-1 : 0] ReadData2,
   output wire [Dbits-1 : 0] ALUResult,
   output wire FlagZ
   );

	register_file #(Nloc, Dbits) registers(clock, RegWrite, ReadAddr1, ReadAddr2, WriteAddr, WriteData, ReadData1, ReadData2);
	ALU #(Dbits) alu_unit(ReadData1, ReadData2, ALUResult, ALUFN, FlagZ);

endmodule
