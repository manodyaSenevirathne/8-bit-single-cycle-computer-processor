// Computer Architecture (CO224) - Lab 05 - Part 1
// Design: ALU
// Group Number : 17

`timescale  1ns/100ps
/**********************************************************************************/
// Define the FORWARD module
module forwardForALU(DATA2, RESULT);
	// Port declarations
	input [7:0] DATA2;
	output [7:0] RESULT;
	assign #1 RESULT=DATA2;
endmodule	// endmodule statement

/**********************************************************************************/
// Define the ADD module
module addForALU(DATA1, DATA2, RESULT);
	// Port declarations
	input [7:0] DATA1, DATA2;
	output [7:0] RESULT;
	assign #2 RESULT=DATA1 + DATA2;
endmodule	// endmodule statement

/**********************************************************************************/
// Define the AND module
module andForALU(DATA1, DATA2, RESULT);
	// Port declarations
	input [7:0] DATA1, DATA2;
	output [7:0] RESULT;
	assign #1 RESULT=DATA1 & DATA2;
endmodule	// endmodule statement

/**********************************************************************************/
// Define the OR module
module orForALU(DATA1, DATA2, RESULT);
	// Port declarations
	input [7:0] DATA1, DATA2;
	output [7:0] RESULT;
	assign #1 RESULT=DATA1 | DATA2;
endmodule	// endmodule statement

/**********************************************************************************/
// ALU 8-bit module 
module alu(DATA1, DATA2, SELECT, RESULT, ZERO);
	// Port declarations, Declarations of wire & reg
	input [7:0] DATA1, DATA2;
	input [2:0] SELECT;
	output reg [7:0] RESULT;
	output reg ZERO;
	wire [7:0] RESULT_FOR_FORWARD, RESULT_FOR_ADD, RESULT_FOR_AND, RESULT_FOR_OR;
	
	// Instantiate modules
	forwardForALU forward_1(DATA2, RESULT_FOR_FORWARD);
	addForALU add_1(DATA1, DATA2, RESULT_FOR_ADD);
	andForALU and_1(DATA1, DATA2, RESULT_FOR_AND);
	orForALU or_1(DATA1, DATA2, RESULT_FOR_OR);

	
	// Select everytime DATA1, DATA2, SELECT updates
	always @(DATA1, DATA2, SELECT)
	begin
		// Select the function to implement using a case structure
		case(SELECT)
			3'b000:	//FORWARD
				assign RESULT=RESULT_FOR_FORWARD;
			3'b001:	//ADD
				assign RESULT=RESULT_FOR_ADD;
			3'b010:	//AND
				assign RESULT=RESULT_FOR_AND;
			3'b011:	//OR
				assign RESULT=RESULT_FOR_OR;
			default: RESULT=8'b00000000;	//DEFAULT
		endcase
	end
	
    always @(RESULT_FOR_ADD) begin
        if (RESULT_FOR_ADD == 8'b00000000) begin
            ZERO = 1'b1;
        end

        else begin
            ZERO = 1'b0;
        end
    end 	
endmodule	// endmodule statement