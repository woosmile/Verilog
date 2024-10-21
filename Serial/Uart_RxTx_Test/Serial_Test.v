module Serial_Test(clk,reset,flag,tx_out,tx_data);  //��� �����

 input clk,reset,flag;  //����� �����
 input [7:0]tx_data;
 output reg tx_out;
 
 reg [15:0]bps_cnt;  //���� ī��Ʈ ����
 reg clk_bps;
 
 reg [3:0]tx_cnt;  //���� ��� ī��Ʈ ����
 reg tx_ready;  //�۽� ����
 reg once;
 
 parameter bps=5624;  //54000000/9600=5625
 
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
	once<=1'b0;
  end
  else begin
   if(flag!=once) tx_ready<=1'b0;  //ó������ 1!=0, ��ǻ�ͷ� �۽� �Ϸ��ϸ� 1!=1
   if(clk_bps==1) begin
	 if(!tx_ready) begin  //�۽� ����
	  tx_cnt<=tx_cnt+1;
	  if(tx_cnt==0) tx_out<=1'b0;  //Start Bit(0)
	  if(tx_cnt>0 && tx_cnt<9) tx_out<=tx_data[tx_cnt-1];  //0~7 LSB~MSB ������ �۽�
	  if(tx_cnt==9) begin  //Stop Bit(1)
	   tx_out<=1'b1;
		tx_ready<=1'b1;
		tx_cnt<=4'b0;
		once<=once+1;
	  end
	 end
	end
  end
  
endmodule
