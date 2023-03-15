`include "RippleCounter.v"
module ripple_counter_tb;

      reg clk_in, reset_in;
      wire [2:0] Q_out;

      ripple_counter rc1 (clk_in, reset_in, Q_out);  
      initial begin
            clk_in =1;
            forever #1 clk_in = ~clk_in;
      end

      initial 
            begin
                  $dumpfile("RippleCounter.vcd");
                  $dumpvars(0, RippleCounter_tb);
                  #1 reset_in = 1;
                  #1 reset_in = 0;
                  #10
                  #1 reset_in = 1;
                  #1 reset_in = 0;
                  #20
                  $finish;
            end
endmodule