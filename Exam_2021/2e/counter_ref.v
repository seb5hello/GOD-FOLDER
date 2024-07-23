module counter_ref (
    input clk,
    input reset,
    input tr,
    output cf,
    input mode);

    parameter t_value = 5;

    reg state, state_next, out;
    parameter COUNTING = 0;
    parameter IDLE = 1;

    reg [15:0] delay, delay_next;
    reg [31:0] nr_clks, nr_clks_next;

    assign cf = (reset)?1:out;

    always @(posedge clk) begin
        if(reset) begin
            out <= 1;
            state <= IDLE;
            delay <= 0;
            nr_clks <= 0;
        end else begin 
            if (~state) begin
                out <= 0;
            end else begin
                out <= 1;
            end
            state <= state_next;
            delay <= delay_next;
            nr_clks <= nr_clks_next;
        end
    end

    always @(*) begin
        delay_next = delay;
        nr_clks_next = nr_clks;
        state_next = state;

        if(state == IDLE) begin
            if(tr) begin
                delay_next = (mode)?(t_value*3):t_value;
                nr_clks_next = 0;
                state_next = COUNTING;
            end
        end else begin 
            if(nr_clks == delay_next-2) begin
                delay_next = 0;
                nr_clks_next = 0;
                state_next = IDLE;
            end else begin
                nr_clks_next = 1 + nr_clks;
            end
        end
    end

endmodule
