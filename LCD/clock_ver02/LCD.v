module LCD(clk,reset,lcd_rs,lcd_rw,lcd_en,lcd_data,sec,min,hour,cnt,day_cnt);  //모듈 선언부

 input clk,reset;  //입출력 선언부
 input [5:0]sec,min;
 input [4:0]hour;
 input [27:0]cnt;
 input [2:0]day_cnt;
 output reg [7:0]lcd_data;
 output reg lcd_rs,lcd_en;
 output lcd_rw;
 
 reg [2:0]state;  //변수 선언부
 reg [31:0]cnt_5ms;
 reg [4:0]cnt_100ms;
 reg cnt_10ms;
 reg [5:0]line;
 reg [7:0]d1,d2,d3;
 
 wire [7:0]h10,h1,m10,m1,s10,s1;  //lcd에 쓰기위해서는 8비트로(lcd_data가 8비트 이므로)
 
 reg [7:0]hour_buff,min_buff;
 
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
 
 assign h10=((hour/10)%10)|8'h30;
 assign h1=(hour%10)|8'h30;
 assign m10=((min/10)%10)|8'h30;
 assign m1=(min%10)|8'h30;
 assign s10=((sec/10)%10)|8'h30;
 assign s1=(sec%10)|8'h30;

 wire [7:0]blink;
 assign blink=(cnt>=26999999) ? ":" : " ";
 wire [7:0]ap;
 assign ap=(hour>=12) ? "P" : "A";
 
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
  
 always@(posedge clk, negedge reset)  //10ms 발생부(5*10)
  if(!reset) cnt_10ms<=5'b0;
  else begin
   if(state==delay_5ms) begin
	 if(cnt_5ms>=269999) begin
	  if(cnt_10ms>=1) cnt_10ms<=5'b0;
	  else cnt_10ms<=cnt_10ms+1;
	 end
	end
	else cnt_10ms<=5'b0;
  end
 
 always@(posedge clk, negedge reset)  //5ms마다 line 값 증가(각 자리에 맞는 값 표시)
  if(!reset) line<=5'b0;
  else begin
   if(state==disp_data) begin
	 if(cnt_5ms>=269999) begin
	  if(line>=35) line<=5'b0;
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
	   if(cnt_10ms>=1) state<=disp_data;
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
	  1 : {lcd_rs,lcd_data}={1'b1,"C"};
	  2 : {lcd_rs,lcd_data}={1'b1,"l"};
	  3 : {lcd_rs,lcd_data}={1'b1,"o"};
	  4 : {lcd_rs,lcd_data}={1'b1,"c"};
	  5 : {lcd_rs,lcd_data}={1'b1,"k"};
	  6 : {lcd_rs,lcd_data}={1'b1," "};
	  7 : {lcd_rs,lcd_data}={1'b1,"V"};
	  8 : {lcd_rs,lcd_data}={1'b1,"0"};
	  9 : {lcd_rs,lcd_data}={1'b1,"2"};
	  10 : {lcd_rs,lcd_data}={1'b1," "};
	  11 : {lcd_rs,lcd_data}={1'b1,":"};
	  12 : {lcd_rs,lcd_data}={1'b1," "};
	  13 : {lcd_rs,lcd_data}={1'b1,"K"};
	  14 : {lcd_rs,lcd_data}={1'b1,"W"};
	  15 : {lcd_rs,lcd_data}={1'b1,"S"};
	  16 : {lcd_rs,lcd_data}={1'b1," "};
	  17 : {lcd_rs,lcd_data}={1'b0,8'b1100_0000};
	  18 : {lcd_rs,lcd_data}={1'b1,d1};
	  19 : {lcd_rs,lcd_data}={1'b1,d2};
	  20 : {lcd_rs,lcd_data}={1'b1,d3};
	  21 : {lcd_rs,lcd_data}={1'b1," "};
	  22 : {lcd_rs,lcd_data}={1'b1,ap};
	  23 : {lcd_rs,lcd_data}={1'b1,"M"};
	  24 : {lcd_rs,lcd_data}={1'b1," "};
	  25 : {lcd_rs,lcd_data}={1'b1,h10};
	  26 : {lcd_rs,lcd_data}={1'b1,h1};
	  27 : {lcd_rs,lcd_data}={1'b1,blink};
	  28 : {lcd_rs,lcd_data}={1'b1,m10};
	  29 : {lcd_rs,lcd_data}={1'b1,m1};
	  30 : {lcd_rs,lcd_data}={1'b1,blink};
	  31 : {lcd_rs,lcd_data}={1'b1,s10};
	  32 : {lcd_rs,lcd_data}={1'b1,s1};
	  33 : {lcd_rs,lcd_data}={1'b1," "};
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
  
 always@(day_cnt)
  case(day_cnt)
   0 : begin
	 d1="M";
	 d2="O";
	 d3="N";
	end
	1 : begin
	 d1="T";
	 d2="U";
	 d3="E";
	end
	2 : begin
	 d1="W";
	 d2="E";
	 d3="D";
	end
	3 : begin
	 d1="T";
	 d2="H";
	 d3="U";
	end
	4 : begin
	 d1="F";
	 d2="R";
	 d3="I";
	end
	5 : begin
	 d1="S";
	 d2="A";
	 d3="T";
	end
   6 : begin
	 d1="S";
	 d2="U";
	 d3="N";
	end
	default : begin
	 d1="M";
	 d2="O";
	 d3="N";
	end
  endcase

endmodule
