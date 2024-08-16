`timescale 1ns / 100ps


module AC_Controller_ref (
    input  wire [0:0] clk,
    input  wire [0:0] reset,
	input  wire [0:0] power,
	input  wire [1:0] temp_comp,
	output  [1:0] action,
	output   [1:0] state_display
    );
    
  // Add your FSM implementation here...
    
    
    reg [1:0] curr_state,next_state;
    
    localparam 
    off=2'd0,
    decrease=2'd1,
    increase=2'd2,
    idle=2'd3;
    
    always @(posedge clk) begin
        if(reset) begin
            curr_state<=off;
        
        end else begin
            curr_state<=next_state;
        
        
        end
    end
    
    
    
    
    always @(*) begin
        next_state=curr_state;
        if(power) begin
        case(curr_state)
            off: next_state= (temp_comp==2'b10 && power) ? decrease :  (temp_comp==2'b01 && power) ? increase : (temp_comp==2'b00 && power) ? idle: !power ? off :curr_state;
            decrease: next_state= (temp_comp==2'b01 && power) ? increase : (temp_comp==2'b00 && power) ? idle : !power ? off :curr_state ;
            increase: next_state= (temp_comp==2'b10 && power) ? decrease : (temp_comp==2'b00 && power) ? idle : !power ? off :curr_state;
            idle: next_state= (temp_comp==2'b10) ? decrease :  (temp_comp==2'b01) ? increase :!power ? off :curr_state;
            default: next_state=curr_state;
        endcase
        end
    end
    
    assign state_display=curr_state;
    assign action= (curr_state==off) ? 2'b11 : (curr_state==decrease) ? 2'b01 : (curr_state==increase) ? 2'b10 : 2'b00;
    
    
    
endmodule