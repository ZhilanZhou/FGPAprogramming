//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// 9/28/2017 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module seebounce(
    input wire X,
    input wire clock,
    output wire [7:0] segments,
    output wire [7:0] digitselect
    );


    // For Part 1, uncomment the two lines below to include a debouncer
     wire cleanX;
     debouncer #(20) d(X, clock, cleanX);    // Choose parameter N appropriately
    // Use cleanX instead of X below to increment numBounces


   logic [31:0] numBounces = 0;

   always_ff @(posedge cleanX)
      numBounces <= numBounces + 1'b 1;    // Let's count number of bounces

   display8digit mydisplay(numBounces, clock, segments, digitselect);
		
endmodule
