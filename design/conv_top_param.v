`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2020 01:45:19 AM
// Design Name: 
// Module Name: conv_top_param
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


module conv_top_param #(parameter INPUT_DIM = 28,
                        parameter ADDRESS_WIDTH = 10,
                        parameter INPUT_DIM_BIT = 5,
                        parameter INBITWIDTH = 8, 
                        parameter OUTBITWIDTH = 25, 
                        parameter KERNEL_SIZE = 21,
                        parameter KERNEL_SIZE_BIT = 5,
                        parameter STRIDE = 7,
                        parameter STEP = (INPUT_DIM - KERNEL_SIZE)/STRIDE,
                        parameter STATE_BIT_WIDTH = 4,
                        parameter OUTPUT_DIM = ((INPUT_DIM - KERNEL_SIZE) + 0) / STRIDE + 1,
                        parameter STATE_COUNT = 2 + STEP**2) (
    input clk, top_start,reset,
    output reg done,
    output reg [OUTPUT_DIM*OUTPUT_DIM*OUTBITWIDTH-1:0] result);

    reg [INPUT_DIM_BIT-1:0] column_count_in = 0;
    reg [INPUT_DIM_BIT-1:0] row_count_in = 0;
    reg [KERNEL_SIZE_BIT-1:0] column_count_ker = 0;
    reg [KERNEL_SIZE_BIT-1:0] row_count_ker = 0;
    reg [ADDRESS_WIDTH-1:0] addra = 0;
    reg [INBITWIDTH-1:0] input_buff [INPUT_DIM-1:0][INPUT_DIM-1:0];
    reg [INBITWIDTH-1:0] kernel_buff [KERNEL_SIZE-1:0][KERNEL_SIZE-1:0];
    wire [INBITWIDTH-1:0] dout_in;
    wire [INBITWIDTH-1:0] dout_ker;
    reg done_in = 0;
    reg done_ker = 0; 
    reg finish = 1'b0;
 
    blk_mem_gen_1 ImageRAM(.clka(clk),.wea(1'b0),.addra(addra),.dina(8'bZ),.douta(dout_in));
    blk_mem_gen_0 KernelRAM(.clka(clk),.wea(1'b0),.addra(addra[8:0]),.dina(8'bZ),.douta(dout_ker));

    reg conv_start, conv_reset;
    
    wire [KERNEL_SIZE*INBITWIDTH-1:0] KERNEL; 		            			
	wire [KERNEL_SIZE*INBITWIDTH-1:0] X;
    
    reg [INBITWIDTH-1:0] kernel_reg [KERNEL_SIZE-1:0];
    reg [INBITWIDTH-1:0] x_reg [KERNEL_SIZE-1:0];
    
    genvar k;
    
    for(k = 0; k < KERNEL_SIZE; k = k + 1) begin
        assign KERNEL[(k+1)*INBITWIDTH-1:k*INBITWIDTH] = kernel_reg[k];
    end
    
    for(k = 0; k < KERNEL_SIZE; k = k + 1) begin
        assign X[(k+1)*INBITWIDTH-1:k*INBITWIDTH] = x_reg[k];
    end
	      
    wire [OUTBITWIDTH-1:0] conv_result;	      

    wire conv_done;

    conv_param conv_ins(conv_reset, clk, conv_start,
                        KERNEL, X, conv_result, conv_done);
                

    reg [STATE_BIT_WIDTH-1:0]state;
    reg init;
    integer i,j;
    integer state_count = STATE_COUNT;

    always@(posedge clk)    
    begin
        if(reset)
        begin
            result <= 0;
            state <= 0;
            conv_reset <= 1;
            conv_start <= 0;
            init <= 0;
            done <= 0;
            finish <= 0;
            column_count_in <= 0;
            row_count_in <= 0;
            column_count_ker <= 0;
            row_count_ker <= 0;
            addra <= 0;
            for(i = 0; i < INPUT_DIM; i = i + 1)
            begin
                for(j = 0; j < INPUT_DIM; j = j + 1)
                begin
                    input_buff[i][j] <= 0;
                end
            end
            for(i = 0; i < KERNEL_SIZE; i = i + 1)
            begin
                for(j = 0; j < KERNEL_SIZE; j = j + 1)
                begin
                    kernel_buff[i][j] <= 0;
                end
            end
            done_in <= 0;
            done_ker <= 0; 
        end
        else if(top_start) 
        begin
            if(state == {STATE_BIT_WIDTH{1'b0}}) 
            begin
                if(init) 
                begin
                    state <= state + 1;
                    conv_reset <= 0;
                end
                init<=init+1;
                addra<=addra+1;
            end
            else if(state == {{(STATE_BIT_WIDTH-1){1'b0}},1'b1})
            begin
                addra <= addra + 1;
                if(row_count_in==INPUT_DIM & column_count_in==0) 
                begin
                    done_in <= 1;
                    state <= state + 1;
                    conv_start <= 1;
                    conv_reset <= 0;
                    column_count_in <= 0;
                    row_count_in <= 0;
                    column_count_ker <= 0;
                    row_count_ker <= 0;
                end
                else 
                begin
                    input_buff[row_count_in][column_count_in] <= dout_in;
                    column_count_in = column_count_in + 1;
                    if(column_count_in == INPUT_DIM) 
                    begin
                        column_count_in <= 0;
                        row_count_in = row_count_in + 1;
                    end
                end
                if(row_count_ker == KERNEL_SIZE & column_count_ker == 0) done_ker <= 1;
                else 
                begin
                    kernel_buff[row_count_ker][column_count_ker] <= dout_ker;
                    column_count_ker = column_count_ker + 1;
                    if(column_count_ker == KERNEL_SIZE) 
                    begin
                        column_count_ker <= 0;
                        row_count_ker <= row_count_ker + 1;
                    end
                end
            end
            else if(state[0] == 1'b0  && (finish == 1'b0))
            begin
                if(conv_done) 
                begin
                    result[OUTPUT_DIM*OUTPUT_DIM*OUTBITWIDTH-1-(((row_count_in*OUTPUT_DIM+column_count_in)/STRIDE)*OUTBITWIDTH)+:OUTBITWIDTH] <= conv_result;
                    conv_start <= 0;
                    state <= state + 1;
                    conv_reset <= 1;
                    row_count_ker <= 0;
                    if (column_count_in + STRIDE < INPUT_DIM)
                    begin
                        column_count_in = column_count_in + STRIDE;
                    end
                    else if (row_count_in + STRIDE < INPUT_DIM)
                    begin
                        column_count_in = 0;
                        row_count_in = row_count_in + STRIDE;
                    end
                    else
                    begin
                        row_count_in = 0;
                        column_count_in = 0;
                        finish = 1'b1;
                    end
                end
                else
                begin
                    for(i = 0; i < KERNEL_SIZE; i = i + 1) begin
                       x_reg[i] = input_buff[row_count_in][i+column_count_in];
                    end
                    row_count_in <= row_count_in + 1;
                    
                    for(i = 0; i < KERNEL_SIZE; i = i + 1) begin
                       kernel_reg[i] = kernel_buff[row_count_ker][i];
                    end
                    row_count_ker <= row_count_ker+1;
                end 
            end
            else if((state[0] == 1'b1) && (finish == 1'b0))
            begin
                conv_reset <= 0;
                conv_start <= 1;
                state <= state + 1;
            end
            else
            begin
                done <= 1;
                conv_reset <= 0;
            end
        end
    end
endmodule
