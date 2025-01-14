`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Matthew Crump
// 
// Create Date: 01/08/2019 12:51:52 AM
// Design Name: 
// Module Name: simpleSPI
// Project Name: Enxor Logic Analyzer
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//      Copyright (C) 2021  Matthew Crump
//
// 		This program is free software: you can redistribute it and/or modify
// 		it under the terms of the GNU General Public License as published by
// 		the Free Software Foundation, either version 3 of the License, or
// 		(at your option) any later version.
//
// 		This program is distributed in the hope that it will be useful,
// 		but WITHOUT ANY WARRANTY; without even the implied warranty of
// 		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// 		GNU General Public License for more details.
//
// 		You should have received a copy of the GNU General Public License
// 		along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module simpleSPI(
    input clk,
    input MISO,
    input rd,
    input rst,
    output reg SCLK,
    output reg CS,
    output reg d_rdy,
    output reg [15:0] d
    );
    
    reg timer;
    reg t_rst;
    
    reg [2:0] state;
    reg [3:0] r_bit; // bit keyword invalid in systemverilog
    reg [31:0] t_count;
    reg [31:0] sclk_count;
    
    //---------------------------
    // Clock Divider for SCLK:
    always @(posedge clk) begin
      if (!rst) begin
        sclk_count <= 0;
        SCLK <= 0;
      end else begin
        if (sclk_count > 25) begin
            SCLK <= ~SCLK;
            sclk_count <= 0;
        end
        else begin
            sclk_count <= sclk_count + 1;
        end
      end
    end
    //---------------------------
    
    //---------------------------
    // Timer Process
    always @(posedge SCLK) begin
        if (t_rst) begin
            timer <= 0;
            t_count <= 0;
        end
        else begin
            if (t_count > 10) begin
                timer <= 1;
            end
            else begin
                t_count <= t_count + 1;
            end
        end
    end
    //------------------------------
    
    //------------------------------
    // SPI State Machine
    localparam RESET = 0, INITIALIZE = 1, WAIT = 2, READ_SPI = 3, WAIT_ACK = 4;
    always @(posedge SCLK) begin
        if (!rst) begin
            state <= RESET;
            t_rst <= 0;
            r_bit <= 0;
            CS <= 1;
            d <= 0;
            d_rdy <= 0;
        end
        else begin
            case (state)
                RESET: begin
                    d_rdy = 0;
                    CS <= 1;
                    t_rst <= 1;
                    state <= INITIALIZE;
                end
                INITIALIZE: begin
                    t_rst <= 0;
                    state <= WAIT;                
                end
                WAIT: begin
                    if (timer & rd) begin
                        CS <= 0;
                        r_bit <= 15;
                        state <= READ_SPI;
                    end                
                end
                READ_SPI: begin
                    if (r_bit > 0) begin
                        d[r_bit] <= MISO;
                        r_bit <= r_bit -1;
                    end
                    else begin
                        d[r_bit] <= MISO;
                        d_rdy <= 1;
                        CS <= 1;
                        state <= WAIT_ACK;
                    end                                
                end
                WAIT_ACK: begin
                    if (rd == 0) begin
                        t_rst <= 1;
                        d_rdy <= 0;
                        state <= INITIALIZE;
                    end
                    else begin
                        state <= WAIT_ACK;
                    end                                                
                end
                default: state <= RESET;
            endcase
        end
    end
    //-------------------------------
    
endmodule
