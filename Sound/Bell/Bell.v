module Bell(clk,reset,enable,spk,portA);  //모듈 선언부

 input clk,reset,enable;  //입출력 선언부
 
 output [1:0]portA;
 output reg spk;
 
 reg [2:0]state;  //상태값 변수
 
 reg [31:0]time_cnt,cnt,temp;  //카운트 변수
 reg [4:0]loop_cnt;

 parameter idle=3'b000, st_320=3'b001, st_480=3'b010;  //상태값 상수 선언
 parameter st_loop=3'b011, mute=3'b100;
 
 assign portA=(!reset) ? 2'b00:2'b01;
 
 always@(posedge clk, negedge reset)  //다음상태 결정 및 상태레지스터 회로ㄴ
  if(!reset) state<=idle;
  else begin
   case(state)
	 idle : begin
	  if(enable==1) state<=st_320;
	  else state<=idle;
	 end
	 st_320 : begin
	  if(time_cnt>=40499999) state<=st_480;  //0.75초 재생
	  else state<=st_320;
	 end
	 st_480 : begin
	  if(time_cnt>=40499999) state<=st_loop;  //0.75초 재생
	  else state<=st_480;
	 end
	 st_loop : begin
	  if(loop_cnt>=19) state<=mute;  //st_320, st_480을 20번 반복
	  else if(loop_cnt<19) state<=st_320;
	  else state<=st_loop;
	 end
	 mute : begin
	  if(time_cnt>=107999999) state<=idle;  //2초 지연
	  else state<=mute;
	 end
	 default : state<=idle;
	endcase
  end
  
 always@(state)  //상태값에 따른 출력(주파수 결정)
  case(state)
	idle : temp=0;
	st_320 : temp=168750;
	st_480 : temp=112500;
	st_loop : temp=0;
	mute : temp=0;
	default : temp=0;
  endcase
	
 always@(posedge clk, negedge reset)  //스피커에 인가되는 주파수 결정 회로
  if(!reset) begin
   cnt<=32'b0;
	spk<=1'b0;
  end
  else begin
   if(cnt>=temp/2) begin  //0과 1이 반복되므로 2를 나눠줌
	 cnt<=32'b0;
	 spk<=~spk;
	end
	else cnt<=cnt+1;
  end
 
 always@(posedge clk, negedge reset)  //0.75초, 20번 반복, 2초 지연 발생 회로
  if(!reset) begin
   time_cnt<=32'b0;
   loop_cnt<=5'b0;
  end
  else begin
   case(state)
	 idle : begin
	  time_cnt<=32'b0;
	  loop_cnt<=5'b0;
	 end
	 st_320 : begin
	  if(time_cnt>=40499999) time_cnt<=32'b0;
	  else time_cnt<=time_cnt+1;
	 end
	 st_480 : begin
	  if(time_cnt>=40499999) begin
	   time_cnt<=32'b0;
		if(loop_cnt>=19) loop_cnt<=0;
		else loop_cnt<=loop_cnt+1;
	  end
	  else time_cnt<=time_cnt+1;
	 end
	 st_loop : time_cnt<=32'b0;
	 mute : begin
	  if(time_cnt>=107999999) time_cnt<=0;
	  else time_cnt<=time_cnt+1;
	 end
	 default : begin
	  time_cnt<=32'b0;
	  loop_cnt<=5'b0;
	 end
	endcase
  end
  
endmodule
