module ccu (
    input  clk,
    input  reset,
    input  proceed,
    output green_walk,
    output orange_walk,
    output red_hand,
    output [1:0] multiplier,
    output tr
);

reg tr_r;
reg [1:0] multiplier_r;
reg green_walk_r;
reg orange_walk_r;
reg red_hand_r;

reg tr_next;
reg [1:0] multiplier_next;
reg green_walk_next;
reg orange_walk_next;
reg red_hand_next;

reg [1:0] state, state_next;
parameter WALK = 0;
parameter CAUTION = 1;
parameter HAND = 2;

assign tr = tr_r;
assign multiplier = multiplier_r;
assign green_walk = green_walk_r;
assign orange_walk = orange_walk_r;
assign red_hand = red_hand_r;

always @(posedge clk) begin

    if(reset) begin
        state <= WALK;
        tr_r <= 1;
        multiplier_r <= 2'b01;
        green_walk_r <= 1;
        orange_walk_r <= 0;
        red_hand_r <= 0;
    end else begin
        state <= state_next;
        tr_r <= tr_next;
        multiplier_r <= multiplier_next;
        green_walk_r <= green_walk_next;
        orange_walk_r <= orange_walk_next;
        red_hand_r <= red_hand_next;
    end
end

always @(*) begin
    state_next = state;
    tr_next = tr_r;
    multiplier_next = multiplier_next;
    green_walk_next = green_walk_next;
    orange_walk_next = orange_walk_next;
    red_hand_next = red_hand_next;
    
    
    case(state_next)
        WALK: begin
            if(proceed) begin
                tr_next = 1;
                multiplier_next = 2'b00;
                green_walk_next = 0;
                orange_walk_next = 1;
                red_hand_next = 0;
                state_next = CAUTION;
            end else begin
                tr_next = 0;
                multiplier_next = 2'b00;
                green_walk_next = 1;
                orange_walk_next = 0;
                red_hand_next = 0;
                state_next = state;
            end
        end
        
        CAUTION: begin
            if(proceed) begin
                tr_next = 1;
                multiplier_next = 2'b11;
                green_walk_next = 0;
                orange_walk_next = 0;
                red_hand_next = 1;
                state_next = HAND;
            end else begin
                tr_next = 0;
                multiplier_next = 2'b11;
                green_walk_next = 0;
                orange_walk_next = 1;
                red_hand_next = 0;
                state_next = state;
            end
        end
        
        HAND: begin
            if(proceed) begin
                tr_next = 1;
                multiplier_next = 2'b01;
                green_walk_next = 1;
                orange_walk_next = 0;
                red_hand_next = 0;
                state_next = WALK;
            end else begin
                tr_next = 0;
                multiplier_next = 2'b01;
                green_walk_next = 0;
                orange_walk_next = 0;
                red_hand_next = 1;
                state_next = state;
            end
        end
    endcase
end


endmodule
