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

parameter HEAD = 8'b0000_1111;
parameter TAIL = 8'b1111_0000;

reg[95:0] bbuf;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) bbuf <= 0;
	else if (ben) dbuf <= {bbuf[94:0], bin};

module manchester(
    input [15:0] din,
    output [7:0] dout
    );

wire[15:0] uid_m;
manchester huid_manchester(	.din(bbuf[23:8]),
										.dout(uid_m[7:0]));
manchester huid_manchester(	.din(bbuf[39:24]),
										.dout(uid_m[15:8]));
wire[7:0] zid_m;
manchester huid_manchester(	.din(bbuf[55:40]),
										.dout(zid_m));
wire[7:0] cnt_m;
manchester huid_manchester(	.din(bbuf[71:56]),
										.dout(cnt_m));
wire[7:0] type_m;
manchester huid_manchester(	.din(bbuf[87:72]),
										.dout(cnt_m));

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
		if ((bbuf[7:0] == HEAD) && (bbuf[95:88] == TAIL)) begin
			
		end
	end
end

assign uid = uid_r;
assign zid = zid_r;
assign cnt = cnt_r;
assign type = type_r;
assign drdy = drdy_r;

endmodule

