module clock_basic(clk,reset,sec,min,hour,sw0,sw1,sw2,cnt,day_cnt);  //입출력 선언부

 input clk,reset;
 input sw0,sw1,sw2;
 output reg [5:0]sec,min;
 output reg [4:0]hour;

 reg [7:0]hour_buff,min_buff,day_buff;  //스위치 버퍼
 
 output reg [27:0]cnt;
 output reg [2:0]day_cnt;
 
 always@(posedge clk, negedge reset)  //시계 모듈
  if(!reset) begin
   cnt<=28'b0;
	{sec,min}<=6'b0;
	hour<=5'b0;
	day_cnt<=3'b0;
  end
  else begin
	if(cnt>=53999999) begin
	 cnt<=28'b0;
	 if(sec>=59) begin
	  sec<=6'b0;
	  if(min>=59) begin
		min<=6'b0;
		if(hour>=23) begin
		 hour<=5'b0;
		 day_cnt<=(day_cnt+1)%7;
		end
		else hour<=hour+1;
	  end
	  else min<=min+1;
	 end
	 else sec<=sec+1;
	end
	else cnt<=cnt+1;
   if(hour_buff==1) hour<=(hour+1)%24;
   if(min_buff==1) min<=(min+1)%60;
	if(day_buff==1) day_cnt<=(day_cnt+1)%7;
  end
  
 always@(posedge clk, negedge reset)  //채터링 회로
  if(!reset) {hour_buff,min_buff,day_buff}<=8'b0;
  else begin
   hour_buff<={hour_buff[6:0],sw0};
	min_buff<={min_buff[6:0],sw1};
	day_buff<={day_buff[6:0],sw2};
  end
  
endmodule
