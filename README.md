# Digital Circuits in Verilog

This repository includes some sample digital circuits scripted in Verilog HDL.
Purpose of this repository is to maintain some useful and common modules used in digital design and CPU designed performed in Verilog.

Each folder includes 4 files:
- module.v
- testbench.v
- module.vvp
- module.vcd

Simulations can be done using iverilog tool.
You can use iverilog tool in vs code application and simulate your Verilog codes (all in the same folder) with 3 commands in your terminal:
```console 
iverilog -o module.vvp testbench.v
vvp module.vvp
gtkwave
```

You can check the waveforms using GTKWave application.

This repository will be updated.

Last update : 10/22/2023
## Arvin Delavari - IUST
