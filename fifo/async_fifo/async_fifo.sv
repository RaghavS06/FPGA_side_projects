`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 01:36:43 PM
// Design Name: 
// Module Name: async_fifo
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


module async_fifo #(parameter WIDTH = 8, parameter DEPTH = 8)(
input logic clk_wr,
input logic clk_re,
input logic rst,
input logic wr_en,
input logic re_en,
input logic [WIDTH-1:0] data_in,
output logic [WIDTH-1:0] data_out,
output logic valid_re,
output logic full,
output logic empty
);

//infer bram
logic [WIDTH-1:0] mem [DEPTH-1:0];

//get pointer width and initialize all the pointers im gonna use
localparam pnt_width = $clog2(DEPTH) + 1;
logic [pnt_width-1:0] re_pnt, wr_pnt, gray_re_pnt,
gray_wr_pnt, gray_wr_pnt_1, gray_wr_pnt_2, gray_re_pnt_1, gray_re_pnt_2;

//gray-code conversion from bianry to gray code
assign gray_re_pnt = re_pnt ^ (re_pnt >> 1);
assign gray_wr_pnt = wr_pnt ^ (wr_pnt >> 1);

//logic for empty/full flags
assign empty = gray_re_pnt == gray_wr_pnt_2;
assign full = (gray_re_pnt_2[pnt_width-1] != gray_wr_pnt[pnt_width-1]) &&
(gray_re_pnt_2[pnt_width-2] != gray_wr_pnt[pnt_width-2]) &&
(gray_re_pnt_2[pnt_width-3:0] == gray_wr_pnt[pnt_width-3:0]);

//double flopping both gray coded pointers for stability
always_ff @(posedge clk_re) begin
    gray_wr_pnt_1 <= gray_wr_pnt;
    gray_wr_pnt_2 <= gray_wr_pnt_1;
end

always_ff @(posedge clk_wr) begin
    gray_re_pnt_1 <= gray_re_pnt;
    gray_re_pnt_2 <= gray_re_pnt_1;
end

//write code
always_ff @(posedge clk_wr) begin
    if (rst) begin
        wr_pnt <= 0;
    end else if (wr_en && !full) begin
        mem[wr_pnt[pnt_width-2:0]] <= data_in;
        wr_pnt <= wr_pnt + 1;
    end  
end

//read code
always_ff @(posedge clk_re) begin
    if (rst) begin
        re_pnt <= 0;
        data_out <= 0;
        valid_re <= 0;
    end else if (re_en && !empty) begin
        data_out <= mem[re_pnt[pnt_width-2:0]];
        re_pnt <= re_pnt + 1;
        valid_re <= 1;
    end else begin
        valid_re <= 0;
    end
end

endmodule
