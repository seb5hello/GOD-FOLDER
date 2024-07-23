`timescale 1ns/1ns
`include "elc_top.v"
`include "elc.v"
`include "reference/elc_top_ref.v"
`include "reference/elc_ref.v"
`include "reference/counter_ref.v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o elc_top_tb.vvp elc_top_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp elc_top_tb.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave"

module elc_top_tb;

        reg clk = 0;
        reg reset = 0;
        reg [2:0] in = 0;
        reg card_is_in = 0;
        reg enter = 0;

        wire unlock;
        wire error;
        wire card_is_needed;
        wire unlock_ref;
        wire error_ref;
        wire card_is_needed_ref;
                
        elc_top_ref elc_top_ref_inst(
		.clk(clk),
		.reset(reset),
		.in(in),
                .card_is_in(card_is_in),
                .enter(enter),
                .unlock(unlock_ref),
                .error(error_ref),
                .card_is_needed(card_is_needed_ref)
                );
                
        elc_top elc_top_inst(
		.clk(clk),
		.reset(reset),
		.in(in),
                .card_is_in(card_is_in),
                .enter(enter),
                .unlock(unlock),
                .error(error),
                .card_is_needed(card_is_needed)
                );
   
//      <<DECLARE CLOCK>>
        always #10 clk=~clk;
        
        initial begin
	        $dumpfile("elc_top_tb.vcd");
   	        $dumpvars(0, elc_top_tb);

                $display("Test Bench Started!!!!!");
//      <<Reset>>
                #10 reset = 1;
                #20 reset = 0; enter = 0; in = 3'b000; card_is_in = 0;

//      <<Input Sequence>>
                #20
                enter = 1;
                in = 3'b000;
                card_is_in = 0;
                #20
                enter = 0; in = 3'b000; card_is_in = 0;

//      <<Input Sequence>>
                #240
                enter = 1;
                in = 3'b000;
                card_is_in = 0;
                #20 
                enter = 0; in = 3'b000; card_is_in = 0;

//      <<Input Sequence>>
                #240
                enter = 1;
                in = 3'b000;
                card_is_in = 0;
                #20
                enter = 0; in = 3'b000; card_is_in = 0;

//      <<Input Sequence>>
                #240
                enter = 1;
                in = 3'b000;
                card_is_in = 1;
                #20
                enter = 0; in = 3'b000; card_is_in = 0;

//      <<Reset>>
                #20 reset = 1;
                #20 reset = 0;

//      <<Input Sequence>>
                #20
                enter = 1;
                in = 3'b010;
                card_is_in = 0;
                #20
                enter = 0; in = 3'b000; card_is_in = 0;

//      <<Input Sequence>>
                #40
                enter = 1;
                in = 3'b000;
                card_is_in = 0;
                #20
                enter = 0; in = 3'b000; card_is_in = 0;

//      <<Input Sequence>>
                #240
                enter = 1;
                in = 3'b010;
                card_is_in = 0;
                #20
                enter = 0; in = 3'b000; card_is_in = 0;

                $display("Test Bench Finished!!!!!");
	        #100
                $finish;
        end


endmodule
