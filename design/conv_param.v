`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2020 04:01:00 AM
// Design Name: 
// Module Name: conv_param
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


module conv_param #(parameter INWIDTH = 8, parameter OUTWIDTH = 25, parameter KERNEL_SIZE = 21, parameter KERNEL_SIZE_BIT = 5) (
    input reset, clk, start,

	input [KERNEL_SIZE*INWIDTH-1:0] KERNEL, 	
	            			
	input [KERNEL_SIZE*INWIDTH-1:0] X, 
	            
	output reg [OUTWIDTH-1:0] result,
	
	output reg done       
    );
    
    wire [KERNEL_SIZE-1:0] mult_done;
    
    wire [INWIDTH-1:0] kernel [KERNEL_SIZE-1:0];
    wire [INWIDTH-1:0] x [KERNEL_SIZE-1:0];
    wire [2*INWIDTH-1:0] multiplier_result [KERNEL_SIZE-1:0];
    wire [KERNEL_SIZE_BIT-1:0] COMPARE = {KERNEL_SIZE{1'b1}};
    
    wire [KERNEL_SIZE_BIT-1:0] column_comp = {KERNEL_SIZE{1'b0}};
    
    genvar i;
    integer j;
    
    assign column_comp = KERNEL_SIZE;
    
    for(i = 0; i < KERNEL_SIZE; i = i + 1) begin
        assign kernel[i] = KERNEL[(i+1)*INWIDTH-1:i*INWIDTH];
    end
    
    for(i = 0; i < KERNEL_SIZE; i = i + 1) begin
        assign x[i] = X[(i+1)*INWIDTH-1:i*INWIDTH];
    end

    generate
        for(i = 0; i < KERNEL_SIZE; i = i + 1) begin
            mult_param #(.WIDTH(INWIDTH)) mult(.A(x[i]),.B(kernel[i]),.result(multiplier_result[i]),.clk(clk),.reset(reset),.start(start),.done(mult_done[i]));
        end
    endgenerate
	
	reg [KERNEL_SIZE_BIT-1:0] counter;
	
    always@(posedge clk) begin
		if(reset) begin
			result <= 0;
		    done <= 0;
		    counter <= 0;
		end
		else begin
			if(start) begin
                if(counter==column_comp)
			    begin
			         counter <= 0;
                     result <= 0;
			         done <= 1;//0;
			    end
			    else 
			         done <= 0;
			    
			    if(mult_done==COMPARE & counter>0 ) 
			    begin
			       for(j = 0; j < KERNEL_SIZE; j = j + 1) begin
                       result = result + multiplier_result[j];
                   end
			       counter <= counter + 1;
			    end
			    else if(mult_done==COMPARE) 
			         counter <= counter + 1;
			end
			else begin
				result <= 0;
				done <= 0;
			end
		end
	 end
endmodule
