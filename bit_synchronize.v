`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:18:08 01/16/2016 
// Design Name: 
// Module Name:    bit_synchroniz 
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

module bit_synchronize(rst,clk_high,ppmdata,clk_low);//,Num,enable,ahead,behind,ahead_final,behind_final,adder,adder_mid,firstbit,adder_mid_ahead);

input clk_high,ppmdata,rst;
output clk_low;

//output[3:0] Num,adder,adder_mid,adder_mid_ahead;
//output firstbit,enable,ahead,behind,ahead_final,behind_final;
wire[3:0] Num;

wire enable,ahead,behind,ahead_final,behind_final; 


phase_detector 	U1(rst,clk_high,clk_low1,ppmdata,Num,enable,ahead,behind);//,adder,adder_mid,firstbit,adder_mid_ahead);

Loop_Filter  	U2(rst,ahead,behind,ahead_final,behind_final);

Num_creat		U3(rst,ahead_final,behind_final,Num);

clock_devide	U4(rst,Num,clk_high,enable,clk_low);

endmodule
