`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2022 09:33:13 AM
// Design Name: 
// Module Name: data_memory
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


module data_memory(

    input [0:0]clk,
    input [0:0]MemWrite,
    input [0:0]MemRead,
    input [7:0]address,
    input [31:0]writeData,
    input [31:0]io_din,
    input [7:0]dm_rf_addr,

    output reg[31:0]readData,
    output reg[31:0]io_dout,
    output reg[7:0]io_addr,
    output reg[0:0]io_we,
    output reg[0:0]io_rd,
    output[31:0]dm_data

);
    
    reg [0:0]dm_we;
    wire[31:0]dm_rdata;
    reg[31:0]dm_wdata;

    dist_mem_gen_0 dm(
        .a(address),
        .d(dm_wdata),
        .dpra(dm_rf_addr),
        .spo(dm_rdata),
        .dpo(dm_data),
        .clk(clk),
        .we(dm_we)
    );

    always @(*) begin
        if(MemWrite)begin
            if(address==0||address==2||address==6)begin
                io_addr=address;
                io_dout=writeData;
                io_we=1;
                dm_we=0;
            end else begin
                io_we=0;
                dm_we=1;
                dm_wdata=writeData;
                io_dout=io_dout;
                io_addr=io_addr;
            end
        end else begin 
            io_we=0;
            dm_we=0;
            if (MemRead)begin
                if(address==1||address==3||address==4||address==5||address==7||address==8||address==9||address==10)begin
                    io_addr=address;
                    readData=io_din;
                    io_rd=1;
                end else begin
                    io_addr=io_addr;
                    io_rd=0;
                    readData=dm_rdata;
                end 
            end else begin
                io_dout=io_dout;
                io_rd=io_rd;
                io_addr=io_addr;
                readData=readData;
                dm_wdata=dm_wdata;
            end
        end
    end

endmodule