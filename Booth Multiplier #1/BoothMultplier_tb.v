`include "BoothMultplier.v"

module BoothMultplier_tb;

reg clk,rst,start;
reg signed [3:0]X,Y;
wire signed [7:0]Z;
wire valid;

always #5 clk = ~clk;

BoothMultplier BM1(clk,rst,start,X,Y,valid,Z);

initial
      $monitor($time,"X=%d, Y=%d, valid=%d, Z=%d ",X,Y,valid,Z);
initial
      begin
            $dumpfile("BoothMultplier.vcd");
            $dumpvars(0,BoothMultplier_tb);
            X = 5;Y = 7;clk = 1'b1;rst = 1'b0;start = 1'b0;
            #10 rst = 1'b1;
            #10 start = 1'b1;
            #10 start = 1'b0;
            @valid
            #10 X=-4;Y=6;start = 1'b1;
            #10 start = 1'b0;
      end      
endmodule