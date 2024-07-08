`timescale 1ns / 1ps

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
