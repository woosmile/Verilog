module clock_basic(clk,reset,sec,min,hour,sw0,sw1);

 input clk,reset;
 input sw0,sw1;
 output reg [5:0]sec,min;
 output reg [4:0]hour;

 reg [7:0]hour_buff,min_buff;
 
 reg [27:0]cnt;
 
 
 always@(posedge clk, negedge reset)
  if(!reset) begin
   cnt<=28'b0;
	{sec,min}<=6'b0;
	hour<=5'b0;
  end
  else begin
	if(cnt>=53999999) begin
	 cnt<=28'b0;
	 if(sec>=59) begin
	  sec<=6'b0;
	  if(min>=59) begin
		min<=6'b0;
		if(hour>=23) hour<=5'b0;
		else hour<=hour+1;
	  end
	  else min<=min+1;
	 end
	 else sec<=sec+1;
	end
	else cnt<=cnt+1;
   if(hour_buff==1) hour<=(hour+1)%24;
   if(min_buff==1) min<=(min+1)%60;
  end
  
 always@(posedge clk, negedge reset)  //채터링 회로
  if(!reset) {hour_buff,min_buff}<=8'b0;
  else begin
   hour_buff<={hour_buff[6:0],sw0};
	min_buff<={min_buff[6:0],sw1};
  end
  
endmodule
