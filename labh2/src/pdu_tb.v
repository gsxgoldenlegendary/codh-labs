`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2022 01:57:44 PM
// Design Name: 
// Module Name: pdu_tb
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


module pdu_tb(

    );
    
  
  reg clk;	   //clk100mhz
  reg rstn;	   //cpu_resetn
  reg step;	   //btnu
  reg cont;	   //btnd
  reg chk;	   //btnr
  reg ent;	   //btnc
  reg del;	   //btnl
  reg [15:0]  hd;    //sw15-0
  wire pause;         //led16r
  wire [15:0] led;  //led15-0
  wire [7:0] an;     //an7-0
  wire [7:0] seg;   //ca-cg 

topmodule_2 topmodule_2(
   clk,	   //clk100mhz
   rstn,	   //cpu_resetn
   step, 	   //btnu
   cont,	   //btnd
   chk,	   //btnr
   ent,	   //btnc
   del,	   //btnl
   hd,    //sw15-0
   pause,         //led16r
  led,  //led15-0
   an,     //an7-0
   seg   //ca-cg 
); 
initial begin
    clk=0;
    rstn=0;
    hd=0;
    cont=0;
    del=0;
    chk=0;
    #10 rstn=1;
    forever begin
        #10 clk=~clk;
    end
end
initial begin
    #20 hd[3]=1;
    #20 hd[3]=0;
    #20 hd[0]=1;
    #20 hd[0]=0;
    #20 hd[8]=1;
    #20 hd[8]=0;
    #20 hd[0]=1;
    #20 hd[0]=0;
    #20 cont=1;
    #20 cont=0;
    #3300 ent=1;
    #20 ent=0;
    #300 ent=1;
    #20 ent=0;
    #300 ent=1;
    #20 ent=0;
end
endmodule
