module pll_test 
(
   // Inputs
    input     ref_clk,    
    // Outputs
    output    clk
);

    // Instantiate PLL (120 MHz)
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),   // Don't use fine delay adjust
        .PLLOUT_SELECT("GENCLK"),   // No phase shift on output
        .DIVR(4'b0000),             // Reference clock divider
        .DIVF(7'b1001111),          // Feedback clock divider
        .DIVQ(3'b011),              // VCO clock divider
        .FILTER_RANGE(3'b001)       // Filter range
    ) pll (
        .REFERENCECLK(ref_clk),     // Input clock
        .PLLOUTCORE(clk),           // Output clock
        .LOCK(),                    // Locked signal
        .RESETB(1'b1),              // Active low reset
        .BYPASS(1'b0)               // No bypass, use PLL signal as output
    );
    
endmodule