module LCD_ADC(clk,reset,rs,rw,lcd_en,lcd_data,result,eoc,start,ale,out_en,adc_clk,addr,led);

 input clk,reset;  //입출력 선언부
 input eoc;
 input [7:0]result;
 
 output rs,rw,lcd_en;
 output [7:0]lcd_data;
 output start,ale,out_en,adc_clk;
 output [2:0]addr;
 output [7:0]led;
 
 wire [9:0]resistor;
 assign resistor=(1000*result)/255;  //10kOhm 수식
 
 adc_1 u0(.clk(clk),.reset(reset),.eoc(eoc),.start(start),.ale(ale),.out_en(out_en),.adc_clk(adc_clk),.addr(addr),.result(result),.led(led));
 LCD3 u1(.clk(clk),.reset(reset),.lcd_rs(rs),.lcd_rw(rw),.lcd_en(lcd_en),.lcd_data(lcd_data),.dipsw(result),.resistor(resistor));

endmodule
