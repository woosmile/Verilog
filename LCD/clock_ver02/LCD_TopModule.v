module LCD_TopModule(clk,reset,lcd_rs,lcd_rw,lcd_en,lcd_data,sw0,sw1,sw2);  //모듈 선언부

 input clk,reset,sw0,sw1,sw2;  //입출력 선언부
 output lcd_rs,lcd_rw,lcd_en;
 output [7:0]lcd_data;

 wire [5:0]sec,min;  //변수 선언부
 wire [4:0]hour;
 wire [27:0]cnt;
 wire [2:0]day_cnt;

 LCD u0(.clk(clk),.reset(reset),.lcd_rs(lcd_rs),.lcd_rw(lcd_rw),.lcd_en(lcd_en),.lcd_data(lcd_data),.sec(sec),.min(min),.hour(hour),.cnt(cnt),.day_cnt(day_cnt));  //lcd 모듈
 clock_basic u1(.clk(clk),.reset(reset),.sec(sec),.min(min),.hour(hour),.sw0(sw0),.sw1(sw1),.sw2(sw2),.cnt(cnt),.day_cnt(day_cnt));  //시계 모듈
 
endmodule
