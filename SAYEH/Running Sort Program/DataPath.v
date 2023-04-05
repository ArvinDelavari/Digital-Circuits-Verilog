//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
// Data Path 

`timescale 1 ns /1 ns

module DataPath (
	clk, Databus, Addressbus, 
    ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
    Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
    B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
    RFLwrite, RFHwrite,
    WPreset, WPadd, IRload, SRload, 
    Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
    Cset, Creset, Zset, Zreset, Shadow, 

    Instruction, Cout, Zout
);
input clk;
inout [15:0] Databus;
output [15:0] Addressbus;
input 
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
	B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
	RFLwrite, RFHwrite,
	WPreset, WPadd, IRload, SRload, 
	Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
	Cset, Creset, Zset, Zreset, Shadow;
output [15:0] Instruction;
output Cout, Zout;

wire [15:0] Right, Left, OpndBus, ALUout, IRout, Address, AddressUnitRSideBus;
wire SRCin, SRZin, SRZout, SRCout;  
wire [2:0] WPout;
wire 
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
	B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
	RFLwrite, RFHwrite,
	WPreset, WPadd, IRload, SRload, 
	Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
	Cset, Creset, Zset, Zreset, Shadow;
wire [1:0] Laddr, Raddr;

	AddressingUnit AU (
		AddressUnitRSideBus, IRout[7:0], Address, clk, ResetPC, PCplusI, PCplus1, RplusI, Rplus0, EnablePC
	);
	
	ArithmeticUnit AL (
		Left, OpndBus, B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
		ALUout, SRCout, SRZin, SRCin
	);

	RegisterFile RF (
		Databus, clk, Laddr, Raddr, WPout, RFLwrite, RFHwrite, Left, Right
	);

	InstrunctionRegister IR (Databus, IRload, clk, IRout);

	StatusRegister SR (SRCin, SRZin, SRload, clk, Cset, Creset, Zset, Zreset, SRCout, SRZout);

	WindowPointer WP (IRout[2:0], clk, WPreset, WPadd, WPout);

	assign AddressUnitRSideBus = 
		(Rs_on_AddressUnitRSide) ? Right : (Rd_on_AddressUnitRSide) ? Left : 16'bZZZZZZZZZZZZZZZZ;

	assign Addressbus = Address;
	
	assign Databus = 
		(Address_on_Databus) ? Address : (ALU_on_Databus) ? ALUout : 16'bZZZZZZZZZZZZZZZZ;
	
	assign OpndBus[07:0] = IR_on_LOpndBus == 1 ? IRout[7:0] : 8'bZZZZZZZZ;

	assign OpndBus[15:8] = IR_on_HOpndBus == 1 ? IRout[7:0] : 8'bZZZZZZZZ;

	assign OpndBus = RFright_on_OpndBus == 1 ? Right : 16'bZZZZZZZZZZZZZZZZ;

	assign Zout = SRZout;

	assign Cout = SRCout;

	assign Instruction = IRout[15:0];

	assign Laddr = (~Shadow) ? IRout[11:10] : IRout[3:2];

	assign Raddr = (~Shadow) ? IRout[09:08] : IRout[1:0];

endmodule