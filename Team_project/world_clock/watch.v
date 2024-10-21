module watch(clk,reset,sec,min,hour,nara,
am_pm,sw_hour,sw_min,sw_nara,sw_day,flag,day_cnt,a_min,a_hour,set,on);

input clk,reset,set,on;
input sw_hour,sw_min,sw_day,sw_nara;		

output flag;
output reg [2:0] nara;

output reg [5:0] a_min,a_hour=1;

output reg am_pm;

reg [31:0]time_cnt;
reg [7:0] hour_buff,min_buff,day_buff;
reg [7:0] nara_buff;
reg [3:0] sec1,sec10,min1,min10,hour1,hour10;
reg n_flag;
reg d_flag;
output reg [5:0] sec,min,hour;
output reg [3:0]day_cnt;
assign flag = (time_cnt>=25000000) ? 1'b1 : 1'b0;


always@(posedge clk,negedge reset)
begin
	if(!reset)	begin
						nara_buff<=0;
						nara <= 3'b110;
					end
	else
		begin
			if(!set)
			begin
				nara_buff<={nara_buff,sw_nara};
				if(nara_buff==1)	begin
					if(nara==3'b011)	nara <= 3'b110;
					else nara <= {nara[1:0],1'b1};
				end
			end			
		end
end

always@(posedge clk,negedge reset)
begin
	if(!reset)	{hour_buff,min_buff,day_buff}<=0;
	else
		begin
			day_buff<={day_buff,sw_day};
			hour_buff<={hour_buff,sw_hour};
			min_buff<={min_buff,sw_min};
		end
end

always @(posedge clk,negedge reset)
begin
	if(!reset)	begin
						{time_cnt,min,sec,day_cnt,a_min,am_pm}<=0;
						a_hour <= 0;
						hour   <= 0;
						n_flag <= 0;
						d_flag <= 0;
					end
	else
	begin
		time_cnt<=time_cnt+1;
		if(!set)
		begin
			if(hour<=11)	
			begin
				am_pm <= 0;
			end
			
			if(hour>=12)	begin
				am_pm <= 1;
			end
		end
		else
		begin
			if(a_hour<=11)	
			begin
				am_pm <= 0;
			end
			
			if(a_hour>=12)	begin
				am_pm <= 1;
			end
		end
		
		if(nara_buff==1)
			begin
				if(!set)
				begin
					if(hour<=11)	
					begin
						am_pm <= 0;
					end
					//else	am_pm <= 0;
					
					if(hour>=12)	begin
						am_pm <= 1;
					end
					
					case(nara)  //
						3'b110:			begin		//서울
										if(hour>=8)	hour <= (hour - 8)%24;
										else if(hour<8)	begin
											if(day_cnt==0)	day_cnt <= 6;
											else	day_cnt <= day_cnt - 1;
											hour <= (24-(8-hour));
										end
									end
						3'b101:			begin		//파리 = 서울 -8
										if(hour>=6)	hour <= (hour - 6)%24;
										else if(hour<6)	begin
											if(day_cnt==0)	day_cnt <= 6;
											else	day_cnt <= day_cnt - 1;
											hour <= (24-(6-hour));
										end
									end
						3'b011:			begin		//뉴욕 = 파리 -6
										if(hour<=9)	
										begin
											hour <= (hour + 14)%24;
										end
										else if(hour>9)	begin
											if(day_cnt==6)	day_cnt <= 0;
											else	day_cnt <= day_cnt + 1;
											hour <= (0 + (hour-10));
										end
									end
					endcase
				end
		end
		else if(day_buff==1 && set==0)
			begin
				day_cnt<=day_cnt+1;
				if(day_cnt>=6)	day_cnt<=0;
			end
			
		
		else if(hour_buff==1)
			begin
				if(!set)
				begin
					hour<=hour+1;
					if(hour>=11)	
					begin
						am_pm <= 1;
					end
					else	am_pm <= 0;
					
					if(hour>=23)	begin
						hour <=0;
						am_pm <= 0;
					end
				end
				else
				begin
					a_hour<=a_hour+1;
					if(a_hour>=11)	
					begin
						am_pm <= 1;
					end
					else	am_pm <= 0;
					if(a_hour>=23)	begin
						a_hour <=0;
						am_pm <= 0;
					end
				end
			end
		
		else if(min_buff==1)
			begin
				if(!set)
				begin
					min<=min+1;
					if(min>=59)	min<=0;
				end
				else
				begin
					a_min<=a_min+1;
					if(a_min>=59)	a_min<=0;
				end
					
			end
		else if(time_cnt>=50000000)
		begin
			time_cnt<=0;
			sec<=sec+1;
			if(sec>=59)
			begin
				sec<=0;
				min<=min+1;
			
				if(min>=59)
				begin
					min<=0;
					hour<=hour+1;
					
					if(hour>=23)	
					begin
						hour<=0;
						if(am_pm==1)
						begin
							day_cnt<=day_cnt+1;
							if(day_cnt>=6)	day_cnt<=0;
						end
						else	day_cnt<=day_cnt;
					end
				end
			end
		end
	end
end



always@(posedge clk,negedge reset)
begin
	if(!reset)	{sec1,sec10,min1,min10,hour1,hour10}<=0;
	else
		begin
			sec1<=sec%10;
			sec10<=(sec/10)%10;
			min1<=min%10;
			min10<=(min/10)%10;
			hour1<=hour%10;
			hour10<=(hour/10)%10;
			
		end
end



	

endmodule
