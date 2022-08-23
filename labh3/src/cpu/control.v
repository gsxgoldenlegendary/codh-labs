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
    
    input [31:0]in,
    
    output [31:0] ctrl
    
);

    parameter JAL=7'b1101111;
    parameter BEQ=7'b1100011;
    parameter LW=7'b0000011;
    parameter SW=7'b0100011;
    parameter ADDI=7'b0010011;
    parameter ADD=7'b0110011;
    parameter AUIPC=7'b0010111;
    parameter JALR=7'b1100111;
    
    parameter BEQ_3=3'b000;
    parameter BLT_3=3'b100;

    parameter ADD_7=7'b0000000;
    parameter SUB_7=7'b0100000;

    parameter ALU_ADD=4'b0000;
    parameter ALU_SUB=4'b0001;
    parameter ALU_PASS=4'b0010;
    parameter NULL=4'b1111;

    wire[5:0]ex;
    reg[3:0]ALUOp;
    reg[0:0]branch;
    reg[1:0]ALUSrc;
    reg[1:0]m;
    reg[0:0]wb;
    reg[0:0]MemtoReg;

    always @(*) begin
        case (in[6:0])
            ADD:begin
                case (in[31:25])
                    ADD_7: begin
                        ALUOp=ALU_ADD;
                        ALUSrc=0;
                        branch=0;
                        m=0;
                        wb=1;
                        MemtoReg=0;
                    end 
                    SUB_7:begin
                        ALUOp=ALU_SUB;
                        ALUSrc=0;
                        branch=0;
                        m=0;
                        wb=1;
                        MemtoReg=0;
                    end
                    default: begin
                        ALUOp=NULL;
                        ALUSrc=3;
                        branch=0;
                        m=0;
                        wb=0;
                        MemtoReg=0;
                    end
                endcase
            end
            ADDI:begin
                ALUOp=ALU_ADD;
                ALUSrc=1;
                branch=0;
                m=0;
                wb=1;
                MemtoReg=0;
            end 
            AUIPC:begin
                ALUOp=ALU_ADD;
                ALUSrc=2;
                branch=0;
                m=0;
                wb=1;
                MemtoReg=0;
            end 
            BEQ:begin
                case (in[14:12])
                    BEQ_3: begin
                        ALUOp=NULL;
                        ALUSrc=3;
                        branch=1;
                        m=0;
                        wb=0;
                        MemtoReg=0;
                    end 
                    BLT_3:begin
                        ALUOp=NULL;
                        ALUSrc=3;
                        branch=1;
                        m=0;
                        wb=0;
                        MemtoReg=0;
                    end
                    default: begin
                        ALUOp=NULL;
                        ALUSrc=3;
                        branch=0;
                        m=0;
                        wb=0;
                        MemtoReg=0;
                    end
                endcase
            end 
            JAL:begin
                ALUOp=ALU_PASS;
                ALUSrc=3;
                branch=1;
                m=0;
                wb=1;
                MemtoReg=0;
            end 
            JALR:begin
                ALUOp=ALU_PASS;
                ALUSrc=3;
                branch=1;
                m=0;
                wb=1;
                MemtoReg=0;
            end 
            LW:begin
                ALUOp=ALU_ADD;
                ALUSrc=1;
                branch=0;
                m=2;
                wb=1;
                MemtoReg=1;
            end 
            SW:begin
                ALUOp=ALU_ADD;
                ALUSrc=1;
                branch=0;
                m=1;
                wb=0;
                MemtoReg=0;
            end  
            default: begin
                ALUOp=NULL;
                ALUSrc=0;
                branch=0;
                m=0;
                wb=0;
                MemtoReg=0;
            end
        endcase
    end

    assign ex={ALUSrc,ALUOp,branch};
    assign ctrl={18'b0,MemtoReg,wb,2'b0,m,2'b0,ex};

endmodule