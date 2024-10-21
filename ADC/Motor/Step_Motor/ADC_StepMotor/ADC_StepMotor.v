module ADC_StepMotor(clk,reset,led,dip_sw,eoc,start,ale,out_en,adc_clk,addr,result,fnd_data,fnd_en,fnd_sel,phase,portc);

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
 
 output [1:0]portc;
 output [3:0]phase;
 
 adc_1 u0(.clk(clk),.reset(reset),.eoc(eoc),.start(start),.ale(ale),.out_en(out_en),.adc_clk(adc_clk),.addr(addr),.result(result),.led(led));  //ADC 회로
 DSP_4bitFND u1(.clk(clk),.rst(reset),.num(result),.fnd_data(fnd_data),.fnd_en(fnd_en),.fnd_sel(fnd_sel));  //FND 회로
 Step_Motor u2(.clk(clk),.reset(reset),.portc(portc),.phase(phase),.adc(result));  //스텝모터 회로
 
endmodule
