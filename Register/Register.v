module Register(clock, r_enable, data_in, data_out);
input             clock;
input             r_enable;
input      [31:0] data_in;
output reg [31:0] data_out;

always @(posedge clock)
      begin
            if(r_enable)
            data_out <= data_in;
      end
endmodule