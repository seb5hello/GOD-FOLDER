`timescale 1ns/1ns
`include "uart.v"
`include "uart_ref.v"

// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o compiled.vvp Test_tb.v"

// RUN THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp compiled.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;

    reg clk = 0;
    reg reset = 0;
    reg signal = 0;
    reg pass = 1; // Indicator for whether outputs match across all cycles

    wire valid;
    wire valid_ref;
            
    uart_ref uart_ref_inst(
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .valid(valid_ref)
    );
    
    uart uart_inst(
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .valid(valid)
    );

    // Check outputs at every positive edge of the clock
    always @(posedge clk) begin
        if (valid !== valid_ref) begin
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
            $finish;
        end
    endtask

    // Clock generation
    always #10 clk = ~clk;
    
    initial begin
        $dumpfile("gtk_sim.vcd");
        $dumpvars(0, Test_tb);

        $display("Test Bench STARTED.\n");

        // Initialize input signals
        clk = 1;
        reset = 0;
        signal = 0;

        // Reset the system
        reset = 1;
        #40;
        reset = 0;
        #20;

        // Test Sequence 1
        signal = 1; #20;
        signal = 0; #20;
        signal = 0; #20;
        signal = 1; #20;
        test_evalutation(1);

        // Reset the system
        signal = 0;
        reset = 1;
        #40;
        reset = 0;
        #20;

        // Test Sequence 2
        signal = 1; #20;
        signal = 0; #20;
        signal = 1; #20;
        signal = 0; #20;
        signal = 1; #20;
        signal = 0; #20;
        signal = 1; #20;
        signal = 0; #20;
        test_evalutation(2);

        // Reset the system
        signal = 0;
        reset = 1;
        #40;
        reset = 0;
        #20;

        // Test Sequence 3
        signal = 1; #20;
        signal = 0; #20;
        signal = 0; #20;
        signal = 1; #20;
        signal = 0; #20;
        signal = 0; #20;
        signal = 0; #20;
        signal = 1; #20;
        signal = 1; #20;
        signal = 1; #20;
        signal = 1; #20;
        test_evalutation(3);

        // Wait for some time to let the final sequence settle
        #60;
        
        finish_test($time);
    end

endmodule
