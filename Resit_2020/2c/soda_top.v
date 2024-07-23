`timescale 1ns / 1ps


module soda_top(clk,reset,next,coin_in,soda,coin_out, state_display,check_coin_in);

input clk, reset, next; 
input [1:0] coin_in;
output soda;
output [1:0] coin_out;
output [2:0] state_display;
output check_coin_in;

parameter S_PUT_COIN = 0; parameter S_INPUT1 = 1; // state assignments
parameter S_INPUT5 = 2; parameter S_INPUT6 = 3;
parameter S_INPUT3 = 4; parameter S_RETURN1 = 5;
parameter S_SODA_OUT = 6;

reg [2:0] curr_state,next_state; 
reg next_reg1, next_reg2;
wire next_reg;

always @(posedge clk) begin
    next_reg1 <= next;
    next_reg2 <= next_reg1;
end

assign next_reg = next_reg1 && !next_reg2;

always @(*) begin // implement state transition diagram
case (curr_state)
S_PUT_COIN: next_state = (next_reg == 1'b1 && coin_in == 2'b10) ? S_INPUT1 : (next_reg == 1'b1 && coin_in == 2'b11) ? S_INPUT5 : (next_reg == 1'b1 && coin_in == 2'b01) ? S_SODA_OUT : curr_state;
S_INPUT1: next_state = (next_reg == 1'b1 && coin_in == 2'b01) ? S_SODA_OUT : (next_reg == 1'b1 && coin_in == 2'b10) ? S_INPUT3 : (next_reg == 1'b1 && coin_in == 2'b11) ? S_INPUT6 : curr_state;
S_INPUT5: next_state = (next_reg == 1'b1) ? S_RETURN1 : curr_state;
S_INPUT6: next_state = (next_reg == 1'b1) ? S_INPUT5 : curr_state;
S_INPUT3: next_state = (next_reg == 1'b1) ? S_PUT_COIN : curr_state;
S_RETURN1: next_state = (next_reg == 1'b1) ? S_SODA_OUT : curr_state;
S_SODA_OUT: next_state = (next == 1'b1) ? S_PUT_COIN : curr_state;
default: next_state = S_PUT_COIN; // handle unused states
endcase
end

always @ (posedge clk) begin
	if (reset) curr_state <= S_PUT_COIN;
	else curr_state <= next_state;
end

assign soda = (curr_state == S_INPUT3); // assign output: Moore machine
assign coin_out = (curr_state == S_INPUT5) ? 2'b10 : 2'b00;
assign check_coin_in = (curr_state == S_PUT_COIN | curr_state == S_INPUT1) ? 1 : 0;
assign state_display = curr_state; // debugging

endmodule