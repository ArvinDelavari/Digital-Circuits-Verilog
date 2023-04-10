`include "Stack_LIFO.v"

module Stack_tb;

     parameter WIDTH = 8; 
     parameter DEPTH = 8;
     // Inputs
     reg clk;
     reg rstn;
     reg pop;
     reg push;
     reg [7:0] din;

     // Outputs
     wire empty;
     wire full;
     wire [7:0] dout;

     // Instantiate the Unit Under Test (UUT)
     Stack #(WIDTH, DEPTH) uut 
     (
      .clk(clk), 
      .rstn(rstn), 
      .pop(pop), 
      .push(push), 
      .empty(empty), 
      .full(full), 
      .din(din), 
      .dout(dout)
     );

     always #5 clk = ~clk;
     
     task reset();  //reset task
          begin
               clk = 1'b1;
               rstn = 1'b0;
               pop = 1'b0;
               push = 1'b0;
               din = 8'd0;
               #30 rstn = 1'b1;
          end
     endtask

     task read_stack();  //read task
          begin
               pop = 1'b1;
               #10
               pop = 1'b0;
          end
     endtask
     
     task write_stack; //write task
          input [7:0]din_tb;
          begin
               push = 1'b1;
               din = din_tb;
               #10 push = 1'b0;
          end
     endtask
     
     // Main code
     initial
     begin
          $dumpfile("Stack_LIFO.vcd");
          $dumpvars(0, Stack_tb);
          
          reset();
          #10;
          repeat(2)
          begin
          write_stack(8'h11);
          #10;
          write_stack(8'h22);
          #10;
          write_stack(8'h33);
          #10;
          write_stack(8'h44);
          #40;
          end
          read_stack();
          #20;
          read_stack();
          #20;
          write_stack(8'hAA);
          #10;
          write_stack(8'hBB);
          #40;
          read_stack();
          #20;
          $finish;
     end
      
endmodule