`include "uart_parity_odd.v"
`include "uart_parity_odd_ref.v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o compiled.vvp Test_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp compiled.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;

    reg clk = 0;
    reg reset = 0;
    reg signal = 1;  // Line is idle when high

    wire error;
    wire valid;
    wire error_ref;
    wire valid_ref;

    // Instantiate the reference FSM
    uart_parity_odd_ref uart_parity_odd_ref_inst (
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .error(error_ref),
        .valid(valid_ref)
    );

    // Instantiate the FSM to be tested
    uart_parity_odd uart_parity_odd_inst (
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .error(error),
        .valid(valid)
    );

    // Check outputs at every positive edge of the clock
    reg pass = 1; // Indicator for whether outputs match across all cycles
    always @(posedge clk) begin
        if (error !== error_ref || valid !== valid_ref) begin
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

        $display("uart_parity_odd Test Bench Started!!!!!");

        // Initialize Inputs
        clk = 0;
        reset = 0;
        signal = 1; // Idle state

        // Apply Reset
        reset = 1; #20;
        reset = 0; #20;

        // <<TEST SEQUENCE 1: Valid Sequence 0101 with Correct Stop Bit and Parity>>
        signal = 0; #20; // Start bit (0)
        signal = 0; #20; // Data bit 1: 0
        signal = 1; #20; // Data bit 2: 1
        signal = 0; #20; // Data bit 3: 0
        signal = 1; #20; // Data bit 4: 1
        signal = 0; #20; // Parity bit: 0 (Odd parity)
        signal = 1; #20; // Stop bit: 1 (Valid sequence)
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 2: Valid Sequence 0110 with Correct Stop Bit and Parity>>
        signal = 0; #20; // Start bit (0)
        signal = 1; #20; // Data bit 1: 1
        signal = 1; #20; // Data bit 2: 1
        signal = 0; #20; // Data bit 3: 0
        signal = 0; #20; // Data bit 4: 0
        signal = 0; #20; // Parity bit: 0 (Odd parity)
        signal = 1; #20; // Stop bit: 1 (Valid sequence)
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 3: Invalid Sequence with Incorrect Stop Bit>>
        signal = 0; #20; // Start bit (0)
        signal = 1; #20; // Data bit 1: 1
        signal = 0; #20; // Data bit 2: 0
        signal = 1; #20; // Data bit 3: 1
        signal = 0; #20; // Data bit 4: 0
        signal = 1; #20; // Parity bit: 1 (Odd parity)
        signal = 0; #20; // Incorrect stop bit: 0
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 4: Break Signal (Immediate Low after Data and Parity)>>
        signal = 0; #20; // Start bit (0)
        signal = 0; #20; // Data bit 1: 0
        signal = 0; #20; // Data bit 2: 0
        signal = 1; #20; // Data bit 3: 1
        signal = 1; #20; // Data bit 4: 1
        signal = 0; #20; // Parity bit: 0 (Odd parity)
        signal = 0; #20; // Break signal, stays low
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 5: Another Valid Sequence after Reset>>
        reset = 1; #20; reset = 0; #20;        // Apply reset
        signal = 0; #20; // Start bit (0)
        signal = 1; #20; // Data bit 1: 1
        signal = 0; #20; // Data bit 2: 0
        signal = 0; #20; // Data bit 3: 0
        signal = 1; #20; // Data bit 4: 1
        signal = 0; #20; // Parity bit: 0 (Odd parity)
        signal = 1; #20; // Stop bit: 1 (Valid sequence)
        test_evalutation(); // Evaluate the test

        finish_test(); // Finish the test after all sequences are evaluated
    end

endmodule
