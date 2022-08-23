`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/18/2022 08:46:41 AM
// Design Name: 
// Module Name: pdu
// Project Name: 
// Target Devices: Nexy4-DDR
// Tool Versions: 
// Description: CPU控制与调试模块
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module  pdu (
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
initial begin
    addr=0;
    cont_flag=0;
    n_state=0;
    state=0;
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
        clk_cpu<=0;
        pause<=1;
        // if(chk)
        //     m_rf_addr<=addr[7:0];
        // else if(cont)begin
        //     cont_flag<=1;
        //     brk_addr<=addr[15:0];
        // end
        if(chk_ps)
            m_rf_addr<=addr[7:0];
        else if(cont_ps)begin
            cont_flag<=1;
            brk_addr<=addr[15:0];
        end
   
        else if(pc==brk_addr)begin
           cont_flag<=0;
        end
         if(io_we)
            temp<=io_dout;
        
            show<=addr;
        led<=io_dout;
        if(io_rd)
            io_din<=addr;
        else
            io_din<=hd_ps;
        //     show<=addr;
        // led<=io_dout;
        //     io_din<=hd_ps;
            
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
    OUT:begin
        show<=temp;
        led<=temp;
        pause<=0;

    end
    IN:begin
        io_din<=addr;
        pause<=0;
        led<=pc;
    end
    WORK:begin
        clk_cpu<=1;
        pause<=0;
        
        if(io_we)
            temp<=io_dout;
        
            show<=addr;
        led<=io_dout;
        if(io_rd)
            io_din<=addr;
        else
            io_din<=hd_ps;
            
    end
    endcase
end
always @(*) begin
    case (state)
    WAIT:begin
        if(io_we)n_state=OUT;
        else if(io_rd)n_state=IN;
        else if(chk_ps)n_state=CHK;
        else if(step_ps||cont_flag&&pc<brk_addr)n_state=WORK;
        else n_state=WAIT;
    end
    CHK:begin
        if(ent_ps)n_state=WAIT;else n_state=CHK;
    end
    OUT:begin
        if(ent_ps)n_state=WORK;else n_state=OUT;
    end
    IN:begin
        if(ent_ps)n_state=WORK;else n_state=IN;
    end
    WORK:begin
        n_state=WAIT;
    end
    endcase
end
endmodule