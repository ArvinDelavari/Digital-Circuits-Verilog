// RS Flip Flop - testbench
// Sequential Logic in Verilog test code
// Computer Organization - IUST 2023

`include "RS_FlipFlop.v"

module RS_FlipFlop_tb;
      reg R_in, S_in, CLK_in;
      wire Q_out, QB_out;

      RS_FlipFlop RSFF1(S_in, R_in, CLK_in, Q_out, QB_out);

      initial begin
            CLK_in = 1;
            forever #1 CLK_in = ~CLK_in;
      end

      initial
            begin
            $dumpfile("RS_FlipFlop.vcd");
            $dumpvars(0,RS_FlipFlop_tb);
            S_in = 1; R_in = 0;
            #10
            S_in = 1; R_in = 1;
            #10
            S_in = 0; R_in = 1;
            #10
            S_in = 1; R_in = 1;
            #10
            S_in = 0; R_in = 0;
            #10
            $finish;
            end
endmodule