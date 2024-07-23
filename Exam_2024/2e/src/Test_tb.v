`timescale 1ns/1ns
`include "timer_fsm_ref.v"
`include "timer_ref.v"
`include "timer.v"
`include "timer_fsm.v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o Test_runner.vvp Test_runner.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp Test_runner.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;

        reg clk = 0;
        reg reset = 0;
        reg enable = 0;
        reg [4:0] value = 4'd0;
        reg valid = 0;

        wire trigger;
        wire [4:0] count;
        wire trigger_ref;
        wire [4:0] count_ref;
                
        timer_ref timer_ref_inst(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.value(value),
                .valid(valid),
                .trigger(trigger_ref),
                .count(count_ref)
                );
                
        timer timer_inst(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.value(value),
                .valid(valid),
                .trigger(trigger),
                .count(count)
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
                enable = 0;
                value = 4'd0;
                valid = 0;
                        
// 	  <<RESET>>
                reset = 1;
                #40
                reset = 0;
                   
// 	  <<INPUT SEQUENCE>>
                enable = 1;
                value = 4'd5;
                valid = 1;
                #20
                value = 4'd0;
                valid = 0;
                #140
                enable = 0;
                #40
                   
// 	  <<INPUT SEQUENCE>>
                enable = 1;
                value = 4'd10;
                valid = 1;
                #20
                value = 4'd0;
                valid = 0;
                #240
                enable = 0;
                
                #40
                $finish;
        end


endmodule
