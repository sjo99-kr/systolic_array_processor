`timescale 1ns / 1ps


module test_bench_a();
//reg -> input 
// wire -> output
// setting for all module
reg clk, rst;
wire gemm_out_signal;

//setting for data_buffer
wire gemm_finish;
// act_out_signal
wire act_valid1,act_valid2,act_valid3,act_valid4,act_valid5,act_valid6,act_valid7,act_valid8,act_valid9,act_valid10,act_valid11,act_valid12,act_valid13,
act_valid14,act_valid15,act_valid16;

// ptr setrting
wire [9:0]ptr_in, ptr_out;

wire mmu_out_signal;

wire signed [19:0] act_out1,act_out2,act_out3,act_out4,act_out5,act_out6,act_out7,act_out8,
act_out9,act_out10,act_out11,act_out12,act_out13,act_out14,act_out15,act_out16;
wire [4:0]gemm_size;
//setting for MMU
wire [1:0] state_in_signal;

wire[1:0] state_out_signal;
wire [4:0] cnn_size;
reg gemm_sig1;
reg [1:0] flag;
wire[7:0] row1, row2, row3, row4, row5, row6, row7, row8, row9, row10, row11, row12, row13, row14, row15, row16;
wire[19:0] col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16;
reg async_rst;
reg[7:0] weight1, weight2, weight3, weight4, weight5, weight6, weight7, weight8, weight9, weight10, weight11, weight12, weight13, weight14, weight15, weight16;

wire act_outsig1,act_outsig2,act_outsig3,act_outsig4,act_outsig5,act_outsig6, act_outsig7, act_outsig8, act_outsig9, act_outsig10,
act_outsig11,act_outsig12,act_outsig13,act_outsig14,act_outsig15,act_outsig16;

wire gemm_end_signal;

wire [19:0] outacc1,outacc2,outacc3,outacc4,outacc5,outacc6, outacc7, outacc8, outacc9, outacc10, outacc11, outacc12, outacc13, outacc14, outacc15, outacc16;
wire act_push;  //  MMU -> ACTIVIATION CONNECTION

wire [6:0] buffer_line;
wire control_out_signal;
wire [10:0] acc_map;

wire [5:0] address;
wire [50:0] instruction;

Instruction_Buffer Instruction_Buffer(.address(address), .instruction(instruction));

buffer_controller Controller(.clk(clk), .rst(rst), .finish_sign(control_out_signal), .instruction(instruction), .address(address), 
.gemm_size(gemm_size), .state_signal(state_in_signal), .ptr_in(ptr_in), .ptr_out(ptr_out), .acc_map(acc_map), .buffer_line(buffer_line),
.gemm_out_signal(gemm_out_signal), .cnn_size(cnn_size)
);


data_buffer data_buffer(
.clk(clk), .rst(rst), .acc_map(acc_map), .cnn_size(cnn_size),
.act_in_sig1(act_valid1), .act_in_sig2(act_valid2), .act_in_sig3(act_valid3), .act_in_sig4(act_valid4), .act_in_sig5(act_valid5), .act_in_sig6(act_valid6), .act_in_sig7(act_valid7),
.act_in_sig8(act_valid8), .act_in_sig9(act_valid9), .act_in_sig10(act_valid10), .act_in_sig11(act_valid11), .act_in_sig12(act_valid12), .act_in_sig13(act_valid13), .act_in_sig14(act_valid14),
.act_in_sig15(act_valid15), .act_in_sig16(act_valid16),
.data_in1(act_out1), .data_in2(act_out2), .data_in3(act_out3), .data_in4(act_out4), .data_in5(data_in5), .data_in6(data_in6), .data_in7(data_in7), .data_in8(data_in8),
.data_in9(data_in9), .data_in10(data_in10), .data_in11(data_in11), .data_in12(data_in12), .data_in13(data_in13), .data_in14(data_in14), .data_in15(data_in15), .data_in16(data_in16),
.col1(col1), .col2(col2), .col3(col3), .col4(col4), .col5(col5), .col6(col6), .col7(col7), .col8(col8), .col9(col9), .col10(col10), .col11(col11), .col12(col12), .col13(col13), .col14(col14), .col15(col15), .col16(col16),
.row1(row1), .row2(row2), .row3(row3), .row4(row4), .row5(row5), .row6(row6), .row7(row7), .row8(row8), .row9(row9), .row10(row10), .row11(row11), .row12(row12), .row13(row13), .row14(row14), .row15(row15), .row16(row16),
.gemm_size(gemm_size), .state_in_signal(state_in_signal), .state_out_signal(state_out_signal) , .control_out_signal(control_out_signal), 
.gemm_out_signal(gemm_out_signal), .gemm_end_signal(gemm_end_signal), 
.ptr_in(ptr_in), .ptr_out(ptr_out), .buffer_line(buffer_line) );


MMU mmu(clk, rst, gemm_end_signal ,state_out_signal,
 row1, row2, row3, row4, row5, row6, row7, row8, row9, row10, row11, row12, row13, row14, row15, row16
 ,async_rst
 ,col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16
 ,flag
 ,weight1, weight2, weight3, weight4, weight5, weight6, weight7, weight8, weight9, weight10, weight11, weight12, weight13, weight14, weight15, weight16
 
 ,outacc1,outacc2,outacc3,outacc4,outacc5,outacc6, outacc7, outacc8, outacc9, outacc10, outacc11, outacc12, outacc13, outacc14, outacc15, outacc16,
 
 act_outsig1, act_outsig2, act_outsig3, act_outsig4, act_outsig5, act_outsig6, act_outsig7, act_outsig8, act_outsig9, act_outsig10,
act_outsig11,act_outsig12,act_outsig13,act_outsig14,act_outsig15,act_outsig16, act_push);

reg [4:0] pcount;

always@(posedge clk)begin
    if(act_push==1) begin
        pcount <= pcount +1;
    end
end

// activation


activation activation(.clk(clk), .rst(rst), .gemm_sig(gemm_sig1),

.mmu_out1(outacc1),.mmu_out2(outacc2), .mmu_out3(outacc3), .mmu_out4(outacc4), .mmu_out5(outacc5), .mmu_out6(outacc6), .mmu_out7(outacc7), .mmu_out8(outacc8), 
.mmu_out9(outacc9), .mmu_out10(outacc10), .mmu_out11(outacc11), .mmu_out12(outacc12), .mmu_out13(outacc13), .mmu_out14(outacc14), .mmu_out15(outacc15), .mmu_out16(outacc16),

.act_insig1(act_outsig1), .act_insig2(act_outsig2), .act_insig3(act_outsig3), .act_insig4(act_outsig4), .act_insig5(act_outsig5), .act_insig6(act_outsig6), .act_insig7(act_outsig7), .act_insig8(act_outsig8),
.act_insig9(act_outsig9), .act_insig10(act_outsig10), .act_insig11(act_outsig11), .act_insig12(act_outsig12), .act_insig13(act_outsig13), .act_insig14(act_outsig14), .act_insig15(act_outsig15), .act_insig16(act_outsig16),

.act_out1(act_out1), .act_out2(act_out2), .act_out3(act_out3), .act_out4(act_out4), .act_out5(act_out5), .act_out6(act_out6), .act_out7(act_out7), .act_out8(act_out8),
.act_out9(act_out9), .act_out10(act_out10), .act_out11(act_out11), .act_out12(act_out12), .act_out13(act_out13), .act_out14(act_out14), .act_out15(act_out15), .act_out16(act_out16),

.act_out_valid1(act_valid1), .act_out_valid2(act_valid2), .act_out_valid3(act_valid3), .act_out_valid4(act_valid4), .act_out_valid5(act_valid5), .act_out_valid6(act_valid6), .act_out_valid7(act_valid7), .act_out_valid8(act_valid8),
.act_out_valid9(act_valid9), .act_out_valid10(act_valid10), .act_out_valid11(act_valid11), .act_out_valid12(act_valid12), .act_out_valid13(act_valid13), .act_out_valid14(act_valid14), .act_out_valid15(act_valid15), .act_out_valid16(act_valid16)
);


always #5 clk = ~clk;

initial begin
    clk =0;
    
    #1 rst =1;
    #1 rst=0;
 //   state_in_signal=2'b00;
    #5 gemm_sig1 =1;rst=1;
 //   gemm_out_signal=0;
  //  #10 state_in_signal=2'b00; ptr_in =0; ptr_out= 40; acc_map= 400;
 //   #10 gemm_out_signal <=1;
 //   #100 gemm_out_signal<=0;

    #3000;
    $finish;
end
endmodule