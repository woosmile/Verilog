//응용과제
module stepmotor_0303(clk,reset,push_sw,dip_sw,step_phase,portc);  //모듈 선언부

 input clk,reset; 
 input [3:0]dip_sw;
 input [2:0]push_sw;

 output [3:0]step_phase;
 output [1:0]portc;
 
 reg [3:0]step_phase;
 reg [2:0]step;
 
 reg [31:0]clk_cnt,rotate,speed;
 reg [7:0]sw_buff0,sw_buff1,sw_buff2;
 reg stop_flag;
 reg clk_div;
 reg one,two,one_two;
 
 parameter A=4'b0001; 
 parameter A_bar=4'b0010;
 parameter B=4'b0100;
 parameter B_bar=4'b1000;
 
 assign portc=(!reset) ? 2'b00:2'b01;
 
 always@(posedge clk, negedge reset)  //채터링 회로
  if(!reset) {sw_buff0,sw_buff1,sw_buff2}<=0;
  else begin
   sw_buff0<={sw_buff0[6:0],push_sw[0]};
	sw_buff1<={sw_buff1[6:0],push_sw[1]};
	sw_buff2<={sw_buff2[6:0],push_sw[2]};
  end
  
 always@(posedge clk, negedge reset)  //분주회로
  if(!reset) {clk_cnt,clk_div}<=0;
  else begin
   if(clk_cnt>=speed) begin clk_cnt<=0; clk_div<=1; end
	else begin clk_cnt<=clk_cnt+1; clk_div<=0; end
  end
  
 always@(posedge clk, negedge reset)  //스위치 값에 따른 여자방식, 회전각 결정 회로
  if(!reset) {one,two,one_two}<=0;
  else begin
   if(sw_buff0==1) {one,two,one_two}<=3'b001;
	else if(sw_buff1==1) {one,two,one_two}<=3'b010;
	else if(sw_buff2==1) {one,two,one_two}<=3'b100;
  end
  
 always@(posedge clk, negedge reset)  //모터 제어 회로
  if(!reset) {rotate,stop_flag}<=0;
  else begin
  
   if(sw_buff0==1 || sw_buff1==1 || sw_buff2==1) begin  //스위치 값이 눌리면 변수 초기화
	 stop_flag<=0;
	 step<=0;
	 rotate<=0;
	end
	
	if(clk_div==1) begin  //분주된 주파수에 따라 동작
	 if(one==1) begin
	  if(rotate>=50) stop_flag<=1;
	  else begin
	   rotate<=rotate+1;
	   step<=(step+1)%4;
	   //stop_flag<=0;
	  end
	 end
	 
	 else if(two==1) begin
	  if(rotate>=200) stop_flag<=1;
	  else begin
	   rotate<=rotate+1;
	   step<=(step+1)%4;
	   //stop_flag<=0;
	  end
	 end
	 
	 else if(one_two==1) begin
	  if(rotate>=400) stop_flag<=1;
	  else begin
	   rotate<=rotate+1; 
	   step<=step+1;
	   //stop_flag<=0;
	  end
    end
	 //else {rotate,step,stop_flag}<=0;
   end
  end

 always@(step)  //디코더 회로
  if(stop_flag==0) begin
   if(one==1) begin  //1상
    case(step)
     0 : step_phase=A;
	  1 : step_phase=B;
	  2 : step_phase=A_bar;
	  3 : step_phase=B_bar;
    endcase
   end
	else if(two==1) begin  //2상
	 case(step)
	  0 : step_phase=A|B_bar;
	  1 : step_phase=A|B;
	  2 : step_phase=B|A_bar;
	  3 : step_phase=A_bar|B_bar;
	 endcase
	end
	else if(one_two==1) begin  //1-2상
	 case(step)
     0 : step_phase=A;
	  1 : step_phase=A|B;
	  2 : step_phase=B;
	  3 : step_phase=B|A_bar;
	  4 : step_phase=A_bar;
	  5 : step_phase=A_bar|B_bar;
	  6 : step_phase=B_bar;
	  7 : step_phase=B_bar|A;
    endcase
	end
  end
  else step_phase=4'b0000;
 
 always@(dip_sw)  //디코더 회로
  case(dip_sw)
   1 : speed=100000;
	2 : speed=300000;
	4 : speed=500000;
	8 : speed=700000;
	default : speed=0;
  endcase
  
endmodule


