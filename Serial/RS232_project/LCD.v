module LCD (clk, reset, 
				lcd_rs, lcd_rw, lcd_en, lcd_data,
				L0, L1, L2, L3, L4, L5, 
				L6, L7, L8, L9, L_A, L_B, 
				L_C, L_D, L_E, L_F
);

 input clk,reset;  //입출력 선언부
 input [7:0]L0, L1, L2, L3, L4, L5;
 input [7:0]L6, L7, L8, L9, L_A, L_B;
 input [7:0]L_C, L_D, L_E, L_F;
 
 output reg [7:0]lcd_data;
 output reg lcd_rs,lcd_en;
 output lcd_rw;
 
 reg [2:0]state;  //변수 선언부
 reg [31:0]cnt_5ms;
 reg [4:0]cnt_100ms;
 reg [5:0]line;
 
 wire [31:0]cnt_5ms_half;  
 assign cnt_5ms_half=202499;
 
 parameter delay_100ms=0;  //상수값 선언
 parameter function_set=1;
 parameter disp_clear=2;
 parameter disp_on=3;
 parameter entry_mode=4;
 parameter disp_data=5;
 parameter delay_5ms=6;
 
 assign lcd_rw=1'b0;  //쓰기 기능
 
 always@(posedge clk, negedge reset)  //5ms 발생부
  if(!reset) cnt_5ms<=18'b0;
  else begin
   if(cnt_5ms>=269999) cnt_5ms<=18'b0;
	else cnt_5ms<=cnt_5ms+1;
  end
  
 always@(posedge clk, negedge reset)  //100ms 발생부(5*20)
  if(!reset) cnt_100ms<=5'b0;
  else begin
   if(state==delay_100ms) begin
	 if(cnt_5ms>=269999) begin 
	  if(cnt_100ms>=19) cnt_100ms<=5'b0;
	  else cnt_100ms<=cnt_100ms+1;
	 end
	end
	else cnt_100ms<=5'b0;
  end
 
 always@(posedge clk, negedge reset)  //5ms마다 line 값 증가(각 자리에 맞는 값 표시)
  if(!reset) line<=5'b0;
  else begin
   if(state==disp_data) begin
	 if(cnt_5ms>=269999) begin
	  if(line>=34) line<=5'b0;
	  else line<=line+1;
	 end
	end
	else line<=5'b0;
  end
 
 always@(posedge clk, negedge reset)  //lcd_en 조건부
  if(!reset) lcd_en<=1'b0;
  else begin 
   if(state==delay_100ms || state==delay_5ms) lcd_en<=1'b0;
	else begin
	 if(cnt_5ms>=67499 && cnt_5ms<=cnt_5ms_half) lcd_en<=1'b1;
	 else lcd_en<=1'b0;
	end
  end
  
 always@(posedge clk, negedge reset)  //상태 레지스터 + 상태 천이회로
  if(!reset) state<=delay_100ms;
  else begin
  if(cnt_5ms==0) begin  //5ms마다 0이된다.(이로인해 상태값이 5ms씩 지연되므로 타이밍도에 따른 동작을 구현한다.)
	 case(state)
	  delay_100ms : begin
	   if(cnt_100ms>=19) state<=function_set;
		else state<=delay_100ms;
	  end
	  function_set : state<=disp_clear;
	  disp_clear : state<=disp_on;
	  disp_on : state<=entry_mode;
	  entry_mode : state<=disp_data;
	  disp_data : begin
	   if(line>=34) state<=delay_5ms;
		else state<=disp_data;
	  end
	  delay_5ms : begin
	   if(cnt_5ms==0) state<=disp_data;
		else state<=delay_5ms;
	  end
	  default : state<=delay_100ms;
	 endcase
	end
  end
  
 always@(state,line)  //상태값에 따른 출력회로
  case(state)
   delay_100ms : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0;
	end
	function_set : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0011_1000;
	end
	disp_clear : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0000_0001;
	end
	disp_on : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0000_1100;
	end
	entry_mode : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0000_0110;
	end
	disp_data : begin
	 case(line)
	  0 : {lcd_rs,lcd_data}={1'b0,8'b1000_0000};
	  1 : {lcd_rs,lcd_data}={1'b1,"R"};
	  2 : {lcd_rs,lcd_data}={1'b1,"S"};
	  3 : {lcd_rs,lcd_data}={1'b1,"2"};
	  4 : {lcd_rs,lcd_data}={1'b1,"3"};
	  5 : {lcd_rs,lcd_data}={1'b1,"2"};
	  6 : {lcd_rs,lcd_data}={1'b1," "};
	  7 : {lcd_rs,lcd_data}={1'b1,"I"};
	  8 : {lcd_rs,lcd_data}={1'b1,"N"};
	  9 : {lcd_rs,lcd_data}={1'b1,"P"};
	  10 : {lcd_rs,lcd_data}={1'b1,"U"};
	  11 : {lcd_rs,lcd_data}={1'b1,"T"};
	  12 : {lcd_rs,lcd_data}={1'b1," "};
	  13 : {lcd_rs,lcd_data}={1'b1,"T"};
	  14 : {lcd_rs,lcd_data}={1'b1,"E"};
	  15 : {lcd_rs,lcd_data}={1'b1,"S"};
	  16 : {lcd_rs,lcd_data}={1'b1,"T"};
	  17 : {lcd_rs,lcd_data}={1'b0,8'b1100_0000};
	  18 : {lcd_rs,lcd_data}={1'b1,1'b0,L0[6:0]};
	  19 : {lcd_rs,lcd_data}={1'b1,1'b0,L1[6:0]};
	  20 : {lcd_rs,lcd_data}={1'b1,1'b0,L2[6:0]};
	  21 : {lcd_rs,lcd_data}={1'b1,1'b0,L3[6:0]};
	  22 : {lcd_rs,lcd_data}={1'b1,1'b0,L4[6:0]};
	  23 : {lcd_rs,lcd_data}={1'b1,1'b0,L5[6:0]};
	  24 : {lcd_rs,lcd_data}={1'b1,1'b0,L6[6:0]};
	  25 : {lcd_rs,lcd_data}={1'b1,1'b0,L7[6:0]};
	  26 : {lcd_rs,lcd_data}={1'b1,1'b0,L8[6:0]};
	  27 : {lcd_rs,lcd_data}={1'b1,1'b0,L9[6:0]};
	  28 : {lcd_rs,lcd_data}={1'b1,1'b0,L_A[6:0]};
	  29 : {lcd_rs,lcd_data}={1'b1,1'b0,L_B[6:0]};
	  30 : {lcd_rs,lcd_data}={1'b1,1'b0,L_C[6:0]};
	  31 : {lcd_rs,lcd_data}={1'b1,1'b0,L_D[6:0]};
	  32 : {lcd_rs,lcd_data}={1'b1,1'b0,L_E[6:0]};
	  33 : {lcd_rs,lcd_data}={1'b1,1'b0,L_F[6:0]};
	  default : {lcd_rs,lcd_data}={1'b0,8'b0};
	 endcase
	end
	delay_5ms : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0;
	end
   default : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0;
	end
  endcase

endmodule
