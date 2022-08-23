`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/16/2022 08:39:06 PM
// Design Name: 
// Module Name: add
// Project Name: 
// Target Devices: Nexy4-DDR
// Tool Versions: 
// Description: 通用加法器
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module add #(parameter W=32)(
    input[W-1:0] in0,in1,
    output[W-1:0] out0
    );
assign out0=in0+in1;
endmodule
