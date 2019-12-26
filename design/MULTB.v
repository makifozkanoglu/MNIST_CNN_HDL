`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Istanbul Technical University
// Engineer: Mehmet Akif Özkanoğlu
// 
// Create Date: 12/11/2019 06:35:41 PM
// Design Name: Behavioral Multiplication
// Module Name: MULTB
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


module MULTB(input [7:0]A,B,
             input clk,reset,start,
             output reg done,
             output reg [15:0] result);
             
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

