`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2022 11:23:01 AM
// Design Name: 
// Module Name: pdu_pl
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


module  pdu_pl (
    
    input clk,	            //clk100mhz
    input rstn,	            //cpu_resetn
    input step, 	        //btnu
    input cont,	            //btnd
    input chk,	            //btnr
    input ent,	            //btnc
    input del,	            //btnl
    input [15:0]  hd,       //sw15-0
    output reg clk_cpu,
    output reg pause,       //led16r
    output reg [15:0] led,  //led15-0
    output[7:0] an,         //an7-0
    output  [7:0] seg,      //ca-cg 
    output  reg[2:0] seg_sel,  //led17
    input rxd,	            //串口接收数据
    output txd,	            //串口发送数据
    
    //IO_BUS
    input [7:0] io_addr,
    input [31:0] io_dout,
    input io_we,
    input io_rd,
    output reg [31:0] io_din,

    //Debug_BUS
    output reg [7:0] m_rf_addr,
    input [31:0] rf_data,
    input [31:0] m_data,

    //IF流水段寄存器
    input [31:0] pc,

    //ID 流水段寄存器
    input [31:0] pcd,
    input [31:0] ir,

    //EX 流水段寄存器
    input [31:0] pce,
    input [31:0] ire,
    input [31:0] ctrl,
    input [31:0] a,
    input [31:0] b,
    input [31:0] imm,
    //MEM 流水段寄存器
    input [31:0] pcm,
    input [31:0] irm,
    input [31:0] ctrlm,
    input [31:0] y,
    input [31:0] bm,

    //WB 流水段寄存器
    input [31:0] pcw,
    input [31:0] irw,
    input [31:0] ctrlw,
    input [31:0] mdr,
    input [31:0] yw

);
   
    parameter WAIT=0;
    parameter CHK=1;
    parameter WORK=2;
    
    integer i;
    
    wire[0:0]step_ps;
    wire[0:0]cont_ps;
    wire[0:0]chk_ps;
    wire[0:0]ent_ps;
    wire[0:0]del_ps;
    wire[15:0]hd_ps;
    
    reg[2:0]state;
    reg[2:0]n_state;
    reg[31:0]addr;
    reg[31:0]brk_addr;
    reg[31:0]show;
    reg[0:0] cont_flag;
    reg[0:0]chk_flag;
    
    reg[15:0]led_dout;
    reg[31:0]sw_din;
    reg[31:0]pol_dout;
    reg[31:0]pol_dout_vld;
    reg[31:0]pol_din;
    reg[31:0]pol_din_vld;
    reg[31:0]tx_data;
    reg[31:0]tx_rdy;
    reg[31:0]rx_data;
    reg[31:0]rx_vld;
    reg[31:0]tm_data;
    reg[31:0]tx_rd;
    wire[0:0]vld_temp;
    wire[0:0]rd_temp;
    wire[7:0]data_temp;

    dis dis(
        .clk(clk),
        .rst(rstn),
        .in(show),
        .an(an),
        .seg(seg)
    );

    db_ps db_ps(
        .clk(clk),
        .step(step),
        .cont(cont),
        .chk(chk),
        .ent(ent),
        .del(del),
        .hd(hd),
        .step_ps(step_ps),
        .cont_ps(cont_ps),
        .chk_ps(chk_ps),
        .ent_ps(ent_ps),
        .del_ps(del_ps),
        .hd_ps(hd_ps)
    );

    tx u_tx (
        .clk                     ( clk        ),
        .rst                     ( rstn  ),
        .tx_ready                ( tx_rdy[0]   ),
        .tx_data                 ( tx_data[7:0]),

        .tx                      ( txd         ),
        .tx_rd                   ( rd_temp     )
    );

    rx u_rx (
        .clk                     ( clk       ),
        .rst                     ( rstn       ),
        .rx                      ( rxd        ),

        .rx_vld                  ( vld_temp    ),
        .rx_data                 ( data_temp  )
    );

    initial begin
        addr=0;
        pol_dout_vld=0;
    end

    always @(posedge clk) begin
        tm_data<=tm_data+1;
    end

    always @(*) begin
        rx_vld[0]=vld_temp;
        rx_data[7:0]=data_temp;
        tx_rd[0]=rd_temp;
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
        if(!rstn)begin
            state<=WAIT;
        end else begin
            state<=n_state;
        end

    end

    always @(posedge clk) begin

        case (n_state)

        WAIT:begin

            if(pol_dout_vld)begin
                seg_sel<=4;
            end else if(pol_din_vld)begin
                seg_sel<=2;
            end

            show<=pol_dout_vld?pol_dout:addr;
            clk_cpu<=0;
            pause<=1;
            led<=led_dout;
            sw_din<=hd_ps;
            
            if(tx_rd)begin
                tx_rdy<=0;
            end else 
            if(ent_ps)begin
            //  if(ent)begin
                pol_dout_vld<=0;
                pol_din_vld<=0;
                
            end else if(io_we)begin
                case (io_addr)
                    6:begin
                        tx_rdy<=1;
                        tx_data<=io_dout;
                    end
                    2:begin
                        pol_dout_vld<=1;
                        pol_dout<=io_dout;
                    end
                    0: begin
                        led_dout<=io_dout[15:0];
                    end
                    default: ;
                endcase
            end else if (io_rd)begin
                case (io_addr)
                    10:begin
                        io_din<=tm_data;
                    end
                    9:begin
                        io_din<=rx_vld;
                    end
                    8:begin
                        io_din<=rx_data;
                    end
                    7:begin
                        io_din<=tx_rdy;
                    end
                    5:begin
                        io_din<=pol_din_vld;
                    end
                    4:begin
                        //pol_din_vld<=1;
                        //pol_din<=addr;
                        //io_din<=pol_din;
                        io_din<=addr;
                    end
                    3:begin
                        io_din<=pol_dout_vld;
                    end
                    1:begin
                        io_din<=sw_din;
                    end
                    default: ;
                endcase
            end else begin 
                if(chk_ps)begin
                    m_rf_addr<=addr[7:0];
                end else if(cont_ps)begin
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

            if(step_ps)begin
                m_rf_addr<=addr[7:0];
            end

            if(chk_ps)begin

                seg_sel<=1;

                case(addr[15:12])
                4:begin
                    case (addr[7:0])    
                        8'h00:show<=pc;
                        8'h10:show<=pcd;
                        8'h11:show<=ir;
                        8'h20:show<=pce;
                        8'h21:show<=ire;
                        8'h22:show<=ctrl;
                        8'h23:show<=a;
                        8'h24:show<=b;
                        8'h25:show<=imm;
                        8'h30:show<=pcm;
                        8'h31:show<=irm;
                        8'h32:show<=ctrlm;
                        8'h33:show<=y;
                        8'h34:show<=bm;
                        8'h40:show<=pcw;
                        8'h41:show<=irw;
                        8'h42:show<=ctrlw;
                        8'h43:show<=mdr;
                        8'h44:show<=yw;
                        default: ;
                    endcase
                end
                8:begin 
                    show<=rf_data;
                    m_rf_addr<=m_rf_addr+1;
                end
                12:begin
                    show<=m_data;
                    m_rf_addr<=m_rf_addr+1;
                end
                default:;
                endcase
            end else begin
                seg_sel<=2;
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
            if(chk_ps)begin
                n_state=CHK;
            end else if(step_ps||cont_flag&&pc<brk_addr)begin
                n_state=WORK;
            end else begin
                n_state=WAIT;
            end 
        end

        CHK:begin
            if(ent_ps)begin
                n_state=WAIT;
            end else begin 
                n_state=CHK;
            end 
        end

        WORK:begin
            n_state=WAIT;
        end

        default:n_state=n_state;

        endcase

    end

endmodule