`timescale 1ns / 1ps
module accu_top_tb();

// 	<<DECLARE SIGNALS TO DRIVE MODULE accu_top>>
    reg clk = 0;
    reg reset = 0;
    reg in = 0;
    reg next = 0;
    
    wire out;
    wire [2:0] state_display;
    
	accu_top accu_top_inst(
		.clk(clk),
		.reset(reset),
		.next(next),
		.in(in),
		
		.out(out),
		.state_display(state_display));
   
//   <<.DECLARE CLOCK>>
   always #10 clk =~ clk;
    
	reg [8:0] i;
	parameter [8:0] length_in_sequence = 12;
    parameter [length_in_sequence-1:0] in_sequence = {1'b1,1'b0,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1};
           
   initial begin
	  $dumpfile("dut.vcd");
   	  $dumpvars(0, accu_top_inst);
	  
// 	  <<INITIALIZE INPUT SIGNALS>>
        clk = 1;
        reset = 0;
        in = 0;
        next = 0;
	  
// 	  <<RESET>>
        reset = 1;
        #40
        reset = 0;
        #40
    	#500
    	$display("state %x, out %x", state_display, out);
   
	    for (i = length_in_sequence; i >= 1; i = i - 1) begin
            next = 1;
            in = in_sequence[i-1];
            #40
            in = 0;
            next = 0;
            #40
            #500
    	    $display("state %x, out %x", state_display, out);
        end
	  
	  #200
      $finish;
   end
endmodule