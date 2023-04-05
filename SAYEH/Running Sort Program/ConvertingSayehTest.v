///----------------------------------------------------------------------
//--SAYEH(Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
// SayehTest

`timescale 1 ns /1 ns

module SayehTestNew();

	parameter totalAddrLen = 16;
	parameter pageLen = 4;
	parameter pageNumberLen = 2;
	
	reg clk, ExternalReset, MemDataready;
	reg [15:0]	MemoryData;
	wire [15:0] Databus;
	wire [totalAddrLen - 1: 0] Addressbus;
	wire ReadMem, WriteMem, ReadIO, WriteIO;
	wire [totalAddrLen - pageLen - 1: 0] physicalAddr;

	
	reg [15:0] SayehRAM [0: (1 << (totalAddrLen - pageLen)) - 1];
	
	reg dirty;
	reg [pageLen - 1: 0] prePage;

	reg[pageNumberLen * 8: 1] pageNumber;
	
	integer i, file;

	always #20 clk = ~clk;
	

	initial begin 
		Translate;  //convert file
	  clk = 0;
	  ExternalReset = 0;
	  MemDataready = 0;
	  MemoryData = 16'bZ;
		dirty = 0;
		prePage = 15;

		
	  #05 ExternalReset = 1;
	  #81 ExternalReset = 0;    //run CPU
	  #3700000;
	  $stop;
	end

	always @(negedge clk) begin : MemoryRead
 	 if (ReadMem) begin
 	   #1
			if(prePage != Addressbus[totalAddrLen - 1: totalAddrLen - pageLen]) begin
				if(dirty)	begin


					$sformat(pageNumber, "%0d", prePage);
					file = $fopen ({"memfile", pageNumber, ".mem"}, "r+");			//open corresponding memory file

					for (i = 0; i < (1 << (totalAddrLen - pageLen)); i = i + 1)
						$fwrite (file, "%h\n", SayehRAM[i]);
					dirty = 0;
					$fclose(file);
				end

				prePage = Addressbus[totalAddrLen - 1: totalAddrLen - pageLen];

				$sformat(pageNumber, "%0d", prePage);			
				$readmemh ({"memfile", pageNumber, ".mem"}, SayehRAM);			//open corresponding memory file
		
			end

 	   MemDataready = 1;
 	   MemoryData = SayehRAM [physicalAddr];
 	 end else begin
  	  #1
   	 MemDataready = 0;
   	 MemoryData = 16'hZZZZ;
 	 end
	end


	always @(negedge clk) begin : MemoryWrite 
	  #1 if (WriteMem) begin
			if(prePage != Addressbus[totalAddrLen - 1: totalAddrLen - pageLen]) begin
				if(dirty)	begin


					$sformat(pageNumber, "%0d", prePage);			
					file = $fopen ({"memfile", pageNumber, ".mem"}, "r+");			//open corresponding memory file

					for (i = 0; i < (1 << (totalAddrLen - pageLen)); i = i + 1)
						$fwrite (file, "%h\n", SayehRAM[i]);
					dirty = 0;
					$fclose(file);
				end

				prePage = Addressbus[totalAddrLen - 1: totalAddrLen - pageLen];

				$sformat(pageNumber, "%0d", prePage);			
				$readmemh ({"memfile", pageNumber, ".mem"}, SayehRAM);			//open corresponding memory file
		
			end
		
			#1 SayehRAM [physicalAddr] = Databus;
			dirty = 1;
		end
	end

	assign Databus = MemoryData;
	assign physicalAddr = Addressbus[totalAddrLen - pageLen - 1: 0];





	Sayeh U1 (clk, ReadMem, WriteMem, ReadIO, WriteIO,
	      Databus, Addressbus, ExternalReset, MemDataready);






	task Translate;
	

		begin: block
		
		reg [totalAddrLen - 1: 0] addr, preAddr;
		reg [pageLen - 1: 0] page;
		reg [totalAddrLen - pageLen - 1: 0] physicalAddr;
		reg [7: 0] data; 
		reg [2 * 8: 1]imData;
		reg im, justData;

		reg [3 * 8: 1] opCode;
		reg [3 * 8: 1] operand1, operand2;
		reg [5 * 8: 1] dat;





		integer i, j;
		integer inst, file, check;
		
		reg [pageNumberLen * 8: 1] pageNumber;
		reg [9 * 8: 1] numberRead;

		reg [100 * 8: 1] dummy;


		for(i=0; i<(1 << pageLen); i = i + 1)
			begin

				$sformat(pageNumber, "%0d", i);			
				file = $fopen ({"memfile", pageNumber, ".mem"});			 //create file or truncate to zero length

				for (j = 0; j<(1 << (totalAddrLen - pageLen)); j = j + 1)
					$fwrite (file, "0000\n");																						//fill with zeros
				$fclose(file);
			end


			inst = $fopen ("inst.mem", "r");

			preAddr = -1;

			while ($fscanf(inst, "%h", addr) != -1) begin
				
				page = addr[totalAddrLen - 1: totalAddrLen - pageLen];
				physicalAddr = addr[totalAddrLen - pageLen - 1: 0];
			

				$sformat(pageNumber, "%0d", page);			
				file = $fopen ({"memfile", pageNumber, ".mem"}, "r+");			//open corresponding memory file

				$fseek(file, physicalAddr * 6, 0);
				if(addr == preAddr)
					$fseek(file, 2, 1);

				check = $fgets( opCode, inst);




				justData = 0;
						case(opCode)

							"nop": begin
												data = 0;
												imData = 0;
												im =0 ;
											end
							"hlt": begin
												data = 1;
												imData = 0;
												im = 0;
											end
							"szf": begin
												data = 2;
												imData = 0;
												im = 0;
											end
							"czf": begin
												data = 3;
												imData = 0;
												im = 0;
											end
							"scf": begin
												data = 4;
												imData = 0;
												im = 0;
											end
							"ccf": begin
												data = 5;
												imData = 0;
												im = 0;
											end
							"cwp": begin
												data = 6;
												imData = 0;
												im = 0;
											end
							"mvr": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 1;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"lda": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 2;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"sta": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 3;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"inp": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 4;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"oup": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 5;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"and": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 6;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"orr": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 7;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"not": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 8;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"shl": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 9;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"shr": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 10;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"add": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 11;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"sub": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 12;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"mul": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 13;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"cmp": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 14;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = operand2[8: 1] - "0";
												imData = 0;
												im = 0;
											end
							"mil": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 15;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = 0;
												imData = operand2[16: 1];
												im = 1;
											end
							"mih": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 15;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = 1;
												imData = operand2[16: 1];
												im = 1;
											end
							"spc": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 15;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = 2;
												imData = operand2[16: 1];
												im = 1;
											end
							"jpa": begin
												check = $fgets(		operand1 , inst);
												check = $fgets(		operand2 , inst);
												data[7: 4] = 15;
												data[3: 2] = operand1[8: 1] - "0";
												data[1: 0] = 3;
												imData = operand2[16: 1];
												im = 1;
											end
							"jpr": begin
												check = $fgets(		operand1 , inst);												
												data = 7;
												imData = operand1[16: 1];
												im = 1;
											end
							"brz": begin
												check = $fgets(		operand1 , inst);												
												data = 8;
												imData = operand1[16: 1];
												im = 1;
											end
							"brc": begin
												check = $fgets(		operand1 , inst);												
												data = 9;
												imData = operand1[16: 1];
												im = 1;
											end
							"awp": begin
												check = $fgets(		operand1 , inst);												
												data = 10;
												imData = operand1[16: 1];
												im = 1;
											end
							":::": begin							//justData data
												check = $fgets(		dat , inst);
												justData = 1;
											end

							default: begin
												data = 0;
												imData = 0;
												im = 0;
											end

						endcase

				if(justData)
					$fwrite(file, "%s", dat[32: 1]);
				else begin
					$fwrite(file, "%h", data);
					if(im)
						$fwrite(file, "%s", imData);
				end

				preAddr = addr;
				check = $fgets(		dummy, inst);
				$fflush(file);
			end




		end


	endtask


endmodule