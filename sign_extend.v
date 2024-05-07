// Computer Architecture (CO224) - Lab 05
// Design: Sign Extend Module
// Group Number : 17

`timescale  1ns/100ps
module sign_extend(
    input [7:0] OFFSET_8BIT,
	output reg [31:0] OFFSET_32BIT);
	
	always @(OFFSET_8BIT) begin
		OFFSET_32BIT={{24{OFFSET_8BIT[7]}},OFFSET_8BIT};
	end	  
endmodule	