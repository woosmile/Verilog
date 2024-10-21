//모듈 선언부
module RS232_project(clk, reset, rxd,
							lcd_rs, lcd_rw, lcd_en, lcd_data,
							led);

input clk, reset, rxd;

output lcd_rs, lcd_rw, lcd_en;
output [7:0]lcd_data, led;

wire RS232_EN;
wire [7:0]rx_data;

wire [7:0]L0, L1, L2, L3, L4, L5; 
wire [7:0]L6, L7, L8, L9, L_A, L_B;
wire [7:0]L_C, L_D, L_E, L_F;

assign led = rx_data;

LCD u0(.clk(clk), .reset(reset), 
		 .lcd_rs(lcd_rs), .lcd_rw(lcd_rw), .lcd_en(lcd_en), .lcd_data(lcd_data),
		 .L0(L0), .L1(L1), .L2(L2), .L3(L3), .L4(L4), .L5(L5), 
		 .L6(L6), .L7(L7), .L8(L8), .L9(L9), .L_A(L_A), .L_B(L_B), 
		 .L_C(L_C), .L_D(L_D), .L_E(L_E), .L_F(L_F));
				
RXD u1(.clk(clk), .reset(reset), .rxd(rxd), .RS232_EN(RS232_EN), .rx_data(rx_data));

Data_Storage u2(.clk(clk), .reset(reset), .RS232_EN(RS232_EN), .RX_DATA(rx_data),
					 .data0(L0), .data1(L1), .data2(L2), .data3(L3), .data4(L4),
					 .data5(L5), .data6(L6), .data7(L7), .data8(L8), .data9(L9),
					 .dataA(L_A), .dataB(L_B), .dataC(L_C), .dataD(L_D), .dataE(L_E),
					 .dataF(L_F));

endmodule
