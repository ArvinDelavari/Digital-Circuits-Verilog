`timescale 1ns/100ps
`include "Reg8.v"
`include "Add8.v"
`include "Mux8.v"
`include "Shift8.v"
`include "Tri8.v"

module datapath ( clk, clr_P, load_P, load_B, msb_out, 
                  lsb_out, sel_sum, load_A, shift_A, data, A0 );
   input clk, clr_P, load_P, load_B, msb_out, lsb_out, sel_sum, load_A, shift_A;
   inout [7:0] data;
   output A0;
   
   wire [7:0] B, P, sum, ShiftAdd;
   wire co;
   
   Reg8 latch_B ( data, clk, load_B, B );
   
   Add8 add_PB ( P, B, 1'b0, sum, co );
   
   Mux8 P_or_sum ( P, sum, sel_sum, clr_P, ShiftAdd );
   
   Reg8 latch_P ( {co&sel_sum,ShiftAdd[7:1]}, clk, load_P, P );
   
   Shift8 latch_A_shift ( clk, ShiftAdd[0], load_A, shift_A, lsb_out, A0, data );
   
   Tri8 buffer ( P, msb_out, data );
            
endmodule