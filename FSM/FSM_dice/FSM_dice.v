module FSM_dice(clk,reset,rs,cl,led);  //모듈 선언부

 input clk,reset;  //입출력 선언부
 input rs,cl;
 output reg [6:0]led;
 
 reg [27:0]cnt;  //변수 선언부
 reg [7:0]rs_buff,cl_buff;
 reg [6:0]random[0:16];
 reg [3:0]i;
 reg [1:0]state;
 
 parameter idle=2'b00, run=2'b01, stop=2'b10;  //상수 선언
 
 initial begin  //LED(주사위) 초기화 구문
  random[0]=7'b0011100;
  random[1]=7'b1110111;
  random[2]=7'b0001000;
  random[3]=7'b0010100;
  random[4]=7'b0111110;
  random[5]=7'b0001000;
  random[6]=7'b0110110;
  random[7]=7'b0001000;
  random[8]=7'b0011100;
  random[9]=7'b0010100;
  random[10]=7'b1110111;
  random[11]=7'b0001000;
  random[12]=7'b0110110;
  random[13]=7'b1110111;
  random[14]=7'b0011100;
  random[15]=7'b0010100;
 end

 always@(posedge clk, negedge reset)  //채터링 방지 회로
  if(!reset) {rs_buff,cl_buff}<=8'b0;
  else begin
   rs_buff<={rs_buff[6:0],rs};
	cl_buff<={cl_buff[6:0],cl};
  end
  
 always@(posedge clk, negedge reset)  //다음상태 결정 및 현재상태 천이 회로
  if(!reset) state<=idle;
  else begin
   case(state)
	 idle : begin 
	  if(rs_buff==1) state<=run;
	  else           state<=idle;
	 end
	 run : begin
	  if(rs_buff==1)      state<=stop;
	  else if(cl_buff==1) state<=idle;
	  else state<=run;
	 end
	 stop : begin
	  if(rs_buff==1)      state<=run;
	  else if(cl_buff==1) state<=idle;
	  else                state<=stop;
	 end
	 default : state<=idle;
	endcase
  end
  
 always@(posedge clk, negedge reset)  //0.05초마다 i값 증가
  if(!reset) begin
   cnt<=28'b0;
	i<=4'b0;
  end
  else begin
   if(state==run) begin
    if(cnt>=2699999) begin  //0.05
	  cnt<=0;
	  i<=i+1;
	 end
	 else cnt<=cnt+1;
	end
  end
  
 always@(state)  //현재상태에 따른 출력 회로
  case(state)
   idle : led=7'b0;
	run  : led=random[i];  //0.05초 마다 led값을 변화 시킴
	stop : led=random[i];
	default : led=7'b0;
  endcase

endmodule

  