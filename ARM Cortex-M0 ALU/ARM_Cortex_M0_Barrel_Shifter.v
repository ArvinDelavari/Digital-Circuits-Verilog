module ARM_Cortex_M0_Barrel_Shifter #(parameter WIDTH = 32, parameter SHIFT = 5)
(
    input  wire [3 : 0] opcode,
    input  wire [WIDTH - 1 : 0] data_in,
    input  wire [SHIFT - 1 : 0] shift_amount,
    output reg  [WIDTH - 1 : 0] shifted_data
);

always @(*) 
begin
    case (opcode)
        4'b1010: shifted_data = data_in << shift_amount;    // LSL (Logical Shift Left)
        4'b1011: shifted_data = data_in >> shift_amount;    // LSR (Logical Shift Right)
        default: shifted_data = data_in;
    endcase
end

endmodule