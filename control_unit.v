// Computer Architecture (CO224) - Lab 05
// Design: Control Unit for Integrated CPU module
// Author: Group 17

`timescale  1ns/100ps

module control_unit (
	input[7:0] OPCODE, 
	output reg [2:0] ALUOP, 
	output reg WRITEENABLE, 
	output reg MUXCOMP, 
	output reg MUXIMM,
	output reg J_TRIGGER, 
	output reg BEQ_TRIGGER,
	input BUSYWAIT,
	output reg READ,
	output reg WRITE,
	output reg MUXDATAMEM);
	// Here, 
	// MUXCOMP --> Multiplexer associate with 2's Complement Operation
	// MUXIMM --> Multiplexer associate with IMMEDIATE

    always @(BUSYWAIT) begin
		if (!BUSYWAIT) begin
			READ = 0;
			WRITE = 0;
		end
	end

	always @(OPCODE) begin
		//decoding the opcodes
		case(OPCODE)
			8'b00000000: begin #1			// op_loadi
				ALUOP = 3'b000;
				MUXCOMP = 1'b0;
				MUXIMM = 1'b1;
				WRITEENABLE = 1'b1;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b0;
				READ = 1'b0;
				WRITE = 1'b0;
				MUXDATAMEM = 1'b0;
			end

			8'b00000001: begin #1			// op_mov
				ALUOP = 3'b000;
				MUXCOMP = 1'b0;
				MUXIMM = 1'b0;
				WRITEENABLE = 1'b1;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b0;
				READ = 1'b0;
				WRITE = 1'b0;
				MUXDATAMEM = 1'b0;
			end

			8'b00000010: begin #1			// op_add
				ALUOP = 3'b001;
				MUXCOMP = 1'b0;
				MUXIMM = 1'b0;
				WRITEENABLE = 1'b1;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b0;
				READ = 1'b0;
				WRITE = 1'b0;
				MUXDATAMEM = 1'b0;
			end

			8'b00000011: begin #1			// op_sub
				ALUOP = 3'b001;
				MUXCOMP = 1'b1;
				MUXIMM = 1'b0;
				WRITEENABLE = 1'b1;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b0;				
				READ = 1'b0;
				WRITE = 1'b0;
				MUXDATAMEM = 1'b0;
			end

			8'b00000100: begin #1			// op_and
				ALUOP = 3'b010;
				MUXCOMP = 1'b0;
				MUXIMM = 1'b0;
				WRITEENABLE = 1'b1;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b0;				
				READ = 1'b0;
				WRITE = 1'b0;
				MUXDATAMEM = 1'b0;
			end

			8'b00000101: begin #1			// op_or
				ALUOP = 3'b011;
				MUXCOMP = 1'b0;
				MUXIMM = 1'b0;
				WRITEENABLE = 1'b1;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b0;				
				READ = 1'b0;
				WRITE = 1'b0;
				MUXDATAMEM = 1'b0;
			end	

			8'b00000110: begin #1			// op_j
				MUXCOMP = 1'b0;
				MUXIMM = 1'b0;
				WRITEENABLE = 1'b0;
				J_TRIGGER = 1'b1;
				BEQ_TRIGGER = 1'b0;				
				READ = 1'b0;
				WRITE = 1'b0;
				MUXDATAMEM = 1'b0;
			end	
				
			8'b00000111: begin #1			// op_beq
				ALUOP = 3'b001;
				MUXCOMP = 1'b1;
				MUXIMM = 1'b0;
				WRITEENABLE = 1'b0;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b1;
				READ = 1'b0;
				WRITE = 1'b0;
				MUXDATAMEM = 1'b0;
			end

			8'b00001000: begin #1			// op_lwd
				ALUOP = 3'b000;
				MUXCOMP = 1'b0;
				MUXIMM = 1'b0;
				WRITEENABLE = 1'b1;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b0;
				READ = 1'b1;
				WRITE = 1'b0;
				MUXDATAMEM = 1'b1;
			end
			
			8'b00001001: begin #1			// op_lwi
				ALUOP = 3'b000;
				MUXCOMP = 1'b0;
				MUXIMM = 1'b1;
				WRITEENABLE = 1'b1;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b0;
				READ = 1'b1;
				WRITE = 1'b0;
				MUXDATAMEM = 1'b1;
			end
				
			8'b00001010: begin #1			// op_swd
				ALUOP = 3'b000;
				MUXCOMP = 1'b0;
				MUXIMM = 1'b0;
				WRITEENABLE = 1'b0;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b0;
				READ = 1'b0;
				WRITE = 1'b1;
				MUXDATAMEM = 1'b0;
			end
				
			8'b00001011: begin #1			// op_swi
				ALUOP = 3'b000;
				MUXCOMP = 1'b0;
				MUXIMM = 1'b1;
				WRITEENABLE = 1'b0;
				J_TRIGGER = 1'b0;
				BEQ_TRIGGER = 1'b0;
				READ = 1'b0;
				WRITE = 1'b1;
				MUXDATAMEM = 1'b0;
			end	
		endcase        
	end
endmodule