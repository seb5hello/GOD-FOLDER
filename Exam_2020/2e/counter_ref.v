
module counter_ref(
    input clk,
    input reset,
    input trL,
    input trS,
    output tL,
    output tS);

    parameter lvalue = 2;
    parameter svalue = 4;
    parameter IDLE = 0;
    parameter COUNTING = 1;
    reg stateL, stateS, stateL_next, stateS_next;
    reg [31:0] timerL, timerS, timerL_next, timerS_next;
    reg outL, outS, outL_next, outS_next;


    always @(posedge clk) begin
        if (reset) begin 
            timerL <= 0;
            timerS <= 0;
            stateL <= 0;
            stateS <= 0;
            outL <= 0;
            outS <= 0;
        end else begin
            timerL <= timerL_next;
            timerS <= timerS_next;
            stateL <= stateL_next;
            stateS <= stateS_next;
            outL <= outL_next;
            outS <= outS_next;
        end
    end

    assign tL = outL;
    assign tS = outS;

    always @(*) begin
        timerL_next = timerL;
        timerS_next = timerS;
        stateL_next = stateL;
        stateS_next = stateS;
        outL_next = outL;
        outS_next = outS;

        case(stateL)
            COUNTING: begin
                if(timerL == lvalue-1) begin
                    stateL_next = IDLE;
                    timerL_next = 0;
                    outL_next = 1;
                end else begin
                    timerL_next = 1 + timerL_next;
                end
            end

            IDLE: begin
                outL_next = 0;
                if(trL & ~trS) begin
                    stateL_next = COUNTING;
                    timerL_next = 0;
                end
            end
        endcase

        case(stateS)
            COUNTING:begin
                if(timerS == svalue-1) begin
                    stateS_next = IDLE;
                    timerS_next = 0;
                    outS_next = 1;
                end else begin
                    timerS_next = 1 + timerS;
                end
            end

            IDLE:begin
                outS_next = 0;
                if(trS & ~trL) begin
                    stateS_next = COUNTING;
                    timerS_next = 0;
                end
            end
        endcase
    end

endmodule