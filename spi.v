`timescale 1ns / 1ps
/////////////////////////////www.openpuu.com/////////////////////////////////////
// Create Date:    20:45:46 10/30/2010 
// Module Name:    spi 
////////////////////////////www.openpuu.com////////////////////////////////////
module spi #
(
parameter SPI_LEN = 4'd8,// ��������������SPI���г���
parameter SPI_DIV = 4'd1 // ���÷�Ƶϵ����0Ϊ2��Ƶ��1Ϊ4��Ƶ
) 
(
Clk,Rst,Sck,Mosi,Miso,RdData,WrData,IsSta,IsDone
); // SPI Э��ӿ�

input  Clk; // ϵͳʱ������
input  Rst; // ��λ����
output Sck; // Spi ʱ��
output Mosi;// �����ӽ�
input  Miso;// �����ӳ�
output [SPI_LEN -1:0] RdData;// ���� ����������
input  [SPI_LEN -1:0] WrData;// ���� д�������
input  IsSta; // һ�����ݶ���д���
output IsDone;// һ�β������

reg  [1:0] SckState; // Spi ʱ��״̬��
reg  s; // 
reg  SckEn; // ʹ�� SPI ʱ��

reg  IsDone; // һ�ζ�����д�������

reg  [6:0]SckC=0; // Sck ������
reg  [3:0]BitC=0; // bit λ������


wire SftOut; // ��λ�������

reg  Sck=0,SckD1=0;
wire SckUp,SckNp;
// ͬ�����ε�·����ȡ Sck��������
// ��������������Sck�����ض���
assign SckUp=Sck&&(!SckD1);
// ͬ�����ε�·����ȡ Sck��������
// ��������������Sck�½��ط���
// ͨ�������������½��أ��ı�����
// �����������⣬������ȡ
assign SckNp=!Sck&&(SckD1);
always @(posedge Clk) SckD1 <= Sck;
 

// SPI ������ �����ؼ���
always @(posedge Clk)
if(SckEn && SckUp) BitC <= BitC + 1'b1; else if(BitC == SPI_LEN) BitC<=4'd0;
 
assign Mosi=  SftOut ; // ��λģ�鴮�����

// ��״̬��
always @(posedge Clk)
if(!Rst)begin
		s<=1'b0; IsDone <= 1'b0; SckEn <= 1'b0;
end
else begin 
		case(s)
		0: //����״̬�����IsSta=1 ������λ״̬
		begin IsDone <= 1'b0; SckEn <= 1'b0; if( IsSta )s<= 1'b1; end
		1://��λ״̬��ʹ��Sck ʱ�� ����������߷��������ݵ���SPI_LEN�� ���β������
		begin  
		SckEn<=1'b1; if(BitC == SPI_LEN)begin SckEn <= 1'b0; IsDone <= 1'b1; s <= 1'b0;end
		end
		endcase
end

// spi ʱ�ӷ�����


always @(posedge Clk)
if(!Rst)begin SckC <= 7'd0; Sck <= 1'b0; SckState <= 2'd0;end
else begin
		case( SckState )
		0:// ״̬0 ��� SckEn=1����ʼ����SPIʱ��
		begin SckC <= 7'd0; Sck <= 1'd0; if( SckEn ) SckState <= 2; end
		1:
		begin // ����ߵ�ƽ
		Sck <= 1'b1; if( SckC >= SPI_DIV ) begin SckState <= 2; SckC <= 7'd0; end else SckC <= SckC + 1'b1;
		end
		2: // ����͵�ƽ
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
					.SPI_LEN(SPI_LEN) //SPI ���ݳ���
				)
			SHIFT_INST
				( 
					.Clk(Clk), // ϵͳʱ��
					.Rst(Rst),// ϵͳ��λ
					.SckWr(SckNp),// ���ʹ���
					.SckRd(SckUp),// ������
					.IsLoad(IsSpiLd), // ��������
					.DataIn(WrData), // ���������� ���е�
					.SftIn(Miso), // ��������ݴ��е�
					.SftEn(SckEn), // Sck ʹ�ܣ�ͬʱ����λʹ��
					.SftOut(SftOut), // ���з���
					.DataOut(RdData) // ����Ĳ�������
				 );
				 

endmodule
