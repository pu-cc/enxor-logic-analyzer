`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2020 06:48:06 PM
// Design Name: 
// Module Name: Data_Buffer_tb
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


module Data_Buffer_tb;

    reg clk, rst, enable, start_read, r_ack;
    wire [7:0] w_time, w_channels;
    reg [11:0] count;
    
    wire buffer_full, w_sample_clk_posedge, w_rollover, w_triggered_state, w_event, finished_read, post_read, t_rdy;
    wire [15:0] data;
    
    Pulse_Sync #(.DATA_WIDTH(8))PS (
        .i_sys_clk(clk),
        .i_async(count[11:4]),
        .o_sync(w_channels)
    );
    
    Clock_Divider CD (
        .i_sys_clk(clk),
        .i_rstn(rst),
        .i_scaler(5),
        .o_sample_clk_posedge(w_sample_clk_posedge)
    );
    
    Timestamp_Counter TSC (
        .i_sys_clk(clk),
        .i_rstn(rst),
        .i_incr(w_sample_clk_posedge),
        .i_event(w_event),
        .o_rollover(w_rollover),
        .o_time(w_time)    
    );
    
    Trigger_Controller #(.DATA_WIDTH(8)) TC (
        .i_sys_clk(clk),
        .i_rstn(rst),
        .i_data(w_channels),
        .i_channel_select(4),
        .i_trigger_type(1),
        .i_enable(enable),
        .i_sample_clk_posedge(w_sample_clk_posedge),
        .o_triggered_state(w_triggered_state),
        .o_event_pulse(w_event)
        );
        
    Data_Buffers #(.PACKET_WIDTH(16), .PRE_DEPTH(4), .POST_DEPTH(12)) DUT (
        .i_sys_clk(clk),
        .i_rstn(rst),
        .i_enable(enable),
        .i_triggered_state(w_triggered_state),
        .i_event(w_event | w_rollover),
        .i_r_ack(r_ack),
        .i_start_read(start_read),
        .i_data({w_time, w_channels}),
        .o_post_read(post_read),
        .o_buffer_full(buffer_full),
        .o_finished_read(finished_read),
        .o_data(data),
        .o_t_rdy(t_rdy)
    );
    
    always
        #2 clk = ~clk;
        
    initial begin
        clk = 0;
        rst = 0;
        enable =0;
        count = 0;
        r_ack = 0;
        start_read = 0;
        #50 rst = 1;
        #15 enable = 1;
    end
    
    always @(posedge clk) begin
        
        
        if (finished_read) begin
            r_ack <= 0;
            #250 start_read <= 0;
            #25 enable <= 0;
            #100 $finish;     
        end
        else if(buffer_full && !start_read) begin
            #100 start_read <= 1;
        end
    end // End always

    always @(posedge clk) begin
        count <= count + 1;
        if (start_read) begin
            if(t_rdy) begin
                r_ack <= 1;
            end
            else if (r_ack) begin
                r_ack <= 0;
                #300; // Simulate send time through UART
            end
        end
    end
    
endmodule