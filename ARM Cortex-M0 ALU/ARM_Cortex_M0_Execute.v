`include "ARM_Cortex_M0_Barrel_Shifter.v"
`include "ARM_Cortex_M0_ALU.v"
`include "ARM_Cortex_M0_ALU_Control.v"

module ARM_Cortex_M0_Execute 
(
    input [3  : 0] opcode,
    input [4  : 0] shift_amount,
    input [31 : 0] operand_A,
    input [31 : 0] operand_B,

    output [31 : 0] result,
    output wire negative_flag,
    output wire zero_flag
);

wire [2 : 0] alu_control;

ARM_Cortex_M0_ALU_Control ARM_ALU_CONTROL
(
    .opcode(opcode),
    .alu_control(alu_control)
);

wire [31 : 0] operand_B_shifted;
ARM_Cortex_M0_Barrel_Shifter ARM_ALU_SHIFT
(
    .opcode(opcode),
    .data_in(operand_B),
    .shift_amount(shift_amount),
    .shifted_data(operand_B_shifted)
);

ARM_Cortex_M0_ALU ALU
(
    .operand_A(operand_A),
    .operand_B(operand_B_shifted),
    .alu_control(alu_control),
    .result(result),
    .neg(negative_flag),
    .zero(zero_flag)
);
    
endmodule