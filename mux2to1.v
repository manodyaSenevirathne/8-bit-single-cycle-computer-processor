// Computer Architecture (CO224) - Lab 05
// Design: 2 to 1 Multiplexer module
// Group Number : 17

`timescale  1ns/100ps

module mux2to1(IN1, IN2, OUT, SELECT);
	input [7:0] IN1, IN2;
	input SELECT;
	output reg [7:0] OUT;

    always @(*) begin 
        if (SELECT) begin 
            OUT = IN2; 
        end 

        else OUT = IN1;  
    end	
endmodule