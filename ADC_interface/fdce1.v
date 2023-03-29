`timescale 1ns / 1ps

module fdce1(q,clk,ce,reset,d);

    input d,clk,ce,reset;
    output reg q;
    initial begin 
      q=0; 
    end
    always @ (negedge (clk)) begin
    if (reset)
      q <= 1'b0;
    else if (ce)
      q <= d;
    else 
    q<= q ;
end

endmodule