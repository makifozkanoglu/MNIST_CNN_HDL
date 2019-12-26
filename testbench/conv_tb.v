`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2019 09:23:25 PM
// Design Name: 
// Module Name: conv_tb
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


module conv_tb;
    reg reset, clk, start;

	reg [7:0]   Kernel_0, Kernel_1, Kernel_2, 
	            Kernel_3, Kernel_4, Kernel_5, 
	            Kernel_6, Kernel_7, Kernel_8, 
	            Kernel_9, Kernel_10, Kernel_11, 
	            Kernel_12, Kernel_13, Kernel_14, 
	            Kernel_15, Kernel_16, Kernel_17, 
	            Kernel_18, Kernel_19, Kernel_20;	
	            			
	reg [7:0]   X_0, X_1, X_2, X_3, 
	            X_4, X_5, X_6, X_7, 
	            X_8, X_9, X_10, X_11, 
	            X_12, X_13, X_14, X_15, 
	            X_16, X_17, X_18, X_19, 
	            X_20;
	            
	wire [24:0] result;
	
	wire done;
	
	conv uut(reset, clk, start,
	         Kernel_0, Kernel_1, Kernel_2, 
	         Kernel_3, Kernel_4, Kernel_5, 
	         Kernel_6, Kernel_7, Kernel_8, 
	         Kernel_9, Kernel_10, Kernel_11, 
	         Kernel_12, Kernel_13, Kernel_14, 
	         Kernel_15, Kernel_16, Kernel_17, 
	         Kernel_18, Kernel_19, Kernel_20,
	         X_0, X_1, X_2, X_3, 
	         X_4, X_5, X_6, X_7, 
	         X_8, X_9, X_10, X_11, 
	         X_12, X_13, X_14, X_15, 
	         X_16, X_17, X_18, X_19, 
	         X_20, result,done);
	         
	 initial 
	 begin
	   clk<=1;
	 end
	         
     always
     begin
        #20;
        clk = !clk;
     end   	         
     
endmodule
