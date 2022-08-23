`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2022 10:09:20 PM
// Design Name: 
// Module Name: rx
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

module rx(
    
    input               clk,
    input               rst,
    input               rx,
    
    output  reg         rx_vld,
    output  reg  [7:0]  rx_data

);

    parameter   DIV_CNT   = 10'd867;
    parameter   HDIV_CNT  = 10'd433;
    parameter   RX_CNT    = 4'h8;
    parameter   C_IDLE    = 1'b0;
    parameter   C_RX      = 1'b1;    

    reg         curr_state;
    reg         next_state;
    reg [9:0]   div_cnt;
    reg [3:0]   rx_cnt;
    reg         rx_reg_0;
    reg         rx_reg_1;
    reg         rx_reg_2;
    reg         rx_reg_3;
    reg         rx_reg_4;
    reg         rx_reg_5;
    reg         rx_reg_6;
    reg         rx_reg_7;

    //reg [7:0]   rx_reg;

    wire        rx_pulse;

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            curr_state  <= C_IDLE;
        end else begin
            curr_state  <= next_state;
        end
    end  

    always@(*)begin
        case(curr_state)
            C_IDLE:
                if(div_cnt==HDIV_CNT)begin
                    next_state  = C_RX;
                end else begin
                    next_state  = C_IDLE;
                end
            C_RX:
                if((div_cnt==DIV_CNT)&&(rx_cnt>=RX_CNT))begin
                    next_state  = C_IDLE;
                end else begin
                    next_state  = C_RX;
                end
        endcase
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            div_cnt <= 10'h0;
        end else if(curr_state == C_IDLE)begin
            if(rx==1'b1)begin
                div_cnt <= 10'h0;
            end else if(div_cnt < HDIV_CNT)begin
                div_cnt <= div_cnt + 10'h1;
            end else begin
                div_cnt <= 10'h0;  
            end  
        end else if(curr_state == C_RX)begin
            if(div_cnt >= DIV_CNT)begin
                div_cnt <= 10'h0;
            end else begin
                div_cnt <= div_cnt + 10'h1;
            end
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            rx_cnt  <= 4'h0;
        end else if(curr_state == C_IDLE)begin
            rx_cnt  <= 4'h0;
        end else if((div_cnt == DIV_CNT)&&(rx_cnt<4'hF))begin
            rx_cnt  <= rx_cnt + 1'b1;      
        end
    end

    always@(posedge clk)begin
        if(rx_pulse)begin
            case(rx_cnt)
            4'h0: rx_reg_0 <= rx;
            4'h1: rx_reg_1 <= rx;
            4'h2: rx_reg_2 <= rx;
            4'h3: rx_reg_3 <= rx;
            4'h4: rx_reg_4 <= rx;
            4'h5: rx_reg_5 <= rx;
            4'h6: rx_reg_6 <= rx;
            4'h7: rx_reg_7 <= rx;
            endcase
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            rx_vld  <= 1'b0;
            rx_data <= 8'h55;
        end else if((curr_state==C_RX)&&(next_state==C_IDLE))begin
            rx_vld  <= 1'b1;
            rx_data <= {rx_reg_7,rx_reg_6,rx_reg_5,rx_reg_4,rx_reg_3,rx_reg_2,rx_reg_1,rx_reg_0};
        end
        else begin
            rx_vld  <= 1'b0;
        end
    end
    
    assign rx_pulse = (curr_state==C_RX)&&(div_cnt==DIV_CNT);

endmodule