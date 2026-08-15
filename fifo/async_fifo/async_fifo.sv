`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2026 01:48:41 PM
// Design Name: 
// Module Name: sync_fifo
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


module sync_fifo #(parameter DEPTH = 8, parameter WIDTH = 8)(
input logic clk,
input logic rst,
input logic wr_en,
input logic re_en,
input logic [WIDTH - 1: 0] data_in,
output logic [WIDTH - 1 : 0] data_out,
output logic full,
output logic empty,
output logic re_valid
    );
    
//infer BRAM used in FIFO
logic [WIDTH - 1 : 0] mem [DEPTH - 1 : 0];
//determine pointer width for re/wr pointers
localparam pnt_width = $clog2(DEPTH) + 1;
//initialize pointers
logic [pnt_width - 1 : 0] re_pnt, wr_pnt;
//empty/full flags
assign empty = re_pnt == wr_pnt;
assign full = (re_pnt[pnt_width - 2 : 0] == wr_pnt[pnt_width - 2 : 0]) 
&& (re_pnt[pnt_width - 1] != wr_pnt[pnt_width - 1]);

//write logic
always_ff @(posedge clk) begin
    if (rst) begin
        wr_pnt <= 0;    
    end else if (wr_en && !full) begin
        mem[wr_pnt[pnt_width - 2 : 0]] <= data_in;
        wr_pnt <= wr_pnt + 1;
    end
end

//read logic
always_ff @(posedge clk) begin
    if (rst) begin
        re_pnt <= 0;
        data_out <= 0;
        re_valid <= 0;
    end else if (re_en && !empty) begin
        data_out <= mem[re_pnt[pnt_width - 2 : 0]];
        re_pnt <= re_pnt + 1;
        re_valid <= 1;
    end else begin
        re_valid <= 0;
    end
end   
 
endmodule
