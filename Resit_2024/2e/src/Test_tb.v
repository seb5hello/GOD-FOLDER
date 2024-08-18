`timescale 1ns/1ns
`include "spi_fsm_ref.v"
`include "spi_fsm.v"

// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o compiled.vvp Test_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp compiled.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;

        reg clk = 0;
        reg reset = 0;
        reg [1:0] mode = 2'b00;
        reg cs = 1;
        reg sclk = 0;

        wire shift;
        wire sample;
        wire shift_ref;
        wire sample_ref;

        spi_fsm_ref spi_fsm_ref_inst(
            .clk(clk),
            .reset(reset),
            .mode(mode),
            .cs(cs),
            .sclk(sclk),
            .shift(shift_ref),
            .sample(sample_ref)
        );

        spi_fsm spi_fsm_inst(
            .clk(clk),
            .reset(reset),
            .mode(mode),
            .cs(cs),
            .sclk(sclk),
            .shift(shift),
            .sample(sample)
        );

        // Check outputs at every positive edge of the clock
        reg pass = 1; // Indicator for whether outputs match across all cycles
        always @(posedge clk) begin
                if (shift !== shift_ref || sample !== sample_ref) begin
                        if($time > 20) begin
                                pass = 0;
                        end
                end
        end

        // Task to finish simulation and print result
        reg test_nr = 1; // Indicator for whether outputs match across all cycles
        task test_evalutation();
                begin
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
                #40;
                $display("Test Bench TERMINATED at time: %d [Ns].",$time);
                $finish;
                end
        endtask

        // Clock generation
        always #10 clk = ~clk;
        
        // SCLK toggle for testing
        always #15 sclk = ~sclk;

        initial begin
	        $dumpfile("src/gtk_sim.vcd");
   	        $dumpvars(0, Test_tb);

                $display("Test Bench Started!!!!!");

// 	        <<INITIALIZE INPUT INS>>
                clk = 1;
                reset = 0;
                mode = 2'b00;
                cs = 1;
                sclk = 0;
                        
// 	        <<RESET>>
                reset = 1; #40;
                reset = 0; #20;

// 	        <<TEST SEQUENCE 1: SPI Mode 0, Check Shift and Sample>>
                mode = 2'b00;   // SPI Mode 0
                cs = 0;         // Enable CS
                #30;            // Wait for setup
                cs = 1;         // Disable CS
                #40;
                test_evalutation();

// 	        <<TEST SEQUENCE 2: SPI Mode 1, Check Shift and Sample>>
                mode = 2'b01;   // SPI Mode 1
                cs = 0;         // Enable CS
                #30;            // Wait for setup
                cs = 1;         // Disable CS
                #40;
                test_evalutation();

// 	        <<TEST SEQUENCE 3: SPI Mode 2, Check Shift and Sample>>
                mode = 2'b10;   // SPI Mode 2
                cs = 0;         // Enable CS
                #30;            // Wait for setup
                cs = 1;         // Disable CS
                #40;
                test_evalutation();

// 	        <<TEST SEQUENCE 4: SPI Mode 3, Check Shift and Sample>>
                mode = 2'b11;   // SPI Mode 3
                cs = 0;         // Enable CS
                #30;            // Wait for setup
                cs = 1;         // Disable CS
                #40;
                test_evalutation();

// 	        <<TEST SEQUENCE 5: Test Full Transaction in Mode 0>>
                reset = 1; #40; reset = 0; // Reset
                mode = 2'b00;   // SPI Mode 0
                cs = 0;         // Enable CS
                sclk = 0;       // Start with SCLK low
                #20;
                sclk = 1;       // SCLK rising edge
                #20;
                sclk = 0;       // SCLK falling edge
                #20;
                cs = 1;         // Disable CS
                #40;
                test_evalutation();

// 	        <<TEST SEQUENCE 6: Test Full Transaction in Mode 1>>
                reset = 1; #40; reset = 0; // Reset
                mode = 2'b01;   // SPI Mode 1
                cs = 0;         // Enable CS
                sclk = 1;       // Start with SCLK high
                #20;
                sclk = 0;       // SCLK falling edge
                #20;
                sclk = 1;       // SCLK rising edge
                #20;
                cs = 1;         // Disable CS
                #40;
                test_evalutation();

//      <<<<FINISH>>>>
        finish_test();

        end
endmodule
