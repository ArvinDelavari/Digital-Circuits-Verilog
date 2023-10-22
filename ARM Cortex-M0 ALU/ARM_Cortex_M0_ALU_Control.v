module ARM_Cortex_M0_ALU_Control
(
  input  wire [3 : 0] opcode,
  output reg  [2 : 0] alu_control
);

  always @(*)
    case (opcode)
      4'b0000: alu_control = 3'b000;    // AND
      4'b0001: alu_control = 3'b001;    // XOR
      4'b0010: alu_control = 3'b010;    // SUB
      4'b0100: alu_control = 3'b011;    // ADD
      4'b1000: alu_control = 3'b100;    // ORR (Bitwise OR)
      4'b1010: alu_control = 3'b111;    // LSL (Logical Shift Left)
      4'b1011: alu_control = 3'b111;    // LSR (Logical Shift Right)
    endcase

endmodule