`timescale 1ns / 1ps
/////////////////////////////www.openpuu.com/////////////////////////////////////
// Create Date:    20:45:46 10/30/2010 
// Module Name:    SHIFT8 
// Revision	:V1.0
////////////////////////////www.openpuu.com////////////////////////////////////
module SHIFT #
(
	parameter SPI_LEN = 4'd8// ��������������SPI���г���
) 

 (
  input Clk,// ϵͳʱ��
  input SckWr, // д����ʱ��
  input SckRd, // ������ʱ��
  input Rst,   // ϵͳ��λ
  input IsLoad,// ���������ź�
  input [SPI_LEN-1:0] DataIn,// SPI���ݳ���
  input SftIn, // ��λ����
  input SftEn, // ��λʹ��
  output SftOut, // ��λ���
  output reg [SPI_LEN-1:0]DataOut //��λ�������
  );
  

  reg [SPI_LEN-1:0] DataInt; //�������ݼĴ���
  assign SftOut=DataInt[7];  // ��λ���
  
  always @( posedge Clk )
    if( !Rst )begin 
		DataInt <= 0;
		DataOut <= 0;
	 end
	 else if(IsLoad ) DataInt <= DataIn; // ���ط��͵����ݣ����Ĵ���
    else if( SftEn ) begin
		if(SckWr) DataInt <= { DataInt [SPI_LEN-2:0], 1'b0 }; // ��λ���
		if(SckRd) DataOut <= { DataOut [SPI_LEN-2:0], SftIn };// ��λ����
    end
  
endmodule
