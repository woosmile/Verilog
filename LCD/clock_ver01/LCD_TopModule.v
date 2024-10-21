module LCD_TopModule(clk,reset,lcd_rs,lcd_rw,lcd_en,lcd_data,sw0,sw1);  //모듈 선언부

 input clk,reset,sw0,sw1;  //입출력 선언부
 output lcd_rs,lcd_rw,lcd_en;
 output [7:0]lcd_data;

 wire [5:0]sec,min;  //변수 선언부
 wire [4:0]hour;

 LCD u0(.clk(clk),.reset(reset),.lcd_rs(lcd_rs),.lcd_rw(lcd_rw),.lcd_en(lcd_en),.lcd_data(lcd_data),.sec(sec),.min(min),.hour(hour));  //lcd 모듈
 clock_basic u1(.clk(clk),.reset(reset),.sec(sec),.min(min),.hour(hour),.sw0(sw0),.sw1(sw1));  //시계 모듈
 
endmodule
