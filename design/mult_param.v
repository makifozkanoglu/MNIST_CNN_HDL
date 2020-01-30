`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2020 01:41:48 AM
// Design Name: 
// Module Name: mult_param
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


module mult_param #(parameter WIDTH = 8)(input [WIDTH-1:0]A,B,
             input clk,reset,start,
             output reg done,
             output reg [2*WIDTH-1:0] result);
             
     always@(posedge clk) begin
		if(reset) begin
			result <= 0;
		    done <= 0;
		end
		else begin
			if(start) begin
				result <= A*B;
				done <= 1;
			end
			else begin
				result <= 0;
				done <= 0;
			end
		end
	 end
endmodule
