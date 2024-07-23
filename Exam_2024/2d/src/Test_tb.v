`timescale 1ns/1ns
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
        reg signal = 0;

        wire valid;
        wire valid_ref;
        wire error;
        wire error_ref;
                
        uart_parity_odd_ref uart_parity_odd_ref_inst(
		.clk(clk),
		.reset(reset),
		.signal(signal),
		.valid(valid_ref),
                .error(error_ref)
                );
                
        uart_parity_odd uart_parity_odd_inst(
		.clk(clk),
		.reset(reset),
		.signal(signal),
		.valid(valid),
                .error(error)
                );
   
//      <<DECLARE CLOCK>>
        always #10 clk=~clk;
        
        initial begin
	        $dumpfile("src/gtk_sim.vcd");
   	        $dumpvars(0, Test_tb);

                $display("Test Bench Started!!!!!");

// 	  <<INITIALIZE INPUT SIGNALS>>
                clk = 1;
                reset = 0;
                        
// 	  <<RESET>>
                reset = 1;
                #40
                reset = 0;
                   
// 	  <<INPUT SEQUENCE>>
                signal = 1;
                #20
                signal = 0;
                #20  
                signal = 0;
                #20  
                signal = 1;
                #20  

// 	  <<RESET>>
                signal = 0;
                reset = 1;
                #40
                reset = 0;
                #20
                   
// 	  <<INPUT SEQUENCE>>
                signal = 1;
                #20
                signal = 0;
                #20  
                signal = 1;
                #20  
                signal = 0;
                #20   
                signal = 1;
                #20
                signal = 0;
                #20  
                signal = 1;
                #20  
                signal = 0;
                #20   

// 	  <<RESET>>
                signal = 0;
                reset = 1;
                #40
                reset = 0;
                #20
                   
// 	  <<INPUT SEQUENCE>>
                signal = 1;
                #20
                signal = 0;
                #20  
                signal = 0;
                #20  
                signal = 1;
                #20  
                signal = 0;
                #20  
                signal = 0;
                #20  
                signal = 0;
                #20  
                signal = 1;
                #20  
                signal = 1;
                #20  
                signal = 1;
                #20  
                signal = 1;
                #20  

// 	  <<RESET>>
                signal = 0;
                reset = 1;
                #40
                reset = 0;
                #20

//        <<Finish>>
                #60
                $finish;
        end


endmodule
