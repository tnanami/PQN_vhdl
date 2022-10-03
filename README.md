# PQN_vhdl

**Piecewise Quadratic Neuron (PQN) model** is a spiking neuron model designed to faithfully reproduce a variety of neuronal activities with limited computational cost.
In addition, the PQN model is designed to support the efficient implementation on digital arithmetic circuits.
This repository provides a simple vhdl codes of the PQN model. These codes are incorporated into the Xilinx Vivado projects, allowing users to easily run PQN models on FPGAs.
This repository includes contains 8 Vivado projects, each of which corresponds to 8 different modes of the PQN model (RSexci, RSinhi, FS, LTS, IB, EB, PB, or Class2).

# Requirements
Digilent Cmod A7 35T FPGA
Xilinx Vivado 2018.3
USB Cable

# Build the project
![demo](https://user-images.githubusercontent.com/108346049/193576760-82d99c17-4d2c-4bf7-8e6f-20115ab6aac5.png)
1. download project
    git clone git@github.com:tnanami/PQN_vhdl.git
2. open Vivado find the Tcl Console on the bottom of the window
3. move to the "RSexci" directory on the Tcl console
4.
