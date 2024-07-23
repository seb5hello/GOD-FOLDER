module counter (
    input clk,
    input reset,
    input trL,
    input trS,
    output tL,
    output tS);

    parameter lvalue = 2;
    parameter svalue = 4;

    assign tL = 0;
    assign tS = 0;

endmodule
