`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:18:47 01/16/2016 
// Design Name: 
// Module Name:    clock_devide 
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
module clock_devide(rst,Num,clk_high,enable,clk_low);
input rst,clk_high;
input[3:0] Num;
output enable,clk_low;

reg enable,clk_low1;
reg[3:0] counter;
reg[3:0] Num_here;
wire clk_low;

parameter N=4'b1000;

assign clk_low=~clk_low1;

always @(posedge clk_high or negedge rst)
begin
	if(!rst)
		begin
			enable <= 1'b0;
			counter <= 4'b0000;
			clk_low1 <= 1'b0;
			Num_here <= N;
		end
	else
		begin
			counter <= counter + 4'b0001;
			case(counter)
				4'b0000:
					begin
						clk_low1 <= ~clk_low1;
						Num_here <= Num;
						enable <= 1'b0;
					end
				N/2:
					begin
						clk_low1 <= ~clk_low1;
					end
				Num_here-4'b0001:
					begin
						enable <= 1'b1;
						counter <= 4'b0000;
					end
				default:	;
			endcase
		end
end
endmodule
