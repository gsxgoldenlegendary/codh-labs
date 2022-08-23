`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2022 09:46:22 AM
// Design Name: 
// Module Name: fd
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


module fd(
    
    input [0:0]clk,
    input [0:0]rst,
    
    output reg [0:0]out

);

    parameter N = 200000;

    reg [19:0]cnt ;
    
    always @(posedge clk or negedge rst ) begin
        if (!rst )begin
             cnt <= 0;
        end else if (cnt == N-1)begin
            cnt <= 0;
        end else begin 
            cnt <= cnt + 1;
        end
    end

    always @(posedge clk) begin
        out <= (cnt == (N-1));
    end

endmodule