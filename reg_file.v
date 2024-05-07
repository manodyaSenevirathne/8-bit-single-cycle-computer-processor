// Computer Architecture (CO224) - Lab 05
// Design: Register File of Simple Processor
// Group Number : 17

`timescale  1ns/100ps
module reg_file (
    input[7:0] IN,
    output[7:0] OUT1,
    output[7:0] OUT2,
    input[2:0] INADDRESS,
    input[2:0] OUT1ADDRESS,
    input[2:0] OUT2ADDRESS,
    input WRITE,
    input CLK,
    input RESET);

    // 8 element array of 8 bit registers
    reg [7:0] register[0:7];
    
    /********************************************************************/

    ///////////////// REGISTER READING OPERATIONS ////////////////////////
    // These assign statements are executed asynchrnously
    // (data is sent parallelly)

    // Note that, artificial delays of two time units for
    // register reading
    assign #2 OUT1 = register[OUT1ADDRESS];
    assign #2 OUT2 = register[OUT2ADDRESS];

    /*********************************************************************/


    /*********************************************************************/
    ///////////////// REGISTER WRITING OPERATIONS /////////////////////////
    
    integer i;
    // This always block triggered (synchronously) only for the  
    // positive edge of the clock pulse
    always @(posedge CLK) begin
        if (RESET) begin
            // This for loop is capable of resetting all register
            // values to zero when RESET signal is high

            #1  // Artificial delay of one time unit for resetting
            for (i = 0; i < 8; i = i + 1) begin
                register[i] <= 0;
            end
        end
        else begin
            // This else condition is used to write data contains inside IN
            // (when WRITE port is set high) to the required register 
            // specified by INADDRESS
            
            if (WRITE) #1 register[INADDRESS] <= IN;
            // Note that, artificial delays of one time units for
            // register writing
        end
    end
    /**********************************************************************/
    
	initial begin
        $dumpfile("cpu_wavedata_group17.vcd");
        for(i=0;i<8;++i)
            $dumpvars(1,register[i]);
    end

	initial begin
		#5
		$display("\t\t======================================================================");
		$display("\t\t\treg0\treg1\treg2\treg3\treg4\treg5\treg6\treg7");
		$display("\t\t======================================================================");
		$monitor($time,"\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", register[0],register[1],register[2],register[3],register[4],register[5],register[6],register[7]);
    end
	
endmodule