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
input[2:0] uart_ctrl;//������ѡ��
input clk;	// 50MHz��ʱ��
input rst_n;	//�͵�ƽ��λ�ź�
input bps_start;	//���յ����ݺ󣬲�����ʱ�������ź���λ
output clk_bps;	// clk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м������ 

parameter 	bps9600 		= 5208,	//������Ϊ9600bps
			 	bps19200 	= 2604,	//������Ϊ19200bps
				bps38400 	= 1302,	//������Ϊ38400bps
				bps57600 	= 868,	//������Ϊ57600bps
				bps115200	= 434;	//������Ϊ115200bps 
 
parameter 	bps9600_2 	    = 2604,
				bps19200_2	= 1302,
				bps38400_2	= 651,
				bps57600_2	= 434,
				bps115200_2 = 217;  

reg[12:0] bps_para;	//��Ƶ�������ֵ
reg[12:0] bps_para_2;	//��Ƶ������һ��
reg[12:0] cnt;			//��Ƶ����
reg clk_bps_r;			//������ʱ�ӼĴ���

//----------------------------------------------------------
reg[2:0] uart_ctrl_r;	// uart������ѡ��Ĵ���
//----------------------------------------------------------

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin 
			uart_ctrl_r <= uart_ctrl;	//����������
		end
	else  begin
			case (uart_ctrl_r)	//����������
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
	else if(cnt<bps_para && bps_start) cnt <= cnt+1'b1;	//������ʱ�Ӽ�������
	else cnt <= 13'd0;

always @ (posedge clk or negedge rst_n)
	if(!rst_n) clk_bps_r <= 1'b0;
	else if(cnt==bps_para_2 && bps_start) clk_bps_r <= 1'b1;	// clk_bps_r�ߵ�ƽΪ���ջ��߷�������λ���м������ 
	else clk_bps_r <= 1'b0;

assign clk_bps = clk_bps_r;

endmodule
