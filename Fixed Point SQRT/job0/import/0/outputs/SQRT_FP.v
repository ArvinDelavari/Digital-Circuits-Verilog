module SQRT_FP #(
    parameter WIDTH = 32,                       // width of radicand
    parameter FBITS = 10 // fractional bits (for fixed point)
    ) 
(
    input clk,
    input start,                                // start signal
    input [WIDTH - 1 : 0] rad,                  // radicand

    output reg busy,                            // calculation in progress
    output reg valid,                           // root and rem are valid
    output reg [WIDTH - 1 : 0] root,            // root
    output reg [WIDTH - 1 : 0] rem              // remainder
    );

    reg [WIDTH - 1 : 0] x, x_next;              // radicand copy
    reg [WIDTH - 1 : 0] q, q_next;              // intermediate root (quotient)
    reg [WIDTH + 1 : 0] ac, ac_next;            // accumulator (2 bits wider)
    reg [WIDTH + 1 : 0] test_res;               // sign test result (2 bits wider)

    localparam ITER = (WIDTH + FBITS) >> 1;     // iterations are half radicand+fbits width
    reg [4 : 0] i;                              // iteration counter

    always @(*)
    begin
        test_res = ac - {q, 2'b01};

        if (test_res[WIDTH + 1] == 0) 
        begin  // test_res    0? (check MSB)
            {ac_next, x_next} = {test_res[WIDTH - 1 : 0], x, 2'b0};
            q_next = {q[WIDTH - 2 : 0], 1'b1};
        end 
        else 
        begin
            {ac_next, x_next} = {ac[WIDTH - 1 : 0], x, 2'b0};
            q_next = q << 1;
        end
    end

    always @(posedge clk) 
    begin
        if (start) 
        begin
            busy <= 1;
            valid <= 0;
            i <= 0;
            q <= 0;
            {ac, x} <= {{WIDTH{1'b0}}, rad, 2'b0};
        end 
        
        else if (busy) 
        begin

            if (i == ITER-1) 
            begin  // we're done
                busy <= 0;
                valid <= 1;
                root <= q_next;
                rem <= ac_next[WIDTH + 1 : 2];  // undo final shift
            end

            else 
            begin  // next iteration
                i <= i + 1;
                x <= x_next;
                ac <= ac_next;
                q <= q_next;
            end
        end
    end
endmodule
