module elc_ref #(parameter [2:0] code = 3'b000)(
        input clk,
        input reset,
        input [2:0] in,
        input card_is_in,
        input enter,
        input tL,
        input tS,
        output trL,
        output trS,
        output unlock,
        output error,
        output card_is_needed);

    reg [3:0] state, state_next;
    parameter START = 4'd0;
    parameter T1_START = 4'd1;
    parameter T1_WAIT = 4'd2;
    parameter T1 = 4'd3;
    parameter T2_START = 4'd4;
    parameter T2_WAIT = 4'd5;
    parameter T2 = 4'd6;
    parameter T3 = 4'd7;
    parameter UNLOCK = 4'd8;

    assign trL = (state == T2_START);
    assign trS = (state == T1_START);
    assign unlock = (state == UNLOCK);
    assign error = ((state == T1_START)|(state == T1_WAIT)|(state == T2_START)|(state == T2_WAIT));
    assign card_is_needed = (state == T3);

    always @(posedge clk) begin
        if (reset) begin
            state <= START;
        end else begin
            state <= state_next;
        end
    end

    always @(*) begin
        state_next = state;
        case(state)
            START: begin
                if(enter & (in !== code)) begin
                    state_next = T1_START;
                end else if(enter & (in == code)) begin
                    state_next = UNLOCK;
                end 
            end
            T1_START: begin
                state_next = T1_WAIT;
            end
            T1_WAIT: begin
                if(tS) begin
                    state_next = T1;
                end 
            end
            T1: begin
                if(enter & (in !== code)) begin
                    state_next = T2_START;
                end else if(enter & (in == code)) begin
                    state_next = UNLOCK;
                end 
            end
            T2_START: begin
                state_next = T2_WAIT;
            end
            T2_WAIT: begin
                if(tL) begin
                    state_next = T2;
                end 
            end
            T2: begin
                if(enter & (in !== code)) begin
                    state_next = T3;
                end else if(enter & (in == code)) begin
                    state_next = UNLOCK;
                end 
            end
            T3: begin
                if(card_is_in) begin
                    state_next = UNLOCK;
                end
            end
            UNLOCK: begin
                state_next = START;
            end
        endcase
    end
endmodule