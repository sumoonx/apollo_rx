`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:18:46 05/10/2016 
// Design Name: 
// Module Name:    segment_driver 
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
module segment_driver(
    input clk,
    input rst_n,
	 input refresh,
	 input[9:0] bin,
	 output Sftclk,
	 output Lchclk,
	 output SDout
    );

wire[15:0] bcd_out;
binary2bcd my_binary2bcd(	.clk(clk),
									.rst_n(rst_n),
									.state_en(1'b1),
									.refresh(refresh),
									.binary(bin),
									.BCD(bcd_out));

display dpy_rssi(	.clk(clk),
						.rst_n(rst_n),
						.Dpy0(bcd_out[3:0]),
						.Dpy1(bcd_out[7:4]),
						.Dpy2(bcd_out[11:8]),
						.Dpy3(bcd_out[15:12]),
						.Sftclk(Sftclk),
						.Lchclk(Lchclk),
						.SDout(SDout));
endmodule
