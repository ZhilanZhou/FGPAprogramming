//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/9/2017
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module imem #(
   parameter Nloc = 64,                      // Number of memory locations
   parameter Dbits = 32,                      // Number of bits in data
   parameter initfile = "...  .mem"          // Name of file with initial values
)(
   input wire [$clog2(Nloc)+1 : 0] pc,
   output logic [Dbits-1 : 0] instr           // Data read from memory (asynchronously, i.e., continuously)
   );

   logic [Dbits-1 : 0] mem [Nloc-1 : 0];     // The actual storage where data resides
   initial $readmemh(initfile, mem, 0, Nloc-1); // Initialize memory contents from a file

   assign instr = mem[pc[$clog2(Nloc)+1:2]];                  // Memory read: read continuously, no clock involved

endmodule