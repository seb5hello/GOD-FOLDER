`timescale 1ns / 1ps
module seq_top_tb();


// 	<<DECLARE SIGNALS TO DRIVE MODULE seq_top>>
    reg clk = 0;
    reg reset = 0;
    reg next = 0;
    reg in = 0;
    
    wire out;
    wire [2:0] state_display;
   
	seq_top seq_top_inst(
		.clk(clk),
		.reset(reset),
		.next(next),
		.in(in),
		.out(out),
		.state_display(state_display));

        // <<DECLARE CLOCK>>
    always #10 clk =~ clk;
   
           
   initial begin
	  $dumpfile("dut.vcd");
   	  $dumpvars(0, seq_top_inst);
   	  clk = 1;
   	  
	  
// 	  <<RESET>>
        reset = 1;
        #40
        reset = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 0;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 1;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 0;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 1;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 1;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 0;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 1;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 0;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 0;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 1;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
// 	  <<STIMULI >>
        next = 1;in = 0;
        #40
        next = 0;in = 0;
        #40
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  #100
      $finish;

   end
endmodule
