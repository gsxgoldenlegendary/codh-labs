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

    input [31:0]in0,
    input [31:0]in1,
    input [3:0]aluop,
    
    output reg[31:0]out0,
    output reg [0:0]zero
    
);
    
    parameter ALU_ADD=4'b0000;
    parameter ALU_SUB=4'b0001;
    parameter ALU_PASS=4'b0010;
    parameter NULL=4'b1111;

always@(*)begin
    case(aluop)
        ALU_ADD:begin
            out0=in0+in1;
            zero=(out0==0)?1:0;
        end
        ALU_SUB:begin
            out0=in0-in1;
            zero=(in0==in1)?1:0;
        end
        ALU_PASS:begin
            out0=in1;
            zero=(out0==0)?1:0;
        end
        default:begin
            out0=0;
            zero=1;
        end
    endcase
end
    
endmodule
