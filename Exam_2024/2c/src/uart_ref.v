module uart_ref (
	input clk,
	input reset,
	input signal,
	output valid);

// define unique constants to identify each state
localparam BREAK = 4'd0;
localparam IDLE = 4'd1;
localparam START = 4'd2;
localparam BIT1 = 4'd3;
localparam BIT2 = 4'd4;
localparam BIT3 = 4'd5;
localparam BIT4 = 4'd6;
localparam BIT5 = 4'd7;
localparam BIT6 = 4'd8;
localparam BIT7 = 4'd9;
localparam BIT8 = 4'd10;
localparam STOP = 4'd11;

// declare verilog variables of type reg for use in always blocks
// <name>_r is used to infer a register in the clocked always block
// <name>_nxt is used assign the next state of the register in the combinational always block
reg [3 : 0] state_r, state_nxt;
// reg valid_r, valid_nxt;

// clock synchronous always block will only be evaluated on the positive edge of the clock
// only use non-blocking assignments (<=) in this block
always @(posedge clk) begin
	// check for the reset signal on the clk edge, infering a synchronous reset
	// if the module is not being reset, assign all of the derived combinational <name>_nxt values to <name>_r
	// if the module is being reset, assign initial constant values to the <name>_r variables
	// this will infer a register for <name>_r if it is assigned defined values at all times
	// otherwise an unintentional latch will be inferred
	if (reset == 1'b0) begin
		// module is not being reset
		// assign all of the derived combinational <name>_nxt values to the respective <name>_r
		state_r <= state_nxt;
// 		valid_r <= valid_nxt;
	end else begin
		// module is being reset
		// assign constant values to each <name>_r variable
		state_r <= BREAK;
// 		valid_r <= 1'b0;
	end
end

// combinational always block will evaluate whenever any signal in its sensitivity list changes
// here we use the wildcard * sensitivity list, which means that the list will be inferred from the assignments in the block
// only use blocking assignments (=) in this block
always @(*) begin
	// make sure that <name>_nxt signals are always defined to avoid latches
	// to ensure register elements minimally retain their last value, assign each <name>_nxt its respective <name>_r value
	state_nxt = state_r;
// 	valid_nxt = valid_r;

	// case statement is used to perform different logical derivations depending on current state
	// state_r stores the current state of this FSM
	// the unique state identifiers that were defined near the top of this file are used to identify the current state
	case (state_r)
		// state_r will remain constant between positive clock edges
		// only one unique state can match at any time
		BREAK: // evaluate logic for state BREAK
		begin
// 			valid_nxt = 1'b0;
			if (signal == 1'b1)
			begin
				state_nxt = IDLE;
			end
		end

		IDLE: // evaluate logic for state IDLE
		begin
// 			valid_nxt = 1'b0;
			if (signal == 1'b0)
			begin
				state_nxt = START;
			end
		end

		START: // evaluate logic for state START
		begin
// 			valid_nxt = 1'b0;
			state_nxt = BIT1;
		end

		BIT1: // evaluate logic for state BIT1
		begin
// 			valid_nxt = 1'b0;
			state_nxt = BIT2;
		end

		BIT2: // evaluate logic for state BIT2
		begin
// 			valid_nxt = 1'b0;
			state_nxt = BIT3;
		end

        BIT3:
        begin
            // valid_nxt = 1'b0;
            state_nxt = BIT4;
        end

		BIT4: // evaluate logic for state BIT4
		begin
// 			valid_nxt = 1'b0;
			state_nxt = BIT5;
		end

		BIT5: // evaluate logic for state BIT5
		begin
// 			valid_nxt = 1'b0;
			state_nxt = BIT6;
		end

		BIT6: // evaluate logic for state BIT6
		begin
// 			valid_nxt = 1'b0;
			state_nxt = BIT7;
		end

		BIT7: // evaluate logic for state BIT7
		begin
// 			valid_nxt = 1'b0;
			state_nxt = BIT8;
		end
		
		BIT8:
		begin
		    if (signal == 1'b1)
		    begin
		      //  valid_nxt = 1'b1;
		        state_nxt = STOP;
		    end
		    else begin
		      //  valid_nxt = 1'b0;
		        state_nxt = BREAK;
		    end
	    end
		

		STOP: // evaluate logic for state STOP
		begin
// 			valid_nxt = 1'b0;
			if (signal == 1'b1)
			begin
				state_nxt = IDLE;
			end
			else if (signal == 1'b0)
			begin
				state_nxt = START;
			end
		end

		default: // should not be reachable if the state register is initialised and updated correctly
		begin
// 			valid_nxt = 1'b0;
			state_nxt = BREAK;
		end
    endcase
end

// assign values to output ports
assign valid = (state_r == STOP);

endmodule
