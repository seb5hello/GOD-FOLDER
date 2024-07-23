`timescale 1ns / 1ps

module seq_top_ref (
    input clk,
    input reset,
    input next,
    input in,
    output out,
    output [2:0] state_display);

    reg [2:0] state, state_next;
    reg last_next;
    parameter START = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter S4 = 3'd4;
    parameter S5 = 3'd5;
    parameter S6 = 3'd6;
    
    assign out = (state == S3);
    assign state_display = state;
    
    always @(posedge clk) begin
        if(reset) begin
            state <= START;
        end else if(next == 1 & last_next == 0) begin
            state <= state_next;
        end
        last_next <= next;
    end
    
    always @(*) begin
        state_next=state;
        
        case(state)
            START:begin
                if(~in) begin
                    state_next = S1;
                end else begin
                    state_next = S4;
                end
            end
            
            S1:begin
                if(~in) begin
                    state_next = S1;
                end else begin
                    state_next = S2;
                end
            end
            
            S2:begin
                if(~in) begin
                    state_next = S3;
                end else begin
                    state_next = S4;
                end
            end
            
            S3:begin
                if(~in) begin
                    state_next = S6;
                end else begin
                    state_next = S2;
                end
            end
            
            S4:begin
                if(~in) begin
                    state_next = S5;
                end else begin
                    state_next = S4;
                end
            end
            
            S5:begin
                if(~in) begin
                    state_next = S6;
                end else begin
                    state_next = S2;
                end
            end
            
            S6:begin
                if(~in) begin
                    state_next = S6;
                end else begin
                    state_next = S6;
                end
            end
            
            default: begin state_next= state; end
        endcase
    end
endmodule
