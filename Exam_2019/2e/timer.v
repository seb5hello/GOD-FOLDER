`timescale 1ns / 1ps
module timer(clk,reset, trL, trS, tL, tS);
	input clk, reset, trL, trS;
	output tL, tS;
		  
	parameter svalue = 5;
	parameter lvalue = 10;
	
	reg [14:0] scount, lcount;
	reg strack, ltrack;
        
    always@(posedge clk)begin
        if(trS)begin
            strack = 1;
            scount = 0;
        end
        
        if(trL)begin
            lcount = 0;
            ltrack = 1;
        end
        
        if(tS)begin
            scount = 0;
            lcount = 0;
        end
        
        if(tL)begin
            scount = 0;
            lcount = 0;
        end
        
        if(reset)begin
            scount = 0;
            lcount = 0;
            strack = 0;
            ltrack = 0;
        end
        
            if(strack)begin
                scount = scount + 1;
            end
            if(ltrack)begin
                lcount = lcount + 1;
            end
        
    end
        
assign tS = (scount >= svalue);
assign tL = (lcount >= lvalue);
endmodule