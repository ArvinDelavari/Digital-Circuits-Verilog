module ARM_Cortex_M0_ALU
(
    input  wire [31 : 0] operand_A,
    input  wire [31 : 0] operand_B,
    input  wire [2  : 0] alu_control,
    output reg  [31 : 0] result,
    output wire neg,
    output wire zero
);
    always @(*) 
    begin
        case (alu_control)
            3'b000: result = operand_A & operand_B;    // AND
            3'b001: result = operand_A ^ operand_B;    // XOR
            3'b010: result = operand_A - operand_B;    // SUB
            3'b011: result = operand_A + operand_B;    // ADD
            3'b100: result = operand_A | operand_B;    // ORR
            3'b111: result = operand_B;                // Pass operand_B = SHIFT R/L
        endcase
    end
    assign neg  = result[31];
    assign zero = (result == 0);
endmodule