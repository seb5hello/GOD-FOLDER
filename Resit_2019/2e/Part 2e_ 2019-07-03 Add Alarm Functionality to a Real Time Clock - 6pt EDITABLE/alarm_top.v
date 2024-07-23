`timescale 1ms / 1us

module alarm (
	input reset,  
	input clk,  
	input [1:0] H_in1,  
	input [3:0] H_in0, 
	input [3:0] M_in1, 
	input [3:0] M_in0, 
	input   LD_alarm,   
	input   STOP_al,  
	input   alarm_ON,  
	input [1:0]  c_hour1, 
	input [3:0]  c_hour0, 
	input [3:0]  c_min1, 
	input [3:0]  c_min0, 
	input [3:0]  c_sec1, 
	input [3:0]  c_sec0,  
	output reg alarm_out
);
 
	
	
	

endmodule

module alarm_top (
	input reset,  
	input clk,  
	input [1:0] H_in1,  
	input [3:0] H_in0, 
	input [3:0] M_in1, 
	input [3:0] M_in0, 
	input LD_time,  
	input   LD_alarm,   
	input   STOP_al,  
	input   alarm_ON,  
	output alarm_out,  
	output [1:0]  H_out1, 
	output [3:0]  H_out0, 
	output [3:0]  M_out1, 
	output [3:0]  M_out0, 
	output [3:0]  S_out1, 
	output [3:0]  S_out0  
 );

 // internal signal
 wire [1:0] c_hour1; 
 wire [3:0] c_hour0; 
 wire [3:0] c_min1; 
 wire [3:0] c_min0;  
 wire [3:0] c_sec1; 
 wire [3:0] c_sec0;

	aclock aclock_inst (
					.reset(reset),  
					.clk(clk),  
					.H_in1(H_in1),  
					.H_in0(H_in0), 
					.M_in1(M_in1), 
					.M_in0(M_in0), 
					.LD_time(LD_time), 
					.H_out1(c_hour1), 
					.H_out0(c_hour0), 
					.M_out1(c_min1), 
					.M_out0(c_min0), 
					.S_out1(c_sec1), 
					.S_out0(c_sec0) 
 );

	alarm alarm_inst (
					.reset(reset),
					.clk(clk),
					.LD_alarm(LD_alarm),
					.alarm_ON(alarm_ON),
					.STOP_al(STOP_al),
					.alarm_out(alarm_out),
					.H_in1(H_in1),
					.H_in0(H_in0),
					.M_in1(M_in1),
					.M_in0(M_in0),
					.c_hour1(c_hour1), 
					.c_hour0(c_hour0), 
					.c_min1(c_min1), 
					.c_min0(c_min0), 
					.c_sec1(c_sec1), 
					.c_sec0(c_sec0) 
	);
   
 assign H_out1 = c_hour1;
 assign H_out0 = c_hour0;
 assign M_out1 = c_min1;
 assign M_out0 = c_min0;
 assign S_out1 = c_sec1;
 assign S_out0 = c_sec0;
 
endmodule