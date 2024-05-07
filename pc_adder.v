// Computer Architecture (CO224) - Lab 05
// Design: Dedicated Adder for PC Increment
// Group Number : 17

`timescale  1ns/100ps

module pc_adder (
	input[31:0] PC,
	output reg [31:0] PCOUT);

	always @(PC) begin
		// default offset(4 bit) is set 
		// with time delay of 1 time unit
		#1 PCOUT = PC+4;
	end
endmodule