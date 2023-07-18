// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Tue Jul 18 12:08:21 2023
// Host        : MSI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/giuse/Desktop/vivado_projects/multi/multi.srcs/sources_1/ip/blk_ram1/blk_ram1_stub.v
// Design      : blk_ram1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module blk_ram1(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[6:0],dina[17:0],douta[17:0],clkb,web[0:0],addrb[6:0],dinb[17:0],doutb[17:0]" */;
  input clka;
  input [0:0]wea;
  input [6:0]addra;
  input [17:0]dina;
  output [17:0]douta;
  input clkb;
  input [0:0]web;
  input [6:0]addrb;
  input [17:0]dinb;
  output [17:0]doutb;
endmodule
