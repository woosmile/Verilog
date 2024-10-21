module ADC_PWM(clk,reset,eoc,start,ale,out_en,adc_clk,addr,result,led);  //모듈 선언부

 input clk,reset;  //입출력 선언부
 input eoc;
 input [7:0]result;
  
 output [2:0]addr;
 output start,ale,out_en,adc_clk;
 output led;
 
 adc_1 u0(.clk(clk),.reset(reset),.eoc(eoc),.start(start),.ale(ale),.out_en(out_en),.adc_clk(adc_clk),.addr(addr),.result(result));
 PWM u1(.clk(clk),.reset(reset),.pwm_in(result),.pwm_out(led));
 
endmodule
