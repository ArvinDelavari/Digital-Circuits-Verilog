`timescale 1ns / 1ps

module ADC(clk, enable, I1,I2,I3,conv, done, ADC_in, ADC_out, data_out);

	// input and outputs
	input 	I1,I2,I3,clk, enable, ADC_out;
	output reg ADC_in;
	output reg conv,done;			// Sampling Clock
	output reg [9:0]	data_out;		// desired sampled Data

	// internal variables
	reg [2:0]   Cs = 0;
	reg [4:0]	count = 0;
	reg [4:0]   bit_pos = 0;

	always @(negedge clk) begin// when enable is on
	
		if (enable == 1) begin
			case (Cs)
				0:	begin
						// initial
						conv 	<= 0;
						done 	<= 0;
						ADC_in = 1;
						Cs <= Cs + 3'b001;
						count <= count + 5'b00001; //1
						data_out <= 0;
					end
				1:	begin
						// initial
						conv 	<= 0;
						done 	<= 0;
						ADC_in = 1;
						Cs <= Cs + 3'b001;
						count <= count + 5'b00001; //2
					end
				2:	begin
						// initial
						conv 	<= 0;
						done 	<= 0;
						ADC_in = I1;
						Cs <= Cs + 3'b001;
						count <= count + 5'b00001; //3
					end
				3:	begin
						// initial
						conv 	<= 0;
						done 	<= 0;
						ADC_in = I2;
						Cs <= Cs + 3'b001;
						count <= count + 5'b00001; //4
					end
				4:	begin
						// initial
						conv 	<= 0;
						done 	<= 0;
						ADC_in = I3;
						Cs <= Cs + 3'b001;
						count <= count + 5'b00001; //5
					end
				
				5:	begin
						
						if (count < 8) begin
						conv 	<= 0;
						done 	<= 0;
						ADC_in = 0;
						Cs <= 5;
						count <= count + 5'b00001; end  //6
						else begin
						conv 	<= 0;
						done 	<= 0;
						ADC_in = 0;
						Cs <= 6;
						bit_pos = 5'b10001 - count;
						data_out[bit_pos] <= ADC_out;
						count <= count + 5'b00001;
						end
					end
				6: begin
				      if (count < 17) begin
                  conv 	<= 0;
						done 	<= 0;
						ADC_in = 0;
						Cs <= 6;
						bit_pos = 5'b10001 - count;
						data_out[bit_pos] <= ADC_out;
						count <= count + 5'b00001;end
						else begin
						conv 	<= 0;
						done 	<= 1;
						ADC_in = 0;
						Cs <= Cs + 3'b001;
						bit_pos = 5'b10001 - count;
						data_out[bit_pos] <= ADC_out;
						count <= count + 5'b00001;
						end
					end
				7: begin
				      if (count == 18) begin
                  conv 	<= 1;
						done 	<= 0;
						ADC_in = 0;
						Cs <= 0;
						conv 	<= 1;
						count <= 0;
						end
					end
				default: begin
						Cs	<= 0;
						conv  <= 0;
						count	<= 0;
						done	<= 0;
					end
			endcase
		end else begin
			// reset
         conv     <= 0;
			done 		<= 0;
			Cs 		<= 0;
			count    <= 0;
			data_out 	<= 0;
		end
	end
endmodule