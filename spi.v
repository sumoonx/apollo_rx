`timescale 1ns / 1ps
/////////////////////////////www.openpuu.com/////////////////////////////////////
// Create Date:    20:45:46 10/30/2010 
// Module Name:    spi 
////////////////////////////www.openpuu.com////////////////////////////////////
module spi #
(
parameter SPI_LEN = 4'd8,// 常量参数，设置SPI串行长度
parameter SPI_DIV = 4'd1 // 设置风频系数，0为2分频，1为4分频
) 
(
Clk,Rst,Sck,Mosi,Miso,RdData,WrData,IsSta,IsDone
); // SPI 协议接口

input  Clk; // 系统时钟输入
input  Rst; // 复位输入
output Sck; // Spi 时钟
output Mosi;// 主出从进
input  Miso;// 主进从出
output [SPI_LEN -1:0] RdData;// 并行 读到的数据
input  [SPI_LEN -1:0] WrData;// 并行 写入的数据
input  IsSta; // 一次数据读或写完成
output IsDone;// 一次操作完成

reg  [1:0] SckState; // Spi 时钟状态机
reg  s; // 
reg  SckEn; // 使能 SPI 时钟

reg  IsDone; // 一次读或者写操作完成

reg  [6:0]SckC=0; // Sck 计数器
reg  [3:0]BitC=0; // bit 位计数器


wire SftOut; // 移位串行输出

reg  Sck=0,SckD1=0;
wire SckUp,SckNp;
// 同步整形电路，获取 Sck的上升沿
// 串行数据数据在Sck上升沿读入
assign SckUp=Sck&&(!SckD1);
// 同步整形电路，获取 Sck的上升沿
// 串行数据数据在Sck下降沿发出
// 通常发送数据是下降沿，改变数据
// 上升数据问题，并被读取
assign SckNp=!Sck&&(SckD1);
always @(posedge Clk) SckD1 <= Sck;
 

// SPI 计数器 上升沿计数
always @(posedge Clk)
if(SckEn && SckUp) BitC <= BitC + 1'b1; else if(BitC == SPI_LEN) BitC<=4'd0;
 
assign Mosi=  SftOut ; // 移位模块串行输出

// 主状态机
always @(posedge Clk)
if(!Rst)begin
		s<=1'b0; IsDone <= 1'b0; SckEn <= 1'b0;
end
else begin 
		case(s)
		0: //空闲状态，如果IsSta=1 进入移位状态
		begin IsDone <= 1'b0; SckEn <= 1'b0; if( IsSta )s<= 1'b1; end
		1://移位状态，使能Sck 时钟 ，当读入或者发出的数据到达SPI_LEN后 本次操作完成
		begin  
		SckEn<=1'b1; if(BitC == SPI_LEN)begin SckEn <= 1'b0; IsDone <= 1'b1; s <= 1'b0;end
		end
		endcase
end

// spi 时钟发生器


always @(posedge Clk)
if(!Rst)begin SckC <= 7'd0; Sck <= 1'b0; SckState <= 2'd0;end
else begin
		case( SckState )
		0:// 状态0 如果 SckEn=1，则开始产生SPI时钟
		begin SckC <= 7'd0; Sck <= 1'd0; if( SckEn ) SckState <= 2; end
		1:
		begin // 输出高电平
		Sck <= 1'b1; if( SckC >= SPI_DIV ) begin SckState <= 2; SckC <= 7'd0; end else SckC <= SckC + 1'b1;
		end
		2: // 输出低电平
		begin 
		Sck <= 1'b0;
		if( SckC >= SPI_DIV ) begin  SckC<=7'd0; if( SckEn ) SckState <= 1; else SckState <= 0; end 
		else SckC <= SckC + 1'b1; 
		end
		endcase
end

wire  IsSpiLd;
assign IsSpiLd = IsSta;
			SHIFT#
				(
					.SPI_LEN(SPI_LEN) //SPI 数据长度
				)
			SHIFT_INST
				( 
					.Clk(Clk), // 系统时钟
					.Rst(Rst),// 系统复位
					.SckWr(SckNp),// 发送触发
					.SckRd(SckUp),// 读触发
					.IsLoad(IsSpiLd), // 加载数据
					.DataIn(WrData), // 发出的数据 并行的
					.SftIn(Miso), // 读入的数据串行的
					.SftEn(SckEn), // Sck 使能，同时是移位使能
					.SftOut(SftOut), // 串行发出
					.DataOut(RdData) // 读入的并行数据
				 );
				 

endmodule
