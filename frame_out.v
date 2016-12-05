`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:51:55 10/12/2016 
// Design Name: 
// Module Name:    frame_out 
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
module frame_out(
    input clk,
	 input rst_n,
    input [15:0] uid,
    input [7:0] zid,
    input [7:0] cnt,
    input [7:0] type,
    input [7:0] rssi,
	 input den,
    output [7:0] dout,
    output drdy
    );

parameter HEAD = 8'hCA;
parameter TAIL = 8'hFE;

parameter O_DURTION = 6000;

reg trans_start;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) trans_start <= 0;
	else if (den) trans_start <= 1;
	else if (fcnt > 7) trans_start <= 0;

reg[63:0] frame_buf;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) frame_buf <= 0;
	else if (trans_start_pos) frame_buf[63:0] <= {HEAD[7:0], uid[15:0], zid[7:0], cnt[7:0], type[7:0], rssi[7:0], 8'hFE};
	//else if (trans_start_pos) frame_buf[63:0] <= {HEAD[7:0], 8'b0000_0001, 8'b0000_0011, 8'b0000_0111, 8'b0000_1111, 8'b0001_1111, 8'b0011_1111, TAIL[7:0]};
	//else if (den) frame_buf <= {HEAD, huid, luid, 8'b0000_0100, 8'b0000_1000, 8'b0001_0000, 8'b0010_0000, TAIL};
	//else if (den) frame_buf <= {HEAD, 8'b0000_0100, 8'b0000_1000, 8'b0001_0000, 8'b0010_0000,huid, luid,  TAIL};
	else if (ocnt == O_DURTION && trans_start == 1) frame_buf[63:0] <= {frame_buf[55:0], 8'd0};

reg trans_start_r;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) trans_start_r <= 0;
	else trans_start_r <= trans_start;

assign trans_start_pos = trans_start & (~trans_start_r);

reg[20:0] ocnt;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) ocnt <= 0;
	else if (trans_start_pos) ocnt <= 0;
	else if (trans_start == 1)begin
		if (ocnt < O_DURTION) ocnt <= ocnt + 1;
		else ocnt <= 0;
		end
	else ocnt <= 0;
	
reg[3:0] fcnt;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) fcnt <= 0;
	else if (trans_start_pos) fcnt <= 0;
	else if (trans_start == 1)begin
		if (ocnt == O_DURTION) fcnt <= fcnt + 1;
		end
	else fcnt <= 0;

reg[7:0] dout_r;
reg drdy_r;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		dout_r <= 0;
		drdy_r <= 1'b0;
	end
	else if (trans_start == 1 && ocnt == 50) begin
		dout_r <= frame_buf[63:56];
		drdy_r <= 1'b1;
	end
	else drdy_r <= 1'b0;
end

assign dout = dout_r;
assign drdy = drdy_r;

endmodule
