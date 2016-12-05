`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:31:01 10/11/2016 
// Design Name: 
// Module Name:    get_rssi 
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
module get_rssi(
	input clk,
   input rst_n,
   input [7:0] din,
   input den,
	input bin,
	input ben,
   output [7:0] dout,
   output drdy
   );

//-------------------------------------------
wire[7:0] d_delay;
delay32 delay(	.clk(clk),
				.ce(ben),
				.d(din),
				.q(d_delay));

parameter IDLE = 0;
parameter CAL = 1;
parameter OUT = 2;

//-----------------------------------------------
assign low = (~bin) & ben;

reg[1:0] lstate;
reg[15:0] lsum;
reg laver_rdy;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		lstate <= IDLE;
		lsum <= 0;
		laver_rdy <= 1'b0;
	end
	else begin
		case(lstate)
			IDLE: begin
				laver_rdy <= 1'b0;
				if (low) begin
					lsum <= lsum - d_delay;
					lstate <= CAL;
					end
				else lstate <= IDLE;
				end
			CAL: begin
				lsum <= lsum + din;
				lstate <= OUT;
				end
			OUT: begin
				laver_rdy <= 1'b1;
				lstate <= IDLE;
				end
		endcase
	end
end

wire[7:0] laver;
assign laver = lsum[13:6];
//-----------------------------------------------
assign high = bin & ben;

reg[1:0] hstate;
reg[15:0] hsum;
reg haver_rdy;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		hstate <= IDLE;
		hsum <= 0;
		haver_rdy <= 1'b0;
	end
	else begin
		case(hstate)
			IDLE: begin
				haver_rdy <= 1'b0;
				if (high) begin
					hsum <= hsum - d_delay;
					hstate <= CAL;
					end
				else hstate <= IDLE;
				end
			CAL: begin
				hsum <= hsum + din;
				hstate <= OUT;
				end
			OUT: begin
				haver_rdy <= 1'b1;
				hstate <= IDLE;
				end
		endcase
	end
end

wire[7:0] haver;
assign haver = hsum[13:0];
//----------------------------------------------
reg[7:0] llv;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) llv <= 0;
	else if(laver_rdy) llv <= laver;

reg[7:0] hlv;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) hlv <= 0;
	else if(haver_rdy) hlv <= haver;

//delay the average signal for one clk cycle
reg haver_rdy_r;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) haver_rdy_r <= 1'b0;
	else haver_rdy_r <= haver_rdy;

reg[7:0] rssi;
reg rssi_rdy;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		rssi <= 0;
		rssi_rdy <= 1'b0;
	end
	else if(haver_rdy_r) begin
		rssi <= hlv - llv;
		rssi_rdy <= 1'b1;
	end
	else rssi_rdy <= 1'b0;

//----------------------------------------------------
wire[7:0] rssi_delay;
delay_64 delay_64(	.clk(clk),
							.ce(rssi_rdy),
							.d(rssi),
							.q(rssi_delay));

reg[1:0] rstate;
reg[15:0] rsum;
reg rssi_aver_rdy;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		rstate <= IDLE;
		rsum <= 0;
		rssi_aver_rdy <= 1'b0;
	end
	else begin
		case(rstate)
			IDLE: begin
				rssi_aver_rdy <= 1'b0;
				if (rssi_rdy) begin
					rsum <= rsum - rssi_delay;
					rstate <= CAL;
					end
				else rstate <= IDLE;
				end
			CAL: begin
				rsum <= rsum + rssi;
				rstate <= OUT;
				end
			OUT: begin
				rssi_aver_rdy <= 1'b1;
				rstate <= IDLE;
				end
		endcase
	end
end

wire[7:0] rssi_aver;
assign rssi_aver = rsum[14:7];

assign dout = rssi_aver;
assign drdy = rssi_aver_rdy;

//------------------------------------------------

endmodule
