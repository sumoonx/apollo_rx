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

assign dout[7] = din[14] & (~din[15]);
assign dout[6] = din[12] & (~din[13]);
assign dout[5] = din[10] & (~din[11]);
assign dout[4] = din[8] & (~din[9]);
assign dout[3] = din[6] & (~din[7]);
assign dout[2] = din[4] & (~din[5]);
assign dout[1] = din[2] & (~din[3]);
assign dout[0] = din[0] & (~din[1]);

endmodule
