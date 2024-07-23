module uart_parity_odd (
        input clk,
        input reset,
        input signal,
        output error,
        output valid);

    parameter BREAK = 'd0;
    parameter IDLE = 'd1;
    parameter START = 'd2;
    parameter B1E = 'd3;
    parameter B2E = 'd4;
    parameter B3E = 'd5;
    parameter B4E = 'd6;
    parameter B1O = 'd7;
    parameter B2O = 'd8;
    parameter B3O = 'd9;
    parameter B4O = 'd10;
    parameter PE = 'd11;
    parameter PO = 'd12;
    parameter STOPE = 'd13;
    parameter STOPO = 'd14;

    reg [15:0] state, state_next;

    assign valid = state==STOPO;
    assign error = state==STOPE;

    always @(posedge clk) begin
        if(~reset) begin
            state = state_next;
        end else begin
            state = BREAK;
        end
    end

    always @(*) begin
        state_next = state;
        case(state)
            BREAK: state_next = (signal)?IDLE:state;
            IDLE: state_next = (signal)?state:START;
            START: state_next = (signal)?B1O:B1E;

            B1E: state_next = (signal)?B2O:B2E;
            B2E: state_next = (signal)?B3O:B3E;
            B3E: state_next = (signal)?B4O:B4E;
            B4E: state_next = (signal)?PE:PO;

            B1O: state_next = (signal)?B2O:B2E;
            B2O: state_next = (signal)?B3O:B3E;
            B3O: state_next = (signal)?B4O:B4E;
            B4O: state_next = (signal)?PE:PO;

            PE: state_next = (signal)?STOPE:BREAK;
            PO: state_next = (signal)?STOPO:BREAK;

            STOPE: state_next = (signal)?IDLE:START;
            STOPO: state_next = (signal)?IDLE:START;

        endcase
    end
endmodule
