`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/18/2022 07:42:02 AM
// Design Name: 
// Module Name: program_counter
// Project Name: 
// Target Devices: Nexy4-DDR
// Tool Versions: 
// Description: 指令寄存器
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module program_counter(
input clk,rstn,
input [31:0]n_pc,
output reg[31:0]c_pc
    );
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            c_pc<=32'h3000;
        else
            c_pc<=n_pc;
    end
endmodule
