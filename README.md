## PQN_vhdl

![demo](https://user-images.githubusercontent.com/108346049/193576760-82d99c17-4d2c-4bf7-8e6f-20115ab6aac5.png)

**Piecewise Quadratic Neuron (PQN) model** is a spiking neuron model designed to faithfully reproduce a variety of neuronal activities with limited computational cost.
In addition, the PQN model is designed to support the efficient implementation on digital arithmetic circuits.
This repository provides simple vhdl codes of the PQN model. The codes are incorporated into the Xilinx Vivado projects, allowing users to easily run PQN models on an FPGA.
This repository contains 8 Vivado projects, each of which corresponds to 8 different modes of the PQN model (RSexci, RSinhi, FS, LTS, IB, EB, PB, or Class 2).
Each mode is fitted to reproduce the corresponding ionic-conductance model. Python version of the PQN model is available from [PQN_py](https://github.com/tnanami/PQN_py "PQN_py").


|        |Mode                            |Target ionic-conductance model|Comment                    |
|:-------|:------------------------------:|:---------------------------:|:-------------------------:|
| RSexci |Regular Spiking                 |[1]                          |Fitted to a excitatory cell|
| RSinhi |Regular Spiking                 |[1]                          |Fitted to an inhibitory cell|
| FS     |Fast Spiking                    |[1]|
| LTS    |Low-threshold Spiking           |[1]|
| IB     |Intrinsically Bursting          |[1]|
| EB     |Elliptic Bursting               |[2]|
| PB     |Parablic Bursting               |[3]|
| Class2 |Class 2 of Hodgkin's Classification||

[1] M. Pospischil et al., “Minimal hodgkin-huxley type models for different classes of cortical and thalamic neurons.” Biological Cybernetics, vol. 99, no. 4-5, pp. 427–441, 2008.  
[2] X. J. Wang, “Ionic basis for intrinsic 40 hz neuronal oscillations,” NeuroReport, vol. 5, pp. 221–224, 1993  
[3] R. E. Plant, “Bifurcation and resonance in a model for bursting nerve cells,” Journal of Mathematical Biology, vol. 67, pp. 15–32, 1981.

## Requirements
Digilent Cmod A7 35T (Xilinx Artix-7 FPGA)  
Xilinx Vivado 2018.3  
USB Cable  

## Build the project
1. Download project `git clone git@github.com:tnanami/PQN_vhdl.git`
2. Open Vivado and find the Tcl console on the bottom of the window
3. Move to a directory of the mode you want to use on the Tcl console with `cd` command
4. Enter the command `source ./create_project.tcl`

## UART communication
`python demo.py`  
The demo.py is a python code for the UART communication to the FPGA. This code send stimulus inputs and receives value of the membrane potential of the PQN unit.

## Example
![all](https://user-images.githubusercontent.com/108346049/194803882-13a07a8a-54db-460f-9958-ee612ef539d4.png)
