`timescale 1ns/1ns

`include "Core.v"

module Core_TB;
    parameter State = 1;  // Sequential : 3 -- Pipline : 1
    parameter ADDRESS_WIDTH = 10;
    parameter DATA_WIDTH = 18;

    reg CLK = 0;
    parameter T = 2;
    always #(T / 2)  CLK = ~CLK;

    reg [ADDRESS_WIDTH - 1 : 0] Counter;
    wire [DATA_WIDTH - 1 : 0] Result;

    Core #(ADDRESS_WIDTH, DATA_WIDTH) uut (CLK, Counter, Result);

    initial
    begin
        $dumpfile("Core.vcd");
        $dumpvars(0, Core_TB);

        for (integer i = 0; i < 100; i = i + 1)
        begin
            Counter = i;
            #(T * State);           
        end
        $finish;
    end
endmodule