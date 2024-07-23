`timescale 1ns / 1ps 

module seq_top_tb(); 
 
    reg clk,reset, next,in;
    wire out;
    wire [2:0] state_display;
//    <<DECLARE SIGNALS TO DRIVE MODULE seq_top>>
	
	seq_top seq_top_inst( 
		 .clk(clk), 
		 .reset(reset), 
	     .next(next), 
	     .in(in), 
		 .state_display(state_display),
		 .out(out)); 

    always #5 clk<=!clk;
    
	initial begin 
	$dumpfile("dut.vcd"); 
	$dumpvars(0, seq_top_inst); 

	//<<DECLARE SIGNALS TO INITIALISE clk AND next VALUES>>
            clk=0;
            next=0;
             reset=1;
            #10 reset=0;
            #10;

	
	$display("state %x, out %x", state_display, out); 
	
	
        #10 next=1;
        in=0;
        #10 next=0;
	
	 
	$display("state %x, out %x", state_display, out); 
        #10 next=1;
        in=1;
        #10 next=0;
	
	
	$display("state %x, out %x", state_display, out); 
 
	#10 next=1;
        in=0;
        #10 next=0;
		
	$display("state %x, out %x", state_display, out); 
 
	
	#10 next=1;
        in=1;
        #10 next=0;
	$display("state %x, out %x", state_display, out); 
 
	
	#10 next=1;
        in=1;
        #10 next=0;
	$display("state %x, out %x", state_display, out); 
 
	
	#10 next=1;
        in=0;
        #10 next=0;
	$display("state %x, out %x", state_display, out); 
	
	#10 next=1;
        in=1;
        #10 next=0;
 
	$display("state %x, out %x", state_display, out); 
 
	#10 next=1;
        in=0;
        #10 next=0;
	
	$display("state %x, out %x", state_display, out); 
 
	#10 next=1;
        in=1;
        #10 next=0;
	 	
	$display("state %x, out %x", state_display, out); 
 #10 next=1;
        in=0;
        #10 next=0;

	
	$display("state %x, out %x", state_display, out); 
 
	#10 next=1;
        in=0;
        #10 next=0;

	$display("state %x, out %x", state_display, out); 
	#100	
 $finish; 
end 
endmodule 