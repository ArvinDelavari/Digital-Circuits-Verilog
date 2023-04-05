//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
// Address Logic

`timescale 1 ns /1 ns

module AddressLogic (
	PCside, Rside, Iside, ALout, ResetPC, PCplusI, PCplus1, RplusI, Rplus0
);
input [15:0] PCside, Rside;
input [7:0] Iside;
input ResetPC, PCplusI, PCplus1, RplusI, Rplus0;
output [15:0] ALout;
reg [15:0] ALout;

	always @(PCside or Rside or Iside or ResetPC or PCplusI or PCplus1 or RplusI or Rplus0)
		case ({ResetPC, PCplusI, PCplus1, RplusI, Rplus0})
			5'b10000: ALout = 0;
			5'b01000: ALout = PCside + Iside;
			5'b00100: ALout = PCside + 1;
			5'b00010: ALout = Rside + Iside;
			5'b00001: ALout = Rside;
			default: ALout = PCside;
		endcase

endmodule