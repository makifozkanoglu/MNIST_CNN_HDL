`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2019 03:36:35 AM
// Design Name: 
// Module Name: conv_TOP_tb
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


module conv_TOP_tb;
    reg clk, start,reset;
    wire done;
    conv_TOP uut(clk,start,reset,done);    
    always #10 clk=!clk;
    initial
    begin
        start<=0;
        clk<=0;
        reset<=1;
        #40;
        reset<=0;
        start<=1;
    end
endmodule
