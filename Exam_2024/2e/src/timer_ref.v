module timer_ref(
            input clk,
            input reset,
            input enable,
            input [4:0] value,
            input valid,
            output trigger,
            output[4:0] count);
    reg [4:0] out;
    // reg [4:0] MUX1_next, MUX2_next;
    wire [4:0] MUX1, MUX2, out_next;
    wire complete;
            
    timer_fsm_ref timer_fsm_ref_inst( 
		 .clk(clk), 
		 .reset(reset), 
	     .enable(enable), 
	     .complete(complete), 
		 .trigger(trigger));
		 
    assign count = out;
    assign complete = ~(|out);
    
    assign MUX1 = (~complete & enable)?(out - 'd1):(out);
    assign MUX2 = (valid)?(value):(MUX1);
    assign out_next = (reset)?(5'h0):(MUX2);
    
    always @(posedge clk) begin
        out <= out_next;
    end
endmodule