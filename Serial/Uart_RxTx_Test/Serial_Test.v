module Serial_Test(clk,reset,flag,tx_out,tx_data);  //모듈 선언부

 input clk,reset,flag;  //입출력 선언부
 input [7:0]tx_data;
 output reg tx_out;
 
 reg [15:0]bps_cnt;  //분주 카운트 변수
 reg clk_bps;
 
 reg [3:0]tx_cnt;  //직렬 통신 카운트 변수
 reg tx_ready;  //송신 시작
 reg once;
 
 parameter bps=5624;  //54000000/9600=5625
 
 always@(posedge clk, negedge reset)  //분주 회로
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
 
 always@(posedge clk, negedge reset)  //송신 회로
  if(!reset) begin
   tx_out<=1'b1;
	tx_cnt<=4'b0;
	tx_ready<=1'b1;
	once<=1'b0;
  end
  else begin
   if(flag!=once) tx_ready<=1'b0;  //처음에는 1!=0, 컴퓨터로 송신 완료하면 1!=1
   if(clk_bps==1) begin
	 if(!tx_ready) begin  //송신 시작
	  tx_cnt<=tx_cnt+1;
	  if(tx_cnt==0) tx_out<=1'b0;  //Start Bit(0)
	  if(tx_cnt>0 && tx_cnt<9) tx_out<=tx_data[tx_cnt-1];  //0~7 LSB~MSB 순서로 송신
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
