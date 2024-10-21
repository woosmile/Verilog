module Motor_PWM(clk,reset,adc,dip_sw,portc,motor);  //입출력 선언부

 input clk,reset;
 input [7:0]adc,dip_sw;
 
 output [2:0]motor;
 output [1:0]portc;
 
 reg [31:0]cnt,grade;  //비교 변수
 
 assign portc=(!reset) ? 2'b00:2'b01;  //양방향 버퍼 출력 설정
 
 assign motor[2]=dip_sw<adc;  //모터 enable 조건
 assign motor[1]=(cnt<grade);  //Duty-rate 설정
 assign motor[0]=1'b0;
 
 always@(posedge clk, negedge reset)  //주파수 발생회로
  if(!reset) cnt<=32'b0;
  else begin
   if(cnt>=5399999) cnt<=32'b0;
	else cnt<=cnt+1;
  end
  
 always@(adc,dip_sw)  //adc-dip_sw의 값에 따른 grade(duty비) 설정
  if(0<adc-dip_sw && adc-dip_sw<=64) grade<=1349999;
  else if(65<=adc-dip_sw && adc-dip_sw<=128) grade<=2699999;
  else if(129<=adc-dip_sw && adc-dip_sw<=192) grade<=4049999;
  else if(193<=adc-dip_sw && adc-dip_sw<=255) grade<=5399999;
  else grade<=0;
 
endmodule
