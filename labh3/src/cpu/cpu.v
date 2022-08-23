`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/22/2022 08:44:56 AM
// Design Name: 
// Module Name: cpu_pl
// Project Name: 流水线CPU设计
// Target Devices: Nexys4-DDR
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


module  cpu_pl (
	input clk, 
	input rstn,

	//IO_BUS
	output [7:0]  io_addr,		//外设地址
	output [31:0]  io_dout,		//向外设输出的数据
	output io_we,				//向外设输出数据时的写使能信号
	output io_rd,				//从外设输入数据时的读使能信号
	input [31:0]  io_din,			//来自外设输入的数据

	//Debug_BUS
	input [7:0] dm_rf_addr,   		//存储器(MEM)或寄存器堆(RF)的调试读口地址
	output [31:0] rf_data,    		//从RF读取的数据
	output [31:0] dm_data,    		//从MEM读取的数据
	output [31:0] pc,

	//ID 流水段寄存器
	output reg [31:0] pcd,
	output reg [31:0] ir,

	//EX 流水段寄存器
	output reg [31:0] pce,
	output reg [31:0] ire,
	output reg [31:0] ctrl,
	output reg [31:0] a,
	output reg [31:0] b,
	output reg [31:0] imm,

	//MEM 流水段寄存器
	output reg [31:0] pcm,
	output reg [31:0] irm,
	output reg [31:0] ctrlm,
	output reg [31:0] y,
	output reg [31:0] bm,

	//WB 流水段寄存器
	output reg [31:0] pcw,
	output reg [31:0] irw,
	output reg [31:0] ctrlw,
	output reg [31:0] mdr,
	output reg [31:0] yw
);

	initial begin
		ir=0;
	end


//Control

	wire[0:0]PCSrc;
	wire[0:0]RegWrite;

//IF

	wire[31:0]n_pc;
	wire[31:0]pc_plus4;
	wire[31:0]instruction;
	wire[7:0]ins;
	wire[31:0]addSum;
	wire[0:0]fStall;
	wire[1:0]dStall;
	wire[4:0]write_addr;

	assign ins=(pc-32'h3000)>>2;
	
	program_counter program_counter(
		.clk(clk),
		.rstn(rstn),
		.fStall(fStall),
		.n_pc(n_pc),
		.c_pc(pc)
	);

	instruction_memory im(
  		.a(ins),
		.spo(instruction)
	);
	
	add add_if(
		.in0(pc),
		.in1(32'd4),
		.out0(pc_plus4)
	);

	mux2to1 mux_if(
		.in0(pc_plus4),
		.in1(addSum),
		.flag(PCSrc),
		.out0(n_pc)
	);
	
	always@(posedge clk)begin
		if(dStall==1)begin
			pcd<=pc;
			ir<=instruction;
		end else if(dStall==2)begin
			pcd<=pcd;
			ir<=ir;
		end else if(dStall==3)begin
			pcd<=0;
			ir<=0;
		end
	end 

//ID

	wire[31:0]write_data1;
	wire[31:0]read_data0;
	wire[31:0]read_data1;
	wire[31:0]ctrl_out;
	wire[31:0]ctrl_choose;
	wire[1:0]m_ex;
	wire[31:0]imm_num;
	wire[0:0]eFlush;
	wire[31:0]cmpsr0;
	wire[31:0]cmpsr1;
	wire[1:0]afwd1;
	wire[1:0]bfwd1;
	wire[31:0]ALUresult;
	wire[31:0]readData;


	registers registers(
		.clk(clk),
		.reg_write(RegWrite),
		.read_addr0(ir[19:15]),
		.read_addr1(ir[24:20]),
		.read_addr2(dm_rf_addr[4:0]),
		.write_addr(write_addr),
		.write_data(write_data1),
		.read_data0(read_data0),
		.read_data1(read_data1),
		.read_data2(rf_data)
	);

	imm_gen imm_gen(
		.in(ir),
		.out(imm_num));

	control control(
		.in(ir),
		.ctrl(ctrl_out)
	);

	mux2to1 mux_id(
		.in0(ctrl_out),
		.in1(0),
		.flag(eFlush),
		.out0(ctrl_choose)
	);

	hdu hdu(
		.ir(ir),
		.PCSrc(PCSrc),
		.rd(ire[11:7]),
		.m_ex(m_ex),
		.fStall(fStall),
		.dStall(dStall),
		.eFlush(eFlush)
	);

	add add_id(
		.in0(pcd),
		.in1({imm_num[30:0],1'b0}),
		.out0(addSum)
	);
	
	and and_id(
		PCSrc,
		ctrl_out[0],
		cmpSignal
	);

	mux4to1 mux_id0(
		.in00(read_data0),
		.in01(readData),
		.in10(0),
		.in11(y),
		.flag(afwd1),
		.out0(cmpsr0)
	);

	mux4to1 mux_id1(
		.in00(read_data1),
		.in01(readData),
		.in10(0),
		.in11(y),
		.flag(bfwd1),
		.out0(cmpsr1)
	);

	compare compare(
		.sr0(cmpsr0),
		.sr1(cmpsr1),
		.funct3(ir[14:12]),
		.opcode(ir[6:0]),
		.cmpSignal(cmpSignal)
	);

	always @(posedge clk) begin
		ctrl<=ctrl_choose;
		pce<=pcd;
		a<=read_data0;
		b<=read_data1;
		imm<=imm_num;
		ire<=ir;
	end

//EX

	wire[31:0]ALUin0;
	wire[31:0]ALUin1;
	wire[1:0]ALUSrc;
	wire[3:0]ALUOp;
	wire[0:0]wb_ex;
	wire[6:0]ex;
	wire[1:0]afwd0;
	wire[1:0]bfwd0;
	wire[31:0]bOrImm;
	wire[0:0]wb_mem;
	wire[0:0]wb_wb;
	wire[31:0]b_real;
	
	assign wb_ex=ctrl[12];
	assign m_ex=ctrl[9:8];
	assign ex=ctrl[6:0];
	assign ALUOp=ex[4:1];
	assign ALUSrc=ex[6:5];

	mux4to1 mux_ex2(
		.in00(b_real),
		.in01(imm),
		.in10(pc),
		.in11(pc_plus4),
		.flag(ALUSrc),
		.out0(ALUin1)
	);

	mux4to1 mux_ex0(
		.in00(a),
		.in01(y),
		.in10(0),
		.in11(write_data1),
		.flag(afwd0),
		.out0(ALUin0)
	);

	// mux4to1 mux_ex1(
	// 	.in00(bOrImm),
	// 	.in01(y),
	// 	.in10(0),
	// 	.in11(write_data1),
	// 	.flag(bfwd0),
	// 	.out0(ALUin1)
	// );

	mux4to1 mux_ex3(
		.in00(b),
		.in01(y),
		.in10(0),
		.in11(write_data1),
		.flag(bfwd0),
		.out0(b_real)
	);

	alu alu(
		.in0(ALUin0),
		.in1(ALUin1),
		.aluop(ALUOp),
		.out0(ALUresult),
		.zero(Zero)
	);

	forwarding forwarding(
		.wb_mem(wb_mem),
		.wb_wb(RegWrite),
		.MemRead(MemRead),
		.rs0_ex(ire[19:15]),
		.rs1_ex(ire[24:20]),
		.rs0_id(ir[19:15]),
		.rs1_id(ir[24:20]),
		.rde(ire[11:7]),
		.rdm(irm[11:7]),
		.rdw(irw[11:7]),
		.afwd0(afwd0),
		.bfwd0(bfwd0),
		.afwd1(afwd1),
		.bfwd1(bfwd1)
	);

	always @(posedge clk) begin
		ctrlm<={ctrl[31:8],8'b0};
		y<=ALUresult;
		bm<=b_real;
		irm<=ire;
		pcm<=pce;
	end

//MEM

	assign MemRead=ctrlm[9];
	assign MemWrite=ctrlm[8];
	assign wb_mem=ctrlm[12];

	data_memory data_memory(
		.clk(clk),
		.MemWrite(MemWrite),
		.MemRead(MemRead),
		.address(y[9:2]),
		.writeData(bm),
		.readData(readData),
		.dm_rf_addr(dm_rf_addr),
		.dm_data(dm_data),
		.io_addr(io_addr),
		.io_din(io_din),
		.io_dout(io_dout),
		.io_rd(io_rd),
		.io_we(io_we)
	);

	always @(posedge clk) begin
		ctrlw<=ctrlm;
		mdr<=readData;
		yw<=y;
		irw<=irm;
		pcw<=pcm;
	end

//WB

	assign write_addr=irw[11:7];
	assign RegWrite=ctrlw[12];
	assign MemtoReg=ctrlw[13];

	mux2to1 mux_wb(
		.in0(yw),
		.in1(mdr),
		.flag(MemtoReg),
		.out0(write_data1)
	);

endmodule