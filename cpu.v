// Computer Architecture (CO224) - Lab 05
// Design: Integrated CPU module for Simple Processor
// Author: Group 17


`include "decoder.v"
`include "pc.v"
`include "pc_adder.v"
`include "pc_adder_jbeq.v"
`include "reg_file.v" 
`include "twos_comp.v" 
`include "mux2to1.v"  
`include "alu.v" 
`include "control_unit.v" 
`include "sign_extend.v"
`include "shifter.v"
`include "mux2to1_32bit.v"

`timescale  1ns/100ps

module cpu (
	output[31:0] PC, 
	input[31:0] INSTRUCTION, 
	input CLK, 
	input RESET,
	input BUSYWAIT,
	input[7:0] READDATA,
	output WRITE,
	output READ,
	output[7:0] WRITEDATA,
	output[7:0] ADDRESS);

	wire [7:0] IMMEDIATE, OPCODE, OFFSET_8BIT;
	wire [2:0] READREG1, READREG2, WRITEREG;
	decoder group17Decorder (INSTRUCTION, OPCODE, IMMEDIATE, READREG2, READREG1, WRITEREG, OFFSET_8BIT);
	
	wire MUXCOMPSELECT, MUXIMMSELECT, WRITEENABLE, J_TRIGGER, BEQ_TRIGGER, MUXDATAMEMSELECT;
	wire [2:0] ALUOP;                                   
	control_unit group17ControlUnit (OPCODE, ALUOP, WRITEENABLE, MUXCOMPSELECT, MUXIMMSELECT, J_TRIGGER, BEQ_TRIGGER, BUSYWAIT, READ, WRITE, MUXDATAMEMSELECT);
	
	wire [7:0] REGOUT1, REGOUT2, ALURESULT;
	wire [7:0] MUXDATAMEMOUT;
	
	wire [7:0] COMPLIMENT;
	twos_comp group17TwosCompliment (REGOUT2,COMPLIMENT);
	
	wire [7:0] MUXCOMPOUT;
	mux2to1 group17MUXCompliment (REGOUT2, COMPLIMENT, MUXCOMPOUT, MUXCOMPSELECT);
	
	wire [7:0] MUXIMMOUT;
	mux2to1 group17MUXImmediate (MUXCOMPOUT, IMMEDIATE, MUXIMMOUT, MUXIMMSELECT);
	
	wire ZERO;
	alu group17ALU (REGOUT1, MUXIMMOUT, ALUOP, ALURESULT, ZERO);
	
	wire [31:0] OFFSET_32BIT;
	sign_extend group17SignExtend(OFFSET_8BIT, OFFSET_32BIT);
	
	wire [31:0] OFFSET_32BIT_SHIFTED;
	shifter group17Shifter(OFFSET_32BIT, OFFSET_32BIT_SHIFTED);
	
	wire IS_BEQ;
	wire IS_J_OR_BEQ;
	assign IS_BEQ = BEQ_TRIGGER & ZERO;
	assign IS_J_OR_BEQ = J_TRIGGER | IS_BEQ;
	
	wire [31:0] PCOUT;
	wire [31:0] PCOUT_JBeq;
	wire [31:0] PCOUT_EXECUTING;	
	pc_adder group17PCAdder (PC, PCOUT);
	
	pc_adder_jbeq group17PCAdderJBeq (PCOUT, INSTRUCTION, OFFSET_32BIT_SHIFTED, PCOUT_JBeq);
	
	mux2to1_32bit group17Mux2to1_32bit (PCOUT, PCOUT_JBeq, PCOUT_EXECUTING, IS_J_OR_BEQ);
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
	assign WRITEDATA = REGOUT1;
	assign ADDRESS = ALURESULT;

	pc group17ProgramCounter (PC, RESET, CLK, PCOUT_EXECUTING, BUSYWAIT);

	mux2to1 group17MUXRegWriteData (ALURESULT, READDATA, MUXDATAMEMOUT, MUXDATAMEMSELECT);
	
	wire WRITEINREG = (WRITEENABLE & !BUSYWAIT);
	reg_file group17RegisterFile (MUXDATAMEMOUT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEINREG, CLK, RESET);
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule