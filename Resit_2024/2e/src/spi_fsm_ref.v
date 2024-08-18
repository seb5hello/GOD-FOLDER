module spi_fsm_ref(
    input wire clk,
    input wire reset,
    input wire [1:0] mode,
    input wire cs,
    input wire sclk,
    output reg shift,
    output reg sample
);

localparam rst = 0;
localparam check_cs_hi =1;
localparam mode_select = 2;
localparam first1 = 3;
localparam first3 =4;
localparam last1 = 5;
localparam last3 = 6;
localparam wait1lo = 7;
localparam wait0lo = 8;
localparam wait2lo = 9;
localparam wait3lo = 10;
localparam wait0hi = 11;
localparam wait1hi = 12;
localparam wait2hi = 13;
localparam wait3hi = 14;
localparam shift0 = 15;
localparam shift1 = 16;
localparam shift2 = 17;
localparam shift3 = 18;
localparam sample0 = 19;
localparam sample1 = 20;
localparam sample2 = 21;
localparam sample3 = 22;

reg [4:0] state_r, state_nxt;

always @(posedge clk)begin
    if(reset == 1)begin
        state_r <= rst; // check
    end else begin
        state_r <= state_nxt;
    end
end

always @(*)begin
    state_nxt = state_r;
    case(state_r)
        check_cs_hi: begin
            if(cs == 1'b1) state_nxt = mode_select;
        end
        mode_select: begin
            if(mode == 2'b01 && cs == 1'b0 && sclk == 1'b0) state_nxt = first1;
            else if(mode == 2'b00 && cs == 1'b0 && sclk == 1'b0) state_nxt = wait0lo;
            else if(mode == 2'b11 && cs == 1'b0 && sclk == 1'b1) state_nxt = first3;
            else if(mode == 2'b10 && cs == 1'b0 && sclk == 1'b1) state_nxt = wait2hi;
        end
        first1: begin
            if(sclk == 1'b1) state_nxt = wait1hi;
        end
        first3: begin
            if(sclk == 1'b0) state_nxt = wait3lo;
        end
        last1: begin
            state_nxt = mode_select;
        end
        last3: begin
            state_nxt = mode_select;
        end
         wait1lo:begin
            if(sclk == 1'b1 && cs == 1'b0) state_nxt = shift1;
            else if(cs == 1'b1) state_nxt = last1;
         end
 wait0lo: begin
    if(sclk == 1'b1 && cs == 1'b0) state_nxt = sample0;
    else if(cs == 1'b1) state_nxt = mode_select;
 end
 wait2lo:begin
    if(sclk == 1'b1) state_nxt = shift2;
 end
 wait3lo:begin
    if(sclk == 1'b1) state_nxt = sample3;
 end
 wait0hi:begin
    if(sclk == 1'b0) state_nxt = shift0;
 end
wait1hi:begin
    if(sclk == 1'b0) state_nxt = sample1;
end
wait2hi:begin
    if(cs == 1'b1) state_nxt = mode_select;
    else if(sclk == 1'b0 && cs == 1'b0) state_nxt = sample2;
end
 wait3hi:begin
    if(cs == 1'b1) state_nxt = last3;
    else if(sclk == 1'b0 && cs == 1'b0) state_nxt = shift3;
 end
 shift0:begin
    state_nxt = wait0lo;
 end
 shift1:begin
    state_nxt = wait1hi;
 end
 shift2:begin
    state_nxt = wait2hi;
 end
 shift3:begin
    state_nxt = wait3lo;
 end
 sample0:begin
    state_nxt = wait0hi;
 end
 sample1:begin
    state_nxt = wait1lo;
 end
 sample2:begin
    state_nxt = wait2lo;
 end
 sample3:begin
    state_nxt = wait3hi;
 end
 default:begin
    state_nxt = check_cs_hi;
 end
    endcase
    
    
end

always @(*)begin
    case(state_r)
        shift1: shift = 1;
        last1: shift =1;
        shift0: shift = 1;
        shift3: shift = 1;
        last3: shift = 1;
        shift2: shift = 1;
        default: shift = 0;
    endcase
end

always @(*)begin
    case(state_r)
        sample1: sample = 1;
        sample0: sample = 1;
        sample3: sample = 1;
        sample2: sample = 1;
        default: sample = 0;
    endcase
end

endmodule
