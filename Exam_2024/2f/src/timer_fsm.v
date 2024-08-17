module timer_fsm(
            input clk,
            input reset,
            input enable,
            input complete,
            output trigger);

    parameter IDLE = 'd0;
    parameter COUNT = 'd1;
    parameter DONE = 'd2;
    parameter PAUSE = 'd3;
    
    reg [1:0] state,state_next;

    assign trigger = state==DONE;

    always @(posedge clk) begin
        if(reset) begin
            state = IDLE;
        end else begin
            state = state_next;
        end
    end

    always @(*) begin
        state_next = state;

        case(state) 
            IDLE: begin
                if(enable == 1 & complete == 0) begin
                    state_next = COUNT;
                end else if(enable == 0 & complete == 0) begin
                    state_next = PAUSE;
                end    
            end

            COUNT: begin
                if(enable == 0 & complete == 1) begin
                    state_next = IDLE;
                end else if(enable == 1 & complete == 1) begin
                    state_next = DONE;
                end else if(enable == 0 & complete == 0) begin
                    state_next = PAUSE;
                end
            end

            DONE: begin
                if(complete == 1) begin
                    state_next = IDLE;
                end else if(enable == 1) begin
                    state_next = COUNT;
                end else if(enable == 0) begin
                    state_next = PAUSE;
                end
            end

            PAUSE: begin
                if(enable == 0 & complete == 1) begin
                    state_next = IDLE;
                end else if(enable == 1 & complete == 1) begin
                    state_next = DONE;
                end else if(enable == 1 & complete == 0) begin
                    state_next = PAUSE;
                end
            end

            default: state_next = IDLE;
        endcase
    end
endmodule
