module uart_retrans(
            input clk,
            input reset,
            input ack,
            input signal,
            output trigger,
            output valid,
            output error,
            output request_resend,
            output[4:0] resend_count);
    reg [4:0] out;
    
            
    timer timer_inst( 
		 .clk(clk), 
		 .reset(reset), 
	     .enable(1), 
	     .value(5'h8), 
	     .valid(valid), 
	     .count(count), 
		 .trigger(trigger));
		 
		 
    uart_retrans_fsm uart_retrans_fsm_inst( 
		 .clk(clk), 
		 .reset(reset), 
		 .ack(ack), 
		 .frame_valid(frame_valid), 
		 .parity_error(parity_error), 
		 .timeout(timeout), 
		 .error(error), 
		 .request_resend(request_resend), 
		 .valid(valid));
		 
		 
    uart_parity_even uart_parity_even_inst( 
		 .clk(clk), 
		 .reset(reset), 
		 .signal(signal), 
		 .error(error), 
		 .valid(valid));
		 
    assign count = out;
    assign complete = ~(|out);
    
    assign MUX1 = (~complete & enable)?(out - 'd1):(out);
    assign MUX2 = (valid)?(value):(MUX1);
    assign out_next = (reset)?(5'h0):(MUX2);
    
    always @(posedge clk) begin
        out <= out_next;
    end
endmodule
