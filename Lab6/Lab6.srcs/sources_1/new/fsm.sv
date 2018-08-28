//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// 9/28/2017 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module fsm(
    input wire clock,
//    input wire RESET,                     // Comment this line out if no RESET input
    input wire up, center, down,         // List of inputs to FSM
    output logic countup, paused    // List of outputs of FSM
                                          // The outputs must be synthesized as combinational logic!
    );


      // The next line is our state encoding
      // You enumerate states, and the compiler decides state encoding

    enum { COUNTUP, COUNTDN, PAUSEUP, PAUSEDN,
           PAUSINGUP, RESUMINGUP, PAUSINGDN, RESUMINGDN } state, next_state;

        // Instantiate the state storage elements (flip-flops)
    always_ff @(posedge clock)
//      if (RESET == 1) state <= STATE_??;    // Remove the "if" part if no RESET input
        state <= next_state;


        // Define next_state logic => combinational
        // Every case must either be a conditional expression
        //   or an "if" with a matching "else"
    always_comb     
      case (state)
            COUNTUP: next_state <= (center == 1) ? PAUSINGUP  : ((down == 1) ? COUNTDN : COUNTUP );
            PAUSEUP: next_state <= (center == 1) ? RESUMINGUP : ((down == 1) ? PAUSEDN : PAUSEUP );
            COUNTDN: next_state <= (center == 1) ? PAUSINGDN  : ((up == 1) ? COUNTUP : COUNTDN );
            PAUSEDN: next_state <= (center == 1) ? RESUMINGDN : ((up == 1) ? PAUSEUP : PAUSEDN );
            PAUSINGUP: next_state <= (center == 0) ? PAUSEUP : PAUSINGUP;
            RESUMINGUP: next_state <= (center == 0) ? COUNTUP : RESUMINGUP;
            PAUSINGDN: next_state <= (center == 0) ? PAUSEDN : PAUSINGDN;
            RESUMINGDN: next_state <= (center == 0) ? COUNTDN : RESUMINGDN;
            default: next_state <= PAUSEUP;
      endcase



        // Define output logic => combinational
        // Every case must either be a conditional expression
        //   or an "if" with a matching "else"
    always_comb     
      case (state)
            COUNTUP: begin countup <= 1; paused <= 0; end
            PAUSEUP: begin countup <= 1; paused <= 1; end
            COUNTDN: begin countup <= 0; paused <= 0; end
            PAUSEDN: begin countup <= 0; paused <= 1; end
            PAUSINGUP: begin countup <= 1; paused <= 1; end
            RESUMINGUP: begin countup <= 1; paused <= 0; end
            PAUSINGDN: begin countup <= 0; paused <= 1; end
            RESUMINGDN: begin countup <= 0; paused <= 0; end
            default: begin countup <= 1; paused <= 1; end
      endcase

endmodule