`timescale  1ns/100ps
`include "Full_Adder.v"

module Full_Adder_Testbench;
    reg A = 0;
    reg B = 0;
    reg Carry_in = 0;

    wire Sum;
    wire Carry_out;

    Full_Adder FA1 (A, B, Carry_in, Sum, Carry_out);

    logic clk = 0;

    parameter time_limit = 100;
    initial begin
        $dumpfile("Full_Adder.vcd");
        $dumpvars(0, Full_Adder_Testbench);
        
        #10
        A = 1; B = 0;
        #30
        A = 1; B = 1;
        #100
        A = 0; B = 0;
        #100
        $dumpoff;

    end

    
endmodule