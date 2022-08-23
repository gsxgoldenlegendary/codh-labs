`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2022 10:48:54 AM
// Design Name: 
// Module Name: topmodule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module topmodule(
  input clk,	   //clk100mhz
  input rstn,	   //cpu_resetn
  input step, 	   //btnu
  input cont,	   //btnd
  input chk,	   //btnr
  input ent,	   //btnc
  input del,	   //btnl
  input [15:0]  hd,    //sw15-0
  output pause,         //led16r
  output [15:0] led,  //led15-0
  output [7:0] an,     //an7-0
  output [7:0] seg   //ca-cg 
); 
wire clk_cpu;
     //IO_BU;
 wire [7:0] io_addr;
 wire [31:0] io_dout;
 wire [0:0]io_we;
 wire [31:0] io_din;
 wire [0:0]io_rd;
 wire [7:0] dm_rf_addr;
 wire [31:0] rf_data;
 wire [31:0] dm_data;
 wire [31:0] pc;
 cpu cpu(
 clk_cpu, 
rstn,

  //IO_BUS
io_addr,	//led和seg的地址
io_dout,	//输出led和seg的数据
io_we,		//输出led和seg数据时的使能信号
io_din,	//来自sw的输入数据
io_rd,   //输入数据时的读使能信号

  //Debug_BUS
 pc,	//PC的内容
 dm_rf_addr,	//数据存储器DM或寄存器堆RF的调试读口地址
  rf_data,	//从RF读取的数据
  dm_data	//从DM读取的数据
);
pdu pdu(
clk,	   //clk100mhz
rstn,	   //cpu_resetn
step, 	   //btnu
cont,	   //btnd
chk,	   //btnr
ent,	   //btnc
del,	   //btnl
hd,    //sw15-0

clk_cpu,
pause,         //led16r
led,  //led15-0
an,     //an7-0
seg,    //ca-cg 
  //IO_BUS
io_addr,
io_dout,
io_we,
io_din,
io_rd,

  //Debug_BUS
dm_rf_addr,
rf_data,
dm_data,
 pc
);
endmodule
