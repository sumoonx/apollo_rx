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

parameter IDLE = 0;
parameter CAL = 1;
parameter OUT = 2;

//-------------------------------------------
/*
wire[7:0] d_delay;
delay32 delay(	.clk(clk),
				.ce(ben),
				.d(din),
				.q(d_delay));
*/

reg[255:0] d_buf;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) d_buf <= 0;
	else if(den) d_buf <= {d_buf[247:0], din[7:0]};

wire[7:0] d_delay;
assign d_delay = d_buf[255:248];

//-----------------------------------------------
reg[1:0] state;
reg[15:0] sum;
reg aver_rdy;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state <= IDLE;
		sum <= 0;
		aver_rdy <= 1'b0;
	end
	else begin
		case(state)
			IDLE: begin
				aver_rdy <= 1'b0;
				if (den) begin
					sum <= sum - d_delay;
					state <= CAL;
					end
				else state <= IDLE;
				end
			CAL: begin
				sum <= sum + din;
				aver_rdy <= 1'b1;
				state <= IDLE;
				end
			OUT: begin
				state <= IDLE;
				end
			default: state <= IDLE;
		endcase
	end
end

reg[7:0] aver;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) aver <= 0;
	else if(aver_rdy) aver <= sum[13:6];

//----------------------------------------------
reg[7:0] llv;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) llv <= 0;
	else if(ben == 1 && bin == 0) llv <= aver;

reg[7:0] hlv;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) hlv <= 0;
	else if(ben == 1 && bin == 1) hlv <= aver;

//delay the average signal for one clk cycle
reg ben_r;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) ben_r <= 1'b0;
	else ben_r <= ben;

reg[7:0] rssi;
reg rssi_rdy;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		rssi <= 0;
		rssi_rdy <= 1'b0;
	end
	else if(ben_r && bin == 1) begin
		rssi <= hlv - llv;
		rssi_rdy <= 1'b1;
	end
	else rssi_rdy <= 1'b0;

//----------------------------------------------------
/*
wire[7:0] rssi_delay;
delay_64 delay_64(	.clk(clk),
							.ce(rssi_rdy),
							.d(rssi),
							.q(rssi_delay));
*/

reg[511:0] rssi_buf;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) rssi_buf <= 0;
	else if(rssi_rdy) rssi_buf <= {rssi_buf[503:0], rssi[7:0]};

wire[7:0] rssi_delay;
assign rssi_delay = rssi_buf[511:504];

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
				rssi_aver_rdy <= 1'b1;
				rstate <= IDLE;
				end
			OUT: begin
				rssi_aver_rdy <= 1'b1;
				rstate <= IDLE;
				end
			default: rstate <= IDLE;
		endcase
	end
end

wire[7:0] rssi_aver;
assign rssi_aver = rsum[14:7];

assign dout = rssi_aver;
assign drdy = rssi_aver_rdy;

//------------------------------------------------

endmodule
