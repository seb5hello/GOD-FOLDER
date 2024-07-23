`timescale 1ns / 10ps

module soda_top_tb();
reg clk, reset, next;
reg [1:0] coin_in;
wire soda;
wire [1:0] coin_out;
wire [2:0] state_display;
wire check_coin_in;

soda_top soda_top_inst(
    .clk(clk),
    .reset(reset),
    .next(next),
    .soda(soda),
    .coin_in(coin_in),
    .coin_out(coin_out),
    .state_display(state_display)
);

always begin
    #5 clk = ~clk;
end

initial begin
    $dumpfile("soda_wave.vcd");
    $dumpvars();

    clk = 1;
    reset = 1;
    next = 0;
    coin_in = 0;
    #500
	$display("state %x, soda %x, coin_out %x", state_display, soda, coin_out);
    reset = 0;
    
    #10 next = 1;
    coin_in = 2'b01;
    #10 next = 0;
    #500
    $display("state %x, soda %x, coin_out %x", state_display, soda, coin_out);

    #10 next = 1;
    coin_in = 2'b00;
    #10 next = 0;
    #500
    $display("state %x, soda %x, coin_out %x", state_display, soda, coin_out);

    #10 next = 1;
    coin_in = 2'b11;
    #10 next = 0;
    #500
    $display("state %x, soda %x, coin_out %x", state_display, soda, coin_out);

    #10 next = 1;
    #10 next = 0;
    #500
    $display("state %x, soda %x, coin_out %x", state_display, soda, coin_out);

    #10 next = 1;
    #10 next = 0;
    #500
    $display("state %x, soda %x, coin_out %x", state_display, soda, coin_out);

    #10 next = 1;
    #10 next = 0;
    #500
    $display("state %x, soda %x, coin_out %x", state_display, soda, coin_out);

    #10 next = 1;

    #10 next = 0;
    #500
    $display("state %x, soda %x, coin_out %x", state_display, soda, coin_out);

    #10 $finish; 
end

endmodule