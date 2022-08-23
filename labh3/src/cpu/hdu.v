`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2022 09:26:12 AM
// Design Name: 
// Module Name: hdu
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


module hdu(
    
    input[31:0]ir,
    input[4:0]rd,
    input[1:0]m_ex,
    input[0:0]PCSrc,

    output reg[0:0]fStall,
    output reg[1:0]dStall,
    output reg[0:0]eFlush

);

    parameter JAL=7'b1101111;
    parameter BEQ=7'b1100011;

always @(*) begin
    if(m_ex==2&&(ir[19:15]==rd||ir[24:20]==rd))begin
        eFlush=1;
        dStall=2;
        fStall=0;
    end else if(PCSrc&&(ir[6:0]==JAL||ir[6:0]==BEQ))begin
        eFlush=1;
        dStall=3;
        fStall=1;
    end else begin
        eFlush=0;
        dStall=1;
        fStall=1;
    end
end
    
endmodule