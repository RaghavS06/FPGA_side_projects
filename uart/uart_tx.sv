`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2026 02:40:19 PM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx #(parameter CLKS_PER_BIT = 868) //same as rx code. 100MHz clock and 115200 baud rate
(
input logic clk,
input logic rst,
input tx_send,
input logic [7:0] data_in,
output logic tx_wire,
output logic tx_ready);

//fsm states
typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t; //fsm states
state_t state;

logic [3:0] bit_counter; // 3 bits needed for 8 bit counter
logic [9:0]clk_counter;  // 10 bits (1024) needed for 868
logic [7:0] data_internal;

always_ff @(posedge clk) begin
if (rst) begin
    tx_wire <= 1;
    tx_ready <= 1;
    bit_counter <= 0;
    clk_counter <= 0;
end else begin
    case (state) 
        IDLE:
            if (tx_send) begin
                data_internal <= data_in;
                tx_wire <= 0;
                tx_ready <= 0;
                clk_counter <= 0;
                bit_counter <= 0;
                state <= START;
            end else begin
                tx_wire <= 1;
                tx_ready <= 1;
            end
        START:
            if (clk_counter < CLKS_PER_BIT - 1) begin
                clk_counter <= clk_counter + 1;
            end else begin
                clk_counter <= 0;
                state <= DATA;
            end
        DATA:
            if (clk_counter < CLKS_PER_BIT - 1) begin
                tx_wire <= data_internal[bit_counter];
                clk_counter <= clk_counter + 1;
                end else begin  
                if (bit_counter == 7) begin
                    clk_counter <= 0;
                    state <= STOP;
                    end
                bit_counter <= bit_counter + 1;
                clk_counter <= 0;
            end      
        STOP:
            if (clk_counter < CLKS_PER_BIT - 1) begin
                tx_wire <= 1;
                clk_counter <= clk_counter + 1;
            end else begin  
                tx_wire <= 1; 
                tx_ready <= 1;
                clk_counter <= 0;
                bit_counter <= 0;
                state  <= IDLE;
            end
    endcase
end
end
endmodule
