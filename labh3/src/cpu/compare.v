`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2022 11:24:40 AM
// Design Name: 
// Module Name: compare
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


module compare(

    input[31:0]sr0,
    input[31:0]sr1,
    input[2:0]funct3,
    input[6:0]opcode,
    
    output reg[0:0]cmpSignal
);

    parameter JAL = 7'b1101111;
    parameter BEQ = 7'b1100011;
    parameter BEQ_3=3'b000;
    parameter BLT_3=3'b100;

    always @(*) begin
        if(opcode==JAL)begin
            cmpSignal=1;
        end else if (opcode==BEQ)begin
            if(funct3==BEQ_3)begin
                cmpSignal=(sr0==sr1)?1:0;
            end else if(funct3==BLT_3)begin
                cmpSignal=(sr0<sr1)?1:0;
            end
        end else begin
            cmpSignal=0;
        end
    end

endmodule