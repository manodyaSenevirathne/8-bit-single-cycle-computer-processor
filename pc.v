// Computer Architecture (CO224) - Lab 05
// Design: Program Count Module
// Group Number : 17

`timescale  1ns/100ps
module pc (
	output reg [31:0] PC,
    input RESET,
    input CLK,
	input [31:0] PCOUT_EXECUTING,
	input BUSYWAIT);
	
	always @(posedge CLK) begin
		if (RESET) begin	// when resetting the pc,
			// write zero to pc value instead of the next pc value 
			// with a delay of 1 time unit
			#1 PC = 0;  
		end
	end

	always @(posedge CLK) begin
		if (!BUSYWAIT) begin
            // PC Update
            #1 PC = PCOUT_EXECUTING;
		end
	end
endmodule