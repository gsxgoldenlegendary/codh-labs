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
    
    parameter JAL=7'b1101111;
    parameter BEQ=7'b1100011;
    parameter LW=7'b0000011;
    parameter SW=7'b0100011;
    parameter ADDI=7'b0010011;
    parameter AUIPC=7'b0010111;
    parameter JALR=7'b1100111;
    
    always@(*)begin
        case(in[6:0])
        JAL:out={{13{in[31]}},in[19:12],in[20],in[30:21]};
        BEQ:out={{21{in[31]}},in[7],in[30:25],in[11:8]};
        LW:out={20'b0,in[31:20]};
        SW:out={20'b0,in[31:25],in[11:7]};
        ADDI:out={{21{in[31]}},in[30:20]};
        AUIPC:out={in[31:12],12'b0};
        JALR:out={20'b0,in[31:20]};
        default:out=in;
        endcase
    end

endmodule