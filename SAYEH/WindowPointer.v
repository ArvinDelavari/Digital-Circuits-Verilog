//----------------------------------------------------------------------
//--SAYEH(Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
//Window Pointer

`timescale 1 ns /1 ns

module WindowPointer (in, clk, WPreset, WPadd, out);
input [2:0] in;
input clk, WPreset, WPadd;
output [2:0] out;
reg [2:0] out;

	always @(negedge clk)
		if (WPreset == 1) out = 0;
		else if (WPadd == 1) begin
			out = out + in;
		end

endmodule