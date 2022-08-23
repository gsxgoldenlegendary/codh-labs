`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2022 10:09:20 PM
// Design Name: 
// Module Name: tx
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


module tx(
    
    input           clk,
    input rst,
    input           tx_ready,
    input   [7:0]   tx_data,
    
    output  reg     tx,
    output  reg     tx_rd
    
);

    parameter   DIV_CNT   = 10'd867;
    parameter   HDIV_CNT  = 10'd433;
    parameter   TX_CNT    = 4'h9;
    parameter   C_IDLE    = 1'b0;
    parameter   C_TX      = 1'b1;    
    
    reg         curr_state;
    reg         next_state;    
    reg [9:0]   div_cnt;
    reg [4:0]   tx_cnt;
    reg [7:0]   tx_reg;
    
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
            if(tx_ready==1'b1)begin
                next_state  = C_TX;
            end else begin
                next_state  = C_IDLE;
            end
        C_TX:
            if((div_cnt==DIV_CNT)&&(tx_cnt>=TX_CNT))begin
                next_state  = C_IDLE;
            end else begin
                next_state  = C_TX;
            end
        endcase
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            div_cnt <= 10'h0;
        end else if(curr_state==C_TX)begin
            if(div_cnt>=DIV_CNT)begin
                div_cnt <= 10'h0;
            end else begin
                div_cnt <= div_cnt + 10'h1;
            end
        end else begin
            div_cnt <= 10'h0;
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            tx_cnt  <= 4'h0;
        end else if(curr_state==C_TX)begin
            if(div_cnt==DIV_CNT)begin
                tx_cnt <= tx_cnt + 1'b1;
            end
        end else begin
            tx_cnt <= 4'h0;
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            tx_rd   <= 1'b0;
        end else if((curr_state==C_IDLE)&&(tx_ready==1'b1))begin
            tx_rd   <= 1'b1;
        end else begin
            tx_rd   <= 1'b0;
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            tx_reg  <= 8'b0;
        end else if((curr_state==C_IDLE)&&(tx_ready==1'b1))begin
            tx_reg  <= tx_data;
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            tx  <= 1'b1;
        end else if(curr_state==C_IDLE)begin
            tx  <= 1'b1;
        end else if(div_cnt==10'h0)begin
            case(tx_cnt)
            4'h0:   tx  <= 1'b0;
            4'h1:   tx  <= tx_reg[0];
            4'h2:   tx  <= tx_reg[1];
            4'h3:   tx  <= tx_reg[2];
            4'h4:   tx  <= tx_reg[3];
            4'h5:   tx  <= tx_reg[4];
            4'h6:   tx  <= tx_reg[5];
            4'h7:   tx  <= tx_reg[6];
            4'h8:   tx  <= tx_reg[7];
            4'h9:   tx  <= 1'b1;
            endcase
        end
    end

endmodule