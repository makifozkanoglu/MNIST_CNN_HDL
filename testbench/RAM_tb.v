`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2019 01:58:25 PM
// Design Name: 
// Module Name: RAM_tb
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


module RAM_tb;
    /*
    ENTITY blk_mem_gen_2 IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END blk_mem_gen_2;
    */
    reg clock=1,en=1;
    wire [7:0]dout;
    reg [4:0] addr=5'd0;
    blk_mem_gen_2 uut(.clka(clock),.ena(en),.wea(1'b0),.addra(addr),.dina(),.douta(dout));
    always 
    begin
        clock=!clock;
        #10;
    end
    /*
    initial
    begin
        en<=1;
        clock<=0;
        addr<=5'd0;
        #100;
        en<=1;
        //addr<=5'd8;
    end
    */
    always #20 addr=addr+1; 

endmodule
