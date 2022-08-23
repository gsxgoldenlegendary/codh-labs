`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2022 08:28:22 PM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input x,clk,
    output reg y);
reg [15:0]cnt ;
initial begin
cnt = 0;
end
    always @(*) begin
        if(cnt == 50000)
            y = x;
    end
always @(posedge clk) begin
    if (cnt == 50000)
cnt <= 0;
else cnt <= cnt + 1;
end
endmodule
