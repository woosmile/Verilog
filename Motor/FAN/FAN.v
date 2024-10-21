/*module FAN(clk,reset,sw1,sw2,sw3,sw4,portc,motor,led,);

 input clk, reset;
 input sw1, sw2, sw3, sw4;
 
 output [1:0]portc;
 output [2:0]motor;
 output [2:0]led;
 
 reg [7:0]stop, level1, level2, level3;
 reg [2:0]led;
 
 reg [19:0]cnt,pwm;
 
 assign portc=2'b01;
 assign motor[2]=(pwm>cnt);
 assign motor[1]=1'b0;
 assign motor[0]=1'b1;
 
 always@(posedge clk, negedge reset)  //채터링 회로
  if(!reset) {stop,level1,level2,level3}<=0;
  else begin
   stop<={stop[6:0],sw1};
	level1<={level1[6:0],sw2};
	level2<={level2[6:0],sw3};
	level3<={level3[6:0],sw4};
  end
  
 always@(posedge clk, negedge reset) //주파수 설정 회로
  if(!reset) cnt<=0;
  else begin
   if(cnt>269999) cnt<=0;
	else cnt<=cnt+1;
  end
  
 always@(posedge clk, negedge reset) //pwm 값 설정회로 및 led 상태표시
  if(!reset) {pwm,led}<=0;
  else begin
   if(stop==1) begin
	 pwm<=0;
	 led<=3'b0;
	end
	
	else if(level1==1) begin
	 pwm<=70000;
	 led<=3'b100;
	end
	
	else if(level2==1) begin
	 pwm<=150000;
	 led<=3'b010;
	end
	
	else if(level3==1) begin
	 pwm<=250000;
	 led<=3'b001;
	end
  end

endmodule
*/


module FAN(clk,reset,sw1,sw2,sw3,sw4,sw5,mode,portc,motor,led,fnd_data,fnd_sel,fnd_en);

 input clk, reset;  //입출력 선언부
 input sw1, sw2, sw3, sw4, sw5, mode;
 
 output [7:0]fnd_data;
 output [3:0]fnd_sel;
 output [2:0]motor;
 output [2:0]led;
 output [1:0]portc;
 output fnd_en;
 
 reg [7:0]fnd_data;
 reg [3:0]fnd_sel;
 
 reg [7:0]stop, level1, level2, level3, time_set;  //채터링 방지 레지스터
 reg [7:0]min, sec;  //시간(분,초)
 reg [3:0]fnd_num;   //쪼갠 숫자를 저장해주는 레지스터
 reg [2:0]led;      
 reg [2:0]digit;     //fnd 자릿수를 결정해주는 레지스터
 
 reg [27:0]timer_cnt,scan_cnt;  //카운터 레지스터
 reg [19:0]cnt,pwm;  //모터 속도 제어 레지스터
 reg flag_stop;      //모터 정지 플래그
  
 assign portc=(!reset) ? 2'b00:2'b01;  //양방향 버퍼 설정
 assign motor[2]=(pwm>cnt);  //pwm 값에 따른 모터 속도 결정
 assign motor[1]=1'b0;       //고정값
 assign motor[0]=(!reset) ? 1'b0:1'b1;       //모터 enable
 
 assign fnd_en=(mode==1) ? 1'b0:1'b1;
 
 always@(posedge clk, negedge reset)  //채터링 회로
  if(!reset) {stop,level1,level2,level3}<=0;
  else begin
   stop<={stop[6:0],sw1};
	level1<={level1[6:0],sw2};
	level2<={level2[6:0],sw3};
	level3<={level3[6:0],sw4};
	time_set<={time_set[6:0],sw5};
  end
  
 always@(posedge clk, negedge reset) //주파수 설정 회로(200hz)
  if(!reset) cnt<=0;
  else begin
   if(cnt>269999) cnt<=0;
	else cnt<=cnt+1;
  end
  
 always@(posedge clk, negedge reset) //pwm 값 설정회로 및 led표시
  if(!reset) {pwm,led}<=0;
  else begin
   if(stop==1||flag_stop==1) begin
	 pwm<=0;
	 led<=3'b0;
	end
	else if(level1==1) begin
	 pwm<=70000;
	 led<=3'b100;
	end
	else if(level2==1) begin
	 pwm<=150000;
	 led<=3'b010;
	end
	else if(level3==1) begin
	 pwm<=250000;
	 led<=3'b001;
	end
  end
 
 always@(posedge clk, negedge reset)  //1초의 주파수를 만들어주는 회로 및 시간 감소
  if(!reset) {timer_cnt,min,sec,flag_stop}<=0;
  else begin
   if(mode==1) begin
	 if(time_set==1) min<=(min+10)%90;  //sw5를 누를 때 마다 10분씩 증가(90분이 넘어가면 초기화)
    if(timer_cnt>=53999999) begin      //1초의 주파수
	  timer_cnt<=0;
	  if(sec==0) begin
	   if(min!=0) sec<=59;  //시간 자동증가 방지
	   if(min==0) begin
	    min<=0;
		 //sec<=0;
		 flag_stop<=1;  //시간이 0분 0초가 되면 flag_stop이 1로
	   end
	   else min<=min-1;
	  end
	  else begin  //시간이 감소(flag_stop이 0으로 -> 정지를 막음)
	   flag_stop<=0;
		sec<=sec-1;
	  end
	 end
	 else timer_cnt<=timer_cnt+1;
   end
	else {timer_cnt,min,sec,flag_stop}<=0;  //mode가 0이되면 변수 초기화
  end
  
 always@(posedge clk, negedge reset) //스캔주파수(400hz)마다 fnd자리 변경(스캔방식)
  if(!reset) {scan_cnt,digit}<=0;
  else begin
   if(mode==1) begin
    if(scan_cnt>=134999) begin
	  scan_cnt<=0;
	  digit<=(digit+1)%4;
	 end
	 else scan_cnt<=scan_cnt+1;
   end
	else {scan_cnt,digit}<=0; //mode가 0이되면 초기화
  end
  
 always@(posedge clk, negedge reset)  //digit값에 따른 자릿수(digit 값은 400hz간격으로 변화한다.)
  if(!reset) begin
   fnd_num<=0;
	fnd_sel<=4'b1111;  //fnd를 전부 끈다.
  end
  else begin
   case(digit)
    0 : begin fnd_num=(sec/1)%10;  fnd_sel=4'b1110; end  //1의자리(초)
	 1 : begin fnd_num=(sec/10)%10; fnd_sel=4'b1101; end  //10의자리(초)
	 2 : begin fnd_num=(min/1)%10;  fnd_sel=4'b1011; end  //1의자리(분)
	 3 : begin fnd_num=(min/10)%10; fnd_sel=4'b0111; end  //10의자리(분)
   endcase
  end
  
 always@(fnd_num)  //fnd디코더
  if(digit==2) begin  //분의 1의자리에 dot표시
   case(fnd_num)
    4'b0000 : fnd_data = 8'b1011_1111; //0
	 4'b0001 : fnd_data = 8'b1000_0110; //1
	 4'b0010 : fnd_data = 8'b1101_1011; //2
	 4'b0011 : fnd_data = 8'b1100_1111; //3
    4'b0100 : fnd_data = 8'b1110_0110; //4
	 4'b0101 : fnd_data = 8'b1110_1101; //5
	 4'b0110 : fnd_data = 8'b1111_1101; //6
	 4'b0111 : fnd_data = 8'b1000_0111; //7
	 4'b1000 : fnd_data = 8'b1111_1111; //8
	 4'b1001 : fnd_data = 8'b1110_1111; //9
	 default : fnd_data = 8'b1000_0000; //null
   endcase
  end
  else begin
   case(fnd_num)
    4'b0000 : fnd_data = 8'b0011_1111; //0
	 4'b0001 : fnd_data = 8'b0000_0110; //1
	 4'b0010 : fnd_data = 8'b0101_1011; //2
	 4'b0011 : fnd_data = 8'b0100_1111; //3
    4'b0100 : fnd_data = 8'b0110_0110; //4
	 4'b0101 : fnd_data = 8'b0110_1101; //5
	 4'b0110 : fnd_data = 8'b0111_1101; //6
	 4'b0111 : fnd_data = 8'b0000_0111; //7
	 4'b1000 : fnd_data = 8'b0111_1111; //8
	 4'b1001 : fnd_data = 8'b0110_1111; //9
	 default : fnd_data = 8'b0000_0000; //null
   endcase
  end

endmodule
