`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:01:30 10/08/2016 
// Design Name: 
// Module Name:    receiver 
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
module receiver(
    input clk,
    input rst_n,
	 input [7:0] level,
    input [7:0] din,
    input den,
    output [7:0] dout,
    output drdy
    );

parameter IDLE = 0;
parameter CAL = 1;
parameter OUT = 2;

//------------------------------------------
assign bdata = (din > level) ? 1'b1 : 1'b0;

wire bout;
wire brdy;
get_bit get_bit(	.clk(clk),
				.rst_n(rst_n),
				.din(bdata),
				.dout(bout),
				.drdy(brdy));

get_rssi get_rssi(	.clk(clk),
							.rst_n(rst_n),
							.din(din),
							.den(den),
							.bin(bout),
							.ben(brdy),
							.dout(rssi),
							.drdy(rssi_rdy));

//------------------------------------------
wire[15:0] uid;
wire[7:0] zid;
wire[7:0] cnt;
wire[7:0] type;
wire data_rdy;

get_data get_data(	.clk(clk),
							.rst_n(rst_n),
							.bin(bout),
							.ben(brdy),
							.uid(uid),
							.zid(zid),
							.cnt(cnt),
							.type(type),
							.drdy(data_rdy));

//-------------------------------------------
reg[8:0] data_rdy_r;
always @ (posedge clk or negedge rst_n)
	if (!rst_n) data_rdy_r <= 0;
	else data_rdy_r <= {data_rdy_r[7:0], data_rdy};

frame_out frame_out(	.clk(clk),
							.rst_n(rst_n),
							.uid(uid),
							.zid(zid),
							.cnt(cnt),
							.type(type),
							.rssi(rssi),
							.den(data_rdy_r[8]),
							.dout(dout),
							.drdy(drdy));				

endmodule
