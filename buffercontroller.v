`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/05 19:37:27
// Design Name: 
// Module Name: buffercontroller
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


module buffer_controller(clk, rst, finish_sign, instruction,  address, gemm_size, state_signal, ptr_in, ptr_out, acc_map, buffer_line, gemm_out_signal, cnn_size);
    input clk, rst;
    input finish_sign;
    input [50:0] instruction;
    output reg [5:0] address =0;
    output reg [10:0] acc_map;
    output reg [1:0] state_signal;
    output reg gemm_out_signal;
    output reg [4:0] gemm_size;
    output reg [6:0] buffer_line;
    output reg [9:0] ptr_in, ptr_out;
    output reg [4:0] cnn_size;
    
    always@(finish_sign)begin
            if(finish_sign==1)begin
                address <= address +1;
            end
    end
    
    always@(instruction)begin
        acc_map <= instruction[10:0];
        state_signal <= instruction[12:11];
        gemm_out_signal <= instruction[13];
        gemm_size <= instruction[18:14];
        buffer_line <= instruction[25:19];
        ptr_in <= instruction[35:26];
        ptr_out <= instruction[45:36];
        cnn_size <= instruction [50:46];
    end
endmodule
