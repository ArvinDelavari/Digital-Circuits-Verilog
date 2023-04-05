`timescale 1ns/100ps

module Tri8 ( d_in, en, d_out );
   input [7:0] d_in;
   input en;
   output [7:0] d_out;
   
   assign d_out = en ? d_in : 8'hzz;

endmodule