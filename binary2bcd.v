module binary2bcd(
      clk,
      rst_n,
      binary,
      state_en,
		refresh,
		BCD
);
parameter   b_length      = 10;
parameter   bcd_len       = 16;
parameter   idle              = 5'b00001;
parameter   shift             = 5'b00010;
parameter   wait_judge   = 5'b00100;
parameter   judge           = 5'b01000;
parameter   add_3          = 5'b10000;
input       clk;
input       rst_n;
input    [b_length-1:0]  binary;
input      state_en;
input refresh;
output reg [bcd_len-1:0]  BCD;
reg  [b_length-1:0]  reg_binary;     
reg  [3:0]    bcd0, bcd1, bcd2, bcd3;
reg  [3:0]    shift_time;                    
reg   [5:0]    c_state, n_state;
reg      add3_en;
reg      change_done;

reg refresh_r;
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n)
              refresh_r <= 1'b0;
       else if(refresh)
             refresh_r <= 1'b1;
end

/*
always@(posedge clk)
begin
	if(refresh_r && change_done == 1'b0) begin
		change_done <= 1'b0;
		refresh_r <= 1'b0;
	end
end
*/

//this is a three section kind of state code style
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n)
              c_state <= idle;
       else
             c_state <= n_state;
end

//the second section
always@(posedge clk or negedge rst_n)
begin
       if(!rst_n)
                  c_state <= idle;
       else
               case(n_state)
					idle:begin
                               if((binary!=0)&&(state_en == 1'b1)&&(refresh_r == 1'b1))
                                       n_state <= shift;
                              else
                                      n_state <= idle;
                          end
					shift: n_state <= wait_judge;
					wait_judge: begin
										if(change_done==1'b1)
                                    n_state <= idle;
                              else
                                    n_state <= judge;
									end
               judge:begin   
									 if(add3_en)
												n_state <= add_3;
									 else
												n_state <= shift;
                          end
               add_3:begin
                                 n_state <= shift;
                           end
               default: n_state <= idle;  
              endcase
end
//the third section
always@(posedge clk or negedge rst_n)
begin
         if(!rst_n)
                  begin
                          shift_time  <= 4'b0;
                          change_done <= 1'b0;
                          add3_en  <= 1'b0;
                 end
         else
           case(n_state)
           idle:begin
                          shift_time <= b_length;
                          reg_binary <= binary;
                          bcd2     <= 4'b0;
                          bcd1     <= 4'b0;
                          bcd0     <= 4'b0;
								  bcd3 <= 4'd0;
                  end
          shift:begin 
                      {bcd3,bcd2,bcd1,bcd0,reg_binary} <= {bcd3,bcd2,bcd1,bcd0,reg_binary}<<1;
                      shift_time <= shift_time-1;
                      if(shift_time==1)     change_done <= 1'b1;
                      else                       change_done <= 1'b0;    
                 end
  wait_judge:begin
                       if((bcd3>=4'd5)||(bcd2>=4'd5)||(bcd1>=4'd5)||(bcd0>=4'd5))
                               add3_en <= 1;
                       else
                               add3_en <= 0;
                      if(change_done==1)   BCD <= {bcd3,bcd2,bcd1,bcd0};
                    end
        judge:  add3_en <= 0;
       add_3: begin
							  if(bcd3 >= 4'd5) bcd3 <= bcd3 + 4'b0011; else bcd3 <= bcd3;
                       if(bcd2>=4'd5) bcd2 <= bcd2 + 4'b0011; else bcd2 <= bcd2;
                       if(bcd1>=4'd5) bcd1 <= bcd1 + 4'b0011; else bcd1 <= bcd1;
                       if(bcd0>=4'd5) bcd0 <= bcd0 + 4'b0011; else bcd0 <= bcd0;
                   end
      default: begin
                           change_done <= 1'b0;
                           add3_en  <= 1'b0;
                  end
           endcase
        end
endmodule