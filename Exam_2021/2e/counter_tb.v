`timescale 1ns/1ns
`include "counter.v"
`include "counter_ref.v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o counter_tb.vvp counter_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp counter_tb.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave"

module counter_tb;

        reg clk = 0;
        reg reset = 0;
        reg tr = 0;
        reg mode = 0;

        wire cf;
        wire cf_ref;

        counter_ref counter_ref_inst(
		.clk(clk),
		.reset(reset),
		.tr(tr),
		.cf(cf_ref),
		.mode(mode)
                );

                
        counter counter_inst(
		.clk(clk),
		.reset(reset),
		.tr(tr),
		.cf(cf),
		.mode(mode)
                );
   
//      <<DECLARE CLOCK>>
        always #10 clk=~clk;
           
        initial begin
	        $dumpfile("counter_tb.vcd");
   	        $dumpvars(0, counter_tb);

                $display("Test Bench Started!!!!!");
//      <<Reset>>
                #10
                reset = 1;
                #40

//      <<Input Sequence Mode = 0>>

                reset = 0;
                tr = 1;
                mode = 0;
                #20
                tr = 0;
                mode = 0;
                #120
                
//      <<Reset>>
                reset = 1;
                #40
                
//      <<Input Sequence Mode = 0>>

                reset = 0;
                tr = 1;
                mode = 1;
                #20
                tr = 0;
                mode = 0;
                #360

                $display("Test Bench Finished!!!!!");
	        #100
                $finish;
        end


endmodule
