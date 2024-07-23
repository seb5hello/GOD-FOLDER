module counter (
    input clk,
    input reset,
    input tr,
    output cf,
    input mode);

    parameter t_value = 1;

    assign cf = tr;

endmodule
