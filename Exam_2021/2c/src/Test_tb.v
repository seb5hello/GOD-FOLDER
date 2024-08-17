`timescale 1ns/1ns
`include "seq_top.v"
`include "seq_top_ref.v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o compiled.vvp Test_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp compiled.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;

        reg clk = 0;
        reg reset = 0;
        reg in = 0;
        reg next = 0;

        wire [2:0] state_display;
        wire out;
        wire [2:0] state_display_ref;
        wire out_ref;

        // Instantiate the reference FSM (seq_top_ref)
        seq_top_ref seq_top_ref_inst (
                .clk(clk),
                .reset(reset),
                .in(in),
                .next(next),
                .state_display(state_display_ref),
                .out(out_ref)
        );

        // Instantiate the FSM to be tested (seq_top)
        seq_top seq_top_inst (
                .clk(clk),
                .reset(reset),
                .in(in),
                .next(next),
                .state_display(state_display),
                .out(out)
        );

        // Check outputs at every positive edge of the clock
        reg pass = 1; // Indicator for whether outputs match across all cycles
        always @(posedge clk) begin
                if (out !== out_ref || state_display !== state_display_ref) begin
                pass = 0;
                end
        end

        // Task to finish simulation and print result
        reg [7:0] test_nr = 'd1; // Indicator for whether outputs match across all cycles
        task test_evalutation();
                begin
                if (pass) begin
                        $display("->TEST %d: PASSED",test_nr);
                end else begin
                        $display("->TEST %d: FAILED",test_nr);
                        finish_test(); // Terminate the simulation early on failure
                end
                test_nr = test_nr + 'd1;
                end
        endtask

        // Task to finish simulation and print result
        task finish_test();
                begin
                if (pass) begin
                        $display("\nFINAL EVALUATION: PASSED\n");
                end else begin
                        $display("\nFINAL EVALUATION: FAILED\n");
                end
                #40;
                $display("Test Bench TERMINATED at time: %d [Ns].",$time);
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
                in = 0;
                next = 0;
                        
// 	        <<RESET>>
                reset = 1; #40;
                reset = 0; #20;
                  
                // <<TEST SEQUENCE 1: Start -> STATE_1 -> STATE_2 -> STATE_3 (Detects 010, Output should be 1)>>
                in = 0; next = 1; #20; next = 0; #20;  // Input 0: Transition to STATE_1
                in = 1; next = 1; #20; next = 0; #20;  // Input 1: Transition to STATE_2
                in = 0; next = 1; #20; next = 0; #20;  // Input 0: Transition to STATE_3, Output should be 1
                test_evalutation();

                // <<TEST SEQUENCE 2: STATE_3 -> STATE_1 -> STATE_2 -> STATE_5 (No detection, output should be 0)>>
                in = 0; next = 1; #20; next = 0; #20;  // Input 0: Transition to STATE_1
                in = 1; next = 1; #20; next = 0; #20;  // Input 1: Transition to STATE_2
                in = 1; next = 1; #20; next = 0; #20;  // Input 1: Transition to STATE_5, Output should be 0
                test_evalutation();

                // <<TEST SEQUENCE 3: STATE_5 -> STATE_6 (Detects 111, FSM should stay in STATE_6)>>
                in = 1; next = 1; #20; next = 0; #20;  // Input 1: Transition to STATE_6, Output should remain 0

                // <<TEST SEQUENCE 4: STATE_6 (Stay in STATE_6 on both 0 and 1 input, output should stay 0)>>
                in = 0; next = 1; #20; next = 0; #20;  // Input 0: Stay in STATE_6, Output should remain 0
                in = 1; next = 1; #20; next = 0; #20;  // Input 1: Stay in STATE_6, Output should remain 0
                test_evalutation();

                // <<TEST SEQUENCE 5: Reset and Restart Sequence>>
                reset = 1; #20; reset = 0; #20;        // Reset: Transition to START state
                in = 0; next = 1; #20; next = 0; #20;  // Input 0: Transition to STATE_1
                in = 1; next = 1; #20; next = 0; #20;  // Input 1: Transition to STATE_2
                in = 0; next = 1; #20; next = 0; #20;  // Input 0: Transition to STATE_3, Output should be 1
        
                test_evalutation();

//      <<<<FINISH>>>>
        finish_test();

        end
endmodule
