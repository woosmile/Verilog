module ADC_Motor_PWM(clk,reset,dip_sw,eoc,start,ale,out_en,adc_clk,addr,result,fnd_data,fnd_en,fnd_sel,motor,portc,led);

 input clk,reset;
 input eoc;
 input [7:0]result;
 input [7:0]dip_sw;
 
 output [7:0]led;
 
 output [2:0]addr;
 output start,ale,out_en,adc_clk;
 
 output [7:0]fnd_data;
 output [3:0]fnd_sel;
 output fnd_en;
 
 output [2:0]motor;
 output [1:0]portc;
 
 wire [10:0]num;
 
 assign num=(result>dip_sw) ? result-dip_sw:1'b0;  //FND에 adc와 dip_sw의 차 표시
 
 adc_1 u0(.clk(clk),.reset(reset),.eoc(eoc),.start(start),.ale(ale),.out_en(out_en),.adc_clk(adc_clk),.addr(addr),.result(result),.led(led));  //adc회로
 DSP_4bitFND u1(.clk(clk),.rst(reset),.num(num),.fnd_data(fnd_data),.fnd_en(fnd_en),.fnd_sel(fnd_sel));  //FND회로
 Motor_PWM u2(.clk(clk),.reset(reset),.adc(result),.dip_sw(dip_sw),.portc(portc),.motor(motor));  //모터 회로
 
endmodule
