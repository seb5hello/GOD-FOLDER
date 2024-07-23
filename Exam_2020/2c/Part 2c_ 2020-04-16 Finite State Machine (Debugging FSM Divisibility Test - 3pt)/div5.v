`timescale 1ns / 1ps


module div5(clk,reset,in,out, state_display);

input clk, reset, in; // Assume asynchronous reset;
output out;
output [2:0] state_display;

parameter S_REM0 = 0; parameter S_REM1 = 1; // state assignments
parameter S_REM2 = 2; parameter S_REM3 = 3;
parameter S_REM4 = 4; 

reg [2:0] curr_state,next_state; 

always @(*) begin // implement state transition diagram
if (reset) next_state = S_REM0;
else case (curr_state)
S_REM0: next_state = in ? S_REM1 : curr_state;
S_REM1: next_state = in ? S_REM3 : S_REM2;
S_REM2: next_state = in ? S_REM0 : S_REM4;
S_REM3: next_state = in ? S_REM1 : S_REM2;
S_REM4: next_state = in ? curr_state : S_REM3;
default: next_state = S_REM0; // handle unused states
endcase
end

always @ (posedge clk) curr_state <= next_state;

assign out = (curr_state == S_REM3); // assign output: Moore machine
assign state_display = curr_state; // debugging

endmodule