module uart_retrans_ref (
    input clk,
    input reset,
    input signal,
    input ack,
    output wire error,
    output wire [4:0] resend_count,
    output request_resend,
    output wire valid);

    parameter [4:0] value = 5'd8;
    wire error_temp, valid_temp, request_resend_temp;
    
    assign request_resend = request_resend_temp;

    uart_retrans_fsm_ref uart_retrans_fsm_ref_inst (
        .clk(clk),
        .reset(reset),
        .frame_valid(valid_temp),
        .parity_error(error_temp),
        .timeout(trigger),
        .ack(ack),
        .error(error),
        .request_resend(request_resend_temp),
        .valid(valid)
        );

    uart_parity_even uart_parity_even_inst (
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .error(error_temp),
        .valid(valid_temp)
        );

    timer timer_inst (
        .clk(clk),
        .reset(reset),
        .valid(request_resend_temp),
        .value(value),
        .enable(1'b1),
        .count(resend_count),
        .trigger(trigger) 
        );
        
endmodule
