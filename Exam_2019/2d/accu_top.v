`timescale 1 ns / 1 ps

module accu_top(
    input clk,
    input reset,
    input in,
    input next,
    output reg out,
    output reg [2:0] state_display
);

localparam
s0 = 3'b000,
s1 = 3'b001,
s2 = 3'b010,
s3 = 3'b011,
s4 = 3'b100,
s5 = 3'b101,
s6 = 3'b110;

reg [2:0] curr_state;
reg [2:0] next_state;

always@(*)begin
    if(reset)begin
        next_state = s0;
    end
    else begin
        case(curr_state)
            s0: begin
                if(next == 1'b1 && in == 1'b0)begin
                    next_state = s0;
                end
                else if(next == 1'b1 && in == 1'b1)begin
                    next_state = s1;
                end
            end
            s1: begin
                if(next == 1'b1 && in == 1'b0)begin
                    next_state = s1;
                end
                else if(next == 1'b1 && in == 1'b1)begin
                    next_state = s2;
                end
            end
            s2: begin
                if(next == 1'b1 && in == 1'b0)begin
                    next_state = s2;
                end
                else if(next == 1'b1 && in == 1'b1)begin
                    next_state = s3;
                end
            end
            s3: begin
                if(next == 1'b1 && in == 1'b0)begin
                    next_state = s3;
                end
                else if(next == 1'b1 && in == 1'b1)begin
                    next_state = s4;
                end
            end
            s4: begin
                if(next == 1'b1 && in == 1'b0)begin
                    next_state = s0;
                end
                else if(next == 1'b1 && in == 1'b1)begin
                    next_state = s1;
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
    if(reset)begin
        out <= 0;
    end
    else begin
        case(curr_state)
            s0: begin
                out <= 0;
                state_display <= curr_state;
            end
            s1: begin
                out <= 0;
                state_display <= curr_state;
            end
            s2: begin
                out <= 0;
                state_display <= curr_state;
            end
            s3: begin
                out <= 0;
                state_display <= curr_state;
            end
            s4: begin
                out <= 1;
                state_display <= curr_state;
            end
        endcase
    end
end



endmodule