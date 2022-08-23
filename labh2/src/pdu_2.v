`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2022 08:44:56 AM
// Design Name: 
// Module Name: pdu_2
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


module  pdu_2 (
  input clk,	   //clk100mhz
  input rstn,	   //cpu_resetn
  input step, 	   //btnu
  input cont,	   //btnd
  input chk,	   //btnr
  input ent,	   //btnc
  input del,	   //btnl
  input [15:0]  hd,    //sw15-0

  output reg clk_cpu,
  output reg pause,         //led16r
  output reg[15:0] led,  //led15-0
  output [7:0] an,     //an7-0
  output [7:0] seg,    //ca-cg 
  //IO_BUS
  input [7:0] io_addr,
  input [31:0] io_dout,
  input io_we,
  output reg[31:0] io_din,
  input io_rd,

  //Debug_BUS
  output reg[7:0] m_rf_addr,
  input [31:0] rf_data,
  input [31:0] m_data,
  input [31:0] pc
);

parameter WAIT=0,CHK=1,OUT=2,IN=3,WORK=4;
reg[2:0]state,n_state;
reg[31:0]addr;
reg [31:0]brk_addr;
wire step_ps,cont_ps,chk_ps,ent_ps,del_ps;
wire[15:0]hd_ps;
db_ps db_ps(clk,step,cont,chk,ent,del,hd,step_ps,cont_ps,chk_ps,ent_ps,del_ps,hd_ps);
reg[31:0]show,temp;
dis dis(clk,rstn,show,an,seg);
integer i;
reg cont_flag,chk_flag;
reg[31:0]io_reg[5:0];
initial begin
    addr=0;
    cont_flag=0;
    n_state=0;
    state=0;
    io_reg[0]=0;
      io_reg[1]=0;
       io_reg[2]=0;
        io_reg[3]=0;
         io_reg[4]=0;
          io_reg[5]=0;
end
always @(posedge clk) begin
    if(del_ps)begin
            addr<={4'b0,addr[31:4]};
        end else begin
            for(i=0;i<16;i=i+1)begin
                if(hd_ps[i])begin
                    addr<={addr[27:0],4'b0}+i;
                end
            end
        end
        // if(del)begin
        //     addr<={4'b0,addr[31:4]};
        // end else begin
        //     for(i=0;i<16;i=i+1)begin
        //         if(hd[i])begin
        //             addr<={addr[27:0],4'b0}+i;
        //         end
        //     end
        // end
    if(!rstn)
        state<=WAIT;
    else
        state<=n_state;
end
always @(posedge clk) begin
    
    case (n_state)
    WAIT:begin
        show<=io_reg[3]?io_reg[2]:addr;
    clk_cpu<=0;
     pause<=1;
    led<=io_reg[0];
    io_reg[1]<=hd_ps;
    if(ent_ps)begin
        // if(ent)begin
        io_reg[3]<=0;
        io_reg[5]<=0;
    end else if(io_we)begin
        if(io_addr==8)begin
            io_reg[3]<=1;
            io_reg[2]<=io_dout;
            
        end else if(io_addr==0)
            io_reg[0]<=io_dout;
    end else if (io_rd)begin
        if(io_addr==16)begin
            io_reg[5]<=1;
            io_reg[4]<=addr;
            io_din<=io_reg[4];
        end else if(io_addr==4||io_addr==12||io_addr==20)
            io_din<=io_reg[io_addr[4:2]];
    end else begin 
        if(chk_ps)
            m_rf_addr<=addr[7:0];
        else if(cont_ps)begin
            cont_flag<=1;
            brk_addr<=addr[15:0];
        end else if(pc==brk_addr)begin
           cont_flag<=0;
        end
        // if(chk)
        //     m_rf_addr<=addr[7:0];
        // else if(cont)begin
        //     cont_flag<=1;
        //     brk_addr<=addr[15:0];
        // end  else if(pc==brk_addr)begin
        //    cont_flag<=0;
        // end
    end
    end
    CHK:begin
        led<=m_rf_addr;
        if(step_ps)
            m_rf_addr<=addr[7:0];
        if(chk_ps)begin
            case(addr[15:12])
                1:show<=pc;
                2:begin 
                    show<=rf_data;
                    m_rf_addr<=m_rf_addr+1;
                    end
                3:begin
                    show<=m_data;
                    m_rf_addr<=m_rf_addr+1;
                end
                default:;
                endcase
        end
    end
    WORK:begin
        clk_cpu<=1;
        pause<=0;        
    end
    endcase
end
always @(*) begin
    case (state)
    WAIT:begin
        if(chk_ps)n_state=CHK;
        else if(step_ps||cont_flag&&pc<brk_addr)n_state=WORK;
        else n_state=WAIT;
    end
    CHK:begin
        if(ent_ps)n_state=WAIT;
        else n_state=CHK;
    end
    WORK:begin
        n_state=WAIT;
    end
    endcase
end
endmodule
