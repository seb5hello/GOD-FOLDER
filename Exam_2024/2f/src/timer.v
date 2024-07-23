module timer(
    input clk,
    input reset,
    input enable,
    input [4:0] value,
    input valid,
    output wire trigger,
    output [4:0] count);

    wire [4:0] MUX1, MUX2, MUX3;
    reg [4:0] IN;
    wire complete;

    always @(posedge clk) begin
        IN <= MUX3;
    end

    assign count = IN;
    assign complete = ~(|IN);

    assign MUX1 = (~complete & enable)?(IN-1):(IN);
    assign MUX2 = (valid)?(value):(MUX1);
    assign MUX3 = (reset)?(5'd0):(MUX2);
    
    timer_fsm timer_fsm_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .complete(complete),
        .trigger(trigger)
        );

endmodule
