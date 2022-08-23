`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2022 10:05:12 AM
// Design Name: 
// Module Name: decoder_3_8
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


module decoder_3_8 (input [2:0] in ,
output reg [7:0]out);
always @(*) begin
case (in)
0:out = 8'b11111110;
1:out = 8'b11111101;
2:out = 8'b11111011;
3:out = 8'b11110111;
4:out = 8'b11101111;
5:out = 8'b11011111;
6:out = 8'b10111111;
7:out = 8'b01111111;
default :out = 8'b11111111;
endcase
end
endmodule

