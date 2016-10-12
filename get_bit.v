`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:27:03 05/20/2016 
// Design Name: 
// Module Name:    get_bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module get_bit(
    input clk,
    input rst_n,
    input din,
    output reg dout,
    output reg drdy
    );

//待同步信号的比特率
parameter BPS = 195_000;
parameter BPS_CNT = 50000000/2/BPS/8;
//parameter BPS_CNT = 256/16;


//产生八倍于bps的时钟，供bit_synchronize模块使用
reg clk_8th;		
reg[21:0] cnt;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			clk_8th <= 1'b0;
			cnt <= 22'd0;
		end
	else begin
		if(cnt == BPS_CNT)	begin
			clk_8th <= ~clk_8th;
			cnt <= 22'd0;
		end
		else begin
			cnt <= cnt + 22'd1;
		end
	end
end

//产生同步信号, sys_out的下降沿进行判决
wire syn_out;
bit_synchronize bit_syn(.clk_high(clk_8th),
								.rst(rst_n),
								.ppmdata(din),
								.clk_low(syn_out));
							
//缓存一次syn_out
reg syn_out_buf;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		syn_out_buf <=  1'b0;
	end
	else begin
		syn_out_buf <=  syn_out;
	end
end

//获取syn_out的下降沿，生成上升沿有效信号
wire syn_neg;
assign syn_neg = ~syn_out & syn_out_buf;

//产生输出信号和输出使能信号
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		dout <= 1'b0;
		drdy <= 1'b0;
	end
	else begin
		if(syn_neg) begin
			dout <= din;
			drdy <= 1'b1;
		end
		else begin
			drdy <= 1'b0;
		end
	end
end

endmodule

