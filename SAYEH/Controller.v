//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
//Controller

`timescale 1 ns /1 ns

module controller (
	ExternalReset, clk,
    ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
    Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC, 
    B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
    RFLwrite, RFHwrite,
    WPreset, WPadd, IRload, SRload, 
    Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
    ReadMem, WriteMem, ReadIO, WriteIO, Cset, Creset, Zset, Zreset, Shadow,
	Instruction,
	Cflag, Zflag, memDataReady
);

input ExternalReset, clk;
output
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC, 
    B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
    RFLwrite, RFHwrite,
    WPreset, WPadd, IRload, SRload, 
    Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
    ReadMem, WriteMem, ReadIO, WriteIO, Cset, Creset, Zset, Zreset, Shadow;
reg
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC, 
    B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
    RFLwrite, RFHwrite,
    WPreset, WPadd, IRload, SRload, 
    Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus,IR_on_HOpndBus, RFright_on_OpndBus,
    ReadMem, WriteMem, ReadIO, WriteIO, Cset, Creset, Zset, Zreset, Shadow;
    
input[15:0] Instruction;
input Cflag, Zflag, memDataReady;

parameter [3:0]
	reset = 0,
	halt = 1,
	fetch = 2,
	memread = 3,
	exec1 = 4,
	exec2 = 5,
	exec1lda = 6,
	exec2lda = 7,
	incpc = 8;

parameter b0000 = 4'b0000;
parameter b1111 = 4'b1111;

parameter nop = 4'b0000;
parameter hlt = 4'b0001;
parameter szf = 4'b0010;
parameter czf = 4'b0011;
parameter scf = 4'b0100;
parameter ccf = 4'b0101;
parameter cwp = 4'b0110;
parameter jpr = 4'b0111;
parameter brz = 4'b1000;
parameter brc = 4'b1001;
parameter awp = 4'b1010;

parameter mvr = 4'b0001;
parameter lda = 4'b0010;
parameter sta = 4'b0011;
parameter inp = 4'b0100;
parameter oup = 4'b0101;
parameter anl = 4'b0110;
parameter orr = 4'b0111;
parameter nol = 4'b1000;
parameter shl = 4'b1001;
parameter shr = 4'b1010;
parameter add = 4'b1011;
parameter sub = 4'b1100;
parameter mul = 4'b1101;
parameter cmp = 4'b1110;

parameter mil = 2'b00;
parameter mih = 2'b01;
parameter spc = 2'b10;
parameter jpa = 2'b11;

reg[3:0] Pstate, Nstate;

wire ShadowEn = ~(Instruction[7:0] == 8'b00001111);

//--------------------------------------------------------------------


	always @ (Instruction or Pstate or ExternalReset or Cflag or Zflag or memDataReady)
	begin    
		ResetPC 			   = 1'b0;
		PCplusI 			   = 1'b0;
		PCplus1 			   = 1'b0;
		RplusI 				   = 1'b0;
		Rplus0  			   = 1'b0;
		EnablePC 			   = 1'b0;
		B15to0 				   = 1'b0;
		AandB 				   = 1'b0;
		AorB 				   = 1'b0;
		notB 				   = 1'b0;
		shrB 				   = 1'b0;
		shlB 				   = 1'b0;
		AaddB  				   = 1'b0;
		AsubB 				   = 1'b0;
		AmulB  				   = 1'b0;
		AcmpB  				   = 1'b0;
		RFLwrite			   = 1'b0;
		RFHwrite 			   = 1'b0;
		WPreset				   = 1'b0;
		WPadd				   = 1'b0;
		IRload 				   = 1'b0;
		SRload  			   = 1'b0;
		Address_on_Databus 	   = 1'b0;
		ALU_on_Databus 		   = 1'b0;
		IR_on_LOpndBus 		   = 1'b0;
		IR_on_HOpndBus		   = 1'b0;
		RFright_on_OpndBus 	   = 1'b0;
		ReadMem 			   = 1'b0;
		WriteMem 			   = 1'b0;
		ReadIO 				   = 1'b0;
		WriteIO 			   = 1'b0;
		Shadow				   = 1'b0;
		Cset				   = 1'b0;
		Creset				   = 1'b0;
		Zset				   = 1'b0;
		Zreset				   = 1'b0;
		Rs_on_AddressUnitRSide = 1'b0;
		Rd_on_AddressUnitRSide = 1'b0;

		case (Pstate)
		reset : // 0000
			if(ExternalReset == 1'b1) begin
				WPreset = 1'b1;
				ResetPC = 1'b1;
				EnablePC=1'b1;
				Creset = 1'b1;
				Zreset = 1'b1;
				Nstate = reset;
			end
			else
				Nstate = fetch;

		halt : // 0001
			if(ExternalReset == 1'b1)
				Nstate = fetch;
			else
				Nstate = halt;

		fetch : // 0010
			if(ExternalReset == 1'b1)
				Nstate = reset;
			else begin
				ReadMem = 1'b1;
				Nstate = memread;
			end 

		memread : // 0011
			if(ExternalReset == 1'b1)
				Nstate = reset;
			else begin
				if (memDataReady == 1'b0) begin
					ReadMem = 1'b1;
					Nstate = memread;
				end
				else begin   
					IRload = 1'b1;   
					Nstate = exec1;
				end
			end

		exec1 : // 0100
			if(ExternalReset == 1'b1)
				Nstate = reset;
			else begin
				case (Instruction[15:12])
				b0000 :
					case (Instruction[11:8]) 
					nop :
						if (ShadowEn==1'b1)  
							Nstate = exec2;
						else begin
							PCplus1 = 1'b1;
							EnablePC=1'b1;
							Nstate = fetch;
						end

					hlt :
						Nstate = halt;

					szf : begin
						Zset = 1'b1;
						if (ShadowEn==1'b1)  
							Nstate = exec2;
						else begin
							PCplus1 = 1'b1;
							EnablePC=1'b1;
							Nstate = fetch; 
						end
					end

					czf : begin
						Zreset = 1'b1;
						if (ShadowEn==1'b1)  
							Nstate = exec2;
						else begin
							PCplus1 = 1'b1;
							EnablePC=1'b1;
							Nstate = fetch; 
						end
					end

					scf : begin
						Cset = 1'b1;
						if (ShadowEn==1'b1)  
							Nstate = exec2;
						else begin
							PCplus1 = 1'b1;
							EnablePC=1'b1;
							Nstate = fetch; 
						end
					end

					ccf : begin
						Creset = 1'b1;
						if (ShadowEn==1'b1)  
							Nstate = exec2;
						else begin
							PCplus1 = 1'b1;
							EnablePC=1'b1;
							Nstate = fetch; 
						end
					end

					cwp : begin
						WPreset = 1'b1;
						if (ShadowEn==1'b1)  
							Nstate = exec2;
						else begin
							PCplus1 = 1'b1;
							EnablePC=1'b1;
							Nstate = fetch; 
						end
					end

					jpr : begin
						PCplusI = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch;
					end

					brz : begin
						if(Zflag == 1'b1) begin
							PCplusI = 1'b1;
							EnablePC=1'b1;
						end
						else begin
							PCplus1 = 1'b1;
							EnablePC=1'b1;
						end
						Nstate = fetch;
					end

					brc : begin
						if(Cflag == 1'b1) begin 
							PCplusI = 1'b1;
							EnablePC=1'b1;
						end
						else begin
							PCplus1 = 1'b1;
							EnablePC=1'b1;
						end  
						Nstate = fetch;
					end

					awp : begin
						PCplus1 = 1'b1;
						EnablePC = 1'b1;
						WPadd = 1'b1;
						Nstate = fetch;
					end

					default: begin
						PCplus1 = 1'b1;
						EnablePC = 1'b1;
						Nstate = fetch;
					end
					endcase

				mvr : begin
					RFright_on_OpndBus = 1'b1;
					B15to0 = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end
				end

				lda : begin
					Rplus0 = 1'b1;
					Rs_on_AddressUnitRSide = 1'b1;
					ReadMem = 1'b1;
					Nstate = exec1lda;
				end

				sta : begin
					Rplus0 = 1'b1;
					Rd_on_AddressUnitRSide = 1'b1;
					RFright_on_OpndBus = 1'b1;
					B15to0 = 1'b1;
					ALU_on_Databus = 1'b1;
					WriteMem = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else
						Nstate = incpc; 
				end

				inp : begin
					Rplus0 = 1'b1;
					Rs_on_AddressUnitRSide = 1'b1;
					ReadIO = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else
						Nstate = incpc; 
				end

				oup : begin
					Rplus0 = 1'b1;
					Rd_on_AddressUnitRSide = 1'b1;
					B15to0 = 1'b1;
					ALU_on_Databus = 1'b1;
					WriteIO = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else
						Nstate = incpc; 
				end

				anl : begin
					RFright_on_OpndBus = 1'b1;
					AandB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end
				end

				orr : begin
					RFright_on_OpndBus = 1'b1;
					AorB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end
				end

				nol : begin
					RFright_on_OpndBus = 1'b1;
					notB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end
				end

				shl : begin
					RFright_on_OpndBus = 1'b1;
					shlB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end
				end

				shr : begin
					RFright_on_OpndBus = 1'b1;
					shrB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end
				end

				add : begin
					RFright_on_OpndBus = 1'b1;
					AaddB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end
				end

				sub : begin
					RFright_on_OpndBus = 1'b1;
					AsubB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end
				end

				mul : begin
					RFright_on_OpndBus = 1'b1;
					AmulB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end
				end

				cmp : begin
					RFright_on_OpndBus = 1'b1;
					AcmpB = 1'b1;
					SRload = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end
				end

				b1111 :
					case (Instruction[9: 8]) 
					mil : begin
						IR_on_LOpndBus = 1'b1;
						ALU_on_Databus = 1'b1;
						B15to0 = 1'b1;
						RFLwrite = 1'b1;
						SRload = 1'b1;
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch;
					end

					mih : begin
						IR_on_HOpndBus = 1'b1;
						ALU_on_Databus = 1'b1;
						B15to0 = 1'b1;
						RFHwrite = 1'b1;
						SRload = 1'b1;
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch;
					end

					spc : begin
						PCplusI = 1'b1;
						EnablePC = 1'b0;
						Address_on_Databus = 1'b1;
						RFLwrite = 1'b1;
						RFHwrite = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch;
					end

					jpa : begin
						Rd_on_AddressUnitRSide = 1'b1;
						RplusI = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch; 
					end

					default:
						Nstate = fetch;
					endcase

				default :
					Nstate = fetch;
				endcase
			end 

		exec1lda : 
			if(ExternalReset == 1'b1)
				Nstate = reset;
			else begin
				if (memDataReady == 1'b0) begin
					Rplus0 = 1'b1;
					Rs_on_AddressUnitRSide = 1'b1;
					ReadMem = 1'b1;
					Nstate = exec1lda;
				end
				else begin  
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					if (ShadowEn==1'b1)  
						Nstate = exec2;
					else begin
						PCplus1 = 1'b1;
						EnablePC=1'b1;
						Nstate = fetch;
					end
				end
			end

		exec2 : begin // 0101
			Shadow=1'b1;
			if(ExternalReset == 1'b1)
				Nstate = reset;
			else begin
				case (Instruction[7:4])
				b0000 :
					case (Instruction[3: 0]) 
					hlt :
						Nstate = halt;

					szf : begin
						Zset = 1'b1;
						PCplus1 = 1'b1;
						EnablePC = 1'b1;
						Nstate = fetch;
					end

					czf : begin
						Zreset = 1'b1;
						PCplus1 = 1'b1;
						EnablePC = 1'b1;
						Nstate = fetch; 
					end

					scf : begin
						Cset = 1'b1;
						PCplus1 = 1'b1;
						EnablePC = 1'b1;
						Nstate = fetch; 
					end

					ccf : begin
						Creset = 1'b1;
						PCplus1 = 1'b1;
						EnablePC = 1'b1;
						Nstate = fetch; 
					end

					cwp : begin
						WPreset = 1'b1;
						PCplus1 = 1'b1;
						EnablePC = 1'b1;
						Nstate = fetch; 
					end

					default : begin
						PCplus1 = 1'b1;
						EnablePC = 1'b1;
						Nstate = fetch;
					end
					endcase
				mvr : begin
					RFright_on_OpndBus = 1'b1;
					B15to0 = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch; 
				end

				lda : begin
					Rplus0 = 1'b1;
					Rs_on_AddressUnitRSide = 1'b1;
					ReadMem = 1'b1;
					Nstate = exec2lda;
				end

				sta : begin
					Rplus0 = 1'b1;
					Rd_on_AddressUnitRSide = 1'b1;
					RFright_on_OpndBus = 1'b1;
					B15to0 = 1'b1;
					ALU_on_Databus = 1'b1;
					WriteMem = 1'b1;
					Nstate = incpc; 
				end

				inp : begin
					Rplus0 = 1'b1;
					Rs_on_AddressUnitRSide = 1'b1;
					ReadIO = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					Nstate = incpc; 
				end

				oup : begin
					Rplus0 = 1'b1;
					Rd_on_AddressUnitRSide = 1'b1;
					B15to0 = 1'b1;
					ALU_on_Databus = 1'b1;
					WriteIO = 1'b1;
					Nstate = incpc; 
				end

				anl : begin
					RFright_on_OpndBus = 1'b1;
					AandB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch; 
				end

				orr : begin
					RFright_on_OpndBus = 1'b1;
					AorB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch; 
				end

				nol : begin
					RFright_on_OpndBus = 1'b1;
					notB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch; 
				end

				shl : begin
					RFright_on_OpndBus = 1'b1;
					shlB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch; 
				end

				shr : begin
					RFright_on_OpndBus = 1'b1;
					shrB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch; 
				end

				add : begin
					RFright_on_OpndBus = 1'b1;
					AaddB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch; 
				end

				sub : begin
					RFright_on_OpndBus = 1'b1;
					AsubB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch; 
				end

				mul : begin
					RFright_on_OpndBus = 1'b1;
					AmulB = 1'b1;
					ALU_on_Databus = 1'b1;
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					SRload = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch; 
				end

				cmp : begin
					RFright_on_OpndBus = 1'b1;
					AcmpB = 1'b1;
					SRload = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch; 
				end

				default:
					Nstate = fetch;

				endcase
			end
		end

		exec2lda : begin
			Shadow=1'b1;
			if(ExternalReset == 1'b1)
				Nstate = reset;
			else begin
				if (memDataReady == 1'b0) begin
					Rplus0 = 1'b1;
					Rs_on_AddressUnitRSide = 1'b1;
					ReadMem = 1'b1;
					Nstate = exec2lda;
				end
				else begin   
					RFLwrite = 1'b1;
					RFHwrite = 1'b1;
					PCplus1 = 1'b1;
					EnablePC = 1'b1;
					Nstate = fetch;
				end
			end
		end

		incpc : begin
			PCplus1 = 1'b1;
			EnablePC = 1'b1;
			Nstate = fetch;
		end
		
		default:  Nstate = reset;

		endcase
	end

	always @ (negedge clk)
		Pstate = Nstate;

endmodule