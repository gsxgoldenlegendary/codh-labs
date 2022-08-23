`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/16/2022 08:39:22 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: Nexy4-DDR
// Tool Versions: 
// Description: 通用算数逻辑单元
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
input [31:0]in0,in1,
input [1:0]alu_op,
output reg[31:0]out0,
output reg zero,bigger
    );
    parameter CMP=1,ZERO_OUT=2,PLUS=3;
    always@(*)begin
        case(alu_op)
        0:begin zero=0;out0=0;end
        CMP:begin 
            if(in0>in1) begin
                zero=0;
                bigger=1;
                out0=0;
            end else if(in0==in1)begin
                zero=1;
                bigger=1;
                out0=0;
            end        
            else begin
                zero=0;
                bigger=0;
                out0=0;
                end
        end
        ZERO_OUT:begin zero=1;out0=0;end
        PLUS:begin zero=0;out0=in0+in1;end  
        endcase
    end
endmodule
