`timescale 1ns / 1ps

/* Top-level module for crosswalk control unit */
module wcu_top (
        input clk,
        input  reset,
		input  p,
		input  q,
        output  [1:0] ts,
        output lid
    );
    
    // Number of cycles for each signal
	parameter tvalue = 6'd2; // TODO: replace this with the correct value

    /* Use these wires for the signals between ccu and parametrized counter.
    Do not change the names of these signals, as the testbench will
    inspect them. */
    wire tr;
    wire cf;
    wire mode;
    
    
	parametrized_counter #(
	.tvalue(tvalue))
	parametrized_counter_inst(
	.clk(clk),
	.reset(reset),
	.tr(tr),
	.cf(cf),
	.mode(mode)
	);
	
	wcu wcu_inst(
	    .clk(clk),
	    .reset(reset),
	    .p(p),
	    .q(q),
	    .lid(lid),
	    .ts(ts),
	    .tr(tr),
	.cf(cf),
	.mode(mode)
	);

	
    /* TODO: Instantiate parametrized_counter module (provided for you).
    Make sure the instance is called parametrized_counter_inst. */
	
    /* TODO: Instantiate FSM module (which you have to implement in wcu.v).
    Make sure the instance is called wcu_inst. */
	
endmodule