`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:56 01/16/2016 
// Design Name: 
// Module Name:    phase_detector 
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
module phase_detector(rst,clk_high,clk_low1,ppmdata,Num_in,enable,ahead,behind);//,adder,adder_mid,firstbit,adder_mid_ahead);

input rst,clk_high,clk_low1,enable,ppmdata;
input [3:0] Num_in;

output ahead,behind;

//output firstbit;
//output[3:0] adder,adder_mid,adder_mid_ahead;

parameter N = 4'b1000;

reg[3:0] adder,count_num,adder_mid,adder_mid_ahead;
reg add_permit,ahead_mid,behind_mid;
reg firstbit;

always @(posedge clk_high or negedge rst)
begin
	if(!rst)
		begin
			add_permit <= 1'b0;
			count_num <= 4'b0000;
			adder <= 4'b0000;
			adder_mid <= N/2;
			adder_mid_ahead <=N/2;
			firstbit <= 1'b0;
		end
	else
		begin
			if(enable && Num_in == N)
				begin	
					adder_mid_ahead <= adder_mid;
					add_permit <= 1'b1;
					count_num <= count_num + 4'b0001;
					firstbit <= ppmdata;
//					firstbit[0] <= firstbit[1];
					adder <= adder + {1'b0,1'b0,1'b0,ppmdata};
				end
			if(!enable && Num_in == N && add_permit)
				begin
					if(count_num == N-4'b0001)
						begin
							count_num <= 4'b0000;
							adder_mid <= adder + {1'b0,1'b0,1'b0,ppmdata};
							adder <= 4'b0000;
						end
					else
						begin
							count_num <=count_num +4'b0001;
							adder <= adder + {1'b0,1'b0,1'b0,ppmdata};
						end
				end
			else if(Num_in != N)
				begin
					firstbit <= ppmdata;

					add_permit <= 1'b0;
					count_num <= 4'b0000;
					adder <= 4'b0000;
					adder_mid <= N/2;
					firstbit <= 1'b0;
				end
		end
end

always @(negedge clk_high or negedge rst)
begin
	if(!rst)
		begin
			ahead_mid <= 1'b0;
			behind_mid <= 1'b0;
		end
	else
		begin
			if(enable && Num_in == N)
				begin
					if((adder_mid < N/2 && !firstbit && adder_mid >0)||(adder_mid > N/2 && adder_mid < N && firstbit))
						begin
							ahead_mid <= 1'b1 ;
							behind_mid <= 1'b0;
						end
					else if((adder_mid < N/2 && adder_mid >0 && firstbit)||(adder_mid > N/2 && adder_mid <N && !firstbit))	
						begin
							ahead_mid <= 1'b0;
							behind_mid <= 1'b1 ;
						end
					else if(adder_mid == N )
						begin
							if(adder_mid_ahead == 0)
								begin
									ahead_mid <= 1'b1 ;
									behind_mid <= 1'b0 ;
								end
							else
								begin
									ahead_mid <= ahead_mid ;
									behind_mid <= behind_mid ;
								end
						end
					else if(adder_mid ==0)
						begin
							if(adder_mid_ahead == N)
								begin
									ahead_mid <= 1'b1 ;
									behind_mid <= 1'b0 ;
								end
							else
								begin
									ahead_mid <= ahead_mid ;
									behind_mid <= behind_mid ;
								end
						end	
					else
						begin	
							ahead_mid <= 1'b0 ;
							behind_mid <= 1'b0 ;
						end
				end
			else
				begin
					ahead_mid <= 1'b0 ;
					behind_mid <= 1'b0 ;					
				end
		end
end

assign ahead = ahead_mid & enable;
assign behind = behind_mid &enable;
			
endmodule		

