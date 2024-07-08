`timescale 1ns / 1ps



module data_buffer(clk, rst, acc_map, cnn_size,
act_in_sig1, act_in_sig2, act_in_sig3, act_in_sig4, act_in_sig5, act_in_sig6, act_in_sig7,
act_in_sig8, act_in_sig9, act_in_sig10, act_in_sig11, act_in_sig12, act_in_sig13, act_in_sig14,
act_in_sig15, act_in_sig16,
data_in1, data_in2, data_in3, data_in4, data_in5, data_in6, data_in7, data_in8,
 data_in9, data_in10, data_in11, data_in12, data_in13, data_in14, data_in15, data_in16,

col1, col2, col3, col4, col5, col6, col7, col8,
 col9, col10, col11, col12, col13, col14, col15, col16,

row1, row2, row3, row4, row5, row6, row7, row8, 
row9, row10, row11, row12, row13, row14, row15, row16,
gemm_size, state_in_signal, state_out_signal,control_out_signal,
gemm_out_signal,gemm_end_signal, 
ptr_in, ptr_out, buffer_line);


input [4:0] gemm_size; // 1~16 row count with finish count
input [4:0] cnn_size;
input[1:0] state_in_signal; // gemm, cnn, dnn
input[10:0] acc_map;
input clk, rst, gemm_out_signal;
input signed [19:0] data_in1, data_in2, data_in3, data_in4, data_in5, data_in6, data_in7, data_in8, data_in9, data_in10, data_in11, data_in12, data_in13, data_in14, data_in15, data_in16;

input [9:0] ptr_in, ptr_out; //pointer setting for data passing
input [6:0] buffer_line;
input act_in_sig1, act_in_sig2, act_in_sig3, act_in_sig4, act_in_sig5, act_in_sig6, act_in_sig7,
act_in_sig8, act_in_sig9, act_in_sig10, act_in_sig11, act_in_sig12, act_in_sig13, act_in_sig14,
act_in_sig15, act_in_sig16;

output reg gemm_end_signal; // signal to MMU, ready for getting data from buffer
output reg [1:0] state_out_signal;
output reg control_out_signal;
output [7:0] row1, row2, row3, row4, row5, row6, row7, row8, row9, row10, row11, row12, row13, row14, row15, row16;
output [19:0] col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15,  col16;

reg pcount =0;

reg [7:0] reg_row1,reg_row2,reg_row3,reg_row4,reg_row5,reg_row6,reg_row7,reg_row8,reg_row9,
reg_row10, reg_row11, reg_row12, reg_row13,reg_row14,reg_row15,reg_row16;
reg [7:0] reg_col1, reg_col2, reg_col3, reg_col4, reg_col5, reg_col6, reg_col7, reg_col8, reg_col9,
reg_col10, reg_col11, reg_col12, reg_col13, reg_col14, reg_col15, reg_col16;
reg [9:0] gemm_ptr_in, gemm_ptr_out;
reg [10:0] acc_memory1, acc_memory2, acc_memory3, acc_memory4, acc_memory5, acc_memory6, acc_memory7, acc_memory8, acc_memory9,
acc_memory10, acc_memory11, acc_memory12, acc_memory13, acc_memory14, acc_memory15, acc_memory16;
// for test, store just 32 data
reg signed [19:0] buffer [0:1000];

initial begin
	$readmemh("data_test.txt", buffer);
	//for cnn 
    end
    
always@(acc_map)begin
		acc_memory1 = acc_map; acc_memory2 =acc_map+16; 
		acc_memory3 = acc_map+32; acc_memory4 = acc_map+48;
		acc_memory5 = acc_map+64; acc_memory6 =acc_map+80;
		acc_memory7 = acc_map+96; acc_memory8 = acc_map+112;
		acc_memory9 = acc_map+128; acc_memory10 = acc_map + 144;
		acc_memory11 =acc_map + 160; acc_memory12 = acc_map + 176;
		acc_memory13 = acc_map + 192; acc_memory14 = acc_map + 208;
		acc_memory15 = acc_map + 224; acc_memory16 = acc_map+240;
		back_count1 =0; back_count2 =0; back_count3 =0; back_count4 =0; back_count5 =0; back_count6 =0; back_count7 =0; back_count8 =0;
		back_count9= 0; back_count10 =0; back_count11 =0; back_count12 =0; back_count13 =0; back_count14 =0; back_count15= 0; back_count16=0;
end 

reg [4:0] back_count1 ,back_count2, back_count3, back_count4, back_count5, back_count6, back_count7, back_count8,
back_count9, back_count10, back_count11, back_count12, back_count13, back_count14, back_count15, back_count16;
// act_in
always@(posedge clk)begin
		if(act_in_sig1)begin
		  control_out_signal <=0;
		  if(back_count1 > 15-gemm_size + cnn_size)begin
			buffer[acc_memory1] <=  data_in1;
			acc_memory1 <= acc_memory1 +1;		  
		  end
		  back_count1<= back_count1 +1;
		  if(back_count1==15)begin
		      back_count1 <=0;
		  end
		end
		
		if(act_in_sig2) begin
			if(back_count2>15-gemm_size + cnn_size)begin
			buffer[acc_memory2] <=  data_in2;
			acc_memory2 <= acc_memory2 +1;		  
		  end
		  back_count2<= back_count2 +1;
		  if(back_count2==15)begin
		      back_count2 <=0;
		  end
		end
		if(act_in_sig3)begin
			if(back_count3>15-gemm_size + cnn_size)begin
			buffer[acc_memory3] <=  data_in3;
			acc_memory3 <= acc_memory3 +1;		  
		  end
		  back_count3<= back_count3 +1;
		  if(back_count3==15)begin
		      back_count3 <=0;
		  end
		end
		if(act_in_sig4) begin
			if(back_count4>15-gemm_size + cnn_size)begin
			buffer[acc_memory4] <=  data_in4;
			acc_memory4 <= acc_memory4 +1;		  
		  end
		  back_count4 <= back_count4 +1;
		  if(back_count4==15)begin
		      back_count4 <=0;
		  end
		end
		if(act_in_sig5) begin
			if(back_count5>15-gemm_size + cnn_size)begin
			buffer[acc_memory5] <=  data_in5;
			acc_memory5 <= acc_memory5 +1;		  
		  end
		  back_count5 <= back_count5 +1;
		  if(back_count5==15)begin
		      back_count5 <=0;
		  end
		end
		if(act_in_sig6) begin
			if(back_count6>15-gemm_size + cnn_size)begin
			buffer[acc_memory6] <=  data_in6;
			acc_memory6 <= acc_memory6 +1;		  
		  end
		  back_count6 <= back_count6 +1;
		  if(back_count6==15)begin
		      back_count6 <=0;
		  end
		end
		if(act_in_sig7) begin
			if(back_count7 >15-gemm_size + cnn_size)begin
			buffer[acc_memory7] <=  data_in7;
			acc_memory7 <= acc_memory7 +1;		  
		  end
		  back_count7 <= back_count7 +1;
		  if(back_count7==15)begin
		      back_count7 <=0;
		  end
		end
		if(act_in_sig8) begin
			if(back_count8 >15-gemm_size + cnn_size )begin
			buffer[acc_memory8] <=  data_in8;
			acc_memory8 <= acc_memory8 +1;		  
		  end
		  back_count8 <= back_count8 +1;
		  if(back_count8==15)begin
		      back_count8 <=0;
		  end
		end
		if(act_in_sig9) begin
			if(back_count9>15-gemm_size + cnn_size)begin
			buffer[acc_memory9] <=  data_in9;
			acc_memory9 <= acc_memory9 +1;		  
		  end
		  back_count9<= back_count9 +1;
		  if(back_count9==15)begin
		      back_count9 <=0;
		  end
		end
		if(act_in_sig10) begin
			if(back_count10 >15-gemm_size + cnn_size)begin
			buffer[acc_memory10] <=  data_in10;
			acc_memory10 <= acc_memory10 +1;		  
		  end
		  back_count10 <= back_count10  +1;
		  if(back_count10==15)begin
		      back_count10 <=0;
		  end
		end
		if(act_in_sig11) begin
			if(back_count11>15-gemm_size+ cnn_size)begin
			buffer[acc_memory11] <=  data_in11;
			acc_memory11 <= acc_memory11 +1;		  
		  end
		  back_count11<= back_count11 +1;
		  if(back_count11==15)begin
		      back_count11 <=0;
		  end
		end
		if(act_in_sig12) begin
			if(back_count12>15-gemm_size + cnn_size)begin
			buffer[acc_memory12] <=  data_in12;
			acc_memory12 <= acc_memory12 +1;		  
		  end
		  back_count12<= back_count12 +1;
		  if(back_count12==15)begin
		      back_count12 <=0;
		  end
		end
		if(act_in_sig13) begin
			if(back_count13>15-gemm_size + cnn_size)begin
			buffer[acc_memory13] <=  data_in13;
			acc_memory13 <= acc_memory13 +1;		  
		  end
		  back_count13 <= back_count13 +1;
		  if(back_count13==15)begin
		      back_count13 <=0;
		  end
		end
		if(act_in_sig14) begin
			if(back_count14 >15-gemm_size + cnn_size)begin
			buffer[acc_memory14] <=  data_in14;
			acc_memory14 <= acc_memory14 +1;		  
		  end
		  back_count14 <= back_count14 +1;
		  if(back_count14==15)begin
		      back_count14 <=0;
		  end
		end
		if(act_in_sig15) begin
			if(back_count15 >15-gemm_size + cnn_size)begin
			buffer[acc_memory15] <=  data_in15;
			acc_memory15 <= acc_memory15 +1;		  
		  end
		  back_count15 <= back_count15 +1;
		  if(back_count15==15)begin
		      back_count15 <=0;
		  end
		end
		if(act_in_sig16) begin
			if(back_count16>15-gemm_size + cnn_size) begin
			buffer[acc_memory16] <=  data_in16;
			acc_memory16 <= acc_memory16 +1;		  
		  end
		  back_count16<= back_count16 +1;
		  if(back_count16==15)begin
			control_out_signal <= 1;
			back_count16 <= 0;
		  end
		end
end
// out_signal setting
always@(posedge clk or negedge rst)begin
	if(~rst) begin
		state_out_signal<=0;
	end
	else begin
		state_out_signal <= state_in_signal;

	end
end

// buffer pointer setting.
always@(ptr_in, ptr_out)begin

	gemm_ptr_in <= ptr_in;
	gemm_ptr_out <=ptr_out;
end


always@(posedge clk or negedge rst)begin
	if(~rst)begin
	reg_row1=0;reg_row2=0;reg_row3=0;reg_row4=0;reg_row5=0;reg_row6=0;reg_row7=0;reg_row8=0;
	reg_row9=0;reg_row10=0;reg_row11=0;reg_row12=0;reg_row13=0;reg_row14=0;reg_row15=0;reg_row16=0;
	
	reg_col1=0;reg_col2=0;reg_col3=0;reg_col4=0;reg_col5=0;reg_col6=0;reg_col7=0;reg_col8=0;reg_col9=0;
	reg_col10=0;reg_col11=0;reg_col12=0;reg_col13=0;reg_col14=0;reg_col15=0;reg_col16=0;
	gemm_end_signal<= 0;

	end

	else begin
		// counting out_signal , pass data
		// out_signal --> controlling the data 
				if(gemm_ptr_in != gemm_ptr_out) begin
				    gemm_end_signal <=1;
					if(gemm_size==1) begin
						reg_row1 <= buffer[gemm_ptr_in];
						reg_col1 <= buffer[gemm_ptr_in+buffer_line];
						gemm_ptr_in <= gemm_ptr_in + gemm_size;
					end
					else if(gemm_size==2)begin
						reg_row1<= buffer[gemm_ptr_in];
						reg_row2<= buffer[gemm_ptr_in+1];
						
						reg_col1 <= buffer[gemm_ptr_in+buffer_line];
						reg_col2 <= buffer[gemm_ptr_in+buffer_line+1];
					
						gemm_ptr_in <= gemm_ptr_in +gemm_size;
					end
					else if(gemm_size==3)begin
						reg_row1 <= buffer[gemm_ptr_in];
						reg_row2 <= buffer[gemm_ptr_in+1];
						reg_row3 <= buffer[gemm_ptr_in+2];

						reg_col1 <= buffer[gemm_ptr_in + buffer_line ];
						reg_col2 <= buffer[gemm_ptr_in+1 + buffer_line];
						reg_col3 <= buffer[gemm_ptr_in +2 + buffer_line];

						gemm_ptr_in <= gemm_ptr_in +gemm_size;
					end
					else if(gemm_size==4)begin
						reg_row1 <= buffer[gemm_ptr_in];
						reg_row2 <= buffer[gemm_ptr_in +1];
						reg_row3 <= buffer[gemm_ptr_in +2];
						reg_row4 <= buffer[gemm_ptr_in +3];

						reg_col1 <= buffer[gemm_ptr_in + buffer_line];
						reg_col2 <= buffer[gemm_ptr_in +1 + buffer_line];
						reg_col3 <= buffer[gemm_ptr_in+2 + buffer_line];
						reg_col4 <= buffer[gemm_ptr_in +3 + buffer_line];

						gemm_ptr_in <= gemm_ptr_in +gemm_size;

					end
				end
				else begin
			     gemm_end_signal<=0;
			 end
		end
			
end


/*
always@(posedge clk or negedge rst)	begin
	if(gemm_in_signal==1) begin
		buffer[gemm_ptr]<= data_in1;
		buffer[gemm_ptr+100] <= data_in2;
		buffer[gemm_ptr+200] <= data_in3;
		buffer[gemm_ptr+300] <= data_in4;
		gemm_ptr <= gemm_ptr +1;
	end
end
*/

assign row1 = reg_row1;
assign row2 = reg_row2;
assign row3 = reg_row3;
assign row4 = reg_row4;
assign row5 = reg_row5;
assign row6 = reg_row6;
assign row7= reg_row7;
assign row8 = reg_row8;
assign row9= reg_row9;
assign row10= reg_row10;
assign row11= reg_row11;
assign row12= reg_row12;
assign row13= reg_row13;
assign row14= reg_row14;
assign row15= reg_row15;
assign row16= reg_row16;

assign col1= reg_col1;
assign col2 = reg_col2;
assign col3 = reg_col3;
assign col4 = reg_col4;
assign col5= reg_col5;
assign col6= reg_col6;
assign col7 = reg_col7;
assign col8 = reg_col8;
assign col9 = reg_col9;
assign col10= reg_col10;
assign col11= reg_col11;
assign col12 = reg_col12;
assign col13 = reg_col13;
assign col14 = reg_col14;
assign col15 = reg_col15;
assign col16= reg_col16;


endmodule
