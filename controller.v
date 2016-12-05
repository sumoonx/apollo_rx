`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:54:41 09/26/2016 
// Design Name: 
// Module Name:    controller 
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
module controller(
    input clk,
    input rst_n,
    input [7:0] rx_out,		//get data from the uart/serial
    input rx_over,			//date ready from the uart/serial
	 input [7:0] recv_in,	//get data from the receiver module
	 input recv_write,	//data ready from the receiver module
    output [7:0] tx_in,	//write data to the uart/serial
    output tx_write,		//write enable for the uart/serial
	 output recv_clk,		//generated receiver module clk
	 output recv_rst,		//generated receiver module rst_n
	 output [7:0] scode,	//status code
	 output scode_rdy,	//positive edged valid the status code
	 output [7:0]level	//judge level for the decode module
    );

parameter CMD_RESET = 1;
parameter CMD_ON = 2;
parameter CMD_OFF = 3;
parameter CMD_STATUS = 4;
parameter CMD_SILENCE = 5;
parameter CMD_LEVEL = 6;

parameter STATE_IDLE = 0;
parameter STATE_RESET = 1;
parameter STATE_ON = 2;
parameter STATE_OFF = 3;
parameter STATE_STATUS = 4;
parameter STATE_SILENCE = 5;
parameter STATE_RETURN = 6;
parameter STATE_LEVEL = 7;

//-------------------------------------------
reg rx_over_r;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		rx_over_r <= 1'b0;
		end
	else begin
		rx_over_r <= rx_over;
		end
end
assign rx_over_pos = ~rx_over_r & rx_over;

//----------------------------------------------
reg recv_en;	//记录接收端开启状态
reg ctr_out;	//记录是否沉默接收端输出
reg recv_rst_r;	//给接收端的重置信号

reg[3:0] para_cnt;	//读取参数
reg[7:0] para_buf;
reg[15:0] out_cnt;

reg[3:0] state;
reg[3:0] state_r;

reg[7:0] level_r;

reg[7:0] scode_r;
reg scode_rdy_r;

reg[7:0] tx_in_r;		//输出
reg tx_write_r;

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		recv_en <= 1'b0;
		ctr_out <= 1'b0;
		recv_rst_r <= 1'b1;
		level_r <= 8'd100;
		para_cnt <= 4'd0;
		out_cnt <= 16'd0;
		state <= STATE_IDLE;
		
		tx_in_r <= 8'd0;
		tx_write_r <= 1'b0;
		scode_r <= 8'd0;
		scode_rdy_r <= 1'd0;
		end
	else begin
		case(state)
			STATE_IDLE: begin
				if (rx_over_pos) begin
					case(rx_out)
						CMD_RESET: begin //设置recv_rst
							state <= STATE_RESET;
							end
						CMD_ON: begin
							state <= STATE_ON;
							end
						CMD_OFF: begin
							state <= STATE_OFF;
							end
						CMD_STATUS: begin
							out_cnt <= 16'd20000;
							state <= STATE_STATUS;
							end
						CMD_SILENCE: state <= STATE_SILENCE;
						CMD_LEVEL: state <= STATE_LEVEL;
						default: state <= STATE_RETURN;
						endcase
					end
				end
			STATE_RESET: begin
					scode_r <= 8'd0;
					scode_rdy_r <= 1'b1;
					recv_rst_r <= 1'b0;
					state <= STATE_RETURN;
				end
			STATE_ON: begin
					scode_r <= 8'd1;
					scode_rdy_r <= 1'b1;
					recv_en <= 1'b1;
					state <= STATE_RETURN;
				end
			STATE_OFF: begin
					scode_r <= 8'd2;
					scode_rdy_r <= 1'd1;
					recv_en <= 1'b0;
					state <= STATE_RETURN;
				end
			STATE_STATUS: begin
					//state <= STATE_STATUS;
					ctr_out <= 1'b1;
					out_cnt <= out_cnt - 16'd1;
					if (out_cnt == 16'd20000) tx_write_r <= 1'b0;
					else if (out_cnt == 16'd19998) begin
							tx_in_r <= {6'd0, recv_en, ctr_out};
							tx_write_r <= 1'b1;
						end
					else if (out_cnt == 16'd10008) begin
							tx_write_r <= 1'b0;
						end
					else if (out_cnt == 16'd9998) begin
							tx_in_r <= level_r;
							tx_write_r <= 1'b1;
						end
					else if (out_cnt == 16'd0)state <= STATE_RETURN;
				end
			STATE_SILENCE: begin
					//scode_r <= 8'd5;
					//scode_rdy_r <= 1'd1;
					if (rx_over_pos) begin
						para_buf <= rx_out;
						state <= STATE_RETURN;
					end else
						state <= STATE_SILENCE;
				end
			STATE_LEVEL: begin
					if (rx_over_pos) begin
						scode_r <= rx_out;
						scode_rdy_r <= 1'd1;
						level_r <= rx_out;
						state <= STATE_RETURN;
					end else
						state <= STATE_LEVEL;
				end
			STATE_RETURN: begin
					case(state_r)
						STATE_RESET: begin
								recv_rst_r <= 1'b1;
								state <= STATE_RETURN;
							end
						STATE_ON: begin
								ctr_out <= 1'b1;
								if (recv_en == 1'b1) tx_in_r <= 8'd1;
								else tx_in_r <= 8'd2;
								tx_write_r <= 1'b1;
								state <= STATE_RETURN;
							end
						STATE_OFF: begin
								ctr_out <= 1'b1;
								if (recv_en == 1'b0) tx_in_r <= 8'd1;
								else tx_in_r <= 8'd2;
								tx_write_r <= 1'b1;
								state <= STATE_RETURN;
							end
						STATE_STATUS: begin	//no output
								if (recv_en == 1'b1) tx_in_r <= 8'd1;
								else tx_in_r <= 8'd2;
								tx_write_r <= 1'b1;
								state <= STATE_RETURN;
							end
						STATE_SILENCE: begin
								if (para_buf == 8'd1) ctr_out <= 1'b1;
								else ctr_out <= 1'b0;
								state <= STATE_RETURN;
							end
						STATE_LEVEL: begin
								tx_in_r <= 8'd1;
								tx_write_r <= 1'b1;
								state <= STATE_RETURN;
							end
						STATE_RETURN: begin
								tx_write_r <= 1'b0;
								scode_rdy_r <= 1'd0;
								state <= STATE_IDLE;
							end
					endcase
				end
			default:	state <= STATE_IDLE;
		endcase
	end
end

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state_r <= STATE_IDLE;
		end
	else begin
		state_r <= state;
		end
end

//assign tx_in = tx_in_r ;
//assign tx_write = tx_write_r;

assign tx_in = ctr_out ? tx_in_r : recv_in;
assign tx_write = ctr_out ? tx_write_r : recv_write;

assign recv_rst = recv_rst_r;
assign recv_clk = clk & recv_en;

assign scode = scode_r;
assign scode_rdy = scode_rdy_r;

assign level = level_r;
endmodule
