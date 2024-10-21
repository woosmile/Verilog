/*
module Serial_TX3(clk,reset,tx_out);  //��� �����(��������)

 input clk,reset;  //����� �����
 output reg tx_out;
 
 reg [15:0]bps_cnt;  //���� ī��Ʈ ����
 reg clk_bps;
 
 reg [7:0]tx_data,tx_temp;  //������ ��
 reg [3:0]tx_cnt;  //���� ��� ī��Ʈ ����
 reg tx_ready;  //�۽� ����
 
 reg [4:0]font_cnt;  //���ĺ� �ڸ� ����
 
 parameter bps=5625;  //54000000/9600=5625
 
 always@(posedge clk, negedge reset)  //���� ȸ��
  if(!reset) begin
   bps_cnt<=16'b0;
	clk_bps<=1'b0;
  end
  else begin
   if(bps_cnt>=bps) begin 
	 bps_cnt<=16'b0;
	 clk_bps<=1'b1;
	end
	else begin
	 bps_cnt<=bps_cnt+1;
	 clk_bps<=1'b0;
	end
  end
 
 always@(posedge clk, negedge reset)  //�۽� ȸ��
  if(!reset) begin
   tx_out<=1'b1;
	tx_cnt<=4'b0;
	tx_ready<=1'b1;
  end
  else begin
   if(clk_bps==1) begin
	 tx_data<=tx_temp;
	 tx_ready<=1'b0;
	 if(!tx_ready) begin  //�۽� ����
	  tx_cnt<=tx_cnt+1;
	  if(tx_cnt==0) tx_out<=1'b0;  //Start Bit(0)
	  if(tx_cnt>0 && tx_cnt<9) tx_out<=tx_data[tx_cnt-1];  //0~7 LSB~MSB ������ �۽�
	  if(tx_cnt==9) begin  //Stop Bit(1)
	   tx_out<=1'b1;
		tx_ready<=1'b1;
		tx_cnt<=4'b0;
	  end
	 end
	end
  end
  
 always@(posedge clk, negedge reset)  //font_cnt ���� ȸ��
  if(!reset) font_cnt<=5'b0;
  else begin
   if(tx_cnt==9 && clk_bps==1) begin  
	 if(font_cnt>=17) font_cnt<=5'b0;
	 else font_cnt<=font_cnt+1;
	end
  end
  
 always@(font_cnt)
  case(font_cnt)
   0 : tx_temp="\r";  //Ŀ�� Ȩ
   1 : tx_temp="H";
	2 : tx_temp="a";
   3 : tx_temp="v";
	4 : tx_temp="e";
   5 : tx_temp=" ";
	6 : tx_temp="a";
   7 : tx_temp=" ";
	8 : tx_temp="g";
   9 : tx_temp="o";
	10 : tx_temp="o";
   11 : tx_temp="d";
	12 : tx_temp=" ";
   13 : tx_temp="d";
	14 : tx_temp="a";
   15 : tx_temp="y";
	16 : tx_temp="!";
	17 : tx_temp="\n";  //�� ĭ �Ʒ���(enter)
	default : tx_temp="0";
  endcase
endmodule
*/
/*
module Serial_TX3(clk,reset,adc_value,tx_out);  //��� �����(��������)

 input clk,reset;  //����� �����
 input [7:0]adc_value;
 
 output reg tx_out;
 
 parameter bps=5625;  //54000000/9600=5625
 
 reg [15:0]bps_cnt;  //���� ī��Ʈ ����

 reg [7:0]tx_data;
 reg [7:0]tx_temp;  //������ ��
 reg [3:0]tx_cnt;  //���� ��� ī��Ʈ ����
 reg tx_ready;  //�۽� ����
 
 reg [2:0]font_cnt;  //���ĺ� �ڸ� ����
 
 wire [7:0]n100,n10,n1;  //����->����
 
 assign n100=(adc_value/100)%10;
 assign n10=(adc_value/10)%10;
 assign n1=adc_value%10;
 
 always@(posedge clk, negedge reset)  //���� ȸ��
  if(!reset) bps_cnt<=16'b0;
  else begin
   if(bps_cnt>=bps) bps_cnt<=16'b0;
	else bps_cnt<=bps_cnt+1;
  end
 
 always@(posedge clk, negedge reset)  //�۽� ȸ��
  if(!reset) begin
   tx_out<=1'b1;
	tx_cnt<=4'b0;
	tx_ready<=1'b1;
  end
  else begin
   if(bps_cnt>=bps) begin
	 tx_data<=tx_temp;
	 tx_ready<=1'b0;
	 if(!tx_ready) begin  //�۽� ����
	  tx_cnt<=tx_cnt+1;
	  if(tx_cnt==0) tx_out<=1'b0;  //Start Bit(0)
	  if(tx_cnt>0 && tx_cnt<9) tx_out<=tx_data[tx_cnt-1];  //0~7 LSB~MSB ������ �۽�
	  if(tx_cnt==9) begin  //Stop Bit(1)
	   tx_out<=1'b1;
		tx_ready<=1'b1;
		tx_cnt<=4'b0;
	  end
	 end
	end
  end
  
 always@(posedge clk, negedge reset)  //font_cnt ���� ȸ��
  if(!reset) font_cnt<=5'b0;
  else begin
   if(tx_cnt==9 && bps_cnt>=bps) begin  
	 if(font_cnt>=4) font_cnt<=5'b0;
	 else font_cnt<=font_cnt+1;
	end
  end
  
 always@(font_cnt,n100,n10,n1)
  case(font_cnt)
   0 : tx_temp="\r";
	1 : tx_temp=n100 + "0";
	2 : tx_temp=n10 + "0";
	3 : tx_temp=n1 + "0";
	4 : tx_temp="\n";
  endcase
endmodule
*/
module Serial_TX3(clk,reset,sw,adc_value,tx_out);  //��� �����(�������� + ����ġ)

 input clk,reset,sw;  //����� �����
 input [7:0]adc_value;
 
 output reg tx_out;
 
 reg [15:0]bps_cnt;  //���� ī��Ʈ ����

 reg [7:0]tx_data;
 reg [7:0]tx_temp [0:4];  //������ ��
 reg [3:0]tx_cnt;  //���� ��� ī��Ʈ ����
 reg tx_ready;  //�۽� ����
 
 reg [7:0]sw_buff;
 reg [4:0]font_cnt;  //���ĺ� �ڸ� ����
 reg tx_flag;
 
 wire [7:0]n100,n10,n1;  //����->����
 
 assign n100=(adc_value/100)%10;
 assign n10=(adc_value/10)%10;
 assign n1=adc_value%10;
 
 parameter bps=5625;  //54000000/9600=5625
 
 initial begin  //View Type
  tx_temp[0]="\r";
  tx_temp[1]="0";
  tx_temp[2]="0";
  tx_temp[3]="0";
  tx_temp[4]="\n";
 end
 
 always@(posedge clk, negedge reset)  //ä�͸� ȸ��
  if(!reset) sw_buff<=8'b0;
  else sw_buff<={sw_buff[6:0],sw};
 
 always@(posedge clk, negedge reset)  //���� ȸ��
  if(!reset) bps_cnt<=16'b0;
  else begin
   if(bps_cnt>=bps) bps_cnt<=16'b0;
	else bps_cnt<=bps_cnt+1;
  end
 
 always@(posedge clk, negedge reset)  //�۽� ȸ��
  if(!reset) begin
   tx_out<=1'b1;
	tx_cnt<=4'b0;
	tx_ready<=1'b1;
  end
  else begin
   if(tx_flag==1) tx_ready<=1'b0;
   if(bps_cnt>=bps) begin
	 tx_data<=tx_temp[font_cnt];
	 if(!tx_ready) begin  //�۽� ����
	  tx_cnt<=tx_cnt+1;
	  if(tx_cnt==0) tx_out<=1'b0;  //Start Bit(0)
	  if(tx_cnt>0 && tx_cnt<9) tx_out<=tx_data[tx_cnt-1];  //0~7 LSB~MSB ������ �۽�
	  if(tx_cnt==9) begin  //Stop Bit(1)
	   tx_out<=1'b1;
		tx_ready<=1'b1;
		tx_cnt<=4'b0;
	  end
	 end
	end
  end
 
 always@(posedge clk, negedge reset)  //tx_flag ���� ȸ��
  if(!reset) tx_flag<=1'b0;
  else begin
   if(sw_buff==8'b1111_1110) tx_flag<=1'b1;
	else if(tx_cnt==9 && bps_cnt>=bps) begin
	 if(font_cnt>=4) tx_flag<=1'b0;
	end
  end
  
 always@(posedge clk, negedge reset)  //font_cnt ���� ȸ��
  if(!reset) font_cnt<=5'b0;
  else begin
   if(tx_cnt==9 && bps_cnt>=bps) begin  
	 if(font_cnt>=4) font_cnt<=5'b0;
	 else font_cnt<=font_cnt+1;
	end
  end
 
 always@(font_cnt,n100,n10,n1)  //tx_temp�� ����
  case(font_cnt)
   0 : tx_temp[0]="\r";
	1 : tx_temp[1]=n100 + "0";
	2 : tx_temp[2]=n10 + "0";
	3 : tx_temp[3]=n1 + "0";
	4 : tx_temp[4]="\n";
  endcase
  
endmodule

