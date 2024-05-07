// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor

`include "cpu.v"
`include "data_memory.v"
`include "data_cache.v"
`include "instruction_memory.v"
`include "instruction_cache.v"

`timescale  1ns/100ps

module cpu_tb;
    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;

    wire READ, WRITE;       
    wire [7:0] ADDRESS;
    wire [7:0] WRITEDATA;
    wire [7:0] CACHE_READDATA;
    wire [31:0] READDATA;
    wire BUSYWAIT;

    cpu mycpu (PC, INSTRUCTION, CLK, RESET, BUSYWAIT, CACHE_READDATA, WRITE, READ, WRITEDATA, ADDRESS);

    wire [31:0] MEM_READDATA;
    wire MEM_READ, MEM_WRITE, MEM_BUSYWAIT;
    wire [5:0] MEM_ADDRESS;
    wire [31:0] MEM_WRITEDATA;
    wire DATA_BUSYWAIT;

    data_cache group17_data_cache(CLK, RESET, READ, WRITE, ADDRESS, WRITEDATA, MEM_BUSYWAIT, MEM_READDATA, CACHE_READDATA, MEM_READ, MEM_WRITE, DATA_BUSYWAIT, MEM_ADDRESS, MEM_WRITEDATA);

    data_memory group17_data_memory(CLK, RESET, MEM_READ, MEM_WRITE, MEM_ADDRESS, MEM_WRITEDATA, MEM_READDATA, MEM_BUSYWAIT);

    wire [127:0] INST_MEM_READDATA;
    wire INST_MEM_READ, INST_MEM_BUSYWAIT;
    wire [5:0] INST_MEM_ADDRESS;
    wire INST_BUSYWAIT;
    wire [9:0] INST_ADDRESS;

    instruction_cache group17_instruction_cache(PC, CLK, RESET, INST_MEM_READDATA, INST_MEM_BUSYWAIT, INST_MEM_READ, INSTRUCTION, INST_MEM_ADDRESS, INST_BUSYWAIT);

    instruction_memory group17_instruction_memory(CLK, INST_MEM_READ, INST_MEM_ADDRESS, INST_MEM_READDATA, INST_MEM_BUSYWAIT);
    
    assign BUSYWAIT = INST_BUSYWAIT || DATA_BUSYWAIT;

	initial begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata_group17.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        // RESET = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        RESET = 1'b1;
        #10;
        RESET = 1'b0;

        // finish simulation after some time
        #3000
        $finish;
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        
endmodule