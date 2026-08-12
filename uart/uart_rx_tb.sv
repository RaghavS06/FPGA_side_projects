`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2026 04:52:36 PM
// Design Name: 
// Module Name: tb
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


module uart_rx_tb();

     logic clk; 
     logic rst;
     logic rx_pin;
     logic [7:0] data_out;
     logic valid;
     logic ready;
     
    uart_rx #(.CLKS_PER_BIT(3)) dut (.*);
            
    initial begin
        clk = 0;
        rst = 1;
        repeat (dut.CLKS_PER_BIT) @(posedge clk);
        rst = 0;
        send_bit_pattern(8'hAB);
        repeat (10) @(posedge clk);
        $finish;
    end 
    
    always #5 clk = ~clk;
    
    
    task automatic send_bit_pattern (input logic  [7:0] data_in);
    rx_pin = 1'b0; 
    repeat (dut.CLKS_PER_BIT) @(posedge clk);
    for (int i = 0; i < 8; i++) begin 
        rx_pin = data_in[i]; 
        repeat (dut.CLKS_PER_BIT) @(posedge clk);
    end 
    rx_pin = 1'b1; 
    repeat (dut.CLKS_PER_BIT) @(posedge clk);
    endtask
   
endmodule
