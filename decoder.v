// Computer Architecture (CO224) - Lab 05
// Design: Module to decode 32 bit instruction
// Group Number : 17

`timescale  1ns/100ps

module decoder (
	input [31:0] INSTRUCTION, 
	output reg [7:0] OPCODE, 
	output reg [7:0] IMMEDIATE, 
	output reg [2:0] READREG2, 
	output reg [2:0] READREG1, 
	output reg [2:0] WRITEREG,
	output reg [7:0] OFFSET_8BIT);
    
	// Instruction decoding
    always @(INSTRUCTION) begin
        OPCODE = INSTRUCTION [31:24];

        // For jump instruction
        if (OPCODE == 8'b00000110) begin
            OFFSET_8BIT = INSTRUCTION [23:16]; 
        end 

        // For Branch instruction
        else if (OPCODE == 8'b00000111) begin
            OFFSET_8BIT = INSTRUCTION [23:16];
            READREG2 = INSTRUCTION [2:0];
            READREG1 = INSTRUCTION [10:8]; 
        end

		// For other instructions
        else begin
            IMMEDIATE = INSTRUCTION [7:0];
            READREG2 = INSTRUCTION [2:0];
            READREG1 = INSTRUCTION [10:8];
            WRITEREG = INSTRUCTION [18:16];
        end
    end
endmodule