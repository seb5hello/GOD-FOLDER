`timescale 1ns / 1ps


module atm_top_ref(
    input clk, cancel, next,
    input [15:0] pin,
    input [13:0] cash_in,
    output success,
    output [13:0] cash_out,
    output [2:0] state_display
    );

parameter S_SCAN_CARD = 0; 
parameter S_CHECK_PIN = 1;
parameter S_WITHDRAW_AMT = 2; 
parameter S_VERIFY_BALANCE = 3;
parameter S_DISPENSE_CASH = 4; 

parameter [15:0] ACCOUNT_PIN = 16'h1234;
parameter [13:0] ACCOUNT_BALANCE = 14'd3000;
parameter [13:0] ATM_OUT_LIMIT = 14'd7000;

reg [2:0] curr_state,next_state; 
reg next_prev;
reg [13:0] cash_in_reg,cash_in_reg_temp; // IMPORTANT
// cash_in is saved when the cash_in <= ATM_OUT_LIMIT 
// to then be used later to check cash_in_reg <= ACCOUNT_BALANCE

always @(posedge clk) begin
    
    if (cancel) begin 
    	curr_state <= S_SCAN_CARD;
    	cash_in_reg <= 0;
    end else begin
        curr_state <= next_state;
        cash_in_reg <= cash_in_reg_temp;
    end
    
    next_prev <= next;
end

always @(*) begin 
    next_state = curr_state;
    cash_in_reg_temp = cash_in_reg;if(next && !next_prev) begin
        case (curr_state)
            S_SCAN_CARD: begin
                next_state = S_CHECK_PIN;
            end
            
            S_CHECK_PIN:  begin
                if (pin == ACCOUNT_PIN) begin
                    next_state = S_WITHDRAW_AMT;
                end else begin
                    next_state = S_CHECK_PIN;
                end
            end
            
            S_WITHDRAW_AMT:  begin
                if (cash_in <= ATM_OUT_LIMIT) begin
                    next_state = S_VERIFY_BALANCE;
                    cash_in_reg_temp = cash_in;
                end else begin
                    next_state = S_WITHDRAW_AMT;
                end
            end
            
            S_VERIFY_BALANCE:  begin
                if (cash_in_reg <= ACCOUNT_BALANCE) begin
                    next_state = S_DISPENSE_CASH;
                end else begin
                    next_state = S_SCAN_CARD;
                end
            end
            
            S_DISPENSE_CASH:  begin
                next_state = S_SCAN_CARD;
            end
            
            default: next_state = S_SCAN_CARD; // handle unused states
        endcase
    end
end

assign success = (curr_state == S_DISPENSE_CASH); // assign output: Moore machine
assign cash_out = (curr_state == S_DISPENSE_CASH) ? cash_in_reg : 14'd0;
assign state_display = curr_state; // debugging

endmodule
