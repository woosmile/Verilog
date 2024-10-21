module project_2(clk, reset, sw_hour,sw_min,sw_nara,sw_day,day,pa,pb,pc,
alarm_set,alarm_on,speaker1,speaker2,fnd_data,fnd_sel,l_am,l_pm,nara);//l_pari,l_new,l_kor);
input clk, reset;
input sw_hour,sw_min,sw_nara,sw_day,alarm_set,alarm_on;			//alarm_set=알람 시간 설정,alarm_on=알람 유무,sw_모드(시,분,요일),시간조절,나라
output speaker1,speaker2;
output l_am,l_pm;//,l_pari,l_new,l_kor;
output [6:0] day;						//키트에선 반전 
output [5:0] fnd_sel;
output [7:0] fnd_data;
output [1:0] pa,pb,pc;
output wire [2:0] nara;

reg l_pari,l_new,l_kor;
reg [6:0] day;
reg [5:0] fnd_sel;
reg [7:0] fnd_data;
reg [31:0] time_cnt;				//주파수 
reg [31:0] sec_count;			//1초 증가
wire [5:0] sec,min,hour,ahour,amin,asec,p_hour,n_hour;			//amin,ahour=알람 설정 시간 
//reg [3:0] sec1,sec10,min1,min10,hour1,hour10,ahour1,ahour10,amin1,amin10,asec1,asec10,phour1,phour10,nhour1,nhour10;
reg [3:0] fnd_num;
reg [2:0] digit=0;


reg [31:0] alram_cnt,cnt,scan_cnt;
reg start,en,same,check;
wire [3:0]day_cnt;
wire [7:0] am_pm;
wire [5:0] sel,a_min,a_hour;
wire flag,ampm;
wire [3:0] hour10,hour1,min10,min1,sec10,sec1,a_hour10,a_hour1,a_min10,a_min1;

watch u0(.clk(clk),.reset(reset),.sec(sec),.min(min),.hour(hour),
         .am_pm(ampm),.sw_hour(sw_hour),.sw_min(sw_min),.sw_day(sw_day),.sw_nara(sw_nara),.nara(nara),
			.flag(flag),.day_cnt(day_cnt),.a_min(a_min),.a_hour(a_hour),.set(alarm_set),.on(alarm_on));

ambulance u1 (clk, reset, en, speaker1, speaker2);

parameter delay_100ms = 0, function_set =1, clear_disp = 2, 
disp_on = 3, entry_mode = 4, disp_data = 5, delay_50ms = 6;

wire [17:0] cnt_clk_half;
wire lcd_rw;
wire [7:0] num100,num10,num1;


assign lcd_rw = 1'b0;
assign cnt_clk_half = 187500;
assign pa= 2'b01;
assign pb = 2'b01;
assign pc = 2'b01;


assign l_am = (!reset)?  1'b0 : (!ampm)? 1'b0 : 1'b1;
assign l_pm = (!reset)?  1'b1 : (!ampm)? 1'b1 : 1'b0;

assign hour10 = (!reset)? 0 : (!alarm_set)? (hour/10)%10 : (a_hour/10)%10;
assign hour1 = (!reset)? 0 : (!alarm_set)? hour%10 : a_hour%10;


assign min10 = (!reset)? 0 : (!alarm_set)? (min/10)%10 : (a_min/10)%10;
assign min1 = (!reset)? 0 : (!alarm_set)? min%10 : a_min%10;

assign sec10 = (!reset)? 0 : (!alarm_set)? (sec/10)%10 : 0;
assign sec1 = (!reset)? 0 : (!alarm_set)? sec%10 : 0;

assign a_hour10 = (!reset)? 0 : (a_hour/10)%10;
assign a_hour1 = (!reset)? 0 : a_hour%10;

assign a_min10 = (!reset)? 0 : (a_min/10)%10;
assign a_min1 = (!reset)? 0 : a_min%10;

always@(posedge clk,negedge reset)
begin
	if(!reset)	day <=1;
	else
		begin
			case(day_cnt)
				0:			day <= 7'b1111110;
				1:			day <= 7'b1111101;
				2:			day <= 7'b1111011;
				3:			day <= 7'b1110111;
				4:			day <= 7'b1101111;
				5:			day <= 7'b1011111;
				6:			day <= 7'b0111111;
				default:	day <= 7'b1111111;
			endcase
		end
end

	always @(posedge clk,negedge reset)
	begin
		if(!reset)	{start,alram_cnt,en,same,check} <= 0;
		else
		begin
			if(a_hour==hour && a_min==min && sec==0)	same<=1;
			
			if(!alarm_on)
			begin
				{en,same} <=0;
				if(alram_cnt!=0)	
				begin
					check <=1;
					alram_cnt<=0;
				end
				else	check <=0;
			end
			
			else
			begin
				if(!check)
				begin
					if(same==1)
					begin
						alram_cnt <= alram_cnt + 1;
						en<=1;
						if(alram_cnt>=50000000)
						begin
							cnt<= cnt+1;
							alram_cnt <= 0;
							if(cnt>=179)
							begin
								en<=0;
								same<=0;
								cnt<=0;
							end
						end
					end
				end
				else
				begin
					if((a_hour!=hour || a_min!=min) && sec==0)	check<=0;
					else													   check<=1;
				end
			end
			
						
		end
	end
	

always @(posedge clk,negedge reset)
begin
	if(!reset)	{fnd_sel,fnd_num,scan_cnt} <= 0;
	else	
	begin
		scan_cnt <= scan_cnt + 1;
		if(scan_cnt > 200000)
		begin
			scan_cnt <= 0;
			digit <= (digit + 1) % 6;
		end
		case(digit)
			0 : begin	fnd_sel <= 6'b000001;	fnd_num <= sec1;  end
			1 : begin	fnd_sel <= 6'b000010;	fnd_num <= sec10;  		  end
			2 : begin	fnd_sel <= 6'b000100;	fnd_num <= min1;  		  end
			3 : begin	fnd_sel <= 6'b001000;	fnd_num <= min10;  		  end
			4 : begin	fnd_sel <= 6'b010000;	fnd_num <= hour1;  		  end
			5 : begin	fnd_sel <= 6'b100000;	fnd_num <= hour10;  		  end
		endcase	
	end
end	



always @(posedge clk, negedge reset)
	begin
		if(!reset)	fnd_data <= 8'b0000_0000;
		else
		begin
			case(fnd_num)
			0 : fnd_data <= (8'b1100_0000);
			1 : fnd_data <= (8'b1111_1001);
			2 : fnd_data <= (8'b1010_0100);
			3 : fnd_data <= (8'b1011_0000);
			4 : fnd_data <= (8'b1001_1001);
			5 : fnd_data <= (8'b1001_0010);
			6 : fnd_data <= (8'b1000_0011);
			7 : fnd_data <= (8'b1111_1000);
			8 : fnd_data <= (8'b1000_0000);
			9 : fnd_data <= (8'b1001_1000);
			default : fnd_data <= 8'b1111_1111;
			endcase
		end
	end	
	
	
endmodule
