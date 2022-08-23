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


module edge_detecting(
    
    input [0:0]a,
    input [0:0]clk ,
    
    output reg [0:0]p

);

    reg [0:0]r;
    reg [0:0]s;
    reg [0:0]in_delay;

    always @(posedge clk) begin

        if (a)begin 
            r <= 1;
        end else begin
            r <= 0;
        end 
        
        if (r)begin 
            s <= 1;
        end else begin
            s <= 0;
        end

        in_delay <= s ;

    end
    
    always @(*) begin
        if (s&&!in_delay)begin
            p <= 1;
        end else begin
            p <= 0;
        end
    end

endmodule