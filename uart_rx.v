module uart_rx(
				clk,rst_n,
				rs232_rx,rx_data,rx_int,
				clk_bps,bps_start
			);
input clk;		
input rst_n;	
input rs232_rx;	
input clk_bps;	
output reg bps_start;	
output[7:0] rx_data;	
output reg rx_int;	

//-------------------------------------
reg rs232_rx0,rs232_rx1,rs232_rx2,rs232_rx3;	
wire neg_rs232_rx;	

always @ (posedge clk or negedge rst_n) 
	if(!rst_n) begin
		rs232_rx0 <= 1'b0;
		rs232_rx1 <= 1'b0;
		rs232_rx2 <= 1'b0;
		rs232_rx3 <= 1'b0;
	end
	else begin
		rs232_rx0 <= rs232_rx;
		rs232_rx1 <= rs232_rx0;
		rs232_rx2 <= rs232_rx1;
		rs232_rx3 <= rs232_rx2;
	end

assign neg_rs232_rx = rs232_rx3 & rs232_rx2 & ~rs232_rx1 & ~rs232_rx0;

//-------------------------------------
reg[3:0] num;	

always @ (posedge clk or negedge rst_n)
	if(!rst_n) bps_start <= 1'b0;
	else if(!bps_start && neg_rs232_rx) bps_start <= 1'b1;	
	else if((num == 4'd9) && clk_bps) bps_start <= 1'b0;	
	
//-------------------------------------
reg[7:0] rx_temp_data;	

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		rx_temp_data <= 8'd0;
		num <= 4'd0;
		rx_int <= 1'b0;
	end
	else if(bps_start) begin	
		if(clk_bps) begin		
			if(num < 4'd9) begin
				num <= num+1'b1;
				rx_int <= 1'b0;	
			end
			else begin
				num <= 4'd0;			
				rx_int <= 1'b1;			
			end
			case (num)
				4'd1: rx_temp_data[0] <= rs232_rx;	
				4'd2: rx_temp_data[1] <= rs232_rx;	
				4'd3: rx_temp_data[2] <= rs232_rx;	
				4'd4: rx_temp_data[3] <= rs232_rx;	
				4'd5: rx_temp_data[4] <= rs232_rx;	
				4'd6: rx_temp_data[5] <= rs232_rx;	
				4'd7: rx_temp_data[6] <= rs232_rx;	
				4'd8: rx_temp_data[7] <= rs232_rx;	
				default: ;
			endcase
			
		end
		else rx_int <= 1'b0;
	end
	else rx_int <= 1'b0;

assign rx_data = rx_temp_data;	
	
endmodule
