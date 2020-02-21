`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2019 08:16:23 PM
// Design Name: 
// Module Name: conv_TOP
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


module conv_TOP(
    input clk, top_start,reset,
    output reg done,dense_flag,
    output reg [17:0] dense_in
    );

reg [71:0] result_0;

reg [4:0] column_count_in=0;
reg [4:0] row_count_in=0;
reg [4:0] column_count_ker=0;
reg [4:0] row_count_ker=0;
reg [13:0] addra=0;
reg signed [8:0] input_buff [27:0][27:0];
reg signed [8:0] kernel_buff [20:0][20:0];
wire signed [8:0] dout_in;
wire signed [8:0] dout_ker;
reg done_in=0;
reg done_ker=0; 
reg [5:0] kernel_counter=0; 

blk_mem_gen_1 ImageRAM(.clka(clk),.wea(1'b0),.addra(addra[9:0]),.dina(8'bZ),.douta(dout_in));
blk_mem_gen_0 KernelRAM(.clka(clk),.wea(1'b0),.addra(addra),.dina(8'bZ),.douta(dout_ker));


//////////////////////////////////////////
wire signed [8:0] bias_mem [0:31];
assign bias_mem[0]= -9'd29;
assign bias_mem[1]= -9'd64;
assign bias_mem[2]= -9'd99;
assign bias_mem[3]= -9'd40;
assign bias_mem[4]= -9'd167;
assign bias_mem[5]= -9'd113;
assign bias_mem[6]= -9'd249;
assign bias_mem[7]= -9'd129;
assign bias_mem[8]= -9'd129;
assign bias_mem[9]= -9'd128;
assign bias_mem[10]= -9'd105;
assign bias_mem[11]= -9'd178;
assign bias_mem[12]= -9'd140; 
assign bias_mem[13]= -9'd97;
assign bias_mem[14]= -9'd151;
assign bias_mem[15]= -9'd123;
assign bias_mem[16]= -9'd86;
assign bias_mem[17]= -9'd81;
assign bias_mem[18]= -9'd201;
assign bias_mem[19]= -9'd244; 
assign bias_mem[20]= -9'd70;
assign bias_mem[21]= -9'd10;
assign bias_mem[22]= -9'd176; 
assign bias_mem[23]= -9'd141;
assign bias_mem[24]= -9'd115;
assign bias_mem[25]= -9'd20;
assign bias_mem[26]= -9'd81; 
assign bias_mem[27]= -9'd87;
assign bias_mem[28]= -9'd108;
assign bias_mem[29]= -9'd119;
assign bias_mem[30]= -9'd159;
assign bias_mem[31]= -9'd196;
///////////////////////////////////////////

reg conv_start,conv_reset;

reg signed [8:0] Kernel_0, Kernel_1, Kernel_2, 
                 Kernel_3, Kernel_4, Kernel_5, 
                 Kernel_6, Kernel_7, Kernel_8, 
                 Kernel_9, Kernel_10, Kernel_11, 
                 Kernel_12, Kernel_13, Kernel_14, 
                 Kernel_15, Kernel_16, Kernel_17, 
                 Kernel_18, Kernel_19, Kernel_20;
	            			
reg signed [8:0] X_0, X_1, X_2, X_3, 
                 X_4, X_5, X_6, X_7, 
                 X_8, X_9, X_10, X_11, 
                 X_12, X_13, X_14, X_15, 
                 X_16, X_17, X_18, X_19, 
                 X_20;
	      
wire signed [26:0] conv_result;	      

wire conv_done;

conv conv_ins(conv_reset,clk,conv_start,
              Kernel_0,  Kernel_1,  Kernel_2, 
	          Kernel_3,  Kernel_4,  Kernel_5, 
	          Kernel_6,  Kernel_7,  Kernel_8, 
	          Kernel_9,  Kernel_10, Kernel_11, 
	          Kernel_12, Kernel_13, Kernel_14, 
	          Kernel_15, Kernel_16, Kernel_17, 
	          Kernel_18, Kernel_19, Kernel_20,
	          X_0,  X_1,  X_2,  X_3, 
	          X_4,  X_5,  X_6,  X_7, 
	          X_8,  X_9,  X_10, X_11, 
	          X_12, X_13, X_14, X_15, 
	          X_16, X_17, X_18, X_19, 
	          X_20,
	          conv_result,conv_done);

wire [71:0] pool_in;
assign pool_in=result_0; 
wire [17:0] pool_out;               
max_pool_72 pool_uut (clk,reset,pool_in,pool_out);

reg [3:0] state;
reg single_filter_done;
reg init;
reg [1:0] _wait;
integer i,j;

always@(posedge clk)
begin
    if(reset)
    begin
        //result_0<=0;
        dense_flag<=0;
        state<=0;
        conv_reset<=1;
        conv_start<=0;
        init<=0;
        _wait<=0;
        single_filter_done<=0;
        done<=0;
        kernel_counter<=0;
        column_count_in<=0;
        row_count_in<=0;
        column_count_ker<=0;
        row_count_ker<=0;
        addra<=0;//10'b1111111111;
        for(i=0;i<28;i=i+1)
        begin
            for(j=0;j<28;j=j+1)
            begin
                input_buff[i][j]<=0;
            end
        end
        for(i=0;i<21;i=i+1)
        begin
            for(j=0;j<21;j=j+1)
            begin
                kernel_buff[i][j]<=0;
            end
        end
        done_in<=0;
        done_ker<=0; 
    end
    else if(top_start) 
    begin
        case(state)
        4'd0://RAM deki 2 clock cycle gecikmeyi bekletmek için başlangıç statei
            begin
                if(init) 
                begin
                    state<=4'd1;
                    conv_reset<=0;
                end
                init<=init+1;
                addra<=addra+1;
            end
        4'd1://input ve ilk filtrenin ramdeki değerlerini ilgili buffera dolduruyor
            begin
                addra <= addra + 1;
                if(row_count_in==28 & column_count_in==0) 
                begin
                    done_in<=1;
                    done_ker<=0;
                    state<=4'd2;
                    //addra <= 13'd441;
                    conv_start<=1;
                    conv_reset<=0;
                    column_count_in<=0;
                    row_count_in<=0;
                    column_count_ker<=0;
                    row_count_ker<=0;
                end
                else 
                begin
                    input_buff[row_count_in][column_count_in]<=dout_in;
                    column_count_in = column_count_in + 1;
                    if(column_count_in==28) 
                    begin
                        column_count_in<=0;
                        row_count_in = row_count_in + 1;
                    end
                end
            
                if(row_count_ker==21 & column_count_ker==0) done_ker<=1;
                else 
                begin
                    kernel_buff[row_count_ker][column_count_ker]<=dout_ker;
                    column_count_ker <= column_count_ker + 1;
                    if(column_count_ker==20) 
                    begin
                        column_count_ker<=0;
                        row_count_ker <= row_count_ker + 1;
                    end
                end
            end
        4'd2:
        //bufferdaki ilgili değerleri sıra sıra çarpım yapacak modülün grişlerine atıyor
        //bu statete kernelin  inputun sol üst köşeine denk geldiği çarpma işlemlerini yapıyor
            begin
                if(conv_done) 
                begin
                    result_0[71:54]<=(conv_result+bias_mem[kernel_counter])>>>10;
                    conv_start<=0;
                    state<=4'd3;
                    conv_reset<=1;
                    row_count_in<=0;
                    row_count_ker<=0;
                end
                else
                begin
                    X_0<=input_buff[row_count_in][0];
                    X_1<=input_buff[row_count_in][1];
                    X_2<=input_buff[row_count_in][2];
                    X_3<=input_buff[row_count_in][3];
                    X_4<=input_buff[row_count_in][4];
                    X_5<=input_buff[row_count_in][5];
                    X_6<=input_buff[row_count_in][6];
                    X_7<=input_buff[row_count_in][7];
                    X_8<=input_buff[row_count_in][8];
                    X_9<=input_buff[row_count_in][9];
                    X_10<=input_buff[row_count_in][10];
                    X_11<=input_buff[row_count_in][11];
                    X_12<=input_buff[row_count_in][12];
                    X_13<=input_buff[row_count_in][13];
                    X_14<=input_buff[row_count_in][14];
                    X_15<=input_buff[row_count_in][15];
                    X_16<=input_buff[row_count_in][16];
                    X_17<=input_buff[row_count_in][17];
                    X_18<=input_buff[row_count_in][18];
                    X_19<=input_buff[row_count_in][19];
                    X_20<=input_buff[row_count_in][20];
                    row_count_in<=row_count_in+1;
                    
                    Kernel_0<=kernel_buff[row_count_ker][0];
                    Kernel_1<=kernel_buff[row_count_ker][1];
                    Kernel_2<=kernel_buff[row_count_ker][2];
                    Kernel_3<=kernel_buff[row_count_ker][3];
                    Kernel_4<=kernel_buff[row_count_ker][4];
                    Kernel_5<=kernel_buff[row_count_ker][5];
                    Kernel_6<=kernel_buff[row_count_ker][6];
                    Kernel_7<=kernel_buff[row_count_ker][7];
                    Kernel_8<=kernel_buff[row_count_ker][8];
                    Kernel_9<=kernel_buff[row_count_ker][9];
                    Kernel_10<=kernel_buff[row_count_ker][10];
                    Kernel_11<=kernel_buff[row_count_ker][11];
                    Kernel_12<=kernel_buff[row_count_ker][12];
                    Kernel_13<=kernel_buff[row_count_ker][13];
                    Kernel_14<=kernel_buff[row_count_ker][14];
                    Kernel_15<=kernel_buff[row_count_ker][15];
                    Kernel_16<=kernel_buff[row_count_ker][16];
                    Kernel_17<=kernel_buff[row_count_ker][17];
                    Kernel_18<=kernel_buff[row_count_ker][18];
                    Kernel_19<=kernel_buff[row_count_ker][19];
                    Kernel_20<=kernel_buff[row_count_ker][20];
                    row_count_ker<=row_count_ker+1;
                end
            end
        4'd3://convolution çarpımlarını yapan modülü yeniden başlatan state
            begin
                conv_reset<=0;
                conv_start<=1;
                state<=4'd4;
            end
        4'd4:
        //bu statete kernelin  inputun sağ üst köşeine denk geldiği çarpma işlemlerini yapıyor

            begin
                if(conv_done) 
                begin
                    result_0[53:36]<=(conv_result+bias_mem[kernel_counter])>>>10;
                    conv_start<=0;
                    state<=4'd5;
                    conv_reset<=1;
                    row_count_in<=0;
                    row_count_ker<=0;
                end
                else
                begin
                    X_0<=input_buff[row_count_in][7];
                    X_1<=input_buff[row_count_in][8];
                    X_2<=input_buff[row_count_in][9];
                    X_3<=input_buff[row_count_in][10];
                    X_4<=input_buff[row_count_in][11];
                    X_5<=input_buff[row_count_in][12];
                    X_6<=input_buff[row_count_in][13];
                    X_7<=input_buff[row_count_in][14];
                    X_8<=input_buff[row_count_in][15];
                    X_9<=input_buff[row_count_in][16];
                    X_10<=input_buff[row_count_in][17];
                    X_11<=input_buff[row_count_in][18];
                    X_12<=input_buff[row_count_in][19];
                    X_13<=input_buff[row_count_in][20];
                    X_14<=input_buff[row_count_in][21];
                    X_15<=input_buff[row_count_in][22];
                    X_16<=input_buff[row_count_in][23];
                    X_17<=input_buff[row_count_in][24];
                    X_18<=input_buff[row_count_in][25];
                    X_19<=input_buff[row_count_in][26];
                    X_20<=input_buff[row_count_in][27];
                    row_count_in<=row_count_in+1;
                    
                    Kernel_0<=kernel_buff[row_count_ker][0];
                    Kernel_1<=kernel_buff[row_count_ker][1];
                    Kernel_2<=kernel_buff[row_count_ker][2];
                    Kernel_3<=kernel_buff[row_count_ker][3];
                    Kernel_4<=kernel_buff[row_count_ker][4];
                    Kernel_5<=kernel_buff[row_count_ker][5];
                    Kernel_6<=kernel_buff[row_count_ker][6];
                    Kernel_7<=kernel_buff[row_count_ker][7];
                    Kernel_8<=kernel_buff[row_count_ker][8];
                    Kernel_9<=kernel_buff[row_count_ker][9];
                    Kernel_10<=kernel_buff[row_count_ker][10];
                    Kernel_11<=kernel_buff[row_count_ker][11];
                    Kernel_12<=kernel_buff[row_count_ker][12];
                    Kernel_13<=kernel_buff[row_count_ker][13];
                    Kernel_14<=kernel_buff[row_count_ker][14];
                    Kernel_15<=kernel_buff[row_count_ker][15];
                    Kernel_16<=kernel_buff[row_count_ker][16];
                    Kernel_17<=kernel_buff[row_count_ker][17];
                    Kernel_18<=kernel_buff[row_count_ker][18];
                    Kernel_19<=kernel_buff[row_count_ker][19];
                    Kernel_20<=kernel_buff[row_count_ker][20];
                    row_count_ker<=row_count_ker+1;
                end
            end
        4'd5://convolution çarpımlarını yapan modülü yeniden başlatan state
            begin
                conv_reset<=0;
                conv_start<=1;
                state<=4'd6;
            end
        4'd6:
        //bu statete kernelin  inputun sol alt köşeine denk geldiği çarpma işlemlerini yapıyor
            begin
                if(conv_done) 
                begin
                    result_0[35:18]<=(conv_result+bias_mem[kernel_counter])>>>10;
                    conv_start<=0;
                    state<=4'd7;
                    conv_reset<=1;
                    row_count_in<=7;
                    row_count_ker<=0;
                end
                else
                begin
                    X_0<=input_buff[row_count_in][0];
                    X_1<=input_buff[row_count_in][1];
                    X_2<=input_buff[row_count_in][2];
                    X_3<=input_buff[row_count_in][3];
                    X_4<=input_buff[row_count_in][4];
                    X_5<=input_buff[row_count_in][5];
                    X_6<=input_buff[row_count_in][6];
                    X_7<=input_buff[row_count_in][7];
                    X_8<=input_buff[row_count_in][8];
                    X_9<=input_buff[row_count_in][9];
                    X_10<=input_buff[row_count_in][10];
                    X_11<=input_buff[row_count_in][11];
                    X_12<=input_buff[row_count_in][12];
                    X_13<=input_buff[row_count_in][13];
                    X_14<=input_buff[row_count_in][14];
                    X_15<=input_buff[row_count_in][15];
                    X_16<=input_buff[row_count_in][16];
                    X_17<=input_buff[row_count_in][17];
                    X_18<=input_buff[row_count_in][18];
                    X_19<=input_buff[row_count_in][19];
                    X_20<=input_buff[row_count_in][20];
                    row_count_in<=row_count_in+1;
                    
                    Kernel_0<=kernel_buff[row_count_ker][0];
                    Kernel_1<=kernel_buff[row_count_ker][1];
                    Kernel_2<=kernel_buff[row_count_ker][2];
                    Kernel_3<=kernel_buff[row_count_ker][3];
                    Kernel_4<=kernel_buff[row_count_ker][4];
                    Kernel_5<=kernel_buff[row_count_ker][5];
                    Kernel_6<=kernel_buff[row_count_ker][6];
                    Kernel_7<=kernel_buff[row_count_ker][7];
                    Kernel_8<=kernel_buff[row_count_ker][8];
                    Kernel_9<=kernel_buff[row_count_ker][9];
                    Kernel_10<=kernel_buff[row_count_ker][10];
                    Kernel_11<=kernel_buff[row_count_ker][11];
                    Kernel_12<=kernel_buff[row_count_ker][12];
                    Kernel_13<=kernel_buff[row_count_ker][13];
                    Kernel_14<=kernel_buff[row_count_ker][14];
                    Kernel_15<=kernel_buff[row_count_ker][15];
                    Kernel_16<=kernel_buff[row_count_ker][16];
                    Kernel_17<=kernel_buff[row_count_ker][17];
                    Kernel_18<=kernel_buff[row_count_ker][18];
                    Kernel_19<=kernel_buff[row_count_ker][19];
                    Kernel_20<=kernel_buff[row_count_ker][20];
                    row_count_ker<=row_count_ker+1;
                end
            end
        4'd7:
            begin
                conv_reset<=0;
                conv_start<=1;
                state<=4'd8;
            end
        4'd8:
        //bu statete kernelin  inputun sağ alt köşeine denk geldiği çarpma işlemlerini yapıyor
            begin
                if(conv_done) 
                begin
                    single_filter_done<=1;
                    result_0[17:0]<=(conv_result+bias_mem[kernel_counter])>>>10;
                    conv_start<=0;
                    state<=4'd9;
                    conv_reset<=1;
                    row_count_in<=7;
                    row_count_ker<=0;
                    kernel_counter <= kernel_counter + 1;
                    //done<=1;//!!!!!!!!!!!!!
                end
                else
                begin
                    X_0<=input_buff[row_count_in][7];
                    X_1<=input_buff[row_count_in][8];
                    X_2<=input_buff[row_count_in][9];
                    X_3<=input_buff[row_count_in][10];
                    X_4<=input_buff[row_count_in][11];
                    X_5<=input_buff[row_count_in][12];
                    X_6<=input_buff[row_count_in][13];
                    X_7<=input_buff[row_count_in][14];
                    X_8<=input_buff[row_count_in][15];
                    X_9<=input_buff[row_count_in][16];
                    X_10<=input_buff[row_count_in][17];
                    X_11<=input_buff[row_count_in][18];
                    X_12<=input_buff[row_count_in][19];
                    X_13<=input_buff[row_count_in][20];
                    X_14<=input_buff[row_count_in][21];
                    X_15<=input_buff[row_count_in][22];
                    X_16<=input_buff[row_count_in][23];
                    X_17<=input_buff[row_count_in][24];
                    X_18<=input_buff[row_count_in][25];
                    X_19<=input_buff[row_count_in][26];
                    X_20<=input_buff[row_count_in][27];
                    row_count_in<=row_count_in+1;
                    
                    Kernel_0<=kernel_buff[row_count_ker][0];
                    Kernel_1<=kernel_buff[row_count_ker][1];
                    Kernel_2<=kernel_buff[row_count_ker][2];
                    Kernel_3<=kernel_buff[row_count_ker][3];
                    Kernel_4<=kernel_buff[row_count_ker][4];
                    Kernel_5<=kernel_buff[row_count_ker][5];
                    Kernel_6<=kernel_buff[row_count_ker][6];
                    Kernel_7<=kernel_buff[row_count_ker][7];
                    Kernel_8<=kernel_buff[row_count_ker][8];
                    Kernel_9<=kernel_buff[row_count_ker][9];
                    Kernel_10<=kernel_buff[row_count_ker][10];
                    Kernel_11<=kernel_buff[row_count_ker][11];
                    Kernel_12<=kernel_buff[row_count_ker][12];
                    Kernel_13<=kernel_buff[row_count_ker][13];
                    Kernel_14<=kernel_buff[row_count_ker][14];
                    Kernel_15<=kernel_buff[row_count_ker][15];
                    Kernel_16<=kernel_buff[row_count_ker][16];
                    Kernel_17<=kernel_buff[row_count_ker][17];
                    Kernel_18<=kernel_buff[row_count_ker][18];
                    Kernel_19<=kernel_buff[row_count_ker][19];
                    Kernel_20<=kernel_buff[row_count_ker][20];
                    row_count_ker<=row_count_ker+1;
                end
            end
        4'd9:
            begin
                
                //done<=1;
                //conv_reset<=0;
                if (_wait==2'd0) 
                begin
                    single_filter_done<=0;
                    addra<=kernel_counter*441;
                    _wait<=_wait+1;
                end
                else if (_wait==2'd1)
                    begin
                        dense_in<=pool_out;
                        dense_flag<=1;
                        addra <= addra + 1;
                        _wait<=_wait+1;
                    end
                else if (_wait==2'd2)
                    begin
                        dense_flag<=0;
                        addra <= addra + 1;
                        _wait<=2'd0;
                        state <= 4'd10;
                    end
                
                if (kernel_counter==32) //Number of Filters  = 32
                begin
                    done <= 1;
                    state <= 4'd11;
                end
            end
        4'd10:
            begin
            /////////////////////////////////////////////////////////////////////////
                addra <= addra + 1;
                if(row_count_ker==21 & column_count_ker==0) 
                begin
                    done_ker<=1;
                    state<=4'd2;
                    conv_start<=1;
                    conv_reset<=0;
                    //column_count_in<=0;
                    //row_count_in<=0;
                    column_count_ker<=0;
                    row_count_ker<=0;
                end
                else 
                begin
                    kernel_buff[row_count_ker][column_count_ker]<=dout_ker;
                    column_count_ker <= column_count_ker + 1;
                    if(column_count_ker==20) 
                    begin
                        column_count_ker<=0;
                        row_count_ker <= row_count_ker + 1;
                    end
                end
            /////////////////////////////////////////////////////////////////////////
            end
         4'd11:
            //////////////////////////////
            //////////LAST STATE//////////
            //////////////////////////////
            begin
                conv_reset<=1;
                done<=0;
            end
        endcase
    end
end
endmodule
