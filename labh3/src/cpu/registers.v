`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: 郭耸霄
// 
// Create Date: 03/17/2022 08:33:46 PM
// Design Name: 
// Module Name: registers
// Project Name: 
// Target Devices: Nexy4-DDR
// Tool Versions: 
// Description: 单周期CPU32位寄存器文件
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module registers(
    
    input clk,
    input reg_write,
    input[4:0]read_addr0,
    read_addr1,
    read_addr2,
    write_addr,
    input[31:0]write_data,
    
    output reg [31:0]read_data0,
    read_data1,
    read_data2
    
);
  
    reg[31:0]register[31:0];
    
    integer i=0;
    
    initial begin
          for(i=0;i<32;i=i+1)
            register[i]=0;
    end
   
    always@(*)begin
        
        read_data2=register[read_addr2];
        
    end

    always @(*) begin
        if(reg_write)begin 
            if(read_addr0==write_addr)begin
                read_data0<=write_data;
            end else begin
                read_data0<=register[read_addr0];
            end
            if(read_addr1==write_addr)begin
                read_data1<=write_data;
            end else begin            
                read_data1<=register[read_addr1];
            end
        end else begin
            read_data0<=register[read_addr0];
            read_data1<=register[read_addr1];        
        end
    end

    always @(posedge clk) begin
        if(reg_write)begin 
            register[write_addr]<=write_data;
        end
    end

endmodule