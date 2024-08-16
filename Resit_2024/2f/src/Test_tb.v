`timescale 1ns/1ns
`include "example.v"
`include "example_ref.v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o compiled.vvp Test_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp compiled.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;

        reg clk = 0;
        reg reset = 0;
        reg input_example = 0;

        wire output_example;
        wire output_example_ref;
        wire error;
        wire error_ref;
                
        example_ref example_ref_inst(
		.clk(clk),
		.reset(reset),
                .input_example(input_example),
		.output_example(output_example_ref)
                );
                
        example example_inst(
		.clk(clk),
		.reset(reset),
                .input_example(input_example),
		.output_example(output_example)
                );

        // Check outputs at every positive edge of the clock
        reg pass = 1; // Indicator for whether outputs match across all cycles
        always @(posedge clk) begin
                if (output_example !== output_example_ref) begin
                        pass = 0;
                end
        end

        // Task to finish simulation and print result
        task test_evalutation(input integer test_nr);
                begin
                if (pass) begin
                        $display("TEST %d: PASSED",test_nr);
                end else begin
                        $display("TEST %d: FAILED",test_nr);
                        finish_test($time); // Terminate the simulation early on failure
                end
                end
        endtask

        // Task to finish simulation and print result
        task finish_test(input integer sim_time);
                begin
                if (pass) begin
                        $display("FINAL EVALUATION: PASSED\n");
                end else begin
                        $display("FINAL EVALUATION: FAILED\n");
                end
                $display("Test Bench TERMINATED at time: %d [s].",sim_time);
                #40;
                $finish;
                end
        endtask

        // Clock generation
        always #10 clk = ~clk;
        
        initial begin
	        $dumpfile("src/gtk_sim.vcd");
   	        $dumpvars(0, Test_tb);

                $display("Test Bench Started!!!!!");

// 	        <<INITIALIZE INPUT input_exampleS>>
                clk = 1;
                reset = 0;
                input_example = 0;
                        
// 	        <<RESET>>
                reset = 1; #40;
                reset = 0; #20;
                   
// 	        <<INPUT SEQUENCE>>
                input_example = 1; #20;
                input_example = 0; #20;
        
        test_evalutation(1);

//      <<<<FINISH>>>>
        finish_test($time);

        end
endmodule
