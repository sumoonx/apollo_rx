`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:51:07 05/09/2016 
// Design Name: 
// Module Name:    display 
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
`timescale 1ns / 1ps
module display(clk,rst_n,Sftclk,Lchclk,SDout,Srst_n,Dpy0,Dpy1,Dpy2,Dpy3);
input clk;
input rst_n;
output Sftclk;
output Lchclk;
output SDout;
output Srst_n;
input  [3:0]Dpy0;
input  [3:0]Dpy1;
input  [3:0]Dpy2;
input  [3:0]Dpy3;
	
parameter // 共阳数码管显示真值表
		zero = 8'b1100_0000,
		one  = 8'b1111_1001,
		two  = 8'b1010_0100,
		three= 8'b1011_0000,
		four = 8'b1001_1001,
		five = 8'b1001_0010,
		six  = 8'b1000_0010,
		seven= 8'b1111_1000,
		eight= 8'b1000_0000,
		nine = 8'b1001_0000;
		
parameter 
		IDLE =0,
		BYT0 =1,
		BYT0W=2,
		BYT1 =3,
		BYT1W=4;

reg Lchclk;
reg Srst_n;

reg rdy;
reg IsSta;
reg [7:0]WrData;
reg [2:0]s;
reg [2:0]Dpy_n;
reg [3:0]dp;
reg [3:0]data;
reg [7:0]dat;

wire IsDone;

always @(posedge clk or negedge rst_n)begin
	if(!rst_n)begin 
		IsSta <= 1'b0; s<= 1'b0; Lchclk <= 1'b0; Srst_n <= 1'b0;
	end
	else begin
		case(s)
		0 : 
		begin IsSta <= 0; s <= 3'd1; rdy <=0; Srst_n <= 1; end  
		1,2: // nop 2 clock
		s <= s + 1'b1;
		3:   // 写 HC595 高8位 选通要显示的数码管
		begin WrData <= dp; IsSta <= 1; Srst_n <=1; s <= 4; Lchclk <= 0;end 
		4:   // 等待写完成
		begin IsSta <=0; if( IsDone ) begin s <= 5; Lchclk <= 0; end end   
		5 :  // 写 HC595 低8位 显示的数值
		begin WrData <= dat ;IsSta <= 1;s <= 6; end     
		6:   // 等待写完成
		begin IsSta <=0; if( IsDone ) begin s <= 0; Lchclk <= 1;rdy <= 1;end end
	endcase
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		Dpy_n <= 3'd0;
	else begin //动态扫描
			if( rdy ) begin Dpy_n <= Dpy_n + 3'd1; 
			if( Dpy_n == 3'd3 ) Dpy_n <= 3'd0; end	
	end
end

always @( posedge clk)begin
			case ( Dpy_n ) // 选择需要显示的数码管
			0:
			begin data <= Dpy0;dp <= 4'b1000;end
			1:
			begin data <= Dpy1;dp <= 4'b0100;end
			2:
			begin data <= Dpy2;dp <= 4'b0010;end
			3:
			begin data <= Dpy3;dp <= 4'b0001;end
			endcase
end

always @(posedge clk )begin
			case( data ) 
				0: dat <= zero; 
				1: dat <= one;
				2: dat <= two;
				3: dat <= three;
				4: dat <= four;
				5: dat <= five;
				6: dat <= six;
				7: dat <= seven;
				8: dat <= eight;
				9: dat <= nine;
			endcase
end

localparam SPI_LEN =4'd8;
localparam SPI_DIV =4'd1;

spi#(
	.SPI_LEN(SPI_LEN), 
	.SPI_DIV(SPI_DIV)
)
hc595x2(
				.Clk(clk),
				.Rst(rst_n),
				.Sck(Sftclk),
				.Mosi(SDout),
				.Miso(Miso),
				.RdData(RdData),
				.WrData(WrData),
				.IsSta(IsSta),
				.IsDone(IsDone)
				);

endmodule
