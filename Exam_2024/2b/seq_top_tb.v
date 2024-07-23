`timescale 1ns / 1ps 

module seq_top_tb(); 
 
    <<DECLARE SIGNALS TO DRIVE MODULE seq_top>>
	
	seq_top seq_top_inst( 
		 .clk(clk), 
		 .reset(reset), 
	     .next(next), 
	     .in(in), 
		 .state_display(state_display),
		 .out(out)); 

    <<DECLARE CLOCK>>
    
	initial begin 
	$dumpfile("dut.vcd"); 
	$dumpvars(0, seq_top_inst); 

	<<DECLARE SIGNALS TO INITIALISE clk AND next VALUES>>


	<<DECLARE SIGNALS TO RESET seq_top>>
	
	$display("state %x, out %x", state_display, out); 

	<<INPUT 0 TO in AND TOGGLE next>>	
	 
	$display("state %x, out %x", state_display, out); 
 
	<<INPUT 1 TO in AND TOGGLE next>>
	
	$display("state %x, out %x", state_display, out); 
 
	<<INPUT 0 TO in AND TOGGLE next>>
		
	$display("state %x, out %x", state_display, out); 
 
	<<INPUT 1 TO in AND TOGGLE next>>
	
	$display("state %x, out %x", state_display, out); 
 
	<<INPUT 1 TO in AND TOGGLE next>>
	
	$display("state %x, out %x", state_display, out); 
 
	<<INPUT 0 TO in AND TOGGLE next>> 	
	
	$display("state %x, out %x", state_display, out); 
	
	<<INPUT 0 TO in AND TOGGLE next>>
 
	$display("state %x, out %x", state_display, out); 
 
	<<INPUT 0 TO in AND TOGGLE next>>	
	
	$display("state %x, out %x", state_display, out); 
 
	<<INPUT 1 TO in AND TOGGLE next>>
	 	
	$display("state %x, out %x", state_display, out); 
 
	<<INPUT 1 TO in AND TOGGLE next>>
	
	$display("state %x, out %x", state_display, out); 
 
	<<INPUT 0 TO in AND TOGGLE next>> 	

	$display("state %x, out %x", state_display, out); 
	#100	
 $finish; 
end 
endmodule 