`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/16/2022 05:22:00 PM
// Design Name: 
// Module Name: CPU
// Project Name: 单周期CPU设计
// Target Devices: Nexy4-DDR
// Tool Versions: 
// Description: CPU模块接口
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module  cpu (
  input  clk, 
  input  rstn,

  //IO_BUS
  output reg [7:0]  io_addr,	//led和seg的地址
  output reg [31:0]  io_dout,	//输出led和seg的数据
  output  reg io_we,		//输出led和seg数据时的使能信号
  input [31:0]  io_din,	//来自sw的输入数据
  output reg io_rd,   //输入数据时的读使能信号

  //Debug_BUS
  output [31:0]  pc,	//PC的内容
  input [7:0]  dm_rf_addr,	//数据存储器DM或寄存器堆RF的调试读口地址
  output [31:0]  rf_data,	//从RF读取的数据
  output [31:0]  dm_data	//从DM读取的数据
);
wire[31:0]c_pc,pc_plus4,n_pc,sum,alu_in1;
assign pc=c_pc;
program_counter program_counter(clk,rstn,n_pc,c_pc);
wire[31:0]instruction,imm_num,alu_result;
wire branch,mem_read,memto_reg,mem_write,alu_src,reg_write,flag,zero,cmp_func,branch_method,bigger;
wire [31:0]read_data0,read_data1,read_data2,write_data0,address;
wire[1:0]alu_op;
reg[31:0]write_data1;
registers registers(clk,reg_write,instruction[19:15],instruction[24:20],dm_rf_addr[4:0],instruction[11:7],write_data0,read_data0,read_data1,rf_data);
control control(instruction,branch,mem_read,memto_reg,mem_write,alu_src,reg_write,alu_op,cmp_func);
wire[7:0]ins;
assign ins=(c_pc-32'h3000)>>2;
instruction_memory im(.a(ins),.spo(instruction));
imm_gen imm_gen(instruction,imm_num);
add add0(c_pc,32'd4,pc_plus4);
add add1(c_pc,{imm_num[30:0],1'b0},sum);
and (flag,branch,branch_method);
mux mux0(pc_plus4,sum,flag,n_pc);
mux mux1(.in0(read_data1),.in1(imm_num),.out0(alu_in1),.flag(alu_src));
mux mux2(.in0(alu_result),.in1(read_data2),.out0(write_data0),.flag(memto_reg));
mux mux3(.in0(zero),.in1(bigger),.out0(branch_method),.flag(cmp_func));
initial begin
  io_dout<=0;
end
always @(posedge clk) begin
  if(instruction[6:0]===7'b0100011)begin
    case(alu_result[7:0])
    0:begin
      io_addr<=0;
      io_dout<=read_data1;
      io_we<=0;
    end
    8:begin
      io_addr<=8;
      io_dout<=read_data1;
      io_we<=0;
    end
    12:begin
      io_addr<=12;
      io_we<=1;
    end
    default:begin
      io_we<=0;
    end
    endcase
  end
  else if(instruction[6:0]===7'b0000011)begin
   case(alu_result[7:0])
    4:begin
      io_addr<=4;
      write_data1<=io_din;
      io_rd<=0;
    end
    16:begin
      io_addr<=16;
      write_data1<=io_din;
      io_rd<=0;
    end
    20:begin
      io_addr<=20;
      io_rd<=1;
    end
    default:begin
      io_rd<=0;
    end
    endcase
  end
  else begin
    write_data1<=write_data0;
    io_rd<=0;
    io_we<=0;
  end
end
data_memory dm(.clk(clk),.a({2'b0,alu_result[7:2]}),.d(read_data1),.dpra(dm_rf_addr),.dpo(dm_data),.spo(read_data2),.we(mem_write));
alu alu(read_data0,alu_in1,alu_op,alu_result,zero,bigger);
endmodule