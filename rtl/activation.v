`timescale 1ns / 1ps

module activation(clk, rst ,gemm_sig,

mmu_out1,mmu_out2,mmu_out3,mmu_out4,mmu_out5,mmu_out6,mmu_out7,mmu_out8, mmu_out9,mmu_out10,mmu_out11,mmu_out12,mmu_out13,mmu_out14,mmu_out15,mmu_out16,

,act_insig1,act_insig2,act_insig3,act_insig4,act_insig5,act_insig6,act_insig7,act_insig8,
act_insig9,act_insig10, act_insig11, act_insig12, act_insig13, act_insig14, act_insig15, act_insig16,

act_out1,act_out2,act_out3,act_out4,act_out5,act_out6,act_out7,act_out8,
act_out9,act_out10,act_out11,act_out12,act_out13,act_out14,act_out15,act_out16,

act_out_valid1, act_out_valid2, act_out_valid3, act_out_valid4, act_out_valid5, act_out_valid6, act_out_valid7, act_out_valid8,
act_out_valid9, act_out_valid10, act_out_valid11, act_out_valid12, act_out_valid13, act_out_valid14, act_out_valid15, act_out_valid16
);
input clk, rst;
input  gemm_sig;

input [19:0] mmu_out1 ,mmu_out2,mmu_out3,mmu_out4,mmu_out5,mmu_out6,mmu_out7,mmu_out8,
mmu_out9,mmu_out10,mmu_out11,mmu_out12,mmu_out13,mmu_out14,mmu_out15,mmu_out16 ; 

input act_insig1,act_insig2,act_insig3,act_insig4,act_insig5,act_insig6,act_insig7,act_insig8,
act_insig9,act_insig10, act_insig11, act_insig12, act_insig13, act_insig14, act_insig15, act_insig16;

output reg signed [19:0] act_out1,act_out2,act_out3,act_out4,act_out5,act_out6,act_out7,act_out8,
act_out9,act_out10,act_out11,act_out12,act_out13,act_out14,act_out15,act_out16 ; 

output reg act_out_valid1, act_out_valid2, act_out_valid3, act_out_valid4, act_out_valid5, act_out_valid6, act_out_valid7, act_out_valid8,
act_out_valid9, act_out_valid10, act_out_valid11, act_out_valid12, act_out_valid13, act_out_valid14, act_out_valid15, act_out_valid16;


always@(posedge clk or negedge rst)begin
    if(~rst)begin
       act_out_valid1<=0; act_out_valid2 <=0; act_out_valid3<=0; act_out_valid4<=0; act_out_valid5<=0; act_out_valid6<=0; 
       act_out_valid7<=0; act_out_valid8<=0; act_out_valid9<=0; act_out_valid10<=0; act_out_valid11<=0; act_out_valid12<=0;
       act_out_valid13<=0; act_out_valid14<=0; act_out_valid15<=0; act_out_valid16<=0;  
    end
    else begin
        act_out_valid1 <= act_insig1;
        act_out_valid2 <= act_insig2;
        act_out_valid3 <= act_insig3;
        act_out_valid4 <= act_insig4;
        act_out_valid5 <= act_insig5;
        act_out_valid6 <= act_insig6;
        act_out_valid7 <= act_insig7;
        act_out_valid8 <= act_insig8;
        act_out_valid9 <= act_insig9;
        act_out_valid10 <= act_insig10;
        act_out_valid11 <= act_insig11;
        act_out_valid12 <= act_insig12;
        act_out_valid13 <= act_insig13;
        act_out_valid14 <=  act_insig14;
        act_out_valid15 <= act_insig15;
        act_out_valid16 <= act_insig16;
    end

end

always@(posedge clk or negedge rst)begin
    if(~rst)begin
        act_out1<=0; act_out2<=0; act_out3 <=0; act_out4<=0; act_out5 <=0; act_out6 <=0; act_out7 <=0; act_out8 <=0;
        act_out9<=0; act_out10<= 0; act_out11<=0; act_out12<=0; act_out13<=0; act_out14<=0; act_out15<=0; act_out16<=0;
        act_out_valid1<=0; act_out_valid2 <=0; act_out_valid3<=0; act_out_valid4<=0; act_out_valid5<=0; act_out_valid6<=0; 
        act_out_valid7<=0; act_out_valid8<=0; act_out_valid9<=0; act_out_valid10<=0; act_out_valid11<=0; act_out_valid12<=0;
        act_out_valid13<=0; act_out_valid14<=0; act_out_valid15<=0; act_out_valid16<=0; 
    end
    else begin
        if(act_insig1)begin
            if(mmu_out1[19]==0)begin
                act_out1 <= mmu_out1;
            end
            else begin
                act_out1<=0;
            end
        end
        if(act_insig2)begin
            if(mmu_out2[19]==0)begin
                act_out2 <= mmu_out2;
            end
            else begin
                act_out2<=0;
            end
        end
        if(act_insig3)begin
            if(mmu_out3[19]==0)begin
                act_out3 <= mmu_out3;
            end
            else begin
                act_out3<=0;
            end
        end
        if(act_insig4)begin
            if(mmu_out4[19]==0)begin
                act_out4 <= mmu_out4;
            end
            else begin
                act_out4<=0;
            end
        end
        if(act_insig5)begin
            if(mmu_out5[19]==0)begin
                act_out5 <= mmu_out5;
            end
            else begin
                act_out5<=0;
            end
        end
        if(act_insig6)begin
            if(mmu_out6[19]==0)begin
                act_out6 <= mmu_out6;
            end
            else begin
                act_out6<=0;
            end
        end
        if(act_insig7)begin
            if(mmu_out7[19]==0)begin
                act_out7 <= mmu_out7;
            end
            else begin
                act_out7<=0;
            end
        end
        if(act_insig8)begin
            if(mmu_out8[19]==0)begin
                act_out8 <= mmu_out8;
            end
            else begin
                act_out8<=0;
            end
        end
        if(act_insig9)begin
            if(mmu_out9[19]==0)begin
                act_out9 <= mmu_out9;
            end
            else begin
                act_out9<=0;
            end
        end
        if(act_insig10)begin
            if(mmu_out10[19]==0)begin
                act_out10 <= mmu_out10;
            end
            else begin
                act_out10<=0;
            end
        end
        if(act_insig11)begin
            if(mmu_out11[19]==0)begin
                act_out11 <= mmu_out11;
            end
            else begin
                act_out11<=0;
            end
        end
        if(act_insig12)begin
            if(mmu_out12[19]==0)begin
                act_out12 <= mmu_out12;
            end
            else begin
                act_out12<=0;
            end
        end
        if(act_insig13)begin
            if(mmu_out13[19]==0)begin
                act_out13 <= mmu_out13;
            end
            else begin
                act_out13<=0;
            end
        end
        if(act_insig14)begin
            if(mmu_out14[19]==0)begin
                act_out14 <= mmu_out14;
            end
            else begin
                act_out14<=0;
            end
        end
        if(act_insig15)begin
            if(mmu_out15[19]==0)begin
                act_out15 <= mmu_out15;
            end
            else begin
                act_out15<=0;
            end
        end
        if(act_insig16)begin
            if(mmu_out16[19]==0)begin
                act_out16 <= mmu_out16;
            end
            else begin
                act_out16<=0;
            end
        end
    end
end

endmodule
