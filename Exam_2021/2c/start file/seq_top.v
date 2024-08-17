module seq_top (
	input wire [0:0] clk,
	input wire [0:0] reset,
	input wire [0:0] next,
	input wire [0:0] in,
	output wire [2:0] state_display,
	output wire [0:0] out
	);

 /* Define state paramaters */
 localparam
 START = 0,
 STATE_1 = 1,
 STATE_2 = 2,
 STATE_3 = 3,
 STATE_4 = 4,
 STATE_5 = 5,
 STATE_6 = 6;
 
 /* Internal state registers */
 reg [2:0] state;
 reg [2:0] next_state;
 
 /* Internal next register */
 reg [0:0] next_last;
 
 /* Clock Logic */
 always @(posedge clk) begin
	if(reset == 1'b1) begin
		state <= START;
		next_last <= 1'b0;
	end else begin
		state <= next_state;
		next_last <= next; 
	end
 end
 
 always @(*) begin
	next_state = state;
	
	if(next == 1'b1 && next_last == 1'b0) begin

		case (state)
		START: begin
			if ((in == 1'b0)) begin
				next_state = STATE_2;
			end else if ((in == 1'b1)) begin
				next_state = STATE_2;
			end
		end
		STATE_1: begin
			if ((in == 1'b0)) begin
			next_state = STATE_4; 
			end else if (in == 1'b1) begin 
			next_state = STATE_2;
			end
		end
		STATE_2: begin
			if ((in == 1'b0)) begin
				next_state = STATE_3;
			end else if ((in == 1'b1)) begin
				next_state = STATE_4;
			end
		end
		STATE_3: begin
			if ((in == 1'b1)) begin
				ext_state = STATE_2;
			end else if ((in == 1'b0)) begin
				next_state = STATE_1;
			end
		end
		STATE_4: begin
			if ((in == 1'b0)) begin
				next_state = STATE_1;
			end else if ((in == 1'b1)) begin
				next_state = STATE_5;
			end
		end 
		STATE_5: begin
			if ((in == 1'b1)) begin
				next_state = STATE_6;
			end else if ((in == 1'b0)) begin
				next_state = STATE_1;
			end
		end 
		STATE_6: begin
			if ((in == 1'b0)) begin
				next_state = STATE_6;
			end else if ((in == 1'b1)) begin
				next_state = STATE_6;
			end
		end 
		endcase
	end
 
 end

assign out = (state == STATE_3); 
assign state_display = state;

endmodule
