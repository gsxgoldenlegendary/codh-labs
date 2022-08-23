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

    input [0:0]x,
    input [0:0]clk,
    
    output reg [0:0]y
);

    reg [15:0]cnt ;
    
    initial begin
        cnt = 0;
    end
    
    always @(*) begin
        if(cnt == 50000)begin
            y = x;
        end else begin
            y=y;
        end
    end
    
    always @(posedge clk) begin
        if (cnt == 50000)begin
            cnt <= 0;
        end else begin 
            cnt <= cnt + 1;
        end
    end

endmodule