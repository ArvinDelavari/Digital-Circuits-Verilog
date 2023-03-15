`include "Register.v"
module Register_tb;

reg         clock = 0;
reg         enable = 1;
reg  [31:0] value_in;
wire [31:0] value_out;

always #1 clock = !clock;

initial $dumpfile("register.vcd");
initial $dumpvars(0, Register_tb);

Register register (clock, enable, value_in, value_out);

initial begin
    //These events must be in chronological order.
    # 5 value_in = 31;
    # 5 value_in = 127;
    # 5 enable = 0;
    # 5 value_in = 1023;
    # 5 $finish;
end
endmodule