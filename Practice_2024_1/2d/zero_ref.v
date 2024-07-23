module zero(
    input clk,
    input reset,
    input in,
    output out);
    
    reg [1:0] state, state_next;
    reg out_next;
    
    parameter START = 0;
    parameter FIRST = 1;
    parameter SECOND = 2;
    parameter THIRD = 3;
    
    assign out = (reset)?0:out_next;

    always @(posedge clk) begin
        if(reset) begin
            state <= START;
        end else begin
            state <= state_next;
        end
    end

    always @(*) begin
        state_next = state;
        
        case (state) 
            START: begin
                if(in == 0) begin
                    state_next = FIRST;
                    out_next = 0;
                end else begin
                    state_next = state;
                    out_next = 0;
                end
            end
            
            FIRST: begin
                if(in == 0) begin
                    state_next = SECOND;
                    out_next = 0;
                end else begin
                    state_next = state;
                    out_next = 0;
                end
            end
            
            SECOND: begin
                if(in == 0) begin
                    state_next = THIRD;
                    out_next = 1;
                end else begin
                    state_next = state;
                    out_next = 0;
                end
            end
            
            THIRD: begin
                if(in == 0) begin
                    state_next = FIRST;
                    out_next = 0;
                end else begin
                    state_next = START;
                    out_next = 0;
                end
            end
        endcase
    end
endmodule
