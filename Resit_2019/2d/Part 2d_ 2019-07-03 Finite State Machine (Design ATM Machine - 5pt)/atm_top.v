`timescale 1 ns / 1 ps

module atm_top(clk,cancel,next,pin,cash_in,success,cash_out,state_display);

input clk;
input cancel;
input next;
input [15:0] pin;
input [13:0] cash_in;
output reg success;
output reg [13:0] cash_out;
output reg [2:0] state_display;

parameter ATM_OUT_LIMIT = 14'd8000;
parameter ACCOUNT_PIN = 16'h5612;
parameter ACCOUNT_BALANCE = 14'd4000;


localparam
s0 = 3'b000,
s1 = 3'b001,
s2 = 3'b010,
s3 = 3'b011,
s4 = 3'b100;

reg [2:0] curr_state;
reg [2:0] next_state;
reg [13:0] cash_temp;


always@(*)begin
    if(cancel)begin
        next_state = s0;
    end
    else begin
        case(curr_state)
            s0: begin
                if(next == 1'b1)begin
                    next_state = s1;
                end
            end
            s1:begin
            if(next == 1'b1 && pin != ACCOUNT_PIN)begin
                next_state = s1;
            end
            else if(next == 1'b1 && pin == ACCOUNT_PIN)begin
                next_state = s2;
            end
            end
            s2: begin
                if(next == 1'b1 && cash_in > ATM_OUT_LIMIT)begin
                    next_state = s2;
                end
                else if(next == 1'b1 && cash_in <= ATM_OUT_LIMIT)begin
                    next_state = s3;
                    cash_temp = cash_in;
                end
            end
            s3: begin
                if(next == 1'b1 && cash_temp > ACCOUNT_BALANCE)begin
                    next_state = s0;
                end
                else if(next == 1'b1 && cash_temp <= ACCOUNT_BALANCE)begin
                    next_state = s4;
                end
            end
            s4: begin
                if(next == 1'b1)begin
                    next_state = s0;
                end
            end
            default: begin
                next_state = s0;
            end
        endcase
    end
    curr_state = next_state;
end

always@(posedge clk)begin
    if(cancel)begin
        success<=0;
        cash_out <= 14'd0;
        
    end
    case(curr_state)
        s0: begin
            success <= 0;
            cash_out <= 14'd0;
            state_display <= curr_state;
        end
        s1: begin
            success <= 0;
            cash_out <= 14'd0;
            state_display <= curr_state;
        end
        s2: begin
            success <= 0;
            cash_out <= 14'd0;
            state_display <= curr_state;
        end
        s3: begin
            success <= 0;
            cash_out <= 14'd0;
            state_display <= curr_state;
        end
        s4: begin
            success <= 1;
            cash_out <= cash_temp;
            state_display <= curr_state;
        end
        default: begin
            success <= 0;
            cash_out <= 14'd0;
            state_display <= curr_state;
        end
    endcase
end

endmodule