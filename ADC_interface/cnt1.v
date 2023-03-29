`timescale 1ns / 1ps

module cnt1(out,data,load,en,clk,tc,lmt);
  output [31:0] out;
  output reg tc;
  input [31:0] data;
  input load, en, clk;
  reg [31:0] out;
  parameter reset=0;
  input [31:0]lmt;
  initial begin out=32'b0;
  tc=0; end
  always @(negedge clk)
  if (reset) begin
    out <= 32'b0 ;
  end else if (load) begin
    out <= data;
  end else if (en)
    out <= out + 32'b00000000000000000000000000000001;
  else out <= out;
  always @(posedge clk)
  if (out ==lmt)
  tc<=1;
  else tc<=0;
endmodule 