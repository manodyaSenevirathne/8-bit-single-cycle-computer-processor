// Computer Architecture (CO224) - Lab 05
// Design: 2's Compliment Module
// Group Number : 17

`timescale  1ns/100ps
module twos_comp (IN, COMPLIMENT);
	input [7:0] IN;
	output reg [7:0] COMPLIMENT;
	reg [7:0] TEMP;
	
	always @(IN) begin
		TEMP = ~IN + 8'b00_000_001;
		#1 COMPLIMENT = TEMP;
	end
endmodule