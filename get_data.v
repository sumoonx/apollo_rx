`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:37:57 10/11/2016 
// Design Name: 
// Module Name:    get_data 
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
module get_data(
	input clk,
   input rst_n,
	input bin,
	input ben,
   output [15:0] uid,
	output [7:0] zid,
	output [7:0] cnt,
	output [7:0] type,
   output drdy
   );

parameter HEAD = 4'b1100;
parameter TAIL = 4'b0011;

reg[87:0] bbuf;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) bbuf <= 0;
	else if (ben) bbuf <= {bbuf[86:0], bin};

wire[15:0] uid_m;
manchester huid_manchester(	.din(bbuf[83:68]),
										.dout(uid_m[15:8]));
manchester luid_manchester(	.din(bbuf[67:52]),
										.dout(uid_m[7:0]));
wire[7:0] zid_m;
manchester zid_manchester(	.din(bbuf[51:36]),
									.dout(zid_m));
wire[7:0] cnt_m;
manchester cnt_manchester(	.din(bbuf[19:4]),
									.dout(cnt_m));
wire[7:0] type_m;
manchester type_manchester(	.din(bbuf[35:20]),
										.dout(type_m));

reg[15:0] uid_r;
reg[7:0] zid_r;
reg[7:0] cnt_r;
reg[7:0] type_r;
reg drdy_r;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		uid_r <= 0;
		zid_r <= 0;
		cnt_r <= 0;
		type_r <= 0;
		drdy_r <= 0;
	end
	else if (ben) begin
		if ((bbuf[87:84] == HEAD) && (bbuf[3:0] == TAIL)) begin
			uid_r <= uid_m;
			zid_r <= zid_m;
			cnt_r <= cnt_m;
			type_r <= type_m;
			drdy_r <= 1'b1;
		end
	end 
	else drdy_r <= 1'b0;
end

assign uid = uid_r;
assign zid = zid_r;
assign cnt = cnt_r;
assign type = type_r;
assign drdy = drdy_r;

endmodule
