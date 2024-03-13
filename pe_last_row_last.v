`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2023 09:00:32 PM
// Design Name: 
// Module Name: pe
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
module pe_last_row_last(clk,rst,state, row_in, col_in , weight, col_result ,flag, gemm_valid, sync_reset, gemm_valid2);
// clk: clock , rst : reset, state: CNN,DNN,GEMM
// data_in1
input clk, rst,sync_reset;
input [1:0] flag; //GEMM END -> 00, CNN END -> 01, DNN END -> 10, NORMAL -> 11;
input [7:0] row_in; //row data
input [19:0] col_in; // GEMM -> data, DNN,CNN -> 0, col data 
input [1:0] state;
input[7:0] weight;
input gemm_valid;


// type of calculation -> divde by using "state"
// calculate or not -> divde by using "~ of valid"

// input_result -> for next pe
output reg gemm_valid2;
output signed  [19:0] col_result;

// product_result -> for under pe or accumulator
reg [19:0] buffer; // 256 x 256 = 2^16 , maximum <2^16-1;
reg [19:0] product;

reg signal =0;
reg [4:0] pcount =0;
// valid on -> pass the calculated data to under blcok
// valid off -> pass the col input data to under block

// flag on -> calculate on
// flag off ->  calculate off


always@(posedge clk or negedge rst) begin
    if(~rst)begin
        gemm_valid2<=0;
        buffer<=0;
        product<=0;
    end

    if(gemm_valid==0 & signal==1) begin
            if(pcount<16)begin
                gemm_valid2<=1;
            end  
            else begin
                gemm_valid2<=0;
                signal<=0;
            end 
        end
    if(~rst)begin
        
    end

    else if (sync_reset)begin
         buffer<=0;
         product<=0;
    end

    else begin
        if(gemm_valid==0)begin
            if(signal==1)begin
                pcount<= pcount +1;
            end
        end
        // GEMM STATE
        if(state==2'b00)begin
                //gemm_valid ==1 -> calculating and store partial sum in register.
                if(gemm_valid==1)begin //pass to activation
                    pcount<=0;
                    signal<=1;
                    buffer <= row_in * col_in + buffer;
                    product <= col_in;
                end
                else begin
                    product<= buffer;
                    buffer<= col_in;
                end
        end
    end
  end
assign  col_result = product;
endmodule


