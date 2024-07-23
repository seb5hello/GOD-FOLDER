/*`timescale 1ns / 1ps


module accu_top(clk, reset, next, in, out, state_display);

input clk, in, next, reset;
output reg out;
output reg [2:0] state_display;

localparam
START = 3'b000,
FIRST1 = 3'b001,
SECOND1 = 3'b010,
THIRD1 = 3'b011,
FOURTH1 = 3'b100;


reg [2:0] curr_state;
reg [2:0] next_state;

always @(posedge clk) begin
    next_reg1 <= next;
    next_reg2 <= next_reg1;
end
    
assign next_reg = next_reg1 && !next_reg2;

always @(*) begin // implement state transition diagram
case (curr_state)
START: begin
	next_state = (next == 1'b1 && in == 1'b1) ? FIRST1 : curr_state;

	end
FIRST1: begin
	next_state = (next_reg == 1'b1 && in == 1'b1) ? SECOND1 : curr_state;

	end
SECOND1: begin 
	next_state = (next_reg == 1'b1 && in == 1'b1) ? THIRD1 : curr_state;
	
	end
THIRD1: begin 
	next_state = (next_reg == 1'b1 && in == 1'b1) ? FOURTH1 : curr_state;

	end
FOURTH1: begin 
	next_state = (next_reg == 1'b1 && in == 1'b0) ? START : (next_reg == 1'b1 && in == 1'b1) ? FIRST1 : curr_state;
	end
default: begin
	next_state = START; // handle unused states

	end
endcase
curr_state=next_state;
end

always @(posedge clk) begin
	if (reset) begin 
		curr_state <= START;
		out <= 1'b0;
	end
	else begin 
		case(curr_state)
		    START: begin
		        out <= 0;
		        state_display <= curr_state;
		    end
		    FIRST1: begin
		        out <= 0;
		        state_display <= curr_state;
		    end
		    SECOND1: begin
		        out <= 0;
		        state_display <= curr_state;
		    end
		    THIRD1: begin
		        out <= 0;
		        state_display <= curr_state;
		    end
		    FOURTH1: begin
		        out <= 1;
		        state_display <= curr_state;
		    end
		    default: begin
		        out <= 0;
		        state_display <= curr_state;
		    end
		endcase
	end
end



endmodule*/

`timescale 1ns / 1ps


module accu_top(clk, reset, next, in, out, state_display);

input clk, in, next, reset;
output out;
output [2:0] state_display;

parameter START = 0; 
parameter FIRST1 = 1; // state assignments
parameter SECOND1 = 2; 
parameter THIRD1 = 3;
parameter FOURTH1 = 4;  

reg [2:0] curr_state, next_state; 
reg next_reg1, next_reg2;
wire next_reg;

always @(posedge clk) begin
    next_reg1 <= next;
    next_reg2 <= next_reg1;
end
    
assign next_reg = next_reg1 && !next_reg2;

always @(*) begin // implement state transition diagram
case (curr_state)
START: begin
	next_state = (next_reg == 1'b1 && in == 1'b1) ? FIRST1 : curr_state;
	//out_reg = (next_reg == 1'b1 && in == 1'b1) ? 1'b0 : out;
	end
FIRST1: begin
	next_state = (next_reg == 1'b1 && in == 1'b1) ? SECOND1 : curr_state;
	//out_reg = (next_reg == 1'b1 && in == 1'b1) ? 1'b0 : out;
	end
SECOND1: begin 
	next_state = (next_reg == 1'b1 && in == 1'b1) ? THIRD1 : curr_state;
	//out_reg = (next_reg == 1'b1 && in == 1'b1) ? 1'b0 : out;
	end
THIRD1: begin 
	next_state = (next_reg == 1'b1 && in == 1'b1) ? FOURTH1 : curr_state;
	//out_reg = (next_reg == 1'b1 && in == 1'b1) ? 1'b0 : out;
	end
FOURTH1: begin 
	next_state = (next_reg == 1'b1 && in == 1'b0) ? START : (next_reg == 1'b1 && in == 1'b1) ? FIRST1 : curr_state;
	//out_reg = 1'b1;
	end
default: begin
	next_state = START; // handle unused states
//	out_reg = 1'b0;
	//out = 1'b0;
	end
endcase
end

always @(posedge clk) begin
	if (reset) begin 
		curr_state <= START;
	end
	else begin 
		curr_state <= next_state;
	end
end

assign state_display = curr_state; 
assign out = (curr_state == FOURTH1);

endmodule