module elc_top_ref(
        input clk,
        input reset,
        input [2:0] in,
        input card_is_in,
        input enter,
        output unlock,
        output error,
        output card_is_needed);

        wire trL, trS, tL, tS;

        parameter [5:0] lvalue = 5;
        parameter [5:0] svalue = 10;
        parameter [2:0] code = 3'b010;

        counter_ref #( .lvalue(lvalue),.svalue(svalue)) counter_ref_inst(
		.clk(clk),
		.reset(reset),
		.trL(trL),
		.trS(trS),
		.tL(tL),
		.tS(tS)
                );

                
        elc_ref #(.code(code)) elc_ref_inst(
		.clk(clk),
		.reset(reset),
		.in(in),
                .card_is_in(card_is_in),
                .enter(enter),
		.tL(tL),
		.tS(tS),
		.trL(trL),
		.trS(trS),
                .unlock(unlock),
                .error(error),
                .card_is_needed(card_is_needed)
                );

endmodule
