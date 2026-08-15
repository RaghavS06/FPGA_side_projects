`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2026 02:12:14 PM
// Design Name: 
// Module Name: tb_fifo
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


module tb_fifo();

    localparam WIDTH = 8;
    localparam DEPTH = 8;
     logic clk;
     logic rst;
     logic wr_en;
     logic re_en;
     logic [WIDTH - 1: 0] data_in;
     logic [WIDTH - 1 : 0] data_out;
     logic full;
     logic empty;
     logic re_valid;
    
    //instantiate dut
    sync_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dut(.*);
    
    //generate clock
    always #5 clk = ~clk;
    
    
    //initial block
    initial begin
    clk = 0;
    rst = 1;
    repeat (3) @(posedge clk);
    rst = 0;
    write_data(8'hFF);
    read_data();
    write_data(8'h1D);
    write_data(8'hAB);
    write_data(8'h10);
    write_data(8'h10);
    write_data(8'h10);
    write_data(8'h10);
    write_data(8'h10);
    write_data(8'h10);
    write_data(8'h10);
    write_data(8'h10);
    read_data();
    read_data();
    read_data();
    
//    if (!re_valid) begin
//        $error("not a valid read");
//    end else if (data_out !== 8'hFF) begin
//        $error("not the right data output");
//    end else begin
//        $display("data read correctly as 0x%0h", data_out);
//    end
    
    $finish;
    end
    
    //read task
    task automatic read_data();
        re_en = 1;
        wr_en = 0;
        @(posedge clk);
        re_en = 0;
    endtask
    
    
    //write task
    task automatic write_data (input logic [WIDTH - 1 : 0] data);
        data_in = data;
        wr_en = 1;
        re_en = 0;
        @(posedge clk);
        data_in = 0;
        wr_en = 0;
    endtask
    
endmodule
