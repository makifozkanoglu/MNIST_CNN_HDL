`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2019 08:00:39 PM
// Design Name: 
// Module Name: conv
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


module conv(
    input reset, clk, start,

	input signed [8:0] Kernel_0, Kernel_1, Kernel_2, 
                       Kernel_3, Kernel_4, Kernel_5, 
                       Kernel_6, Kernel_7, Kernel_8, 
                       Kernel_9, Kernel_10, Kernel_11, 
                       Kernel_12, Kernel_13, Kernel_14, 
                       Kernel_15, Kernel_16, Kernel_17, 
                       Kernel_18, Kernel_19, Kernel_20, 	
	            			
	input signed [8:0] X_0, X_1, X_2, X_3, 
	                   X_4, X_5, X_6, X_7, 
	                   X_8, X_9, X_10, X_11, 
	                   X_12, X_13, X_14, X_15, 
	                   X_16, X_17, X_18, X_19, 
	                   X_20, 
	            
	output reg signed [25:0] result,
	
	output reg done       
    );
    
    wire [20:0] mult_done;
    
    
    wire signed [16:0] multiplier_result0, multiplier_result1, multiplier_result2, multiplier_result3, multiplier_result4, 
				       multiplier_result5, multiplier_result6, multiplier_result7, multiplier_result8, multiplier_result9, 
				       multiplier_result10, multiplier_result11, multiplier_result12, multiplier_result13, multiplier_result14, 
				       multiplier_result15, multiplier_result16, multiplier_result17, multiplier_result18, multiplier_result19, 
				       multiplier_result20;
				
    
    MULTB mult0(.A(X_0),.B(Kernel_0),.result(multiplier_result0),.clk(clk),.reset(reset),.start(start),.done(mult_done[0])); 
	MULTB mult1(.A(X_1),.B(Kernel_1),.result(multiplier_result1),.clk(clk),.reset(reset),.start(start),.done(mult_done[1])); 
	MULTB mult2(.A(X_2),.B(Kernel_2),.result(multiplier_result2),.clk(clk),.reset(reset),.start(start),.done(mult_done[2])); 
	MULTB mult3(.A(X_3),.B(Kernel_3),.result(multiplier_result3),.clk(clk),.reset(reset),.start(start),.done(mult_done[3])); 
	MULTB mult4(.A(X_4),.B(Kernel_4),.result(multiplier_result4),.clk(clk),.reset(reset),.start(start),.done(mult_done[4])); 
	MULTB mult5(.A(X_5),.B(Kernel_5),.result(multiplier_result5),.clk(clk),.reset(reset),.start(start),.done(mult_done[5])); 
	MULTB mult6(.A(X_6),.B(Kernel_6),.result(multiplier_result6),.clk(clk),.reset(reset),.start(start),.done(mult_done[6])); 
	MULTB mult7(.A(X_7),.B(Kernel_7),.result(multiplier_result7),.clk(clk),.reset(reset),.start(start),.done(mult_done[7])); 
	MULTB mult8(.A(X_8),.B(Kernel_8),.result(multiplier_result8),.clk(clk),.reset(reset),.start(start),.done(mult_done[8])); 
	MULTB mult9(.A(X_9),.B(Kernel_9),.result(multiplier_result9),.clk(clk),.reset(reset),.start(start),.done(mult_done[9])); 
	MULTB mult10(.A(X_10),.B(Kernel_10),.result(multiplier_result10),.clk(clk),.reset(reset),.start(start),.done(mult_done[10])); 
	MULTB mult11(.A(X_11),.B(Kernel_11),.result(multiplier_result11),.clk(clk),.reset(reset),.start(start),.done(mult_done[11])); 
	MULTB mult12(.A(X_12),.B(Kernel_12),.result(multiplier_result12),.clk(clk),.reset(reset),.start(start),.done(mult_done[12])); 
	MULTB mult13(.A(X_13),.B(Kernel_13),.result(multiplier_result13),.clk(clk),.reset(reset),.start(start),.done(mult_done[13])); 
	MULTB mult14(.A(X_14),.B(Kernel_14),.result(multiplier_result14),.clk(clk),.reset(reset),.start(start),.done(mult_done[14])); 
	MULTB mult15(.A(X_15),.B(Kernel_15),.result(multiplier_result15),.clk(clk),.reset(reset),.start(start),.done(mult_done[15])); 
	MULTB mult16(.A(X_16),.B(Kernel_16),.result(multiplier_result16),.clk(clk),.reset(reset),.start(start),.done(mult_done[16])); 
	MULTB mult17(.A(X_17),.B(Kernel_17),.result(multiplier_result17),.clk(clk),.reset(reset),.start(start),.done(mult_done[17])); 
	MULTB mult18(.A(X_18),.B(Kernel_18),.result(multiplier_result18),.clk(clk),.reset(reset),.start(start),.done(mult_done[18])); 
	MULTB mult19(.A(X_19),.B(Kernel_19),.result(multiplier_result19),.clk(clk),.reset(reset),.start(start),.done(mult_done[19])); 
	MULTB mult20(.A(X_20),.B(Kernel_20),.result(multiplier_result20),.clk(clk),.reset(reset),.start(start),.done(mult_done[20])); 
	
	reg [4:0] counter;
	
    always@(posedge clk) begin
		if(reset) begin
			result <= 0;
		    done <= 0;
		    counter <= 0;
		end
		else begin
			if(start) begin
			    
			     
			   
			    if(mult_done==21'b111111111111111111111 & counter>0 ) 
			    begin
			         result<=result
			                 +multiplier_result0 +multiplier_result1 +multiplier_result2 +multiplier_result3
			                 +multiplier_result4 +multiplier_result5 +multiplier_result6 +multiplier_result7
			                 +multiplier_result8 +multiplier_result9 +multiplier_result10+multiplier_result11
			                 +multiplier_result12+multiplier_result13+multiplier_result14+multiplier_result15
			                 +multiplier_result16+multiplier_result17+multiplier_result18+multiplier_result19
			                 +multiplier_result20;
			         counter <= counter + 1;
			         //done <= 0;
			    end
			    else if(mult_done==21'b111111111111111111111) 
			         counter <= counter + 1;
			    
			    if(counter==5'd20)
			         done <= 1;
			    else if(counter==5'd21) //üzerine düşünmem gerekiyor
			    begin
			         counter <= 0;
                     result <= 0;
			         done <= 0;
			    end
			    else 
			         done <= 0;
			    
			end
			else begin
				result <= 0;
				done <= 0;
			end
		end
	 end
	 
endmodule
