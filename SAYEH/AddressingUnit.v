//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
// Addressing Unit

`timescale 1 ns /1 ns

module AddressingUnit (
	Rside, Iside, Address, clk, ResetPC, PCplusI, PCplus1, RplusI, Rplus0, PCenable
);
input [15:0] Rside;
input [7:0] Iside;
input ResetPC, PCplusI, PCplus1, RplusI, Rplus0, PCenable;
input clk;
output [15:0] Address;
wire [15:0] PCout;

	ProgramCounter PC (Address, PCenable, clk, PCout);
	AddressLogic AL (PCout, Rside, Iside, Address, ResetPC, PCplusI, PCplus1, RplusI, Rplus0);

endmodule