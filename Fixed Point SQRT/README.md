# Fixed Point SQRT Module
FBITS is defined for the number of fractional bits in the radicand (FBITS must be a multiple of two). 
For example, if we want to calculate √2 using Q8.8 format (eight integer and eight fractional bits), we set WIDTH=16 and FBITS=8. 
The only change within the module is for ITER, which now accounts for fractional bits. For a Q8.8 radicand, we now perform (16+8)/2 = 12 iterations, generating four more bits for the root.

- Module is written in Verilog
- RTL to GDSII done with Siliconcompiler (Yosys/OpenRoad)
- Area, Power, Frequency & ... reports are included in report.html

![SQRT_FP](https://github.com/ArvinDelavari/Digital-Circuits-Verilog/assets/86099054/70ef11af-f4c7-422c-87e2-0cad0da8783d)
