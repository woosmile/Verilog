module LCD(clk,reset,lcd_rs,lcd_rw,lcd_en,lcd_data);  //��� �����

 input clk,reset;  //����� �����
 output reg [7:0]lcd_data;
 output reg lcd_rs,lcd_en;
 output lcd_rw;
 
 reg [2:0]state;  //���� �����
 reg [31:0]cnt_5ms;
 reg [10:0]cnt_100ms,cnt_50ms;
 reg [7:0]line,comp_line;
 reg frame=0;
 
 wire [31:0]cnt_5ms_half;  
 assign cnt_5ms_half=202499;
 
 parameter delay_100ms=0;  //����� ����
 parameter function_set=1;
 parameter disp_clear=2;
 parameter disp_on=3;
 parameter entry_mode=4;
 parameter disp_data=5;
 parameter delay_2s=6;
 
 assign lcd_rw=1'b0;  //���� ���
 
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
   if(state==delay_2s) begin
	 if(cnt_5ms>=269999) begin
	  if(cnt_50ms>=399) cnt_50ms<=5'b0;
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
	  if(line>=comp_line) line<=5'b0;
	  else line<=line+1;
	 end
	end
	else line<=5'b0;
  end
 
 always@(posedge clk, negedge reset)  //lcd_en ���Ǻ�
  if(!reset) lcd_en<=1'b0;
  else begin 
   if(state==delay_100ms || state==delay_2s) lcd_en<=1'b0;
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
	   if(line>=comp_line) state<=delay_2s;
		else state<=disp_data;
	  end
	  delay_2s : begin
	   if(cnt_50ms>=399) begin  //2�� ����(50ms * 400)
		 state<=disp_data;
		 frame<=~frame;  //2�ʸ��� frame ����
		end
		else state<=delay_2s;
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
	 if(frame==0) begin
	  case(line)
	   0 : {lcd_rs,lcd_data}={1'b0,8'b1000_0000};
	   1 : {lcd_rs,lcd_data}={1'b1," "};
	   2 : {lcd_rs,lcd_data}={1'b1,"D"};
	   3 : {lcd_rs,lcd_data}={1'b1,"i"};
	   4 : {lcd_rs,lcd_data}={1'b1,"g"};
	   5 : {lcd_rs,lcd_data}={1'b1,"i"};
	   6 : {lcd_rs,lcd_data}={1'b1,"t"};
	   7 : {lcd_rs,lcd_data}={1'b1,"a"};
	   8 : {lcd_rs,lcd_data}={1'b1,"l"};
	   9 : {lcd_rs,lcd_data}={1'b1," "};
	   10 : {lcd_rs,lcd_data}={1'b1,"D"};
	   11 : {lcd_rs,lcd_data}={1'b1,"e"};
	   12 : {lcd_rs,lcd_data}={1'b1,"s"};
	   13 : {lcd_rs,lcd_data}={1'b1,"i"};
	   14 : {lcd_rs,lcd_data}={1'b1,"g"};
	   15 : {lcd_rs,lcd_data}={1'b1,"n"};
	   16 : {lcd_rs,lcd_data}={1'b1," "};
	   17 : {lcd_rs,lcd_data}={1'b0,8'b1100_0000};
	   18 : {lcd_rs,lcd_data}={1'b1,"W"};
	   19 : {lcd_rs,lcd_data}={1'b1,"i"};
	   20 : {lcd_rs,lcd_data}={1'b1,"t"};
	   21 : {lcd_rs,lcd_data}={1'b1,"h"};
	   22 : {lcd_rs,lcd_data}={1'b1," "};
	   23 : {lcd_rs,lcd_data}={1'b1,"V"};
	   24 : {lcd_rs,lcd_data}={1'b1,"e"};
	   25 : {lcd_rs,lcd_data}={1'b1,"r"};
	   26 : {lcd_rs,lcd_data}={1'b1,"i"};
	   27 : {lcd_rs,lcd_data}={1'b1,"l"};
	   28 : {lcd_rs,lcd_data}={1'b1,"o"};
	   29 : {lcd_rs,lcd_data}={1'b1,"g"};
	   30 : {lcd_rs,lcd_data}={1'b1," "};
	   31 : {lcd_rs,lcd_data}={1'b1,"H"};
	   32 : {lcd_rs,lcd_data}={1'b1,"D"};
	   33 : {lcd_rs,lcd_data}={1'b1,"L"};
	   default : {lcd_rs,lcd_data}={1'b0,8'b0};
	  endcase
	 end
	 else begin
	  case(line)
	   0 : {lcd_rs,lcd_data}={1'b0,8'b1000_0000};
		1 : {lcd_rs,lcd_data}={1'b0,8'b0000_0001};
	   2 : {lcd_rs,lcd_data}={1'b1," "};
	   3 : {lcd_rs,lcd_data}={1'b1,"Y"};
	   4 : {lcd_rs,lcd_data}={1'b1,"o"};
	   5 : {lcd_rs,lcd_data}={1'b1,"u"};
	   6 : {lcd_rs,lcd_data}={1'b1,"r"};
	   7 : {lcd_rs,lcd_data}={1'b1," "};
	   8 : {lcd_rs,lcd_data}={1'b1,"N"};
	   9 : {lcd_rs,lcd_data}={1'b1,"a"};
	   10 : {lcd_rs,lcd_data}={1'b1,"m"};
	   11 : {lcd_rs,lcd_data}={1'b1,"e"};
	   12 : {lcd_rs,lcd_data}={1'b1,":"};
	   13 : {lcd_rs,lcd_data}={1'b0,8'b1100_0000};
	   14 : {lcd_rs,lcd_data}={1'b1," "};
	   15 : {lcd_rs,lcd_data}={1'b1,"K"};
	   16 : {lcd_rs,lcd_data}={1'b1,"i"};
	   17 : {lcd_rs,lcd_data}={1'b1,"m"};
	   18 : {lcd_rs,lcd_data}={1'b1," "};
	   19 : {lcd_rs,lcd_data}={1'b1,"W"};
	   20 : {lcd_rs,lcd_data}={1'b1,"o"};
	   21 : {lcd_rs,lcd_data}={1'b1,"o"};
	   22 : {lcd_rs,lcd_data}={1'b1," "};
	   23 : {lcd_rs,lcd_data}={1'b1,"S"};
	   24 : {lcd_rs,lcd_data}={1'b1,"e"};
	   25 : {lcd_rs,lcd_data}={1'b1,"o"};
	   26 : {lcd_rs,lcd_data}={1'b1,"n"};
	   27 : {lcd_rs,lcd_data}={1'b1,"g"};
		default : {lcd_rs,lcd_data}={1'b0,8'b0};
	  endcase
	 end
	end
	delay_2s : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0000_0000;
	end
   default : begin
	 lcd_rs=1'b0;
	 lcd_data=8'b0;
	end
  endcase
  
 always@(frame)  //frame ���� ���� line�񱳰� ����
  if(frame==0) comp_line=34;
  else comp_line=28;
  
endmodule
