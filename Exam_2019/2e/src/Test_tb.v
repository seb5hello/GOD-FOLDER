`timescale 1ns/1ns
`include "_ref.v"
`include ".v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o compiled.vvp Test_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp compiled.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;

        reg clk = 0;
        reg reset = 0;

        wire out;
        wire out_ref;
                
        timer_ref timer_ref_inst(
		.clk(clk),
		.reset(reset),
                .out(out_ref)
                );
                
        timer timer_inst(
		.clk(clk),
		.reset(reset),
		.out(out)
                );
   
//      <<DECLARE CLOCK>>
        always #10 clk=~clk;
        
        initial begin
	        $dumpfile("src/gtk_sim.vcd");
   	        $dumpvars(0, Test_tb);

                $display("Test Bench Started!!!!!");

// 	  <<INITIALIZE INPUT SIGNALS>>
                clk = 1;
                reset = 0;
                        
// 	  <<RESET>>
                reset = 1;
                #40
                reset = 0;
                   
// 	  <<INPUT SEQUENCE>>
                


//        <<Finish>>
                #60
                $finish;
        end


endmodule
