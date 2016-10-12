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

//��ͬ���źŵı�����
parameter BPS = 195_000;
parameter BPS_CNT = 50000000/2/BPS/8;
//parameter BPS_CNT = 256/16;


//�����˱���bps��ʱ�ӣ���bit_synchronizeģ��ʹ��
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

//����ͬ���ź�, sys_out���½��ؽ����о�
wire syn_out;
bit_synchronize bit_syn(.clk_high(clk_8th),
								.rst(rst_n),
								.ppmdata(din),
								.clk_low(syn_out));
							
//����һ��syn_out
reg syn_out_buf;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		syn_out_buf <=  1'b0;
	end
	else begin
		syn_out_buf <=  syn_out;
	end
end

//��ȡsyn_out���½��أ�������������Ч�ź�
wire syn_neg;
assign syn_neg = ~syn_out & syn_out_buf;

//��������źź����ʹ���ź�
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

