module ALU (
           input [31:0] A,B,    // ALU 32-bit Inputs                 
           input [3:0] select,  // ALU 4-bit Selection
           output [31:0] out,   // ALU 32-bit Output
           output carry         // Carry Flag
           );
           
        reg [31:0] ALU_Result;
        wire [32:0] tmp;
        assign out = ALU_Result;  // ALU output
        assign tmp = {1'b0,A} + {1'b0,B};
        assign carry = tmp[32];   // carry flag
        always @(*)
            begin
            case(select)

                  4'b0000: // Addition
                  ALU_Result = A + B ; 
                  4'b0001: // Subtraction
                  ALU_Result = A - B ;
                  4'b0010: // Multiplication
                  ALU_Result = A * B;
                  4'b0011: // Division
                  ALU_Result = A/B;
                  4'b0100: // Logical shift left
                  ALU_Result = A<<1;
                  4'b0101: // Logical shift right
                  ALU_Result = A>>1;
                  4'b0110: // Rotate left
                  ALU_Result = {A[30:0],A[31]};
                  4'b0111: // Rotate right
                  ALU_Result = {A[0],A[31:1]};
                  4'b1000: //  Logical and 
                  ALU_Result = A & B;
                  4'b1001: //  Logical or
                  ALU_Result = A | B;
                  4'b1010: //  Logical xor 
                  ALU_Result = A ^ B;
                  4'b1011: //  Logical nor
                  ALU_Result = ~(A | B);
                  4'b1100: // Logical nand 
                  ALU_Result = ~(A & B);
                  4'b1101: // Logical xnor
                  ALU_Result = ~(A ^ B);
                  4'b1110: // Greater comparison
                  ALU_Result = (A>B)?32'd1:32'd0 ;
                  4'b1111: // Equal comparison   
                  ALU_Result = (A==B)?32'd1:32'd0 ;
          default: ALU_Result = A + B ; 

        endcase
    end
endmodule