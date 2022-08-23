`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2022 10:06:39 AM
// Design Name: 
// Module Name: cnt_3
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

module cnt_3 (
    
    input [0:0]clk ,
    input [0:0]rstn ,
    
    output reg [2:0] cnt 

);

    always @(posedge clk or negedge rstn) begin
        if (!rstn)begin
             cnt <= 0;
        end else begin
             cnt <= cnt + 1;
        end
    end
endmodule