`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2026 11:58:20 AM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx #(parameter clks_per_bit = 868) //this is for 115200 baud rate at a 100MHz clock freq
(input logic clk, 
input logic rst,
input logic rx_pin,
output logic [7:0] data_out,
output logic valid,
output logic ready);

logic [9:0] clk_counter = 0; // 10 bits (1024) needed for 868
logic [7:0] bit_counter = 0; //8 bit uart signal
logic [7:0] read_data = 8'b0; //8 bits of data

typedef enum logic [1:0] {
IDLE,
START,
DATA,
STOP} state_t;

state_t state;

//double flop the incoming rx_pin
logic rx_pin_1;
logic rx_pin_2;

always_ff @(posedge clk) begin
    rx_pin_1 <= rx_pin;
    rx_pin_2 <= rx_pin_1;
    
    if (rst) begin
        ready <= 1;
        valid <= 0;
        clk_counter <= 0;
        bit_counter <= 0;
        read_data <= 0;
        state <= IDLE;
    end else begin
    case(state)
        IDLE:
            if (!rx_pin_2) begin
                ready <= 0;
                valid <= 0;
                clk_counter <= 0;                
                state <= START;
            end else begin
                valid <= 0;
            end
        START:
            if(clk_counter == clks_per_bit/2 - 1 && !rx_pin_2) begin
                clk_counter <= 0;
                state <= DATA;
            end else if (clk_counter == clks_per_bit/2 - 1 && rx_pin_2)begin
                clk_counter <= 0;
                ready <= 1;
                state <= IDLE;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        DATA:
            if (clk_counter == clks_per_bit - 1) begin
                read_data[bit_counter] <= rx_pin_2;
                bit_counter <= bit_counter + 1;
                clk_counter <= 0;
                if (bit_counter == 7) begin
                    clk_counter <= 0;
                    bit_counter <= 0;
                    state <= STOP;
                end
            end else begin
                clk_counter <= clk_counter + 1;
            end
        STOP:
            if (clk_counter == clks_per_bit - 1 && rx_pin_2) begin
                ready <= 1;
                valid <= 1;
                data_out <= read_data;
                state <= IDLE;
            end else if(clk_counter == clks_per_bit - 1 && !rx_pin_2) begin
                ready <= 1;
                valid <= 0;
                data_out <= 0;
                state <= IDLE;
            end else begin
                clk_counter <= clk_counter + 1;
            end
    endcase 
    end
end   
endmodule
