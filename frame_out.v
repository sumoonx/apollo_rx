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

reg[63:0] frame_buf;

always @ (posedge clk or negedge rst_n)
	if(!rst_n) frame_buf <= 0;
	else if (den) frame_buf <= {HEAD, uid, zid, cnt, type, rssi, TAIL};
	else if (ocnt == 3300 && fcnt != 0) frame_buf <= {frame_buf[55:0], 8'd0};

reg[11:0] ocnt;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) ocnt <= 0;
	else if (den || ocnt == 0) ocnt <= 3300;
	else if (ocnt != 0) ocnt <= ocnt - 1;

reg[3:0] fcnt;
reg[7:0] dout_r;
reg drdy_r;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		fcnt <= 0;
		dout_r <= 0;
		drdy_r <= 1'b0;
	end
	else if (den) begin
		fcnt <= 8;
		dout_r <= 0;
		drdy_r <= 1'b0;
	end
	else if (ocnt == 3300 && fcnt != 0) begin
		dout_r <= frame_buf[63:56];
		drdy_r <= 1'b1;
	end
	else if (ocnt == 0 && fcnt != 0) begin
		fcnt <= fcnt - 1;
		drdy_r <= 1'b0;
	end
end

assign dout = dout_r;
assign drdy = drdy_r;
endmodule
