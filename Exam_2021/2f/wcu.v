`timescale 1ns / 1ps

   module wcu (
       input   [0:0] clk,
       input  [0:0] reset,
       input  [0:0] q,
       input   [0:0] p,
       input   [0:0] cf,
       output  [1:0] ts,
       output  [0:0] lid,
       output  [0:0] tr,
       output  [0:0] mode
   );

   // Add your FSM implementation here...
   
   localparam 
   zero=3'd0,
   one=3'd1,
   two=3'd2,
   three=3'd3,
   four=3'd4,
   five=3'd5,
   six=3'd6,
   seven=3'd7;
   
   reg [2:0]  next_state;
   reg [2:0] curr_state;
   
   
   always @(posedge clk) begin
    if(reset) begin
        curr_state<=zero;
        next_state<=zero;
    end else begin
        curr_state<=next_state;
    end
   end
   
   always @(*) begin
        next_state=curr_state;
        case(curr_state)
            zero: next_state= !q ? curr_state : one;
            one: next_state= (q) ? two : zero;
            two: next_state= three;
            three: next_state= (cf && p ) ? four : (cf && !p) ? five : curr_state;
            four: next_state= six;
            five: next_state= seven;
            six: next_state= cf ? five : curr_state;
            seven: next_state= cf ? zero : curr_state;
            default: next_state=zero;
        
        endcase
   end
   assign lid = (curr_state==3'd0) ? 1'b1 :1'b0;
   assign ts = (curr_state==two || curr_state==three || curr_state==four || curr_state==six) ? 2'b10 :  ((curr_state==five) || (curr_state==seven)) ? 2'b11 : (curr_state == one) ? 2'b01 : (curr_state == zero) ? 2'b00 : 2'b00;
   assign tr= (curr_state==two || curr_state==four || curr_state==five);
   assign mode= (curr_state==five || curr_state==seven) ? 1'b0 : 1'b1;

endmodule