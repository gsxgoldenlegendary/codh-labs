`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/16/2022 08:38:54 PM
// Design Name: 
// Module Name: mux
// Project Name: 
// Target Devices: 通用多路选择器
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


module mux #(parameter W=32)(
input [W-1:0]in0,in1,
input flag,
output [W-1:0]out0
    );
    assign out0=flag?in1:in0;
endmodule
