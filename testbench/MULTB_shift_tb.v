`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2020 12:45:54 AM
// Design Name: 
// Module Name: MULTB_shift_tb
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


module MULTB_shift_tb;
    reg signed [7:0] A,B;
    reg clk, reset, start;
    wire done;
    wire signed [6:0] result;
    MULTB_shift uut(A,B,clk,reset,start,done,result);    
    always #10 clk=!clk;
    initial
    begin
        start<=0;
        clk<=0;
        reset<=1;
        #40;
        reset<=0;
        start<=1;
        #10;
        A<= 8'd127;
        B<= 8'd127;
        #40;
        A<=-8'd127;
        B<=-8'd127;
        #40;
        A<=-8'd10;
        B<= 8'd11;
        #40;
        A<=-8'd55;
        B<= 8'd33;
        #40;
    end
endmodule
