`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:15 01/16/2016 
// Design Name: 
// Module Name:    Loop_Filter 
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
module Loop_Filter(rst,ahead_in,behind_in,ahead_out,behind_out);

input rst,ahead_in,behind_in;
output ahead_out,behind_out;

reg ahead_out_mid,behind_out_mid;
reg [3:0] ahead_count;
reg [3:0] behind_count;

parameter K = 4'b0000;

always @(posedge ahead_in or negedge rst)
begin
	if(!rst)
		begin
			ahead_out_mid <= 1'b0;
			ahead_count <= 4'b0000;
		end
	else
		begin
			ahead_count <= ahead_count +4'b0001;
			if(ahead_count == K && ahead_count - behind_count >= K/2)
				begin
					ahead_count <=4'b0000;
					ahead_out_mid <= ahead_in;
				end
			else
				ahead_out_mid <= 1'b0;
		end
end
assign ahead_out = ahead_in & ahead_out_mid;

always @(posedge behind_in or negedge rst)
begin
	if(!rst)
		begin
			behind_out_mid <= 1'b0;
			behind_count <= 4'b0000;
		end
	else
		begin
			behind_count <= behind_count +4'b0001;
			if(behind_count == K && behind_count - ahead_count >= K/2)
				begin
					behind_count <=4'b0000;
					behind_out_mid <= behind_in;
				end
			else
				behind_out_mid <= 1'b0;
		end
end	
assign behind_out = behind_in & behind_out_mid;
/*
always @(posedge clk_high or negedge rst)
begin
	if(!rst)
		begin
			ahead_out <= 1'b0;
			behind_out <= 1'b0;
			ahead_count <= 4'b0000;
			behind_count <= 4'b0000;
		end
	else
		begin
			if(ahead_in)
				ahead_count <= ahead_count + 4'b0001;
			if(behind_in)
				behind_count <= behind_count + 4'b0001;
			if(ahead_count == K && ahead_count - behind_count >= K/2)
				begin
					ahead_out <= 1'b1;
					behind_out <= 1'b0;
					ahead_count	<= 4'b0000;
					behind_count <= 4'b0000;
				end
			else if(behind_count == K && behind_count - ahead_count >= K/2)
				begin
					ahead_out <=1'b0;
					behind_out <= 1'b1;
					ahead_count	<= 4'b0000;
					behind_count <= 4'b0000;
				end
			else
				begin
					ahead_out <= 1'b0;
					behind_out <= 1'b0;
				end
		end
end
*/
			
			
	
	
	/*	if(!rst)
		begin
			ahead_out = 1'b0;
			behind_out = 1'b0;
			ahead_count = 4'b0000;
			behind_count = 4'b0000;
		end
	else
		begin
			case({ahead_in,behind_in})
			
				2'b10:	
					begin
						ahead_count = ahead_count + 4'b0001;
						//behind_count <= behind_count;
					end
				2'b01:
					begin
						//ahead_count <= ahead_count;
						behind_count = behind_count+4'b0001;
					end
				default:
					begin
						//ahead_count <= ahead_count;
						//behind_count <= behind_count;
					end
			endcase
		end
end
*/
/*
always @(ahead_count or behind_count)
begin
	if(ahead_count == K && ahead_count - behind_count >= K/2)
		begin
			ahead_out = 1'b1;
			behind_out = 1'b0;
			ahead_count	= 4'b0000;
			behind_count = 4'b0000;
		end
	else if(behind_count == K && behind_count - ahead_count >= K/2)
		begin
			ahead_out =1'b0;
			behind_out = 1'b1;
			ahead_count	= 4'b0000;
			behind_count = 4'b0000;
		end
	else
		begin
			ahead_out = 1'b0;
			behind_out = 1'b0;
		end
end
	*/

endmodule

	
