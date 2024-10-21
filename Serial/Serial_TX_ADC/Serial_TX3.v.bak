/*
module Serial_TX3(clk,reset,tx_out);  //모듈 선언부(문장전송)

 input clk,reset;  //입출력 선언부
 output reg tx_out;
 
 reg [15:0]bps_cnt;  //분주 카운트 변수
 reg clk_bps;
 
 reg [7:0]tx_data,tx_temp;  //전송할 값
 reg [3:0]tx_cnt;  //직렬 통신 카운트 변수
 reg tx_ready;  //송신 시작
 
 reg [4:0]font_cnt;  //알파벳 자리 변수
 
 parameter bps=5625;  //54000000/9600=5625
 
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
   if(clk_bps==1) begin
	 tx_data<=tx_temp;
	 tx_ready<=1'b0;
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
  
 always@(posedge clk, negedge reset)  //font_cnt 증가 회로
  if(!reset) font_cnt<=5'b0;
  else begin
   if(tx_cnt==9 && clk_bps==1) begin  
	 if(font_cnt>=17) font_cnt<=5'b0;
	 else font_cnt<=font_cnt+1;
	end
  end
  
 always@(font_cnt)
  case(font_cnt)
   0 : tx_temp="\r";  //커서 홈
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
	17 : tx_temp="\n";  //한 칸 아래로(enter)
	default : tx_temp="0";
  endcase
endmodule
*/

module Serial_TX3(clk,reset,sw,tx_out);  //모듈 선언부(문장전송 + 스위치)

 input clk,reset,sw;  //입출력 선언부
 output reg tx_out;
 
 reg [15:0]bps_cnt;  //분주 카운트 변수

 reg [7:0]tx_data;
 reg [7:0]tx_temp [0:17];  //전송할 값
 reg [3:0]tx_cnt;  //직렬 통신 카운트 변수
 reg tx_ready;  //송신 시작
 
 reg [7:0]sw_buff;
 reg [4:0]font_cnt;  //알파벳 자리 변수
 reg tx_flag;
 
 parameter bps=5625;  //54000000/9600=5625
 
 initial begin
  tx_temp[0]="\r";
  tx_temp[1]="H";
  tx_temp[2]="a";
  tx_temp[3]="v";
  tx_temp[4]="e";
  tx_temp[5]=" ";
  tx_temp[6]="a";
  tx_temp[7]=" ";
  tx_temp[8]="g";
  tx_temp[9]="o";
  tx_temp[10]="o";
  tx_temp[11]="d";
  tx_temp[12]=" ";
  tx_temp[13]="d";
  tx_temp[14]="a";
  tx_temp[15]="y";
  tx_temp[16]="!";
  tx_temp[17]="\n";
 end
 
 always@(posedge clk, negedge reset)  //채터링 회로
  if(!reset) sw_buff<=8'b0;
  else sw_buff<={sw_buff[6:0],sw};
 
 always@(posedge clk, negedge reset)  //분주 회로
  if(!reset) bps_cnt<=16'b0;
  else begin
   if(bps_cnt>=bps) bps_cnt<=16'b0;
	else bps_cnt<=bps_cnt+1;
  end
 
 always@(posedge clk, negedge reset)  //송신 회로
  if(!reset) begin
   tx_out<=1'b1;
	tx_cnt<=4'b0;
	tx_ready<=1'b1;
  end
  else begin
   if(tx_flag==1) tx_ready<=1'b0;
   if(bps_cnt>=bps) begin
	 tx_data<=tx_temp[font_cnt];
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
 
 always@(posedge clk, negedge reset)  //tx_flag 결정 회로
  if(!reset) tx_flag<=1'b0;
  else begin
   if(sw_buff==8'b1111_1110) tx_flag<=1'b1;
	else if(tx_cnt==9 && bps_cnt>=bps) begin
	 if(font_cnt>=17) tx_flag<=1'b0;
	end
  end
  
 always@(posedge clk, negedge reset)  //font_cnt 증가 회로
  if(!reset) font_cnt<=5'b0;
  else begin
   if(tx_cnt==9 && bps_cnt>=bps) begin  
	 if(font_cnt>=17) font_cnt<=5'b0;
	 else font_cnt<=font_cnt+1;
	end
  end
  
endmodule
