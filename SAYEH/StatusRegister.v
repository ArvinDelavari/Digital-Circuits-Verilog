//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
//Status Register

`timescale 1 ns /1 ns

module StatusRegister (Cin, Zin, SRload, clk, Cset, Creset, Zset, Zreset, Cout, Zout);
input Cin, Zin, Cset, Creset, Zset, Zreset;
input SRload, clk;
output Cout, Zout;
reg Cout, Zout;

	always @(negedge clk) 
		if (SRload == 1) begin
			Cout = Cin;
			Zout = Zin;
		end else if (Cset)
			Cout = 1;
		else if (Creset)
			Cout = 0;
		else if (Zset)
			Zout = 1;
		else if (Zreset)
			Zout = 0;

endmodule