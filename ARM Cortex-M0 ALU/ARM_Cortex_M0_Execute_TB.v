`include "ARM_Cortex_M0_Execute.v"

module ARM_Cortex_M0_Execute_TB;

    reg  [3  : 0] opcode;
    reg  [4  : 0] shift_amount;
    reg  [31 : 0] operand_A;
    reg  [31 : 0] operand_B;
    wire [31 : 0] result;
    wire negative_flag;
    wire zero_flag;

ARM_Cortex_M0_Execute ALU_EXE
(
    .opcode(opcode),
    .shift_amount(shift_amount),
    .operand_A(operand_A),
    .operand_B(operand_B),
    .result(result),
    .negative_flag(negative_flag),
    .zero_flag(zero_flag)
);

initial begin
    $dumpfile("ARM_Cortex_M0_Execute.vcd");
    $dumpvars(0, ARM_Cortex_M0_Execute_TB);
    // Case 1 : ADD
    opcode = 4'b0100;
    shift_amount = 5'b0;
    operand_A = 32'd10;
    operand_B = 32'd5;
    #20;
    $display("Case 1 : ADD");
    $display("A = %d", operand_A);
    $display("B = %d", operand_B);
    $display("Result = %d", result);
    $display("Z = %d", zero_flag);
    $display("N = %d\n", negative_flag);
    #20;
    // Case 2 : SUB
    opcode = 4'b0010;
    shift_amount = 5'b0;
    operand_A = 32'd10;
    operand_B = 32'd5;
    #20;
    $display(">>> Case 2 : SUB");
    $display("A = %d", operand_A);
    $display("B = %d", operand_B);
    $display("Result = %d", result);
    $display("Z = %d", zero_flag);
    $display("N = %d\n", negative_flag);
    #20;
    // Case 3 : SUB (N)
    opcode = 4'b0010;
    shift_amount = 5'b0;
    operand_A = 32'd10;
    operand_B = 32'd15;
    #20;
    $display("Case 3 : SUB (N)");
    $display("A = %d", operand_A);
    $display("B = %d", operand_B);
    $display("Result = %d", result);
    $display("Z = %d", zero_flag);
    $display("N = %d\n", negative_flag);
    #20;
    // Case 4 : SUB (Z)
    opcode = 4'b0010;
    shift_amount = 5'b0;
    operand_A = 32'd10;
    operand_B = 32'd10;
    #20;
    $display("Case 4 : SUB (Z)");
    $display("A = %d", operand_A);
    $display("B = %d", operand_B);
    $display("Result = %d", result);
    $display("Z = %d", zero_flag);
    $display("N = %d\n", negative_flag);
    #20;
    // Case 5 : SHIFT LEFT
    opcode = 4'b1010;
    shift_amount = 5'd8;
    operand_A = 32'd10;
    operand_B = 32'd15;
    #20;
    $display("Case 5 : LSL");
    $display("A = %d", operand_A);
    $display("B = %b", operand_B);
    $display("Result = %b", result);
    $display("Z = %d", zero_flag);
    $display("N = %d\n", negative_flag);
    #20;
    // Case 6 : SHIFT RIGHT
    opcode = 4'b1011;
    shift_amount = 5'd2;
    operand_A = 32'd10;
    operand_B = 32'd15;
    #20;
    $display("Case 6 : LSR");
    $display("A = %d", operand_A);
    $display("B = %b", operand_B);
    $display("Result = %b", result);
    $display("Z = %d", zero_flag);
    $display("N = %d\n", negative_flag);
    #20;
    $finish;
end

endmodule