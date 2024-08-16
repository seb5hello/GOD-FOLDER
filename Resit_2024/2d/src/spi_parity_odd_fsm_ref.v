module spi_parity_odd_fsm_ref (
    input clk,
    input reset,
    input cs,
    input sample,
    input in,
    output parity_bit);

    parameter RESET = 'd0;
    parameter CHECK = 'd1;
    parameter CS = 'd2;
    parameter ODD = 'd3;
    parameter EVEN = 'd4;
    
    reg [2:0] state, state_next;
    reg parity_bit_r, parity_bit_next;
    
    // assign parity_bit = (in == 1)?0:parity_bit_r;
    assign parity_bit = parity_bit_next;
    
    always @(posedge clk) begin
        if(reset) begin
            state <= RESET;
            parity_bit_r <= 1;
        end else begin
            state <= state_next;
            parity_bit_r <= parity_bit_next;
        end
    end
    
    always @(*) begin
        state_next = state;
        parity_bit_next = parity_bit_r;
        
        // if (reset) begin
        //     state_next = RESET;
        //     parity_bit_next = 1;
        // end else begin
            case(state)
                RESET: begin
                    if(reset == 0) begin
                        state_next = CHECK;
                        parity_bit_next = 1;
                    end
                end
                
                CHECK: begin
                    if(cs == 1) begin
                        state_next = CS;
                    end
                end
                
                CS: begin
                    if(cs == 0 & sample == 1 & in == 1) begin
                        state_next = ODD;
                        parity_bit_next = 0;
                    end
                end
                
                ODD: begin
                    if(cs == 1) begin
                        state_next = CS;
                    end else if(cs == 0 & sample == 1 & in == 1) begin
                        state_next = EVEN;
                        parity_bit_next = 1;
                    end
                end
                
                EVEN: begin
                    if(cs == 1) begin
                        state_next = CS;
                    end else if(cs == 0 & sample == 1 & in == 1) begin
                        state_next = ODD;
                        parity_bit_next = 0;
                    end
                end
                
                default: begin
                    state_next = CHECK;
                    parity_bit_next = 1;
                end
            
            endcase
        
        // end
    end
endmodule
