`timescale 1ns / 1ps
/////////////////////////////www.openpuu.com/////////////////////////////////////
// Create Date:    20:45:46 10/30/2010 
// Module Name:    SHIFT8 
// Revision	:V1.0
////////////////////////////www.openpuu.com////////////////////////////////////
module SHIFT #
(
	parameter SPI_LEN = 4'd8// 常量参数，设置SPI串行长度
) 

 (
  input Clk,// 系统时钟
  input SckWr, // 写触发时钟
  input SckRd, // 读触发时钟
  input Rst,   // 系统复位
  input IsLoad,// 加载数据信号
  input [SPI_LEN-1:0] DataIn,// SPI数据长度
  input SftIn, // 移位输入
  input SftEn, // 移位使能
  output SftOut, // 移位输出
  output reg [SPI_LEN-1:0]DataOut //移位并行输出
  );
  

  reg [SPI_LEN-1:0] DataInt; //发送数据寄存器
  assign SftOut=DataInt[7];  // 移位输出
  
  always @( posedge Clk )
    if( !Rst )begin 
		DataInt <= 0;
		DataOut <= 0;
	 end
	 else if(IsLoad ) DataInt <= DataIn; // 加载发送的数据，到寄存器
    else if( SftEn ) begin
		if(SckWr) DataInt <= { DataInt [SPI_LEN-2:0], 1'b0 }; // 移位输出
		if(SckRd) DataOut <= { DataOut [SPI_LEN-2:0], SftIn };// 移位输入
    end
  
endmodule
