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
// Description: 		����ͨ��ģ�飬tx_write�����ش������ݷ��ͣ����ݽ������rx_over����һ����ʱ�����ڵĸߵ�ƽ
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module my_uart(clk,rst_n,rs232_rx,rs232_tx,tx_in,rx_out,rx_over,tx_write);
input clk;	// 50MHz��ʱ��
input rst_n;	//�͵�ƽ��λ�ź�
input rs232_rx;	// RS232���������ź�
input[7:0] tx_in; //���ղ�������
input tx_write;   //���ղ�������ʹ���ź�
output rs232_tx;	//	RS232���������ź�
output[7:0] rx_out; //���մ������ݵĲ������
output rx_over;     //�������ݽ�������ź�

wire bps_start_rx;	//���յ����ݺ󣬲�����ʱ�������ź���λ
wire clk_bps_rx;		// clk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м������ 	

//----------------------------------------------------
speed_select		speed_rx(	.clk(clk),	//������ѡ��ģ�飬���պͷ���ģ�鸴�ã���֧��ȫ˫��ͨ��
										.rst_n(rst_n),
										.bps_start(bps_start_rx),
										.clk_bps(clk_bps_rx),
										.uart_ctrl(3'd4)
										);

//��������ģ�飬rx_over�����ر�ʾ�������
uart_rx			uart_rx(		.clk(clk),
									.rst_n(rst_n),
									.rs232_rx(rs232_rx),
									.clk_bps(clk_bps_rx),
									.bps_start(bps_start_rx),
									.rx_data(rx_out),
									.rx_int(rx_over)
									//.rx_over(rx_over)
									);

wire bps_start_tx;	//���յ����ݺ󣬲�����ʱ�������ź���λ
wire clk_bps_tx;		// clk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м������ 	
//----------------------------------------------------
speed_select		speed_tx(	.clk(clk),	//������ѡ��ģ�飬���պͷ���ģ�鸴�ã���֧��ȫ˫��ͨ��
										.rst_n(rst_n),
										.bps_start(bps_start_tx),
										.clk_bps(clk_bps_tx),
										.uart_ctrl(3'd4)
										);

//��������ģ�飬�����ش������Ͷ���
uart_tx			uart_tx(		.clk(clk),
									.rst_n(rst_n),
									.clk_bps(clk_bps_tx),
									.rx_data(tx_in),
									.rx_int(~tx_write),
									.rs232_tx(rs232_tx),
									.bps_start(bps_start_tx)
									);

endmodule
