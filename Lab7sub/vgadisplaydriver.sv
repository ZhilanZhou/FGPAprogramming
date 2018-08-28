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
   parameter NlocC = 1200,        
   parameter DbitsC = 4,
   parameter NlocB = 1024,
   parameter DbitsB = 12         
)(
    input wire clock,
    input wire [DbitsC-1 : 0] CharCode,
    output wire [$clog2(NlocC)-1 : 0] ScreenAddr,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );

   wire activevideo;
   wire [$clog2(NlocB)-1 : 0] BitmapAddr;
   wire [11:0] rgb;
   wire [`xbits-1:0] x;
   wire [`ybits-1:0] y;
   
   vgatimer myvgatimer(clock, hsync, vsync, activevideo, x, y);
   
   assign ScreenAddr = (y[`ybits-1:4] << 3) + (y[`ybits-1:4] << 5) + x[`xbits-1:4];
   
   assign BitmapAddr = {CharCode, y[3:0], x[3:0]};
   
   bitmapmem bmem(clock, 1'b0, BitmapAddr, 12'b0, rgb);
   
   assign red[3:0]   = (activevideo == 1) ? rgb[11:8] : 4'b0;
   assign green[3:0] = (activevideo == 1) ? rgb[7:4] : 4'b0;
   assign blue[3:0]  = (activevideo == 1) ? rgb[3:0] : 4'b0;

endmodule
