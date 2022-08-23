`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2022 10:09:56 AM
// Design Name: 
// Module Name: mux_8_4
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


module mux_8_4 (input[31:0]in,
input [2:0]c ,
output reg [3:0]out);
always @(*) begin
case(c)
0:out=in[3:0];
1:out=in[7:4];
2:out=in[11:8];
3:out=in[15:12];
4:out=in[19:16];
5:out=in[23:20];
6:out=in[27:24];
7:out=in[31:28];
endcase
end
endmodule