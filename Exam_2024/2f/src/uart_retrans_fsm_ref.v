module uart_retrans_fsm_ref (
    input clk,
    input reset,
    input ack,
    input frame_valid,
    input parity_error,
    input timeout,
    output error,
    output request_resend,
    output valid);

    parameter WAIT = 'd0;
    parameter WAIT_R1 = 'd1;
    parameter WAIT_R2 = 'd2;
    parameter RELEASE = 'd3;
    parameter ERROR = 'd4;

    reg [2:0] state, state_next;
    reg error_next, request_resend_next, valid_next;

    assign error = (reset)?0:error_next;
    assign request_resend = (reset)?0:request_resend_next;
    assign valid = (reset)?0:valid_next;

    always @(posedge clk) begin 
        if(reset) begin 
            state <= WAIT;
        end else begin 
            state <= state_next;
        end
    end

    always @(*) begin 
        state_next = state;
        
        case(state)
            WAIT: begin
                if(parity_error == 1) begin 
                    state = WAIT_R1;
                    request_resend_next = 1;
                end else if(parity_error == 0 & frame_valid == 1) begin 
                    state = RELEASE;
                    valid_next = 1;
                end
            end
            
            WAIT_R1: begin
                if(timeout == 0 & frame_valid == 0) begin 
                    state = WAIT_R1;
                    request_resend_next = 0;
                end else if(timeout == 1 & frame_valid == 0) begin 
                    state = WAIT_R2;
                    request_resend_next = 1;
                end else if(frame_valid == 1) begin 
                    state = RELEASE;
                    request_resend_next = 0;
                    valid_next = 1;
                end
            end
            
            WAIT_R2: begin
                if(timeout == 0 & frame_valid == 0) begin 
                    state = WAIT_R2;
                    request_resend_next = 0;
                end else if(timeout == 1 & frame_valid == 0) begin 
                    state = ERROR;
                    request_resend_next = 0;
                    error_next = 1;
                end else if(frame_valid == 1) begin 
                    state = RELEASE;
                    request_resend_next = 0;
                    valid_next = 1;
                end
            end

            RELEASE: begin
                if(ack == 1) begin 
                    state = WAIT;
                    valid_next = 0;
                end
            end

            ERROR: begin
                if(ack == 1) begin 
                    state = WAIT;
                    error_next = 0;
                end
            end

            default: begin
                    state = WAIT;
                    request_resend_next = 0;
                    valid_next = 0;
                    error_next = 0;
                end
        endcase
    end
endmodule
