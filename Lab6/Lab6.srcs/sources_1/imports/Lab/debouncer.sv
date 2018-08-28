//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// 3/4/2016
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module debouncer #(parameter N=20)(
    input wire raw,
    input wire clock,
    output logic clean = 0
    );

	logic [N:0] count;
	
	always_ff @(posedge clock) begin
		count <= (raw != clean)  ? count + 1 : 0 ;
		clean <= (count[N] == 1) ? raw : clean ;
	end
	
endmodule
