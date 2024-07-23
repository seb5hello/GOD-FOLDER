module timer_fsm_ref(
            input clk,
            input reset,
            input enable,
            input complete,
            output trigger);
    
    reg [1:0] state, state_next;
    parameter IDLE = 'd0;
    parameter COUNTING = 'd1;
    parameter PAUSED = 'd2;
    parameter DONE = 'd3;
            
    assign trigger = (state == DONE);
    
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
        end else begin
            state <= state_next;
        end
    end
    
    always @(*) begin
        state_next = state;
        
        case(state)
            IDLE: begin
                if((enable==0) & (complete==0)) begin
                    state_next = PAUSED;
                end else if((enable==1) & (complete==0)) begin
                    state_next = COUNTING;
                end
            end
            COUNTING: begin
                if((enable==0) & (complete==1)) begin
                    state_next = IDLE;
                end else if((enable==1) & (complete==1)) begin
                    state_next = DONE;
                end else if((enable==0) & (complete==0)) begin
                    state_next = PAUSED;
                end
            end
            PAUSED: begin
                if((enable==1) & (complete==1)) begin
                    state_next = DONE;
                end else if((enable==1) & (complete==0)) begin
                    state_next = COUNTING ;
                end else if((enable==0) & (complete==1)) begin
                    state_next = IDLE;
                end
            end
            DONE: begin
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
