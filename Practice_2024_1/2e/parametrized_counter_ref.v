module parametrized_counter (
        input clk,
        input reset,
        input tr,
        input [1:0] multiplier,
        output cf
    );

    parameter [31:0] tvalue = 7; // Replace the ... with a reasonable default value
    parameter COUNT = 0;
    parameter OFF = 1;
    reg state, state_next;
    reg [31:0] clycles, clycles_next;
    reg [31:0] target, target_next;
    
    initial begin
        state = OFF;
    end
    
    always @(posedge clk) begin
        if(reset) begin
            state <= OFF;
            clycles <= 0;
            target <= 0;
        end else begin
            state <= state_next;
            clycles <= clycles_next + 1;
            target <= target_next;
        end
    end
    
    always @(*) begin
        state_next = state;
        clycles_next = clycles;
        target_next = target;
        if(state_next) begin
            if(tr) begin
                state_next = COUNT;
                clycles_next = 1;
                target_next = tvalue*(2**multiplier);
            end
        end else begin
            if(clycles == target) begin
                state_next = OFF;
            end
        end
    end
    
    assign cf = state;

endmodule
