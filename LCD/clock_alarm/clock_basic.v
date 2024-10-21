module clock_basic(clk,reset,sec,min,hour,sw,cnt,day_cnt,enable);  //입출력 선언부

 input clk,reset;
 input [3:0]sw;
 output reg [5:0]sec,min;
 output reg [4:0]hour;
 output reg enable;

 reg [7:0]hour_buff,min_buff,day_buff;  //스위치 버퍼
 
 output reg [27:0]cnt;
 output reg [2:0]day_cnt;
 
 reg [4:0]a_hour=6;
 reg [5:0]a_min=1;
 reg [5:0]a_sec=6'b0;
 
 always@(posedge clk, negedge reset)  //시계 모듈
  if(!reset) begin
   cnt<=28'b0;
	{sec,min}<=6'b0;
	hour<=5'b0;
	day_cnt<=3'b0;
  end
  else begin
	if(cnt>=5399999) begin
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
   hour_buff<={hour_buff[6:0],sw[0]};
	min_buff<={min_buff[6:0],sw[1]};
	day_buff<={day_buff[6:0],sw[2]};
  end

 always@(posedge clk, negedge reset)  //enable 조건 회로
  if(!reset) enable<=1'b0;
  else begin
   if(hour==a_hour && min==a_min && sec==a_sec && sw[3]==1) enable<=1'b1;
   else if(sw[3]==0 || min==(a_min+3)%60) enable<=1'b0;
   //else enable=1'b0;
  end
  
endmodule
