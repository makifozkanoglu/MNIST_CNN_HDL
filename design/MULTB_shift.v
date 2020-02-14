`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2020 10:28:14 PM
// Design Name: 
// Module Name: MULTB_shift
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module MULTB_shift(input signed [7:0] A,B,
                   input clk,reset,start,
                   output reg done,
                   output reg signed [14:0] result);
             
     always@(posedge clk) begin
		if(reset) begin
			result <= 0;
		    done <= 0;
		end
		else begin
			if(start) begin
				result <= (A*B)>>>8;
				done <= 1;
			end
			else begin
				result <= 0;
				done <= 0;
			end
		end
	 end
    
endmodule

