module LCD3(clk,reset,lcd_rs,lcd_rw,lcd_en,lcd_data,dipsw,resistor);  //��� �����

 input clk,reset;  //����� �����
 input [7:0]dipsw;
 input [9:0]resistor;
 output reg [7:0]lcd_data;
 output reg lcd_rs,lcd_en;
 output lcd_rw;
 
 reg [2:0]state;  //���� �����
 reg [31:0]cnt_5ms;
 reg [4:0]cnt_100ms,cnt_50ms;
 reg [5:0]line;
 
 wire [3:0]n100,n10,n1;
 wire [3:0]r1000,r100,r10,r1;
 
 wire [31:0]cnt_5ms_half;  
 assign cnt_5ms_half=202499;
 
 parameter delay_100ms=0;  //����� ����
 parameter function_set=1;
 parameter disp_clear=2;
 parameter disp_on=3;
 parameter entry_mode=4;
 parameter disp_data=5;
 parameter delay_5ms=6;
 
 assign lcd_rw=1'b0;  //���� ���
 
 assign n100=(dipsw/100)%10;
 assign n10=(dipsw/10)%10;
 assign n1=dipsw%10;
 
 assign r1000=(resistor/1000)%10;
 assign r100=(resistor/100)%10;
 assign r10=(resistor/10)%10;
 assign r1=resistor%10;
 
 always@(posedge clk, negedge reset)  //5ms �߻���
  if(!reset) cnt_5ms<=18'b0;
  else begin
   if(cnt_5ms>=269999) cnt_5ms<=18'b0;
	else cnt_5ms<=cnt_5ms+1;
  end
  
 always@(posedge clk, negedge reset)  //100ms �߻���(5*20)
  if(!reset) cnt_100ms<=5'b0;
  else begin
   if(state==delay_100ms) begin
	 if(cnt_5ms>=269999) begin 
	  if(cnt_100ms>=19) cnt_100ms<=5'b0;
	  else cnt_100ms<=cnt_100ms+1;
	 end
	end
	else cnt_100ms<=5'b0;
  end
  
 always@(posedge clk, negedge reset)  //50ms �߻���(5*10)
  if(!reset) cnt_50ms<=5'b0;
  else begin
   if(state==delay_5ms) begin
	 if(cnt_5ms>=269999) begin
	  if(cnt_50ms>=9) cnt_50ms<=5'b0;
	  else cnt_50ms<=cnt_50ms+1;
	 end
	end
	else cnt_50ms<=5'b0;
  end
 
 always@(posedge clk, negedge reset)  //5ms���� line �� ����(�� �ڸ��� �´� �� ǥ��)
  if(!reset) line<=5'b0;
  else begin
   if(state==disp_data) begin
	 if(cnt_5ms>=269999) begin
	  if(line>=35) line<=5'b0;
	  else line<=line+1;
	 end
	end
	else line<=5'b0;
  end
 
 always@(posedge clk, negedge reset)  //lcd_en ���Ǻ�
  if(!reset) lcd_en<=1'b0;
  else begin 
   if(state==delay_100ms || state==delay_5ms) lcd_en<=1'b0;
	else begin
	 if(cnt_5ms>=67499 && cnt_5ms<=cnt_5ms_half) lcd_en<=1'b1;
	 else lcd_en<=1'b0;
	end
  end
  
 always@(posedge clk, negedge reset)  //���� �������� + ���� õ��ȸ��
  if(!reset) state<=delay_100ms;
  else begin
  if(cnt_5ms==0) begin  //5ms���� 0�̵ȴ�.(�̷����� ���°��� 5ms�� �����ǹǷ� Ÿ�ֵ̹��� ���� ������ �����Ѵ�.)
	 case(state)
	  delay_100ms : begin
	   if(cnt_100ms>=19) state<=function_set;
		else state<=delay_100ms;
	  end
	  function_set : state<=disp_clear;
	  disp_clear : state<=disp_on;
	  disp_on : state<=entry_mode;
	  entry_mode : state<=disp_data;
	  disp_data : begin
	   if(line>=33) state<=delay_5ms;
		else state<=disp_data;
	  end
	  delay_5ms : begin
	   if(cnt_50ms>=1) state<=disp_data;
		else state<=delay_5ms;
	  end
	  default : state<=delay_100ms;
	 endcase
	end
  end
  
 always@(state,line)  //���°��� ���� ���ȸ��
  case(state)
   delay_100ms : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0;
	end
	function_set : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0011_1000;
	end
	disp_clear : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0000_0001;
	end
	disp_on : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0000_1100;
	end
	entry_mode : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0000_0110;
	end
	disp_data : begin
	 case(line)
	  0 : {lcd_rs,lcd_data}={1'b0,8'b1000_0000};  //line1
	  1 : {lcd_rs,lcd_data}={1'b1,"R"};
	  2 : {lcd_rs,lcd_data}={1'b1,"V"};
	  3 : {lcd_rs,lcd_data}={1'b1,"a"};
	  4 : {lcd_rs,lcd_data}={1'b1,"l"};
	  5 : {lcd_rs,lcd_data}={1'b1,"u"};
	  6 : {lcd_rs,lcd_data}={1'b1,"e"};
	  7 : {lcd_rs,lcd_data}={1'b1,8'b0011_1010};  //:
	  8 : {lcd_rs,lcd_data}={1'b1,r1000|8'h30};
	  9 : {lcd_rs,lcd_data}={1'b1,r100|8'h30};
	  10 : {lcd_rs,lcd_data}={1'b1,8'b0010_1110};  // .
	  11 : {lcd_rs,lcd_data}={1'b1,r10|8'h30};
	  12 : {lcd_rs,lcd_data}={1'b1,r1|8'h30};
	  13 : {lcd_rs,lcd_data}={1'b1,"k"};
	  14 : {lcd_rs,lcd_data}={1'b1,"o"};
	  15 : {lcd_rs,lcd_data}={1'b1,"h"};
	  16 : {lcd_rs,lcd_data}={1'b1,"m"};
	  17 : {lcd_rs,lcd_data}={1'b0,8'b1100_0000};  //line2
	  18 : {lcd_rs,lcd_data}={1'b1," "};
	  19 : {lcd_rs,lcd_data}={1'b1,"A"};
	  20 : {lcd_rs,lcd_data}={1'b1,"D"};
	  21 : {lcd_rs,lcd_data}={1'b1,"C"};
	  22 : {lcd_rs,lcd_data}={1'b1," "};
	  23 : {lcd_rs,lcd_data}={1'b1,"D"};
	  24 : {lcd_rs,lcd_data}={1'b1,"a"};
	  25 : {lcd_rs,lcd_data}={1'b1,"t"};
	  26 : {lcd_rs,lcd_data}={1'b1,"a"};
	  27 : {lcd_rs,lcd_data}={1'b1," "};
	  28 : {lcd_rs,lcd_data}={1'b1,8'b0011_1010};  //:
	  29 : {lcd_rs,lcd_data}={1'b1," "};
	  30 : {lcd_rs,lcd_data}={1'b1,n100|8'h30};  //0~9�� �ش��ϴ� ������ ASCII�ڵ�� ����� 8'h30�� ���ؾ� �Ѵ�.
	  31 : {lcd_rs,lcd_data}={1'b1,n10|8'h30};
	  32 : {lcd_rs,lcd_data}={1'b1,n1|8'h30};
	  default : {lcd_rs,lcd_data}={1'b0,8'b0};
	 endcase
	end
	delay_5ms : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0;
	end
   default : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0;
	end
  endcase

endmodule
