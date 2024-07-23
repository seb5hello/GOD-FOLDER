`timescale 1ns/1ns
`include "tlc_top.v"
`include "tlc.v"
`include "counter.v"

module tlc_top(
        input clk,
        input reset,
        input detect,
        output hg,
        output hy,
        output hr,
        output fg,
        output fy,
        output fr);

        wire trL, trS, tL, tS;

        parameter lvalue = 2;
        parameter svalue = 4;


        counter_ref #( .lvalue(lvalue),.svalue(svalue)) counter_ref_inst(
		.clk(clk),
		.reset(reset),
		.trL(trL),
		.trS(trS),
		.tL(tL),
		.tS(tS)
                );

                
        tlc tlc_inst(
		.clk(clk),
		.reset(reset),
		.detect(detect),
		.tL(tL),
		.tS(tS),
		.trL(trL),
		.trS(trS),
                .hg(hg),
                .hy(hy),
                .hr(hr),
                .fg(fg),
                .fy(fy),
                .fr(fr)
                );

endmodule
