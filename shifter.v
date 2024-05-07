// Computer Architecture (CO224) - Lab 05
// Design: Module to shift
// Group Number : 17

`timescale  1ns/100ps
module shifter(
    input [31:0] OFFSET,
	output reg [31:0] OFFSET_SHIFTED);
	
	always @(OFFSET) begin
		OFFSET_SHIFTED=OFFSET<<2;
	end	  
endmodule	