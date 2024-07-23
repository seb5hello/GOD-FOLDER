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
        wire resend_count_ref;
        wire request_resend_ref;
        wire valid_ref;
                
        uart_retrans_ref uart_retrans_ref_inst(
		.clk(clk),
		.reset(reset),
		.signal(signal),
		.ack(ack),
                .error(error_ref),
                .resend_count(resend_count_ref),
                .request_resend(request_resend_ref),
                .valid(valid_ref)
                );
                
        uart_retrans uart_retrans_inst(
		.clk(clk),
		.reset(reset),
		.signal(signal),
		.ack(ack),
                .error(error),
                .resend_count(resend_count),
                .request_resend(request_resend),
                .valid(valid)
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
                #220  

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
                #220  

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
