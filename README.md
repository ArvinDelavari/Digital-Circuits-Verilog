# Digital-Circuits-Verilog

This repository includes some sample digital circuits scripted in Verilog HDL.
Purpose of this repository is to maintain modules used in CPUs and computer architecture techniques performed in Verilog used in digital design and CPU design based on RISC-V ISA.


Each folder includes 4 files:
- module.v
- testbench.v
- module.vvp
- module.vcd

Simulations can be done using iverilog tool.
You can use iverilog tool in vs code application and simulate your Verilog codes (all in the same folder) with 3 commands in your terminal:
1) iverilog -o module.vvp testbench.v
2) vvp module.vvp
3) gtkwave

You can check the waveforms using GTKWave application.

This repository will be updated.

Last update : 4/20/2023
## Arvin Delavari - IUST
