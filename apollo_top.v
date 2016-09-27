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
								.scode_rdy(scode_rdy)
								);

segment_driver segment(	.clk(clk),
								.rst_n(rst_n),
								.bin(scode),
								.refresh(scode_rdy),
								.Sftclk(Sftclk),
								.Lchclk(Lchclk),
								.SDout(SDout));

endmodule
