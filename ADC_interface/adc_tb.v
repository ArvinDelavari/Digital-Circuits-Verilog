`timescale 1ns / 1ps

`include "ADC_top.v"

module ADC_tb;
 
	// Inputs
	reg clk;
	reg enable;
	reg ADC_out;
	reg I1;
	reg I2;
	reg I3;
	// Outputs
	wire conv;
	wire done;
	wire ADC_in;
	wire ADCclk;
	wire [9:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	ADC_top uut (
		.clk(clk), 
		.enable(enable),
		.I1(I1),	
		.I2(I2),	
		.I3(I3),		
		.conv(conv), 
		.done(done), 
		.ADC_in(ADC_in), 
		.ADC_out(ADC_out), 
		.ADCclk(ADCclk),
		.data_out(data_out)
	);
	always #5 clk = ~clk;
	initial begin
		$dumpfile("ADC.vcd");
		$dumpvars(0, ADC_tb);
		// Initialize Inputs
		clk = 0;
		enable = 1;
		ADC_out = 0;
		I1 = 0;
		I2 = 0;
		I3 = 0;
		// Wait 100 ns for global reset to finish
		#100;
		ADC_out = 0;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 0;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 0;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 0;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 0;
		#10;
		ADC_out = 0;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 0;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 0;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 0;
		#10;
		ADC_out = 1;
		#10;
		ADC_out = 0;
		
		$dumpoff;
		#100 $finish;

	end
endmodule
