module uart_retrans_fsm(
            input clk,
            input reset,
            input ack,
            input ,
            input ,
            input ,
            output error,
            output request_resend,
            output valid);
    
    reg [2:0] state, state_next;
    parameter WAIT_ = 'd0;
    parameter WAIT_RESEND1 = 'd1;
    parameter WAIT_RESEND2 = 'd2;
    parameter ERROR = 'd3;
    parameter RELEASE_ = 'd4;
            
    always @(posedge clk) begin
        if(reset & ~(valid &) begin
            state <= IDLE;
        end else begin
            state <= state_next;
        end
    end
    
    always @(*) begin
        state_next = state;
        
        case(state)
            WAIT_: begin
                if((enable==0) & (complete==0)) begin
                    state_next = PAUSED;
                end else if((enable==1) & (complete==0)) begin
                    state_next = COUNTING;
                end
            end
            WAIT_RESEND1: begin
                if((enable==0) & (complete==1)) begin
                    state_next = IDLE;
                end else if((enable==1) & (complete==1)) begin
                    state_next = DONE;
                end else if((enable==0) & (complete==0)) begin
                    state_next = PAUSED;
                end
            end
            WAIT_RESEND2: begin
                if((enable==1) & (complete==1)) begin
                    state_next = DONE;
                end else if((enable==1) & (complete==0)) begin
                    state_next = COUNTING ;
                end else if((enable==0) & (complete==1)) begin
                    state_next = IDLE;
                end
            end
            ERROR: begin
                if(complete==1) begin
                    state_next = IDLE;
                end else if((enable==1) & (complete==0)) begin
                    state_next = COUNTING;
                end else if((enable==0) & (complete==0)) begin
                    state_next = PAUSED;
                end
            end
            RELEASE_: begin
                if(complete==1) begin
                    state_next = IDLE;
                end else if((enable==1) & (complete==0)) begin
                    state_next = COUNTING;
                end else if((enable==0) & (complete==0)) begin
                    state_next = PAUSED;
                end
            end
        endcase
    end
endmodule
