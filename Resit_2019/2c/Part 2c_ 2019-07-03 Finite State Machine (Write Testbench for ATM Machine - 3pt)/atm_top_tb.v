`timescale 1ns / 1ps
module atm_top_tb();


	//<<DECLARE SIGNALS TO DRIVE MODULE atm_top>>
	
	reg clk = 0;
	reg cancel = 0;
	reg next = 0;
	reg [15:0] pin = 0;
	reg [13:0] cash_in = 0;
	wire success;
	wire [13:0] cash_out;
	wire [2:0] state_display;
   
	atm_top atm_top_inst(
		.clk(clk),
		.cancel(cancel),
		.next(next),
		.pin(pin),
		.cash_in(cash_in),
		.success(success),
		.cash_out(cash_out),
		.state_display(state_display));

        //<<DECLARE CLOCK>>
        always #2 clk = ~clk;

   
           
   initial begin
	  $dumpfile("dut.vcd");
   	  $dumpvars;
   
      //<<WRITE YOUR TEST LOGIC FOR STATE TRANSITION 0 to 1>>
      #10 next = 1;
      #10 next = 0;
      #100 
	  $display("state %x, success %x, cash_out %d", state_display, success, cash_out);
	  
	  //<<WRITE YOUR TEST LOGIC FOR STATE TRANSITION 1 to 2>>
	  #10 next = 1;
	  pin = 16'h5612;
	  #10 next =0;
      #100 
	  $display("state %x, success %x, cash_out %d", state_display, success, cash_out);
      
	  //<<WRITE YOUR TEST LOGIC FOR STATE TRANSITION 2 to 3>>
	  #10 next = 1;
	  cash_in = 14'd2500;
	  #10 next = 0;
      #100 
	  $display("state %x, success %x, cash_out %d", state_display, success, cash_out);
	  
	  //<<WRITE YOUR TEST LOGIC FOR STATE TRANSITION 3 to 4>>
	  #10 next = 1;
	  #10 next = 0;
      #100 
	  $display("state %x, success %x, cash_out %d", state_display, success, cash_out);
      $finish;

   end
endmodule