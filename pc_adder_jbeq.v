// Computer Architecture (CO224) - Lab 05
// Design: Dedicated Adder for jump/branch instruction
// Group Number : 17

`timescale  1ns/100ps

module pc_adder_jbeq (
	input [31:0] PC,
    input [31:0] INSTRUCTION,
    input [31:0] OFFSET,
    output reg [31:0] PCOUT_JBeq);

    always @(INSTRUCTION) begin
		#2 PCOUT_JBeq=PC+OFFSET;
    end
endmodule