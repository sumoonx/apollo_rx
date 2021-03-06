`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:58:45 01/15/2016 
// Design Name: 
// Module Name:    speed_select 
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
module speed_select(clk,rst_n,bps_start,clk_bps,uart_ctrl);
input[2:0] uart_ctrl;//波特率选择
input clk;	// 50MHz主时钟
input rst_n;	//低电平复位信号
input bps_start;	//接收到数据后，波特率时钟启动信号置位
output clk_bps;	// clk_bps的高电平为接收或者发送数据位的中间采样点 

parameter 	bps9600 		= 5208,	//波特率为9600bps
			 	bps19200 	= 2604,	//波特率为19200bps
				bps38400 	= 1302,	//波特率为38400bps
				bps57600 	= 868,	//波特率为57600bps
				bps115200	= 434;	//波特率为115200bps 
 
parameter 	bps9600_2 	    = 2604,
				bps19200_2	= 1302,
				bps38400_2	= 651,
				bps57600_2	= 434,
				bps115200_2 = 217;  

reg[12:0] bps_para;	//分频计数最大值
reg[12:0] bps_para_2;	//分频计数的一半
reg[12:0] cnt;			//分频计数
reg clk_bps_r;			//波特率时钟寄存器

//----------------------------------------------------------
reg[2:0] uart_ctrl_r;	// uart波特率选择寄存器
//----------------------------------------------------------

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin 
			uart_ctrl_r <= uart_ctrl;	//波特率设置
		end
	else  begin
			case (uart_ctrl_r)	//波特率设置
				3'd0:	begin
						bps_para <= bps9600;
						bps_para_2 <= bps9600_2;
						end
				3'd1:	begin
						bps_para <= bps19200;
						bps_para_2 <= bps19200_2;
						end
				3'd2:	begin
						bps_para <= bps38400;
						bps_para_2 <= bps38400_2;
						end
				3'd3:	begin
						bps_para <= bps57600;
						bps_para_2 <= bps57600_2;
						end
				3'd4:	begin
						bps_para <= bps115200;
						bps_para_2 <= bps115200_2;
						end
				default:begin
				        bps_para <= bps9600;
						bps_para_2 <= bps9600_2;
						end
				endcase
		end
end

always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt <= 13'd0;
	else if(cnt<bps_para && bps_start) cnt <= cnt+1'b1;	//波特率时钟计数启动
	else cnt <= 13'd0;

always @ (posedge clk or negedge rst_n)
	if(!rst_n) clk_bps_r <= 1'b0;
	else if(cnt==bps_para_2 && bps_start) clk_bps_r <= 1'b1;	// clk_bps_r高电平为接收或者发送数据位的中间采样点 
	else clk_bps_r <= 1'b0;

assign clk_bps = clk_bps_r;

endmodule
