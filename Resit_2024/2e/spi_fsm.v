module spi_fsm( input clk,
                input reset,
                input [1:0] mode,
                input cs,
                input sclk,
                output sample,
                output shift);

    parameter RESET = 'd0;
    parameter CS = 'd1;
    parameter MODE = 'd2;
    parameter FIRST1 = 'd3;
    parameter FIRST3 = 'd4;
    parameter LAST1 = 'd5;
    parameter LAST3 = 'd6;
    parameter WAIT_LO1 = 'd7;
    parameter WAIT_LO0 = 'd8;
    parameter WAIT_LO2 = 'd9;
    parameter WAIT_LO3 = 'd10;
    parameter WAIT_HI0 = 'd11;
    parameter WAIT_HI1 = 'd12;
    parameter WAIT_HI2 = 'd13;
    parameter WAIT_HI3 = 'd14;
    parameter SHIFT0 = 'd15;
    parameter SHIFT1 = 'd16;
    parameter SHIFT2 = 'd17;
    parameter SHIFT3 = 'd18;
    parameter SAMPLE0 = 'd19;
    parameter SAMPLE1 = 'd20;
    parameter SAMPLE2 = 'd21;
    parameter SAMPLE3 = 'd22;

    reg [4:0] state, state_next;
    assign sample = (state == SAMPLE0 | state == SAMPLE1 | state == SAMPLE2 | state == SAMPLE3 );
    assign shift = (state == SHIFT0 | state == SHIFT1 | state == SHIFT2 | state == SHIFT3 );

    always @(posedge clk)begin
        if(reset) begin
            state <= RESET;
        end else begin
            state <= state_next;
        end
    end

    always @(*)begin
        state_next = state;

        case(state)
            
            RESET: begin
                state_next = CS;
            end
            
            CS: begin
                if(cs == 1) begin
                    state_next = MODE;
                end
            end

            MODE: begin
                if(mode == 'b01 && cs == 0 && sclk == 0) begin
                    state_next = FIRST1;
                end else if(mode == 'b00 && cs == 0 && sclk == 0) begin
                    state_next = WAIT_LO0;
                end else if(mode == 'b11 && cs == 0 && sclk == 1) begin
                    state_next = FIRST3;
                end else if(mode == 'b10 && cs == 0 && sclk == 1) begin
                    state_next = WAIT_HI2;
                end
            end

            FIRST1: state_next = (sclk == 1)? WAIT_HI1:state ;
            WAIT_HI1: state_next = (sclk == 0)? SAMPLE1:state ;
            SAMPLE1: state_next = WAIT_HI1;
            WAIT_LO1: begin
                if(cs == 0 && sclk == 1) begin
                    state_next = SHIFT1;
                end else if(cs == 1) begin
                    state_next = LAST1;
                end
            end
            SHIFT1: state_next = WAIT_HI1;
            LAST1: state_next = (cs == 1)? MODE:state ;
            

            WAIT_LO0: begin
                if(sclk == 1 && cs == 0) begin
                    state_next = SAMPLE0;
                end else if(cs == 1) begin
                    state_next = MODE;
                end
            end
            SAMPLE0: state_next = WAIT_HI0;
            WAIT_HI0: state_next = (sclk == 0)? SHIFT0:state ;
            SHIFT0: state_next = WAIT_LO0;


            FIRST3: state_next = (sclk == 0)? WAIT_LO3:state ;
            WAIT_LO3: state_next = (sclk == 1)? SAMPLE3:state ;
            SAMPLE3: state_next = WAIT_HI3;
            WAIT_HI3:  begin
                if(cs == 0 && sclk == 0) begin
                    state_next = SHIFT3;
                end else if(cs == 1) begin
                    state_next = LAST3;
                end
            end
            SHIFT3: state_next = WAIT_LO3;
            LAST3: state_next = (cs == 1)? MODE:state ;
            

            WAIT_HI2: begin
                if(sclk == 0 && cs == 0) begin
                    state_next = SAMPLE2;
                end else if(cs == 1) begin
                    state_next = MODE;
                end
            end
            SAMPLE2: state_next = WAIT_LO2;
            WAIT_LO2: state_next = (sclk == 1)? SHIFT2:state ;
            SHIFT2: state_next = WAIT_HI2;

            default: begin 
                state_next = RESET;
            end
        endcase   
    end
endmodule
