module LCD_hangle(clk,reset,lcd_rs,lcd_rw,lcd_en,lcd_data);  //모듈 선언부

 input clk,reset;  //입출력 선언부
 output reg [7:0]lcd_data;
 output reg lcd_rs,lcd_en;
 output lcd_rw;
 
 reg [2:0]state;  //변수 선언부
 reg [31:0]cnt_5ms;
 reg [4:0]cnt_100ms,cnt_50ms;
 reg [5:0]line;
 
 wire [31:0]cnt_5ms_half;  
 assign cnt_5ms_half=202499;
 
 parameter delay_100ms=0;  //상수값 선언
 parameter function_set=1;
 parameter disp_clear=2;
 parameter disp_on=3;
 parameter entry_mode=4;
 parameter cgram_data=5;
 parameter disp_data=6;
 parameter delay_50ms=7;
 
 reg [7:0]hangle[32:0];  //33byte 배열
 initial begin
  hangle[0]=8'b0100_0000;
  hangle[1]=8'h1D;
  hangle[2]=8'h05;
  hangle[3]=8'h09;
  hangle[4]=8'h11;
  hangle[5]=8'h0F;
  hangle[6]=8'h09;
  hangle[7]=8'h0F;
  hangle[8]=8'h00;  //김 
  hangle[9]=8'h0E;
  hangle[10]=8'h11;
  hangle[11]=8'h11;
  hangle[12]=8'h0E;
  hangle[13]=8'h00;
  hangle[14]=8'h1F;
  hangle[15]=8'h04;
  hangle[16]=8'h00;  //우
  hangle[17]=8'h09;
  hangle[18]=8'h1D;
  hangle[19]=8'h17;
  hangle[20]=8'h15;
  hangle[21]=8'h06;
  hangle[22]=8'h09;
  hangle[23]=8'h06;
  hangle[24]=8'h00;  //성
  hangle[25]=8'h00;
  hangle[26]=8'h0A;
  hangle[27]=8'h15;
  hangle[28]=8'h11;
  hangle[29]=8'h11;
  hangle[30]=8'h0A;
  hangle[31]=8'h04;
  hangle[32]=8'h00;  //♡
 end
  
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
   if(state==delay_50ms) begin
	 if(cnt_5ms>=269999) begin
	  if(cnt_50ms>=9) cnt_50ms<=5'b0;
	  else cnt_50ms<=cnt_50ms+1;
	 end
	end
	else cnt_50ms<=5'b0;
  end
 
 always@(posedge clk, negedge reset)  //5ms마다 line 값 증가(각 자리에 맞는 값 표시)
  if(!reset) line<=6'b0;
  else begin
   if(state==disp_data || state==cgram_data) begin
	 if(cnt_5ms>=269999) begin
	  if(state==cgram_data) begin
	   if(line>=33) line<=6'b0;
		else line<=line+1;
	  end
	  else if(state==disp_data) begin
	   if(line>=5) line<=6'b0;
		else line<=line+1;
	  end
	 end
	end
	else line<=5'b0;
  end
 
 always@(posedge clk, negedge reset)  //lcd_en 조건부
  if(!reset) lcd_en<=1'b0;
  else begin 
   if(state==delay_100ms || state==delay_50ms) lcd_en<=1'b0;
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
	  entry_mode : state<=cgram_data;
	  cgram_data : begin
	   if(line>=33) state<=disp_data;
		else state<=cgram_data;
	  end
	  disp_data : begin
	   if(line>=5) state<=delay_50ms;
		else state<=disp_data;
	  end
	  delay_50ms : begin
	   if(cnt_50ms>=9) state<=disp_data;
		else state<=delay_50ms;
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
	cgram_data : begin
	 if(line==0) {lcd_rs,lcd_data}={1'b0,hangle[line]};
	 else {lcd_rs,lcd_data}={1'b1,hangle[line]};
	 /*
	 case(line)
	  0 : {lcd_rs,lcd_data}={1'b0,8'b0100_0000};  //CGRAM 어드레스 00번지로 설정
	  1 : {lcd_rs,lcd_data}={1'b1,8'h1D};
	  2 : {lcd_rs,lcd_data}={1'b1,8'h05};
	  3 : {lcd_rs,lcd_data}={1'b1,8'h09};
	  4 : {lcd_rs,lcd_data}={1'b1,8'h11};
	  5 : {lcd_rs,lcd_data}={1'b1,8'h0F};
	  6 : {lcd_rs,lcd_data}={1'b1,8'h09};
	  7 : {lcd_rs,lcd_data}={1'b1,8'h0F};
	  8 : {lcd_rs,lcd_data}={1'b1,8'h00};  //김
	  9 : {lcd_rs,lcd_data}={1'b1,8'h0E};
	  10 : {lcd_rs,lcd_data}={1'b1,8'h11};
	  11 : {lcd_rs,lcd_data}={1'b1,8'h11};
	  12 : {lcd_rs,lcd_data}={1'b1,8'h0E};
	  13 : {lcd_rs,lcd_data}={1'b1,8'h00};
	  14 : {lcd_rs,lcd_data}={1'b1,8'h1F};
	  15 : {lcd_rs,lcd_data}={1'b1,8'h04};
	  16 : {lcd_rs,lcd_data}={1'b1,8'h00};  //우
	  17 : {lcd_rs,lcd_data}={1'b1,8'h09};
	  18 : {lcd_rs,lcd_data}={1'b1,8'h1D};
	  19 : {lcd_rs,lcd_data}={1'b1,8'h17};
	  20 : {lcd_rs,lcd_data}={1'b1,8'h15};
	  21 : {lcd_rs,lcd_data}={1'b1,8'h06};
	  22 : {lcd_rs,lcd_data}={1'b1,8'h09};
	  23 : {lcd_rs,lcd_data}={1'b1,8'h06};
	  24 : {lcd_rs,lcd_data}={1'b1,8'h00};
	  25 : {lcd_rs,lcd_data}={1'b1,8'h00};  //성
	  26 : {lcd_rs,lcd_data}={1'b1,8'h0A};
	  27 : {lcd_rs,lcd_data}={1'b1,8'h15};
	  28 : {lcd_rs,lcd_data}={1'b1,8'h11};
	  29 : {lcd_rs,lcd_data}={1'b1,8'h11};
	  30 : {lcd_rs,lcd_data}={1'b1,8'h0A};
	  31 : {lcd_rs,lcd_data}={1'b1,8'h04};
	  32 : {lcd_rs,lcd_data}={1'b1,8'h00};  //♡
	  default : {lcd_rs,lcd_data}={1'b0,8'h00};
	 endcase
	 */
	end
	disp_data : begin
	 case(line)
	  0 : {lcd_rs,lcd_data}={1'b0,8'b1000_0000};
	  1 : {lcd_rs,lcd_data}={1'b1,8'h00};
	  2 : {lcd_rs,lcd_data}={1'b1,8'h01};
	  3 : {lcd_rs,lcd_data}={1'b1,8'h02};
	  4 : {lcd_rs,lcd_data}={1'b1,8'h03};
	  default : {lcd_rs,lcd_data}={1'b0,8'h00};
	 endcase
	end
	delay_50ms : {lcd_rs,lcd_data}={1'b0,8'h00};
   default : {lcd_rs,lcd_data}={1'b0,8'h00};
  endcase

endmodule
