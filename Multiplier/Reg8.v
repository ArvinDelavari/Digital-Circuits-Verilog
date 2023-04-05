`timescale 1ns/100ps

module Reg8 ( d_in, clk, en, d_out );
   input [7:0] d_in;
   input clk, en;
   output [7:0] d_out;
   reg [7:0] d_out;
   
   always @( posedge clk )
      if (en) d_out = d_in;
   
endmodule