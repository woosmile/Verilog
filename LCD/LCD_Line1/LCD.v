module LCD(clk,reset,lcd_rs,lcd_rw,lcd_en,lcd_data);  //모듈 선언부

 input clk,reset;  //입출력 선언부
 output reg [7:0]lcd_data;
 output reg lcd_rs,lcd_en;
 output lcd_rw;
 
 reg [2:0]state;  //변수 선언부
 reg [31:0]cnt_5ms;
 reg [4:0]cnt_100ms,cnt_50ms;
 reg [4:0]line;
 
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
  
 always@(posedge clk, negedge reset)  //50ms 발생부(5*10)
  if(!reset) cnt_50ms<=5'b0;
  else begin
   if(state==delay_5ms) begin
	 if(cnt_5ms>=269999) begin
	  if(cnt_50ms>=9) cnt_50ms<=5'b0;
	  else cnt_50ms<=cnt_50ms+1;
	 end
	end
	else cnt_50ms<=5'b0;
  end
 
 always@(posedge clk, negedge reset)  //5ms마다 line 값 증가(각 자리에 맞는 값 표시)
  if(!reset) line<=5'b0;
  else begin
   if(state==disp_data) begin
	 if(cnt_5ms>=269999) begin
	  if(line>=17) line<=5'b0;
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
   if(cnt_5ms==0) begin
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
	   if(line>=17) state<=delay_5ms;
		else state<=disp_data;
	  end
	  delay_5ms : begin
	   if(cnt_50ms>=1) state<=disp_data;
		else state<=delay_5ms;
	  end
	  default state<=delay_100ms;
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
	  1 : {lcd_rs,lcd_data}={1'b1," "};
	  2 : {lcd_rs,lcd_data}={1'b1,"K"};
	  3 : {lcd_rs,lcd_data}={1'b1,"i"};
	  4 : {lcd_rs,lcd_data}={1'b1,"m"};
	  5 : {lcd_rs,lcd_data}={1'b1," "};
	  6 : {lcd_rs,lcd_data}={1'b1,"W"};
	  7 : {lcd_rs,lcd_data}={1'b1,"o"};
	  8 : {lcd_rs,lcd_data}={1'b1,"o"};
	  9 : {lcd_rs,lcd_data}={1'b1," "};
	  10 : {lcd_rs,lcd_data}={1'b1,"S"};
	  11 : {lcd_rs,lcd_data}={1'b1,"e"};
	  12 : {lcd_rs,lcd_data}={1'b1,"o"};
	  13 : {lcd_rs,lcd_data}={1'b1,"n"};
	  14 : {lcd_rs,lcd_data}={1'b1,"g"};
	  15 : {lcd_rs,lcd_data}={1'b1," "};
	  16 : {lcd_rs,lcd_data}={1'b1," "};
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
