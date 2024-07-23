`timescale 1ns / 1ps
module accu_top_tb();

	//<<DECLARE SIGNALS TO DRIVE MODULE accu_top>>
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
   
   //<<DECLARE CLOCK>>
   always #2 clk = ~clk;
   
           
   initial begin
	  $dumpfile("dut.vcd");
   	  $dumpvars(0, accu_top_inst);

          //<<INITIALIZE INPUT SIGNALS>>	
  
	  //<<RESET>>
	  #10 reset = 1;
	  #10 reset = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
   
	  
	  //<<STIMULI 1>>
	  #10 next = 1;
	  in = 1;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 2>>
	  #10 next = 1;
	  in = 0;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 3>>
	  #10 next = 1;
	  in = 0;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 4>>
	  #10 next = 1;
	  in = 1;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 5>>
	  #10 next = 1;
	  in = 0;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 6>>
	  #10 next = 1;
	  in = 1;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 7>>
	  #10 next = 1;
	  in = 0;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 8>>
	  #10 next = 1;
	  in = 1;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 9>>
	  #10 next = 1;
	  in = 1;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 10>>
	  #10 next = 1;
	  in = 1;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 11>>
	  #10 next = 1;
	  in = 1;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
	  //<<STIMULI 12>>
	  #10 next = 1;
	  in = 1;
	  #10 next = 0;
	  #500
	  $display("state %x, out %x", state_display, out);
	  
        
	  
	  #100
      $finish;
   end
endmodule