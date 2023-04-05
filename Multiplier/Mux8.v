`timescale 1ns/100ps

module Mux8 ( a, b, sel, zero, y );
   input [7:0] a, b;
   input sel, zero;
   output [7:0] y;

   assign y = zero ? 8'h0 : ( ~sel ? a : b );
   
endmodule