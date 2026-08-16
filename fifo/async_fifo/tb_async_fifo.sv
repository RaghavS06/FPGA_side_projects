`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 02:14:06 PM
// Design Name: 
// Module Name: tb_fifo_async
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


module tb_fifo_async();
    localparam WIDTH = 8;
    localparam DEPTH = 8;
    logic clk_wr;
    logic clk_re;
    logic rst;
    logic wr_en;
    logic re_en;
    logic [WIDTH-1:0] data_in;
    logic [WIDTH-1:0] data_out;
    logic valid_re;
    logic full;
    logic empty;
    
    //create DUT
    async_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dut (.*);
    //generate clocks
    always #3 clk_wr = ~clk_wr;
    always #7 clk_re = ~clk_re;
    
    //initial block
    initial begin
    clk_re = 0;
    clk_wr = 0;
    wr_en = 0;
    re_en = 0;
    rst = 1;
    repeat (5) @(posedge clk_wr);
    rst = 0;
    write_data(8'hA7);
    repeat (1) @(posedge clk_wr);
    write_data(8'hFE);
    repeat (1) @(posedge clk_wr);
    read_data();
    repeat (1) @(posedge clk_re);
    read_data();
    repeat (5) @(posedge clk_re);
    read_data();
    $finish;
    end
    
        //read task
    task automatic read_data();
        re_en = 1;
        wr_en = 0;
        @(posedge clk_re);
        re_en = 0;
    endtask
    
    //write task
    task automatic write_data (input logic [WIDTH - 1 : 0] data);
        data_in = data;
        wr_en = 1;
        re_en = 0;
        @(posedge clk_wr);
        data_in = 0;
        wr_en = 0;
    endtask
 
 
endmodule
