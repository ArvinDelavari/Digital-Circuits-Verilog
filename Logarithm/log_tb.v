`include "log.v"
`timescale 1ns / 1ps

module log_tb;
	// Inputs
	reg [13:0] x0;
	reg clk;
	reg reset;
	reg start;
	// Outputs
	wire [13:0] xf;
	wire [13:0] yf;
	// Instantiate the Unit Under Test (UUT)
	log uut (
		.x0(x0), 
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.xf(xf), 
		.yf(yf)
	);

	always #5 clk = ~clk;
	
	initial begin
		$dumpfile("logarithm.vcd");
		$dumpvars(0,log_tb);
		// Initialize Inputs
		x0 = 0;
		clk = 0;
		reset = 1;
		start = 0;
		// Wait 100 ns for global reset to finish
		#104.5;
        	x0 = 14'b0000_1011100000;
		start = 1;
		reset = 0;
		#10;
		start = 0;
		#10 $finish;
	end     
endmodule