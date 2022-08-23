`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/16/2022 08:38:04 PM
// Design Name: 
// Module Name: control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 单周期CPU控制单元
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control(
input [31:0]instruction,
output reg branch,mem_read,memto_reg,mem_write,alu_src,reg_write,
output reg[1:0] alu_op,output reg cmp_func
    );
    parameter JAL = 7'b1101111,BEQ=7'b1100011,LW=7'b0000011,SW=7'b0100011,ADDI=7'b0010011,ADD=7'b0110011;
    parameter CMP=1,ZERO_OUT=2,PLUS=3;
    
    always @(*) begin
        case(instruction[6:0])
        JAL:begin
        branch=1;
        mem_read=0;
        memto_reg=0;
        mem_write=0;
        alu_src=0;
        reg_write=0;
        alu_op=ZERO_OUT;
        cmp_func=0;
        end
        BEQ:begin
        branch=1;
        mem_read=0;
        memto_reg=0;
        mem_write=0;
        alu_src=0;
        reg_write=0;
        alu_op=CMP;
        if(instruction[14:12]==3'b000)
        cmp_func=0;
        else if(instruction[14:12]==3'b111)
        cmp_func=1;
        end
        LW:begin
        branch=0;
        mem_read=1;
        memto_reg=1;
        mem_write=0;
        alu_src=1;
        reg_write=1;
        alu_op=PLUS;
        cmp_func=0;
        end
        SW:begin
        branch=0;
        mem_read=0;
        memto_reg=0;
        mem_write=1;
        alu_src=1;
        reg_write=0;
        alu_op=PLUS;
        cmp_func=0;
        end
        ADDI:begin
        branch=0;
        mem_read=0;
        memto_reg=0;
        mem_write=0;
        alu_src=1;
        reg_write=1;
        alu_op=PLUS;
        cmp_func=0;
        end
        ADD:begin
        branch=0;
        mem_read=0;
        memto_reg=0;
        mem_write=0;
        alu_src=0;
        reg_write=1;
        alu_op=PLUS;
        cmp_func=0;
        end
        default:begin
        branch=0;
        mem_read=0;
        memto_reg=0;
        mem_write=0;
        alu_src=0;
        reg_write=0;
        alu_op=0;
        cmp_func=0;
        end
        endcase
    end
endmodule
