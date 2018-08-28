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
   parameter Dbits = 32         
)(
   input wire clk,
   input wire reset,
   input wire enable,
   output logic [31:0] pc = 32'h0040_0000,
   input wire [31:0] instr,
   
   input wire [1:0] pcsel,
   input wire [1:0] wasel,
   input wire sext, 
   input wire bsel,
   input wire [1:0] wdsel,
   input wire [4:0] alufn,
   input wire werf,
   input wire [1:0] asel,
   output wire Z,

   output wire [31 : 0] mem_addr,
   output wire [Dbits-1 : 0] mem_writedata,
   input wire [Dbits-1 : 0] mem_readdata
   );

    wire [31:0] pcPuls4;
    wire [31:0] newpc;
    wire [15:0] Imm;                    
    wire [31:0] signImm;  
    wire [Dbits-1:0] ReadData1, ReadData2;     
    logic [Dbits-1:0] reg_writedata;
    logic [4:0] reg_writeaddr; 
    wire [Dbits-1:0] aluA, aluB;
    wire [Dbits-1:0] alu_result;
    wire [Dbits-1:0] BT;
    
    
    assign pcPuls4 = pc + 3'b100;
    assign newpc = (pcsel == 2'b11) ? ReadData1: 
                   (pcsel == 2'b10) ? {pc[31:28],instr[25:0],2'b00}:
                   (pcsel == 2'b01) ? BT:
                   pcPuls4; 
                   
    always_ff @(posedge clk)
        if (enable)
            pc <= (reset)? 32'h400000 : newpc;

    assign reg_writeaddr = (wasel == 2'b10) ? 5'b11111 :
                           (wasel == 2'b01) ? instr[20:16] :
                           instr[15:11];
    register_file #(Nloc, Dbits) r(clk, enable, werf, instr[25:21], instr[20:16], reg_writeaddr,
                     reg_writedata, ReadData1, ReadData2);
     
    assign mem_writedata = ReadData2;   
    assign Imm = instr[15:0];
    
    assign aluA = (asel == 2'b10) ? {5'b10000} : 
                  (asel == 2'b01) ? instr[10:6]: ReadData1;
    assign aluB = (bsel == 1'b1) ? signImm : ReadData2;               
    assign signImm = (sext == 1 & Imm[15] == 1) ?
                     {16'b1111111111111111, Imm} : {16'b0, Imm};
                     
    wire FlagN, FlagC, FlagV;           
    addsub bqeadder(pcPuls4, (signImm << 2), 1'b0, BT, FlagN, FlagC, FlagV);
        
    ALU #(32) alu(aluA, aluB, alu_result, alufn, Z);
       
    assign mem_addr = alu_result;
     
    assign reg_writedata = (wdsel == 2'b10) ? mem_readdata :
                           (wdsel == 2'b01) ? alu_result : pcPuls4;
                            
endmodule
