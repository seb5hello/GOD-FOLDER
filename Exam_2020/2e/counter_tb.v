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
        reg trL = 0;
        reg trS = 0;

        wire tL;
        wire tS;
        wire tL_ref;
        wire tS_ref;

        counter_ref counter_ref_inst(
		.clk(clk),
		.reset(reset),
		.trL(trL),
		.trS(trS),
		.tL(tL_ref),
		.tS(tS_ref)
                );

                
        counter counter_inst(
		.clk(clk),
		.reset(reset),
		.trL(trL),
		.trS(trS),
		.tL(tL),
		.tS(tS)
                );
   
//      <<DECLARE CLOCK>>
        always #10 clk=~clk;
        
        initial begin
	        $dumpfile("counter_tb.vcd");
   	        $dumpvars(0, counter_tb);

                $display("Test Bench Started!!!!!");
//      <<Reset>>
                #10 reset = 1;
                #40
                reset = 0;
//      <<Input Sequence Mode = 0>>
                trL = 1;
                trS = 1;
                #20
                trL = 0;
                trS = 0;
                #120
                
//      <<Reset>>
                reset = 1;
                #40
                reset = 0;
//      <<Input Sequence Mode = 0>>
                trL = 1;
                trS = 0;
                #20
                trL = 0;
                trS = 0;
                #120
                
//      <<Reset>>
                reset = 1;
                #40
                reset = 0;  
//      <<Input Sequence Mode = 0>>
                trL = 0;
                trS = 1;
                #20
                trL = 0;
                trS = 0;
                #120

//      <<Reset>>
                reset = 1;
                #40
                reset = 0;  
//      <<Input Sequence Mode = 0>>
                trL = 1;
                trS = 0;
                #20
                trL = 0;
                trS = 1;
                #20
                trL = 0;
                trS = 0;
                #120

                $display("Test Bench Finished!!!!!");
	        #100
                $finish;
        end


endmodule
