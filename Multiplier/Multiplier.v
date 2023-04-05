`timescale 1ns/100ps

`include "Datapath.v"
`include "Controller.v"

module Multiplier ( clk, start, databus, lsb_out, msb_out, done );
   input clk, start;
   inout [7:0] databus;
   output done, lsb_out, msb_out;

   wire clr_P, load_P, load_B, msb_out, lsb_out, sel_sum, load_A, Shift_A;
   
   datapath dpu( clk, clr_P, load_P, load_B,
                 msb_out, lsb_out, sel_sum, load_A, Shift_A, databus, A0 );
                 
   controller cu( clk, start, A0, clr_P, load_P, load_B,
                  msb_out, lsb_out, sel_sum, load_A, Shift_A, done );

endmodule