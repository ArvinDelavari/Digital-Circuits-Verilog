module MemoryModel(clk, memRead, memWrite, addrBus, dataBus);

	input clk;
	input memRead, memWrite;

	input [15: 0] addrBus;

	inout [15: 0] dataBus;

	reg [15: 0] data[0: 4095];
	reg [15: 0] midData;

	reg dirty;
	reg [3:0] prePage;
	
	integer i, file;
	wire [11: 0] midAddr;

	assign midAddr = addrBus[11: 0];

	initial begin
		//#1;
		//$readmemh ("memfile0.mem", data);
		prePage = 15;
		dirty = 0;
		i = 0;
		file = 0;
	end

	reg select;
	assign dataBus = (select)? midData : 16'bzzzzzzzzzzzzzzzz;

	always @(posedge clk) begin
		select = 0;
		if(memRead) begin
			if(prePage != addrBus[15: 12]) begin
				if(dirty) begin
					case(prePage)
						0:		file = $fopen ("memfile0.mem", "r+");
						1:		file = $fopen ("memfile1.mem", "r+");
						2:		file = $fopen ("memfile2.mem", "r+");
						3:		file = $fopen ("memfile3.mem", "r+");
						4:		file = $fopen ("memfile4.mem", "r+");
						5:		file = $fopen ("memfile5.mem", "r+");
						6:		file = $fopen ("memfile6.mem", "r+");
						7:		file = $fopen ("memfile7.mem", "r+");
						8:		file = $fopen ("memfile8.mem", "r+");
						9:		file = $fopen ("memfile9.mem", "r+");
						10:		file = $fopen ("memfile10.mem", "r+");
						11:		file = $fopen ("memfile11.mem", "r+");
						12:		file = $fopen ("memfile12.mem", "r+");
						13:		file = $fopen ("memfile13.mem", "r+");
						14:		file = $fopen ("memfile14.mem", "r+");
						15:		file = $fopen ("memfile15.mem", "r+");
					endcase
					for (i = 0; i < 4096; i = i + 1)
						$fwrite (file, "%h\n", data[i]);
					dirty = 0;
					$fclose(file);
				end

				prePage = addrBus[15: 12];
				case(prePage)
					0: $readmemh ("memfile0.mem", data);
					1: $readmemh ("memfile1.mem", data);
					2: $readmemh ("memfile2.mem", data);
					3: $readmemh ("memfile3.mem", data);
					4: $readmemh ("memfile4.mem", data);
					5: $readmemh ("memfile5.mem", data);
					6: $readmemh ("memfile6.mem", data);
					7: $readmemh ("memfile7.mem", data);
					8: $readmemh ("memfile8.mem", data);
					9: $readmemh ("memfile9.mem", data);
					10: $readmemh ("memfile10.mem", data);
					11: $readmemh ("memfile11.mem", data);
					12: $readmemh ("memfile12.mem", data);
					13: $readmemh ("memfile13.mem", data);
					14: $readmemh ("memfile14.mem", data);
					15: $readmemh ("memfile15.mem", data);
				endcase
			end
			midData = data[midAddr];
			select = 1;
		end


		if(memWrite) begin
			if(prePage != addrBus[15: 12]) begin
				if(dirty) begin
					case(prePage)
						0:		file = $fopen ("memfile0.mem", "r+");
						1:		file = $fopen ("memfile1.mem", "r+");
						2:		file = $fopen ("memfile2.mem", "r+");
						3:		file = $fopen ("memfile3.mem", "r+");
						4:		file = $fopen ("memfile4.mem", "r+");
						5:		file = $fopen ("memfile5.mem", "r+");
						6:		file = $fopen ("memfile6.mem", "r+");
						7:		file = $fopen ("memfile7.mem", "r+");
						8:		file = $fopen ("memfile8.mem", "r+");
						9:		file = $fopen ("memfile9.mem", "r+");
						10:		file = $fopen ("memfile10.mem", "r+");
						11:		file = $fopen ("memfile11.mem", "r+");
						12:		file = $fopen ("memfile12.mem", "r+");
						13:		file = $fopen ("memfile13.mem", "r+");
						14:		file = $fopen ("memfile14.mem", "r+");
						15:		file = $fopen ("memfile15.mem", "r+");
					endcase
					for (i = 0; i < 4096; i = i + 1)
						$fwrite (file, "%h\n", data[i]);
					dirty = 0;
					$fclose(file);
				end

				prePage = addrBus[15: 12];
				case(prePage)
					0: $readmemh ("memfile0.mem", data);
					1: $readmemh ("memfile1.mem", data);
					2: $readmemh ("memfile2.mem", data);
					3: $readmemh ("memfile3.mem", data);
					4: $readmemh ("memfile4.mem", data);
					5: $readmemh ("memfile5.mem", data);
					6: $readmemh ("memfile6.mem", data);
					7: $readmemh ("memfile7.mem", data);
					8: $readmemh ("memfile8.mem", data);
					9: $readmemh ("memfile9.mem", data);
					10: $readmemh ("memfile10.mem", data);
					11: $readmemh ("memfile11.mem", data);
					12: $readmemh ("memfile12.mem", data);
					13: $readmemh ("memfile13.mem", data);
					14: $readmemh ("memfile14.mem", data);
					15: $readmemh ("memfile15.mem", data);
				endcase
			end
			
		data[midAddr] = dataBus;
		dirty = 1;

		end
	end
endmodule