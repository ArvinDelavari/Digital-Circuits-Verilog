`timescale 1ns/100ps

module Shift8 ( clk, sin, s1, s0, oe, qa, data );
   input clk, sin, s1, s0, oe;
   output qa;
   inout [7:0] data;
   
   reg [7:0] im_data;
   
   always @( posedge clk )
      case ( { s1, s0 } )
         2'b00 : im_data = im_data;
         2'b01 : im_data = { sin, im_data[7:1] };
         2'b10 : im_data = data;
         2'b11 : im_data = 8'b00;
      endcase

   assign data = ( oe & ~s1 ) ? im_data : 8'hzz;
   assign qa = im_data[0];

endmodule