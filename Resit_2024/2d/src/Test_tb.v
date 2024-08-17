`timescale 1ns/1ns
`include "spi_parity_odd_fsm.v"
`include "spi_parity_odd_fsm_ref.v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o compiled.vvp Test_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp compiled.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;

        reg clk = 0;
        reg reset = 0;
        reg cs = 0;
        reg sample = 0;
        reg in = 0;

        wire parity_bit;
        wire parity_bit_ref;
                
        spi_parity_odd_fsm_ref spi_parity_odd_fsm_ref_inst(
		.clk(clk),
		.reset(reset),
                .cs(cs),
                .sample(sample),
                .in(in),
		.parity_bit(parity_bit_ref)
                );
                
        spi_parity_odd_fsm spi_parity_odd_fsm_inst(
		.clk(clk),
		.reset(reset),
                .cs(cs),
                .sample(sample),
                .in(in),
		.parity_bit(parity_bit)
                );

        // Check outputs at every positive edge of the clock
        reg pass = 1; // Indicator for whether outputs match across all cycles
        always @(posedge clk) begin
                if (parity_bit !== parity_bit_ref) begin
                        if($time > 20) begin
                                pass = 0;
                        end
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

// 	        <<INITIALIZE INPUT csS>>
                clk = 1;
                reset = 0;
                cs = 0;
                sample = 0;
                in = 0;
                        
// 	        <<RESET>>
                reset = 1; #40;
                reset = 0; #20;
                   
                   
// 	        <<TEST SEQUENCE 1:>>
// 	        <<INPUT 1: Simple CS High and Low with No Sample>>
                cs = 1;
                sample = 0;
                in = 0;
                #20;

                cs = 0; 
                sample = 0;
                in = 0; 
                #20;

        // <<INPUT 2: CS Low, Sample High, In High (Transition to ODD)>>
                cs = 0; 
                sample = 1;
                in = 1;
                #20;

        // <<INPUT 3: CS Low, Sample High, In High (Transition to EVEN)>>
                cs = 0;
                sample = 1;
                in = 1;
                #20;

        // <<INPUT 4: CS High (Back to CS state)>>
        cs = 1;
        sample = 0;
        in = 0;
        #20;

        // <<INPUT 5: CS Low, Sample High, In High (Transition back to ODD)>>
        cs = 0;
        sample = 1;
        in = 1;
        #20;

        // <<INPUT 6: Transition from ODD to EVEN and back to CS>>
        cs = 0;
        sample = 1;
        in = 1;
        #20;

        cs = 1;
        sample = 0;
        in = 0;
        #20;

        // <<INPUT 7: CS Low, Sample Low, In Low (Remain in CS)>>
        cs = 0;
        sample = 0;
        in = 0;
        #20;

        // <<INPUT 8: CS Low, Sample High, In Low (No Parity Change)>>
        cs = 0;
        sample = 1;
        in = 0;
        #20;
        
        test_evalutation();

        // <<RESET>>
    reset = 1; #40;
    reset = 0; #20;

    // <<NEW TEST SEQUENCE: Different Scenario>>
    // <<INPUT 1: CS Low, Sample Low, In High (No Transition, Remain in CS)>>
    cs = 0;
    sample = 0;
    in = 1;
    #20;

    // <<INPUT 2: CS Low, Sample High, In Low (No Parity Change, Remain in EVEN/ODD)>>
    cs = 0;
    sample = 1;
    in = 0;
    #20;

    // <<INPUT 3: CS High, Sample High, In Low (Should transition back to CS state)>>
    cs = 1;
    sample = 1;
    in = 0;
    #20;

    // <<INPUT 4: CS Low, Sample High, In High (Transition to ODD if in EVEN, or EVEN if in ODD)>>
    cs = 0;
    sample = 1;
    in = 1;
    #20;

    // <<INPUT 5: CS Low, Sample High, In Low (No Parity Change)>>
    cs = 0;
    sample = 1;
    in = 0;
    #20;

    // <<INPUT 6: CS Low, Sample High, In High (Force parity transition to EVEN/ODD)>>
    cs = 0;
    sample = 1;
    in = 1;
    #20;

    // <<INPUT 7: CS High, Sample Low, In High (Return to CS state)>>
    cs = 1;
    sample = 0;
    in = 1;
    #20;

    // <<INPUT 8: CS Low, Sample Low, In Low (No Parity Change, Remain in CS)>>
    cs = 0;
    sample = 0;
    in = 0;
    #20;

    test_evalutation();

//      <<<<FINISH>>>>
        finish_test();

        end
endmodule