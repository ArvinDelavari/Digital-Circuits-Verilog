`include "ALU.v"
`timescale 1ns / 1ps  

module ALU_tb;

 reg[31:0] A,B;
 reg[3:0] select;
 wire[31:0] out;
 wire carry;
 integer i;

 ALU test_unit(
               A,B,     // ALU 32-bit Inputs                 
               select,  // ALU Selection
               out,     // ALU 32-bit Output
               carry    // Carry Out Flag
              );

    initial begin

      $dumpfile("ALU.vcd");
      $dumpvars(0,ALU_tb);
      
      A = 32'h001A;
      B = 32'h00B2;
      select = 4'h0;

      for (i=0 ; i<=15 ; i = i+1)
      begin
       #10;
       select = select + 8'h01;
       #10;
      end;

      A = 32'h00F6;
      B = 32'h000A;  
    end
endmodule