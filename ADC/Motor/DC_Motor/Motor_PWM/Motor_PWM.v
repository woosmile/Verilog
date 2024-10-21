module Motor_PWM(clk,reset,adc,dip_sw,portc,motor);  //����� �����

 input clk,reset;
 input [7:0]adc,dip_sw;
 
 output [2:0]motor;
 output [1:0]portc;
 
 reg [31:0]cnt,grade;  //�� ����
 
 assign portc=(!reset) ? 2'b00:2'b01;  //����� ���� ��� ����
 
 assign motor[2]=dip_sw<adc;  //���� enable ����
 assign motor[1]=(cnt<grade);  //Duty-rate ����
 assign motor[0]=1'b0;
 
 always@(posedge clk, negedge reset)  //���ļ� �߻�ȸ��
  if(!reset) cnt<=32'b0;
  else begin
   if(cnt>=5399999) cnt<=32'b0;
	else cnt<=cnt+1;
  end
  
 always@(adc,dip_sw)  //adc-dip_sw�� ���� ���� grade(duty��) ����
  if(0<adc-dip_sw && adc-dip_sw<=64) grade<=1349999;
  else if(65<=adc-dip_sw && adc-dip_sw<=128) grade<=2699999;
  else if(129<=adc-dip_sw && adc-dip_sw<=192) grade<=4049999;
  else if(193<=adc-dip_sw && adc-dip_sw<=255) grade<=5399999;
  else grade<=0;
 
endmodule
