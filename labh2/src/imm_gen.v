`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/17/2022 08:33:26 PM
// Design Name: 
// Module Name: imm_gen
// Project Name: 
// Target Devices: Nexy4-DDR
// Tool Versions: 
// Description: 单周期CPU的立即数处理器
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module imm_gen(
input [31:0]in,
output reg[31:0]out
    );
    parameter JAL = 7'b1101111,BEQ=7'b1100011,LW=7'b0000011,SW=7'b0100011,ADDI=7'b0010011,ADD=7'b0110011;
    always@(*)begin
        case(in[6:0])
        JAL:out={{13{in[31]}},in[19:12],in[20],in[30:21]};
        BEQ:out={{21{in[31]}},in[7],in[30:25],in[11:8]};
        LW:out={20'b0,in[31:20]};
        SW:out={20'b0,in[31:25],in[11:7]};
        ADDI:out={20'b0,in[31:20]};
        default:out=in;
        endcase
    end
endmodule
