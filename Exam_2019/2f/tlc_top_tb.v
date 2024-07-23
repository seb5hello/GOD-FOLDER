`timescale 1ns/1ns
`include "tlc_top_tb.v"
`include "tlc_top.v"
`include "tlc.v"
`include "counter.v"

`include "Solutions/elc_top_ref.v"
`include "Solutions/elc_ref.v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o tlc_top_tb.vvp tlc_top_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp tlc_top_tb.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave"

module tlc_top_tb;

        reg clk = 0;
        reg reset = 0;
        reg detect = 0;

        wire hg;
        wire hy;
        wire hr;
        wire fg;
        wire fy;
        wire fr;

                
        tlc_top #(.svalue(svalue),.lvalue(lvalue)) tlc_top_inst(
		.clk(clk),
		.reset(reset),
		.detect(detect),
                .hg(hg),
                .hy(hy),
                .hr(hr),
                .fg(fg),
                .fy(fy),
                .fr(fr)
                );
   
//      <<DECLARE CLOCK>>
        always #10 clk=~clk;
        
        initial begin
	        $dumpfile("tlc_top_tb.vcd");
   	        $dumpvars(0, tlc_top_tb);

                $display("Test Bench Started!!!!!");
//      <<Reset>>
                #10 reset = 1;
                #40
                reset = 0;

//      <<Input Sequence Mode = 0>>
                in = 3'b000;
                card_is_in = 0;
                enter = 0;
                clk = 0;
                #10 reset = 1;
                
                #10 reset = 0;
                
                #10; //start 
                in = 3'b100;
                enter = 1;

                #500
                card_is_in = 1;

                #20
                card_is_in = 0;


                #40
                in = 3'b010;             

                $display("Test Bench Finished!!!!!");
	        #100
                $finish;
        end


endmodule
