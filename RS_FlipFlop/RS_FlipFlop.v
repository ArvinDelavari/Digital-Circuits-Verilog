// RS Flip Flop
// Sequential Logic in Verilog test code
// Computer Organization - IUST 2023

`timescale 1ns/1ns

module RS_FlipFlop(S,R,CLK,Q,QB);
      input S,R,CLK;
      output reg Q,QB;

      always @(posedge CLK) 
      begin
      if ((S == 1) & (R == 0))
            begin
            Q <= 1;
            QB <= !Q;
            end
      else if ((S == 0) & (R == 1))
            begin
            Q <= 0;
            QB <= !Q;
            end
      else if ((S == 0) & (R == 0))
            begin
            Q <= Q;
            QB <= !Q;
            end
      else if ((S == 1) & (R == 1))
            begin
            Q <= 0;
            QB <= !Q;
            end
      end
endmodule