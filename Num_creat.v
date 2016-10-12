`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:38 01/16/2016 
// Design Name: 
// Module Name:    Num_creat 
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
module Num_creat(rst,ahead,behind,Num);

input rst,ahead,behind;
output [3:0] Num; 
reg [3:0] Num;


parameter N=4'b1000;

always @(ahead or behind)
		begin
			case({ahead,behind})
				2'b10:		Num <= N+4'b0001;
				2'b01: 		Num <= N-4'b0001;
				default: 	Num <= N;
			endcase
		end

endmodule

