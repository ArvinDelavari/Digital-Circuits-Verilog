`timescale 1ns/100ps

`define  idle     4'b0000
`define  init     4'b0001
`define  m1       4'b0010
`define  m2       4'b0011
`define  m3       4'b0100
`define  m4       4'b0101
`define  m5       4'b0110
`define  m6       4'b0111
`define  m7       4'b1000
`define  m8       4'b1001
`define  rslt1    4'b1010
`define  rslt2    4'b1011

module controller ( clk, start, A0, clr_P, load_P, load_B, 
                    msb_out, lsb_out, sel_sum, load_A, Shift_A, done );
   input clk, start, A0;
   output clr_P, load_P, load_B, msb_out, lsb_out, sel_sum, done;
   output load_A, Shift_A; 
   reg clr_P, load_P, load_B, msb_out, lsb_out, sel_sum, done;
   reg load_A, Shift_A; 

   reg [3:0] current;
   
   always @ ( negedge clk )
   begin
      clr_P = 0; load_P = 0; load_B = 0;  
      msb_out = 0; lsb_out = 0; sel_sum = 0; 
      load_A = 0; Shift_A = 0; 
      done = 0;
      case ( current )
         `idle : 
            if (~start) begin
               current = `idle;
               done = 1;
            end else begin
               current=`init; 
               load_A = 1;
               clr_P = 1; load_P = 1;
            end
         `init : 
            begin
               current=`m1; 
               load_B = 1;
            end
         `m1, `m2, `m3, `m4, `m5, `m6, `m6, `m7, `m8 : 
            begin          
               current = current + 1; Shift_A = 1; load_P = 1; 
               if (A0) sel_sum = 1;
            end            

         `rslt1 :    
            begin
               current=`rslt2; lsb_out = 1;
            end            
         `rslt2 : 
            begin
               current=`idle; msb_out = 1; 
            end
         default : current=`idle;
      endcase
   end
         
endmodule