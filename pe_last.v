`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/30 17:20:36
// Design Name: 
// Module Name: pe_last
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
module pe_last(clk, rst,state, data_in1, data_in2 ,weight, product_result,flag,gemm_valid,sync_reset,gemm_valid2);
input gemm_valid;
input clk,rst,sync_reset;
input [1:0] flag; //GEMM END -> 00, CNN END -> 01, DNN END -> 10, NORMAL -> 11;
input [7:0]data_in1;
input [19:0] data_in2; // GEMM -> data, DNN,CNN -> 0 
input [1:0] state;
input[7:0] weight;

output signed [19:0]product_result; // 256 x 256 = 2^16 , maximum <2^16-1;
output reg gemm_valid2;

reg [19:0] buffer; // 2^8 * 2^8 *4;
reg [19:0] product;

// type of calculation -> divde by using "state"
// calculate or not -> divde by using "~ of valid"

always@(posedge clk or negedge rst or posedge sync_reset) begin
    if(~rst)begin
        product <=0;
        buffer<=0;
    end
    else if (sync_reset)begin
        product<=0;
        buffer<=0;
    end
    else begin
        if(state==2'b00)begin
            if(gemm_valid)begin
                gemm_valid2 <= 1;
                buffer <= data_in1 * data_in2 + buffer;
                product <= data_in2;    
            end
            else begin
                gemm_valid2 <=0;
                product <= buffer;
                buffer<= data_in2;
            end  
        end
    end
end


assign product_result = product;

endmodule

