`timescale 1ns / 1ps
`default_nettype none

module updowncounter(
    input wire clock,
    input wire countup,
    input wire paused,
    output wire [31:0] value
    );
    
    logic [50:0] count = 0;
    
    always_ff @(posedge clock)
    begin
        if (~paused)
            count <= (countup) ? count + 1 : count - 1;
    end
    
    assign value = count[50:19];
    
endmodule