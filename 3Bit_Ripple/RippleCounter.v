`timescale 1ns/1ns
module ripple_counter(
      input clk_in, reset_in, 
      output reg [2:0] Q_out);

      always @(negedge clk_in) 
      begin
            if (reset_in == 1)
            begin
              Q_out = 3'b000;
            end
            else
            begin
              Q_out = Q_out + 1;
            end
      end
endmodule