`timescale 1ns/1ns
`include "alu_ref.v"
`include "alu.v"
`include "aluctrl_ref.v"
`include "aluctrl.v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o compiled.vvp Test_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp compiled.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;
        // Inputs to ALU
        // reg clk;
        reg [31:0] a;
        reg [31:0] b;

        // Inputs to ALUCTRL
        reg [5:0] functionCode;
        reg [4:0] ALUop;
        reg [4:0] Shamt;

        // Outputs
        wire [5:0] ALUctrl, ALUctrl_ref;
        wire [31:0] r, r_ref;
        wire [31:0] r2, r2_ref;
        wire z, z_ref;

        // Instantiate the ALUCTRL module
        ALUCTRL aluctrl_inst (
                .functionCode(functionCode),
                .ALUop(ALUop),
                .Shamt(Shamt),
                .ALUctrl(ALUctrl)
        );

        // Instantiate the ALU module
        ALU ALU_inst (
                .ctrl(ALUctrl),
                .a(a),
                .b(b),
                .r(r),
                .r2(r2),
                .z(z)
        );

        // Instantiate the ALUCTRL module
        ALUCTRL_ref aluctrl_ref_inst (
                .functionCode(functionCode),
                .ALUop(ALUop),
                .Shamt(Shamt),
                .ALUctrl(ALUctrl_ref)
        );

        // Instantiate the ALU module
        ALU_ref ALU_ref_inst (
                .ctrl(ALUctrl_ref),
                .a(a),
                .b(b),
                .r(r_ref),
                .r2(r2_ref),
                .z(z_ref)
        );
        
        // Check outputs at every positive edge of the clock


        // Task to finish simulation and print result
        reg [7:0] test_nr = 1; // Indicator for whether outputs match across all cycles
        reg pass = 1; // Indicator for whether outputs match across all cycles
        task test_evalutation();
                begin
                if (r !== r_ref) begin
                        pass = 0;
                end
                if (pass) begin
                        $display("->TEST %d: PASSED",test_nr);
                end else begin
                        $display("->TEST %d: FAILED",test_nr);
                        finish_test(); // Terminate the simulation early on failure
                end
                test_nr = test_nr + 1;
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
                $display("Test Bench TERMINATED at time: %d [Ns].",$time);
                $finish;
                end
        endtask

        initial begin

                // Initialize Inputs to ALUCTRL
                ALUop = 5'h02;      // R-type instruction
                Shamt = 5'd0;       // No shift
                functionCode = 6'h32; // Function code for custom thresholding instruction

                // Test case 1: a > b
                a = 150;
                b = 128;
                #10;  // Wait for 10 ns
                $display("function(a=%d,b=%d) = %d || expected result = %d",a,b,r,r_ref);
                test_evalutation();

                // Test case 2: a <= b
                a = 100;
                b = 128;
                #10;  // Wait for 10 ns
                $display("function(a=%d,b=%d) = %d || expected result = %d",a,b,r,r_ref);
                test_evalutation();

                // Test case 3: a == b
                a = 128;
                b = 128;
                #10;  // Wait for 10 ns
                $display("function(a=%d,b=%d) = %d || expected result = %d",a,b,r,r_ref);
                test_evalutation();

                finish_test();
        end

endmodule