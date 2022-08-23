`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2022 08:44:56 AM
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

  input [0:0]clk,	   //clk100mhz
  input [0:0]rstn,	   //cpu_resetn
  input [0:0]step, 	   //btnu
  input [0:0]cont,	   //btnd
  input [0:0]chk,	   //btnr
  input [0:0]ent,	   //btnc
  input [0:0]del,	   //btnl
  input [15:0]  hd,    //sw15-0
  input [0:0]rxd,

  output [0:0] pause,         //led16r
  output [15:0] led,  //led15-0
  output [7:0] an,     //an7-0
  output [7:0] seg,   //ca-cg 
  output [2:0]seg_sel,	//led17
  output [0:0]txd
  
); 

  wire 	[0:0] 	 clk_cpu;
  wire 	[7:0] 	 io_addr;
  wire 	[31:0]	 io_dout;
  wire 	[0:0] 	 io_we;
  wire 	[0:0] 	 io_rd;
  wire 	[31:0]	 io_din;
  wire 	[7:0]	 dm_rf_addr;
  wire 	[31:0]	 rf_data;
  wire 	[31:0]	 dm_data;
  wire 	[31:0]	 pc;
  wire 	[31:0]	 pcd;
  wire 	[31:0]	 ir;
  wire 	[31:0]	 pce;
  wire 	[31:0]	 ire;
  wire 	[31:0]	 ctrl;
  wire 	[31:0]	 a;
  wire 	[31:0]	 b;
  wire 	[31:0]	 imm;
  wire 	[31:0]	 pcm;
  wire 	[31:0]	 irm;
  wire 	[31:0]	 ctrlm;
  wire 	[31:0]	 y;
  wire 	[31:0]	 bm;
  wire 	[31:0]	 pcw;
  wire 	[31:0]	 irw;
  wire 	[31:0]	 ctrlw;
  wire 	[31:0]	 mdr;
  wire 	[31:0]	 yw;

cpu_pl cpu_pl(
	.clk(clk_cpu), 
	.rstn(rstn),
	.io_addr(io_addr),		
	.io_dout(io_dout),	
	.io_we(io_we),			
	.io_rd(io_rd),			
	.io_din(io_din),			
	.dm_rf_addr(dm_rf_addr),   	
	.rf_data(rf_data),    		
	.dm_data(dm_data),    	
	.pc(pc),
	.pcd(pcd),
	.ir(ir),
	.pce(pce),
	.ire(ire),
	.ctrl(ctrl),
	.a(a),
	.b(b),
	.imm(imm),
	.pcm(pcm),
	.irm(irm),
	.ctrlm(ctrlm),
	.y(y),
	.bm(bm),
	.pcw(pcw),
	.irw(irw),
	.ctrlw(ctrlw),
	.mdr(mdr),
	.yw(yw)
);

pdu_pl pdu_pl (
	.clk(clk),	    
	.rstn(rstn),	    
	.step(step), 	   
	.cont(cont),	
	.chk(chk),	
	.ent(ent),	
	.del(del),	
	.hd(hd),    
	.clk_cpu(clk_cpu),
	.pause(pause),  
	.led(led),
	.an(an), 
	.seg(seg), 
	.seg_sel(seg_sel),  
	.rxd(rxd),	
	.txd(txd),
	.io_addr(io_addr),
	.io_dout(io_dout),
	.io_we(io_we),
	.io_rd(io_rd),
	.io_din(io_din),
	.m_rf_addr(dm_rf_addr),
	.rf_data(rf_data),
	.m_data(dm_data),
	.pc(pc),
	.pcd(pcd),
	.ir(ir),
	.pce(pce),
	.ire(ire),
	.ctrl(ctrl),
	.a(a),
	.b(b),
	.imm(imm),
	.pcm(pcm),
	.irm(irm),
	.ctrlm(ctrlm),
	.y(y),
	.bm(bm),
	.pcw(pcw),
	.irw(irw),
	.ctrlw(ctrlw),
	.mdr(mdr),
	.yw(yw)
);

endmodule