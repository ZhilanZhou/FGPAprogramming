//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 9/12/2017 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"

module vgadisplaydriver#(
   parameter bitmap_init="bmem_screentest.mem"                  
)(
    input wire clock,
    input wire [3 : 0] CharCode,
    output wire [10 : 0] ScreenAddr,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );

   wire activevideo;
   wire [11 : 0] bmem_addr;
   wire [11:0] bmem_color;
   wire [`xbits-1:0] x;
   wire [`ybits-1:0] y;
   
   vgatimer myvgatimer(clock, hsync, vsync, activevideo, x, y);
   
   assign ScreenAddr = (y[`ybits-1:4] << 3) + (y[`ybits-1:4] << 5) + x[`xbits-1:4];
   
   assign bmem_addr = {CharCode, y[3:0], x[3:0]};
   
   bitmapmem #(2048, 12, bitmap_init) bmem(clock, 1'b0, bmem_addr, 12'b0, bmem_color);
   
   assign red[3:0]   = (activevideo == 1) ? bmem_color[11:8] : 4'b0;
   assign green[3:0] = (activevideo == 1) ? bmem_color[7:4] : 4'b0;
   assign blue[3:0]  = (activevideo == 1) ? bmem_color[3:0] : 4'b0;

endmodule
