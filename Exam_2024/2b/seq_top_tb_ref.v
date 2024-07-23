`timescale 1ns / 1ps 

module seq_top_tb(); 
 
    // <<DECLARE SIGNALS TO DRIVE MODULE seq_top>>
    reg clk = 0;
    reg reset = 0;
    reg next = 0;
    reg in = 0;
    wire out;
    wire[2:0] state_display;
	
	seq_top seq_top_inst( 
		 .clk(clk), 
		 .reset(reset), 
	     .next(next), 
	     .in(in), 
		 .state_display(state_display),
		 .out(out)); 

    // <<DECLARE CLOCK>>
    always #10 clk = ~clk;
    
	initial begin 
	$dumpfile("dut.vcd"); 
	$dumpvars(0, seq_top_inst); 

// 	<<DECLARE SIGNALS TO INITIALISE clk AND next VALUES>>
    reset = 1;
    #20
    reset = 0;
    #500


// 	<<DECLARE SIGNALS TO RESET seq_top>>
	
	$display("state %x, out %x", state_display, out); 

// 	<<INPUT 0 TO in AND TOGGLE next>>	
	#20
	next=1;
	in = 0;
	#40
	next = 0;
	in=0;
	#500
	$display("state %x, out %x", state_display, out); 
 
// 	<<INPUT 1 TO in AND TOGGLE next>>
    #20
    next = 1;
    in = 1;
    #40
    next = 0;
    in = 0;
	#500
	$display("state %x, out %x", state_display, out); 
 
// 	<<INPUT 0 TO in AND TOGGLE next>>
    #20 next = 1;
    in = 0;
    #40
    next = 0;
    in =0;
	#500
	$display("state %x, out %x", state_display, out); 
 
// 	<<INPUT 1 TO in AND TOGGLE next>>
    #20 
    next = 1;
    in = 1;
    #40
    next = 0;
    in = 0;
	#500
// 	$display("state %x, out %x", state_display, out);
	
	$display("state %x, out %x", state_display, out); 
 
// 	<<INPUT 1 TO in AND TOGGLE next>>
    #20
    next = 1;
    in = 1;
    #40
    next = 0;
    in = 0;
	#500
// 	$display("state %x, out %x", state_display, out);
	
	$display("state %x, out %x", state_display, out); 
 
// 	<<INPUT 0 TO in AND TOGGLE next>> 
    #20
    next = 1;
    in = 0;
    #40
    next = 0;
    in = 0;
	#500
	
	$display("state %x, out %x", state_display, out); 
	
// 	<<INPUT 0 TO in AND TOGGLE next>>
    #20
    next = 1;
    in = 0;
    #40
    next = 0;
    in = 0;
	#500
 
	$display("state %x, out %x", state_display, out); 
 
// 	<<INPUT 0 TO in AND TOGGLE next>>
    #20
    next = 1;
    in = 0;
    #40
    next = 0;
    in = 0;
	#500
	
	$display("state %x, out %x", state_display, out); 
 
// 	<<INPUT 1 TO in AND TOGGLE next>>
    #20
    next = 1;
    in = 1;
    #40
    next = 0;
    in = 0;
	#500
	 	
	$display("state %x, out %x", state_display, out); 
 
// 	<<INPUT 1 TO in AND TOGGLE next>>
    #20
    next = 1;
    in = 1;
    #40
    next = 0;
    in = 0;
	#500
	
	$display("state %x, out %x", state_display, out); 
 
// 	<<INPUT 0 TO in AND TOGGLE next>> 
    #20
    next = 1;
    in = 0;
    #40
    next = 0;
    in = 0;
	#500

	$display("state %x, out %x", state_display, out); 
	#100	
 $finish; 
end 
endmodule 