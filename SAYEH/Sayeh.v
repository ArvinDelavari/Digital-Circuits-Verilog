//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
//SAYEH

`timescale 1 ns /1 ns

module Sayeh (
	clk,
	ReadMem, WriteMem, ReadIO, WriteIO,
	Databus,
	Addressbus,
	ExternalReset, MemDataready
);
input clk;
output ReadMem, WriteMem, ReadIO, WriteIO;
inout [15: 0] Databus;
output [15: 0] Addressbus;
input ExternalReset, MemDataready;

//----------------------------------------------------------------------
wire[15:0] Instruction;
wire
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
	B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
	RFLwrite, RFHwrite, 
	WPreset, WPadd, IRload, SRload, 
	Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
	Cset, Creset, Zset, Zreset, Shadow,
	Cflag, Zflag;  

	DataPath dp (
		clk, Databus, Addressbus, ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
		Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
		B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
		RFLwrite, RFHwrite,
		WPreset, WPadd, IRload, SRload, 
		Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
		Cset, Creset, Zset, Zreset, Shadow,
		Instruction, Cflag, Zflag
	);

	controller ctrl (
		ExternalReset, clk,
		ResetPC, PCplusI, PCplus1, RplusI, Rplus0, 
		Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC, 
		B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
		RFLwrite, RFHwrite,
		WPreset, WPadd,IRload, SRload, 
		Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
		ReadMem, WriteMem,ReadIO, WriteIO, Cset, Creset, Zset, Zreset, Shadow, 
		Instruction, Cflag, Zflag, MemDataready
	);

endmodule