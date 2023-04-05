`timescale 1ns/100ps

module Full_Adder 
(
    input A,
    input B,
    input Carry_in,
    output Sum,
    output Carry_out
);
    wire Wire1;
    wire Wire2;
    wire Wire3;

    xor #1.3    G1  (Wire1, A, B);
    xor #1.3    G2  (Sum , Wire1, Carry_in);
    and #1.4    G3  (Wire2, Wire1, Carry_in);
    and #1.4    G4  (Wire3, A, B);
    or  #0.9    G5  (Carry_out, Wire2, Wire3);

endmodule