`include "mux_4to1.v"
module tb_4t01_mux;
      reg [3:0] a;
      reg [3:0] b;
      reg [3:0] c;
      reg [3:0] d;
      wire [3:0] out;
      reg [1:0] sel;
      integer i;
      mux_4to1 mux0(.a (a),
                    .b (b),
                    .c (c),
                    .d (d),
                    .sel (sel),
                    .out (out));
      
      initial begin

            $dumpfile("mux_4to1.vcd");
            $dumpvars(0,tb_4t01_mux);

            sel <= 0;
            a <= $random;
            b <= $random; 
            c <= $random;
            d <= $random;

            for (i = 1; i < 4; i=i+1) begin
                  #5 sel <= i;
            end
            #5 $finish;
      end
endmodule