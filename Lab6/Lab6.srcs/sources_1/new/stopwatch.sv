`timescale 1ns / 1ps
`default_nettype none

module stopwatch(
        input wire clock,
        input wire BTNU, BTNC, BTND,
        output wire [7:0] segments,
        output wire [7:0] digitselect
        );
        
        wire up, center, down;
        wire countup, paused;
        wire [31:0] value;
        
        debouncer deUp(BTNU, clock, up);
        
        debouncer deDown(BTND, clock, down);
                
        debouncer deCenter(BTNC, clock, center);
        
        fsm fsm(clock, up, center, down, countup, paused);
         
        updowncounter counter(clock, countup, paused, value);
         
        display8digit display(value, clock, segments, digitselect);
         
endmodule