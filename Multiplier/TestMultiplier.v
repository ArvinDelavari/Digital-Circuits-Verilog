`timescale 1ns/100ps

`include "Multiplier.v"

module test_multiplier;
   reg clk, start, error;
   wire [7:0] databus;
   wire lsb_out, msb_out, done;
        
   reg [7:0] mem1[0:2], mem2[0:2];
   reg [7:0] im_data, opnd1, opnd2; 
   reg [15:0] expected_result, multiplier_result;
   integer indx;
   
   Multiplier uut( clk, start, databus, lsb_out, msb_out, done );

   initial begin
      $dumpfile("Multiplier.vcd");
      $dumpvars(0, test_multiplier);
   end

   initial begin: Apply_data
      indx=0;
      $readmemh( "data1.dat", mem1 );
      $readmemh( "data2.dat", mem2 );
      repeat(3) begin
         #300 im_data = mem1[indx]; 
         #100 im_data = mem2[indx]; 
         #100 im_data = 8'hzz; 
         indx = indx+1;
         #1000;
      end
      #200 $stop;
   end
   
   initial begin: Apply_Start
      clk=1'b0; start = 1'b0; im_data=8'hzz;
      #200 ;
      repeat(3) begin
         #50   start = 1'b1;
         #100  start = 1'b0;
         #1350;
      end
   end
   
   initial begin: Expected_Result
      error=1'b0;
      repeat(3) begin
         wait ( start == 1'b1 );
         @( databus );
         opnd1 = databus;
         @( databus );
         opnd2 = databus;
         expected_result = opnd1 * opnd2;
      end
   end
   
   always @(posedge clk) begin: Actual_Result
      if (msb_out) multiplier_result[15:8] = databus;
      if (lsb_out) multiplier_result[7:0] = databus;
   end

   always @(posedge clk) begin: Compare_Results
      if (done) 
        if (multiplier_result != expected_result) error = 1;
        else error = 0;
   end


   always #50 clk = ~clk;
   assign databus = im_data;
   
endmodule