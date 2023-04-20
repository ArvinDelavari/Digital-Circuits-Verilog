module Control_Unit (
    input [17 : 0] Instruction,

    output [1 : 0] Operation,
    output [7 : 0] Operand_1,
    output [7 : 0] Operand_2
);
    
    assign Operation = Instruction[17 : 16];
    assign Operand_1 = Instruction[15 : 8];
    assign Operand_2 = Instruction[7 : 0];
endmodule