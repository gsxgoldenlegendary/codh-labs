`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/31/2022 11:12:20 AM
// Design Name: 
// Module Name: forwarding
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


module forwarding(
    
    input[0:0]wb_mem,
    input[0:0]wb_wb,
    input[0:0]MemRead,
    input[4:0]rs0_ex,
    input[4:0]rs1_ex,
    input[4:0]rs0_id,
    input[4:0]rs1_id,
    input[4:0]rde,
    input[4:0]rdm,
    input[4:0]rdw,
    
    output reg[1:0]afwd0,
    output reg[1:0]bfwd0,
    output reg[1:0]afwd1,
    output reg[1:0]bfwd1
);

    always @(*) begin

        if(wb_mem&&rdm==rs0_ex)begin
            afwd0=1;
        end else if(wb_wb&&rdw==rs0_ex)begin
            afwd0=3;
        end else begin
            afwd0=0;
        end
        if(wb_mem&&rdm==rs1_ex)begin
            bfwd0=1;
        end else if(wb_wb&&rdw==rs1_ex)begin
            bfwd0=3;
        end else begin
            bfwd0=0;
        end

        if(wb_mem&&MemRead&&rdm==rs0_id)begin
            afwd1=1;
        end else if(wb_mem&&rdm==rs0_id)begin
            afwd1=3;
        end else begin
            afwd1=0;
        end
        if(wb_mem&&MemRead&&rdm==rs1_id)begin
            bfwd1=1;
        end else if(wb_mem&&rdm==rs1_id)begin
            bfwd1=3;
        end else begin
            bfwd1=0;
        end

    end

endmodule
