`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2020 10:59:58 PM
// Design Name: 
// Module Name: Clock_Divider
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


module Clock_Divider(
    input i_sys_clk,
    input i_enable,
    input [15:0] i_scaler, // CLK / scalar / 2 = sample rate
    output reg o_sample_clk_posedge
    );
    
    reg [15:0] r_count;

    always @(posedge i_sys_clk) begin
        if(!i_enable) begin
            r_count <= 0;
            o_sample_clk_posedge <= 0;
        end
        else if (r_count >= i_scaler) begin
            r_count <= 0;
            o_sample_clk_posedge <= 1;
        end
        else begin
            r_count <= r_count + 1;
            o_sample_clk_posedge <= 0;
        end
    end // End always    
    
endmodule
