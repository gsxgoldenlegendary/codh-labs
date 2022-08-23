`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/16/2022 08:29:32 PM
// Design Name: 
// Module Name: edge_detecting
// Project Name: 
// Target Devices: Nexy4-DDR
// Tool Versions: 
// Description: 取边沿
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module edge_detecting(input a,
clk ,
output reg p);
reg r , s ,in_delay;
always @(posedge clk) begin
if (a)r <= 1;
else r <= 0;
end
always @(posedge clk) begin
if (r)s <= 1;
else s <= 0;
end
always @(posedge clk) begin
in_delay <= s ;
end
always @(*) begin
if (s&&!in_delay)
p <= 1;
else
p <= 0;
end
endmodule

