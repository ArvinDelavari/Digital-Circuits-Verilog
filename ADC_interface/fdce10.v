`timescale 1ns / 1ps

`include "fdce1.v"

module fdc10(a,clk,en,reset,y);
	input [9:0] a;
	input clk,en,reset;
	output [9:0] y;

	fdce1 d1(y[0],clk,en,reset,a[0]);
	fdce1 d2(y[1],clk,en,reset,a[1]);
	fdce1 d3(y[2],clk,en,reset,a[2]);
	fdce1 d4(y[3],clk,en,reset,a[3]);
	fdce1 d5(y[4],clk,en,reset,a[4]);
	fdce1 d6(y[5],clk,en,reset,a[5]);
	fdce1 d7(y[6],clk,en,reset,a[6]);
	fdce1 d8(y[7],clk,en,reset,a[7]);
	fdce1 d9(y[8],clk,en,reset,a[8]);
	fdce1 d10(y[9],clk,en,reset,a[9]);

endmodule