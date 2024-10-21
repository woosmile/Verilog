module Serial_TX1(clk,reset,sw,tx_out);  //모듈 선언부

 input clk,reset,sw;  //입출력 선언부
 output reg tx_out;
 
 reg [15:0]bps_cnt;  //분주 카운트 변수
 reg clk_bps;
 
 reg [7:0]tx_data;  //전송할 값
 reg [3:0]tx_cnt;  //직렬 통신 카운트 변수
 reg tx_ready;  //송신 시작
 
 reg [7:0]sw_buff;
 
 parameter bps=5625;  //54000000/9600=5625
 
 always@(posedge clk, negedge reset)  //채터링 회로
  if(!reset) sw_buff<=8'b0;
  else sw_buff<={sw_buff[6:0],sw};
 
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
  end
  else begin
   if(sw_buff==8'b1111_1110) tx_ready<=1'b0;
   if(clk_bps==1) begin
	 tx_data<="A";
	 if(!tx_ready) begin  //송신 시작
	  tx_cnt<=tx_cnt+1;
	  if(tx_cnt==0) tx_out<=1'b0;  //Start Bit(0)
	  if(tx_cnt>0 && tx_cnt<9) tx_out<=tx_data[tx_cnt-1];  //0~7 LSB~MSB 순서로 송신
	  if(tx_cnt==9) begin  //Stop Bit(1)
	   tx_out<=1'b1;
		tx_ready<=1'b1;
		tx_cnt<=4'b0;
	  end
	 end
	end
  end
  
endmodule
