`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2022 10:13:25 AM
// Design Name: 
// Module Name: db_ps
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


module db_ps(
input clk,step,cont,chk,ent,del,[15:0]hd,
output step_ps,cont_ps,chk_ps,ent_ps,del_ps,[15:0]hd_ps
    );
wire step_db,cont_db,chk_db,ent_db,del_db;
wire [15:0]hd_db;
debounce debounce1(step,clk,step_db);
debounce debounce2(cont,clk,cont_db);
debounce debounce3(chk,clk,chk_db);
debounce debounce4(ent,clk,ent_db);
debounce debounce5(del,clk,del_db);
debounce debounce6(hd[0],clk,hd_db[0]);
debounce debounce7(hd[1],clk,hd_db[1]);
debounce debounce8(hd[2],clk,hd_db[2]);
debounce debounce9(hd[3],clk,hd_db[3]);
debounce debouncea(hd[4],clk,hd_db[4]);
debounce debounceb(hd[5],clk,hd_db[5]);
debounce debouncec(hd[6],clk,hd_db[6]);
debounce debounced(hd[7],clk,hd_db[7]);
debounce debouncee(hd[8],clk,hd_db[8]);
debounce debouncef(hd[9],clk,hd_db[9]);
debounce debounce10(hd[10],clk,hd_db[10]);
debounce debounce11(hd[11],clk,hd_db[11]);
debounce debounce12(hd[12],clk,hd_db[12]);
debounce debounce13(hd[13],clk,hd_db[13]);
debounce debounce14(hd[14],clk,hd_db[14]);
debounce debounce15(hd[15],clk,hd_db[15]);
edge_detecting edge_detecting0(step_db,clk,step_ps);
edge_detecting edge_detecting1(cont_db,clk,cont_ps);
edge_detecting edge_detecting2(chk_db,clk,chk_ps);
edge_detecting edge_detecting3(ent_db,clk,ent_ps);
edge_detecting edge_detecting4(del_db,clk,del_ps);
edge_detecting edge_detecting5(hd_db[0],clk,hd_ps[0]);
edge_detecting edge_detecting6(hd_db[1],clk,hd_ps[1]);
edge_detecting edge_detecting7(hd_db[2],clk,hd_ps[2]);
edge_detecting edge_detecting8(hd_db[3],clk,hd_ps[3]);
edge_detecting edge_detecting9(hd_db[4],clk,hd_ps[4]);
edge_detecting edge_detectinga(hd_db[5],clk,hd_ps[5]);
edge_detecting edge_detectingb(hd_db[6],clk,hd_ps[6]);
edge_detecting edge_detectingc(hd_db[7],clk,hd_ps[7]);
edge_detecting edge_detectingd(hd_db[8],clk,hd_ps[8]);
edge_detecting edge_detectinge(hd_db[9],clk,hd_ps[9]);
edge_detecting edge_detectingf(hd_db[10],clk,hd_ps[10]);
edge_detecting edge_detecting10(hd_db[11],clk,hd_ps[11]);
edge_detecting edge_detecting11(hd_db[12],clk,hd_ps[12]);
edge_detecting edge_detecting12(hd_db[13],clk,hd_ps[13]);
edge_detecting edge_detecting13(hd_db[14],clk,hd_ps[14]);
edge_detecting edge_detecting14(hd_db[15],clk,hd_ps[15]);

endmodule
