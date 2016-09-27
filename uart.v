`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:39 09/26/2016 
// Design Name: 
// Module Name:    uart 
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
module uart(clk,rst_n,rs232_rx,rs232_tx,uart_ctrl,tx_in,rx_out,rx_over,tx_write);
input clk;	// 50MHz��ʱ��
input rst_n;	//�͵�ƽ��λ�ź�
input rs232_rx;	// RS232���������ź�
input[7:0] tx_in; //���ղ�������
input tx_write;   //���ղ�������ʹ���ź�
output rs232_tx;	//	RS232���������ź�
output[7:0] rx_out; //���մ������ݵĲ������
output rx_over;     //�������ݽ�������ź�
wire bps_start;	//���յ����ݺ󣬲�����ʱ�������ź���λ
wire clk_bps;		// clk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м������ 	
wire rx_int;	//���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ

//���Ͷ˲�����ѡ��ģ��
speed_select		speed_tx(	.clk(clk),
										.rst_n(rst_n),
										.bps_start(bps_start),
										.clk_bps(clk_bps),
										);

//���ն˲�����ѡ��ģ��
speed_select		speed_rx(	.clk(clk),
											.rst_n(rst_n),
											.bps_start(bps_start),
											.clk_bps(clk_bps),
											);

//��������ģ�飬rx_over�����ر�ʾ�������
uart_rx			uart_rx(		.clk(clk),
									.rst_n(rst_n),
									.rs232_rx(rs232_rx),
									.clk_bps(clk_bps),
									.bps_start(bps_start),
									.rx_data(rx_out),
									//.rx_int(rx_int),
									.rx_over(rx_over)																			
									);
											
//��������ģ�飬�����ش������Ͷ���
uart_tx			uart_tx(		.clk(clk),
									.rst_n(rst_n),
									.clk_bps(clk_bps),
									.rx_data(tx_in),
									.rx_int(~tx_write),
									.rs232_tx(rs232_tx),
									.bps_start(bps_start)
									);
endmodule
