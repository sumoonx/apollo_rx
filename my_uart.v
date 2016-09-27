`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:01:03 01/15/2016 
// Design Name: 
// Module Name:    uart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 		串口通信模块，tx_write上升沿触发数据发送，数据接收完毕rx_over产生一个主时钟周期的高电平
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module my_uart(clk,rst_n,rs232_rx,rs232_tx,tx_in,rx_out,rx_over,tx_write);
input clk;	// 50MHz主时钟
input rst_n;	//低电平复位信号
input rs232_rx;	// RS232接收数据信号
input[7:0] tx_in; //接收并行数据
input tx_write;   //接收并行数据使能信号
output rs232_tx;	//	RS232发送数据信号
output[7:0] rx_out; //接收串行数据的并行输出
output rx_over;     //串行数据接收完毕信号

wire bps_start_rx;	//接收到数据后，波特率时钟启动信号置位
wire clk_bps_rx;		// clk_bps的高电平为接收或者发送数据位的中间采样点 	

//----------------------------------------------------
speed_select		speed_rx(	.clk(clk),	//波特率选择模块，接收和发送模块复用，不支持全双工通信
										.rst_n(rst_n),
										.bps_start(bps_start_rx),
										.clk_bps(clk_bps_rx),
										.uart_ctrl(3'd4)
										);

//接收数据模块，rx_over上升沿表示传输结束
uart_rx			uart_rx(		.clk(clk),
									.rst_n(rst_n),
									.rs232_rx(rs232_rx),
									.clk_bps(clk_bps_rx),
									.bps_start(bps_start_rx),
									.rx_data(rx_out),
									.rx_int(rx_over)
									//.rx_over(rx_over)
									);

wire bps_start_tx;	//接收到数据后，波特率时钟启动信号置位
wire clk_bps_tx;		// clk_bps的高电平为接收或者发送数据位的中间采样点 	
//----------------------------------------------------
speed_select		speed_tx(	.clk(clk),	//波特率选择模块，接收和发送模块复用，不支持全双工通信
										.rst_n(rst_n),
										.bps_start(bps_start_tx),
										.clk_bps(clk_bps_tx),
										.uart_ctrl(3'd4)
										);

//发送数据模块，上升沿触发发送动作
uart_tx			uart_tx(		.clk(clk),
									.rst_n(rst_n),
									.clk_bps(clk_bps_tx),
									.rx_data(tx_in),
									.rx_int(~tx_write),
									.rs232_tx(rs232_tx),
									.bps_start(bps_start_tx)
									);

endmodule
