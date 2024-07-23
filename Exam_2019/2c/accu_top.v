`timescale 1ns/100ps

module accu_top(
//Inputs and outputs
input clk, reset, in, next,
output out,
output [2:0] state_display
);

//Parameters - localparam always safer
parameter START = 3'b000;
parameter FIRST1 = 3'b001;
parameter SECOND1 = 3'b010;
parameter THIRD1 = 3'b011;
parameter FOURTH1 = 3'b100;

//Other needed registers

reg [2:0] current_state, prev_state, next_state;
reg prev_next;

//Posedge block

always @(posedge clk) begin
    if(reset) begin
        current_state <= START;
        prev_state <= START;
        prev_next <= 1'b0;
    end else if(next && !prev_next) begin
        prev_state <= current_state;
        current_state <= next_state;
    end
        prev_next <= next;
end

//FSM Logic

always @(*) begin
    next_state = current_state;
    case(current_state)
        START: next_state = (in == 1) ? FIRST1 : START;
        FIRST1: next_state = (in == 1) ? SECOND1 : FIRST1;
        SECOND1: next_state = (in == 1) ? THIRD1 : SECOND1;
        THIRD1: next_state = (in == 1) ? FOURTH1 : THIRD1;
        FOURTH1: next_state = (in == 1) ? FIRST1 : START;
        default: next_state = current_state;
    endcase
end

assign state_display = current_state;
assign out = (prev_state == THIRD1 && current_state == FOURTH1) ? 1 : 0;

endmodule