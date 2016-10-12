`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:59:50 09/26/2016 
// Design Name: 
// Module Name:    apollo_top 
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
module apollo_top(
	input clk,
   input rst_n,
	input rs232_rx,	// RS232接收数据信号
	output rs232_tx,	//	RS232发送数据信号
	input[7:0] in_ad_data,
	output out_ad_clk,
	output Sftclk,
	output Lchclk,
	output SDout
    );

wire[7:0] tx_in;
wire tx_write;
wire[7:0] rx_out;
wire rx_over;
my_uart	uart(	.clk(clk),
					.rst_n(rst_n),
					.rs232_rx(rs232_rx),
					.rs232_tx(rs232_tx),
					.tx_in(tx_in),
					.tx_write(tx_write),
					.rx_out(rx_out),
					.rx_over(rx_over)
					);

wire[7:0] recv_in;
wire recv_write;
wire recv_clk;
wire recv_rst;

wire [7:0] scode;
wire scode_rdy;
wire [7:0] level;
controller controller(	.clk(clk),
								.rst_n(rst_n),
								.rx_out(rx_out),
								.rx_over(rx_over),
								.recv_in(recv_in),
								.recv_write(recv_write),
								.tx_in(tx_in),
								.tx_write(tx_write),
								.recv_clk(recv_clk),
								.recv_rst(recv_rst),
								.scode(scode),
								.scode_rdy(scode_rdy),
								.level(level)
								);

segment_driver segment(	.clk(clk),
								.rst_n(rst_n),
								.bin(scode),
								.refresh(scode_rdy),
								.Sftclk(Sftclk),
								.Lchclk(Lchclk),
								.SDout(SDout));

wire[7:0] ad_data_in;
wire ad_data_rdy;
ad_driver ad_driver(	.clk(recv_clk),
							.rst_n(recv_rst),
							.din(in_ad_data),
							.clk_out(out_ad_clk),
							.dout(ad_data_in),
							.ready(ad_data_rdy));

receiver receiver(	.clk(recv_clk),
							.rst_n(recv_rst),
							.level(level),
							.din(ad_data_in),
							.den(ad_data_rdy),
							.dout(recv_in),
							.drdy(recv_write));
endmodule
