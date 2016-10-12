`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:49:03 05/13/2016 
// Design Name: 
// Module Name:    ad_driver 
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
module ad_driver(
    input clk,
    input rst_n,
    input[7:0] din,
    output clk_out,
	 output reg[7:0] dout,
    output ready
    );

reg[3:0] cnt;
always@(posedge clk or negedge rst_n)begin
	if (!rst_n)	cnt <= 4'd0;
	//else if (cnt == 15)	cnt <= 0;
	else	cnt <= cnt + 4'd1;
end

//posetive edge to sample
reg clk_r;
always@(posedge clk or negedge rst_n)begin
	if (!rst_n) begin
		clk_r <= 1'b0;
	end
	else begin
		if (cnt == 7)	clk_r <= 1'b1;
		else if (cnt == 15) clk_r <= 1'b0;
	end
end

reg rdy;
always@(posedge clk or negedge rst_n)begin
	if (!rst_n) begin
		dout <= 0;
		rdy <= 1'b0;
	end
	else begin
		if (cnt == 8'd10) begin
			dout <= din;
			rdy <= 1'b1;
		end
		else rdy <= 1'b0;
	end
end
assign ready = rdy;
assign clk_out = clk_r;
endmodule
