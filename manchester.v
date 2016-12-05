`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:02:27 10/11/2016 
// Design Name: 
// Module Name:    manchester 
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
module manchester(
    input [15:0] din,
    output [7:0] dout
    );

assign dout[7] = din[15] & (~din[14]);
assign dout[6] = din[13] & (~din[12]);
assign dout[5] = din[11] & (~din[10]);
assign dout[4] = din[9] & (~din[8]);
assign dout[3] = din[7] & (~din[6]);
assign dout[2] = din[5] & (~din[4]);
assign dout[1] = din[3] & (~din[2]);
assign dout[0] = din[1] & (~din[0]);

endmodule
