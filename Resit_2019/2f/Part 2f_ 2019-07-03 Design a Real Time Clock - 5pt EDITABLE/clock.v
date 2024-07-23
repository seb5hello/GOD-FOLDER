`timescale 1ms / 1us
module aclock (
	input reset, 
	input clk, 
	input [1:0] H_in1, 
	input [3:0] H_in0, 
	input [3:0] M_in1,
	input [3:0] M_in0,
	input LD_time,  
	output  [1:0]  H_out1, 
	output  [3:0]  H_out0, 
	output  [3:0]  M_out1, 
	output  [3:0]  M_out0,
	output  [3:0]  S_out1,
	output  [3:0]  S_out0 
 );
    

    

endmodule 