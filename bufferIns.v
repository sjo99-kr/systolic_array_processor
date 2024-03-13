`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/05 20:03:44
// Design Name: 
// Module Name: bufferIns
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


module Instruction_Buffer(address, instruction);
    input [5:0] address;
    output reg [50:0] instruction;
    
    reg [50:0] instruction_buffer [100:0];
    
    initial begin
        $readmemb("insbuffer.txt", instruction_buffer);
    end
    always@(address)begin
        instruction <= instruction_buffer[address];
    
        
    end

endmodule
