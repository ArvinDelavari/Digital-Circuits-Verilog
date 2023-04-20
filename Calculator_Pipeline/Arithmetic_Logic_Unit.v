module Arithmetic_Logic_Unit #(
    parameter DATA_WIDTH = 18
) (
    input [1 : 0] Operation,
    input [7 : 0] Operand_1,
    input [7 : 0] Operand_2,

    output reg [DATA_WIDTH - 1 : 0] Result
);
    always @(*)
        begin
        case (Operation)
            2'b00 : Result = Operand_1 + Operand_2;
            2'b01 : Result = Operand_1 - Operand_2;
            2'b10 : Result = Operand_1 * Operand_2;
            2'b11 : Result = Operand_1 / Operand_2;
        endcase
    end
endmodule