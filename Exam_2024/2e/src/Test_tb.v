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

    timer_ref timer_ref_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .value(value),
        .valid(valid),
        .trigger(trigger_ref),
        .count(count_ref)
    );

    timer timer_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .value(value),
        .valid(valid),
        .trigger(trigger),
        .count(count)
    );

    // Check outputs at every positive edge of the clock
    reg pass = 1; // Indicator for whether outputs match across all cycles
    always @(posedge clk) begin
        if (trigger !== trigger_ref || count !== count_ref) begin
            if($time > 20) begin
                pass = 0;
            end
        end
    end

    // Task to finish simulation and print result
    reg [7:0] test_nr = 'd1; // Indicator for test sequence number
    task test_evalutation();
        begin
            if (pass) begin
                $display("->TEST %d: PASSED", test_nr);
            end else begin
                $display("->TEST %d: FAILED", test_nr);
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
            $display("Test Bench TERMINATED at time: %d [Ns].", $time);
            $finish;
        end
    endtask

    // Clock generation
    always #10 clk = ~clk;

    initial begin
        $dumpfile("src/gtk_sim.vcd");
        $dumpvars(0, Test_tb);

        $display("Test Bench Started!!!!!");

        // Initialize Input Signals
        clk = 1;
        reset = 0;
        enable = 0;
        value = 4'd0;
        valid = 0;

        // Apply Reset
        reset = 1; #40;
        reset = 0; #20;

        // <<TEST SEQUENCE 1: Load Timer Value and Countdown with Enable>>
        value = 5'd10;   // Load the value 10 into the counter
        valid = 1; #20;  // Apply valid to load the value
        valid = 0; #20;  // Remove valid
        enable = 1; #200; // Enable countdown for a few cycles
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 2: Pause Countdown and Resume>>
        enable = 0; #40;  // Pause countdown
        enable = 1; #100; // Resume countdown
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 3: Countdown to Zero and Trigger>>
        enable = 1; #200; // Continue countdown until trigger
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 4: Reset While Counting>>
        reset = 1; #20; // Reset the system
        reset = 0; #20;
        enable = 1; #40; // Re-enable counting after reset
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 5: Load New Value and Countdown Again>>
        value = 5'd5;    // Load the value 5 into the counter
        valid = 1; #20;  // Apply valid to load the value
        valid = 0; #20;  // Remove valid
        enable = 1; #100; // Enable countdown
        test_evalutation(); // Evaluate the test

        finish_test(); // Finish the test after all sequences are evaluated
    end

endmodule
