`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2022 10:16:45 AM
// Design Name: 
// Module Name: dis
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


module dis(
input clk,rst,[31:0]in,
output[7:0]an,seg
    );
wire clkd ;
wire [2:0]cntd;
wire [3:0]muxd;
fd fd(. clk(clk ) ,
. rst ( rst ) ,
.out(clkd ));
cnt_3 cnt(. clk(clkd) ,
. rstn( rst ) ,
. cnt(cntd));
decoder_3_8 decoder(. in(cntd) 
,.out(an)
);
mux_8_4 mux(. c(cntd) ,
.in(in),
.out(muxd));
decoder_4_7 decoder2(. in(muxd) ,
.out(seg[7:1]));
//assign an=8'b00000000;
endmodule
