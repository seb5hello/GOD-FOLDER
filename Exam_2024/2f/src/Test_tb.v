`timescale 1ns/1ns

`include "uart_parity_even.v"
`include "timer.v"
`include "timer_fsm.v"

`include "uart_retrans_ref.v"
`include "uart_retrans_fsm_ref.v"
`include "uart_retrans.v"
`include "uart_retrans_fsm.v"

// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o compiled.vvp Test_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp compiled.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;

    reg clk = 0;
    reg reset = 0;
    reg signal = 0;
    reg ack = 0;

    wire error;
    wire [4:0] resend_count;
    wire request_resend;
    wire valid;
    wire error_ref;
    wire [4:0] resend_count_ref;
    wire request_resend_ref;
    wire valid_ref;

    uart_retrans_ref uart_retrans_ref_inst (
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .ack(ack),
        .error(error_ref),
        .resend_count(resend_count_ref),
        .request_resend(request_resend_ref),
        .valid(valid_ref)
    );

    uart_retrans uart_retrans_inst (
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .ack(ack),
        .error(error),
        .resend_count(resend_count),
        .request_resend(request_resend),
        .valid(valid)
    );

    // Check outputs at every positive edge of the clock
    reg pass = 1; // Indicator for whether outputs match across all cycles
    always @(posedge clk) begin
        if (error !== error_ref || resend_count !== resend_count_ref || request_resend !== request_resend_ref || valid !== valid_ref) begin
            pass = 0;
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

        // Apply Reset
        reset = 1; #40;reset = 0; #20;

        // <<TEST SEQUENCE 1: Valid Frame with Correct Parity>>
        signal = 0; #20; // Start bit (0)
        signal = 1; #20; // Data bit 1: 1
        signal = 0; #20; // Data bit 2: 0
        signal = 1; #20; // Data bit 3: 1
        signal = 0; #20; // Data bit 4: 0
        signal = 1; #20; // Data bit 5: 1
        signal = 0; #20; // Data bit 6: 0
        signal = 1; #20; // Data bit 7: 1
        signal = 1; #20; // Parity bit: 1 (Even parity)
        signal = 1; #20; // Stop bit: 1
        ack = 1; #20; // Acknowledge the valid frame
        ack = 0; #20;
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 2: Invalid Frame with Incorrect Parity>>
        reset = 1; #40;reset = 0; #20;
        signal = 0; #20; // Start bit (0)
        signal = 1; #20; // Data bit 1: 1
        signal = 0; #20; // Data bit 2: 0
        signal = 1; #20; // Data bit 3: 1
        signal = 0; #20; // Data bit 4: 0
        signal = 1; #20; // Data bit 5: 1
        signal = 0; #20; // Data bit 6: 0
        signal = 1; #20; // Data bit 7: 1
        signal = 0; #20; // Parity bit: 0 (Incorrect parity)
        signal = 1; #20; // Stop bit: 1
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 3: Timeout Occurs, Request Resend>>
        #200; // Wait for timer to trigger a timeout
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 4: Valid Frame After Timeout>>
        reset = 1; #40;reset = 0; #20;
        signal = 0; #20; // Start bit (0)
        signal = 1; #20; // Data bit 1: 1
        signal = 1; #20; // Data bit 2: 1
        signal = 1; #20; // Data bit 3: 1
        signal = 0; #20; // Data bit 4: 0
        signal = 0; #20; // Data bit 5: 0
        signal = 0; #20; // Data bit 6: 0
        signal = 0; #20; // Data bit 7: 0
        signal = 1; #20; // Parity bit: 1 (Even parity)
        signal = 1; #20; // Stop bit: 1
        ack = 1; #20; // Acknowledge the valid frame
        ack = 0; #20;
        test_evalutation(); // Evaluate the test

        // <<TEST SEQUENCE 5: Frame with Break Signal (No Stop Bit)>>
        reset = 1; #40;reset = 0; #20;
        signal = 0; #20; // Start bit (0)
        signal = 0; #20; // Data bit 1: 0
        signal = 0; #20; // Data bit 2: 0
        signal = 0; #20; // Data bit 3: 0
        signal = 0; #20; // Data bit 4: 0
        signal = 0; #20; // Data bit 5: 0
        signal = 0; #20; // Data bit 6: 0
        signal = 0; #20; // Data bit 7: 0
        signal = 1; #20; // Parity bit: 1 (Even parity)
        signal = 0; #20; // No stop bit (Break signal)
        test_evalutation(); // Evaluate the test

        finish_test(); // Finish the test after all sequences are evaluated
    end

endmodule
