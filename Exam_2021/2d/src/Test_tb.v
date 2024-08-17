`timescale 1ns/1ns
`include "AC_Controller.v"
`include "AC_Controller_ref.v"
// COMPILE THE CODE WITH THE FOLLOWING COMMAND:
// "iverilog -o compiled.vvp Test_tb.v"

// COMPILE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "vvp compiled.vvp"

// SEE THE SIMULATION WITH THE FOLLOWING COMMAND:
// "gtkwave gtk_sim.vcd"

module Test_tb;

       reg clk = 0;
    reg reset = 0;
    reg power = 0;
    reg [1:0] temp_comp = 2'b00;
    
    wire [1:0] action;
    wire [1:0] state_display;
    wire [1:0] action_ref;
    wire [1:0] state_display_ref;
    
    // Instantiate the AC_Controller FSM
    AC_Controller_ref AC_Controller_ref_inst (
        .clk(clk),
        .reset(reset),
        .power(power),
        .temp_comp(temp_comp),
        .action(action_ref),
        .state_display(state_display_ref)
    );
                
    AC_Controller AC_Controller_inst (
        .clk(clk),
        .reset(reset),
        .power(power),
        .temp_comp(temp_comp),
        .action(action),
        .state_display(state_display)
    );

        // Check outputs at every positive edge of the clock
        reg pass = 1; // Indicator for whether outputs match across all cycles
        always @(posedge clk) begin
                if (action !== action_ref | state_display !== state_display_ref) begin
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
// <<INITIALIZE INPUT SIGNALS>>
        clk = 0;
        reset = 0;
        power = 0;
        temp_comp = 2'b00;

        // <<RESET>>
        reset = 1; #40;
        reset = 0; #20;

        // <<TEST SEQUENCE 1: Power Off (Initial State)>>
        power = 0;
        temp_comp = 2'b00;
        #20;

        // <<TEST SEQUENCE 2: Power On, Temperature is Equal (Idle State)>>
        power = 1;
        temp_comp = 2'b00;
        #20;

        // <<TEST SEQUENCE 3: Power On, Temperature Higher (Decrease State)>>
        power = 1;
        temp_comp = 2'b10;
        #20;

        // <<TEST SEQUENCE 4: Power On, Temperature Lower (Increase State)>>
        power = 1;
        temp_comp = 2'b01;
        #20;

        // <<TEST SEQUENCE 5: Power On, Temperature Equal (Transition to Idle State)>>
        power = 1;
        temp_comp = 2'b00;
        #20;

        // <<TEST SEQUENCE 6: Power Off (Return to Off State)>>
        power = 0;
        temp_comp = 2'b00;
        #20;

        // <<TEST SEQUENCE 7: Power On, Temperature Higher (Transition Directly to Decrease from Off)>>
        power = 1;
        temp_comp = 2'b10;
        #20;

        // <<TEST SEQUENCE 8: Power On, Temperature Lower (Transition to Increase)>>
        power = 1;
        temp_comp = 2'b01;
        #20;

        // <<TEST SEQUENCE 9: Power Off during Decrease (Immediate transition to Off)>>
        power = 0;
        temp_comp = 2'b10;
        #20;

        // <<TEST SEQUENCE 10: Power On, Temperature Equal (From Off to Idle State)>>
        power = 1;
        temp_comp = 2'b00;
        #20;

        
        test_evalutation();
        // <<RESET>>
    reset = 1; #40;
    reset = 0; #20;

    // <<TEST SEQUENCE 1: Power On, Temperature Lower (Transition to Increase)>>
    power = 1;
    temp_comp = 2'b01;
    #20;

    // <<TEST SEQUENCE 2: Temperature Remains Lower (Stay in Increase)>>
    power = 1;
    temp_comp = 2'b01;
    #20;

    // <<TEST SEQUENCE 3: Temperature Becomes Equal (Transition to Idle)>>
    power = 1;
    temp_comp = 2'b00;
    #20;

    // <<TEST SEQUENCE 4: Power Off While Idle (Transition to Off)>>
    power = 0;
    temp_comp = 2'b00;
    #20;

    // <<TEST SEQUENCE 5: Power On, Temperature Higher (Transition to Decrease)>>
    power = 1;
    temp_comp = 2'b10;
    #20;

    // <<TEST SEQUENCE 6: Temperature Becomes Lower (Transition to Increase)>>
    power = 1;
    temp_comp = 2'b01;
    #20;

    // <<TEST SEQUENCE 7: Temperature Remains Higher (Transition to Decrease)>>
    power = 1;
    temp_comp = 2'b10;
    #20;

    // <<TEST SEQUENCE 8: Temperature Becomes Equal Again (Transition to Idle)>>
    power = 1;
    temp_comp = 2'b00;
    #20;

    // <<TEST SEQUENCE 9: Power Off While in Decrease State (Transition to Off)>>
    power = 0;
    temp_comp = 2'b10;
    #20;

    // <<TEST SEQUENCE 10: Power On, Immediate Temperature Equal (Transition Directly to Idle)>>
    power = 1;
    temp_comp = 2'b00;
    #20;

        test_evalutation();
//      <<<<FINISH>>>>
        finish_test();

        end
endmodule
