module Step_Motor(clk,reset,portc,phase,adc);  //모듈 선언부

 input clk,reset;
 input [7:0]adc;  //adc 값을 받음
 
 output reg [3:0]phase;  //스텝모터
 output [1:0]portc;  
 
 reg [31:0]clk_cnt;
 reg [1:0]step;
 reg clk_div;
 
 parameter A=4'b0001;  //상수 값 설정
 parameter A_bar=4'b0010;
 parameter B=4'b0100;
 parameter B_bar=4'b1000;
 
 assign portc=(!reset) ? 2'b00:2'b01;  //양방향 버퍼 출력 설정
 
 always@(posedge clk, negedge reset)  //adc값에 따른 주파수 변화 회로
  if(!reset) begin
   clk_cnt<=32'b0;
	clk_div<=1'b0;
  end
  else begin
   if(clk_cnt>=adc*5000) begin
	 clk_cnt<=0;
	 clk_div<=1'b1;
	end
	else begin
	 clk_cnt<=clk_cnt+1;
	 clk_div<=1'b0;
	end
  end
  
 always@(posedge clk, negedge reset)  //clk_div 값이 1이 될 때마다 상이 이동됨
  if(!reset) step<=2'b0;
  else begin
   if(clk_div==1) step<=step+1;
  end
  
 always@(step,adc)  //A -> B -> A_bar -> B_bar
  if(adc==0) phase<=4'b0;
  else begin
   case(step)
    0 : phase=A;
	 1 : phase=B;
	 2 : phase=A_bar;
	 3 : phase=B_bar;
   endcase
  end
  
endmodule

  