/*
module Serial_TX_ADC(clk,reset,tx_out,eoc,start,ale,out_en,adc_clk,addr,result,led);  //�ֻ��� ���

 input clk,reset;  //����� �����
 input eoc;
 input [7:0]result;
 
 output tx_out;
 output start,ale,out_en,adc_clk;
 output [2:0]addr;
 output [7:0]led;

 Serial_TX3 u0(.clk(clk),.reset(reset),.adc_value(led),.tx_out(tx_out));  //��� ���
 //ADC ��ȯ ���
 ADC1 u1(.clk(clk),.reset(reset),.adc_clk(adc_clk),.ale(ale),.start(start),.oe(out_en),.eoc(eoc),.adc_input(result),.addr(addr),.adc_data(led));
 
endmodule
*/

module Serial_TX_ADC(clk,reset,sw,tx_out,eoc,start,ale,out_en,adc_clk,addr,result,led);  //�ֻ��� ���

 input clk,reset,sw;  //����� �����
 input eoc;
 input [7:0]result;
 
 output tx_out;
 output start,ale,out_en,adc_clk;
 output [2:0]addr;
 output [7:0]led;

 Serial_TX3 u0(.clk(clk),.reset(reset),.sw(sw),.adc_value(led),.tx_out(tx_out));  //��� ���
 //ADC ��ȯ ���
 ADC1 u1(.clk(clk),.reset(reset),.adc_clk(adc_clk),.ale(ale),.start(start),.oe(out_en),.eoc(eoc),.adc_input(result),.addr(addr),.adc_data(led));
 
endmodule
