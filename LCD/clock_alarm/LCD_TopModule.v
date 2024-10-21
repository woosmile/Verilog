module LCD_TopModule(clk,reset,lcd_rs,lcd_rw,lcd_en,lcd_data,sw,portA,spk);  //��� �����

 input clk,reset;  //����� �����
 input [3:0]sw;
 output lcd_rs,lcd_rw,lcd_en;
 output [7:0]lcd_data;
 output [1:0]portA;
 output spk;

 wire [5:0]sec,min;  //���� �����
 wire [4:0]hour;
 wire [27:0]cnt;
 wire [2:0]day_cnt;
 wire enable;

 LCD u0(.clk(clk),.reset(reset),.lcd_rs(lcd_rs),.lcd_rw(lcd_rw),.lcd_en(lcd_en),.lcd_data(lcd_data),.sec(sec),.min(min),.hour(hour),.cnt(cnt),.day_cnt(day_cnt));  //lcd ���
 clock_basic u1(.clk(clk),.reset(reset),.sec(sec),.min(min),.hour(hour),.sw(sw),.cnt(cnt),.day_cnt(day_cnt),.enable(enable));  //�ð� ���
 melody u2(.clk(clk),.reset(reset),.sw(enable),.portA(portA),.spk(spk));  //���� ���
 
endmodule
