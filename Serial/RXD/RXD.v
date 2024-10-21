////���� 
//module RXD(clk, reset, rxd, rx_data);
//
//input clk, reset, rxd;
//
//output [7:0]rx_data;
//
//reg [7:0]rx_data;
//
//parameter baud_rate = 5625; //=54MHz / 9600bps
//parameter cnt_half = 5625/2;//start��ȣ���� 
//
//reg start; //������ ���� flag  start=0: ȸ�� ��������, start=1: �����ͼ��� ���  
//reg [7:0] rdata; //���ŵ����� �ӽ÷� �����ϱ� ���� �������� 
//integer  st_cnt, r_cnt; // st_cnt: start_bit check cnt, r_cnt: ������ ���� ��żӵ� cnt
//integer  rdata_cnt;//���ŵ����� bit cnt 
//
//always @(posedge clk, negedge reset)
//begin
//   if(!reset) 
//	   begin
//	      start <= 0;
//		   st_cnt <= 0;
//		   rdata_cnt <= 0;
//		end
//	else 
//	   begin
//			if(start==0 && rxd==0) // start bit check, �������¿��� 0�� ���ŵǸ� 
//				begin 
//					if(st_cnt >= cnt_half) // 0�� �����ð� ���� �����Ǹ� start bit�� �ν� 
//						begin
//							start<=1; // ������ ���� ���� ���� ���� 
//							st_cnt <= 0;
//						end
//					else 
//						begin
//							start <= 0;
//							st_cnt <= st_cnt+1;
//						end
//				end
//			else if(start==1)
//			begin
//				if(r_cnt >= baud_rate) // 9600bps�ӵ�  
//					begin
//						r_cnt <= 0;
//						if(rdata_cnt >= 8)  //���ŵ����� bit ī��Ʈ   
//							begin
//								rdata_cnt <=0;
//								start <= 0;
//							end
//						else 
//							begin
//								rdata_cnt <= rdata_cnt +1;
//								start <=1;
//							end
//					end
//				else   r_cnt <= r_cnt + 1; // ǥ�� ��żӵ� ī��Ʈ 
//			end
//		end
//	  end
//	
//always @(posedge clk, negedge reset)
//if(!reset)
//	begin
//		rdata<=0;
//		rx_data <= 0;
//		
//	end
//else
//  begin
//	   if(r_cnt==baud_rate)begin
//			case(rdata_cnt)
//			 0: rdata[0]<=rxd;
//			 1: rdata[1]<=rxd;
//			 2: rdata[2]<=rxd;
//			 3: rdata[3]<=rxd;
//			 4: rdata[4]<=rxd;
//			 5: rdata[5]<=rxd;
//			 6: rdata[6]<=rxd;
//			 7: rdata[7]<=rxd;
//			 default: rdata <= rdata;
//			endcase
//			end
//		 if(rdata_cnt==8)  rx_data<= rdata; //���� ������ ��� 
//		   
//	end	
//endmodule

module RXD (
			input clk, input reset,
			input rxd, output reg [7:0]rx_data
);
					
parameter baud_rate = 5624;  // = 54MHz / 9600bps
parameter cnt_half = 5624 / 2;

reg [7:0]	rxd_buff;    //���� �����͸� �ӽ� �����ϴ� �������� 
reg [3:0]	rx_bit_cnt;  //���� ������ ��Ʈ ī����(0~7 bit 8��, stop bit 1��)
reg [19:0]	rx_clk_cnt;  //������ ���� �ӵ� (9600bps)
reg [19:0]	check_cnt;   //Start Bit Ȯ�� ��������

reg state_rx;  // state_rx=1 => receive mode

//Start bit Ȯ�� �� state_rx ���� ȸ��
always @(posedge clk) begin  
	if(reset == 0) begin
		check_cnt <= 0;
		state_rx <= 0;
	end
	else begin
		if(state_rx == 0 && rxd == 0) begin
			if(check_cnt >= cnt_half) begin
				check_cnt <= 0;
				state_rx <= 1;
			end
			else begin
				check_cnt <= check_cnt + 1;
				state_rx <= 0;
			end
		end
		else begin
			check_cnt <= 0;
			//state_rx <= 0;
		end
		
		//ȸ�� ���� ����
		if(state_rx == 1) begin  
			if(rx_bit_cnt >= 8 && rx_clk_cnt >= baud_rate && rxd == 1) state_rx <= 0;
			else state_rx <= 1;
		end
	end
end

//��� �ӵ� ���� ȸ��
always @(posedge clk) begin  
	if(reset == 0) rx_clk_cnt <= 0;
	else begin
		if(state_rx == 1) begin
			if(rx_bit_cnt < 8 && rx_clk_cnt >= baud_rate) rx_clk_cnt <= 0;
			else rx_clk_cnt <= rx_clk_cnt + 1;
		end
		else rx_clk_cnt <= 0;
	end
end

//rx_bit_cnt ���� ȸ��
always @(posedge clk) begin  
	if(reset == 0) rx_bit_cnt = 0;
	else begin
		if(state_rx == 1) begin	
			if(rx_bit_cnt >= 8 && rx_clk_cnt >= baud_rate && rxd == 1) rx_bit_cnt <= 0;
			else if(rx_bit_cnt < 8 && rx_clk_cnt >= baud_rate)         rx_bit_cnt <= rx_bit_cnt + 1;
		end
		else rx_bit_cnt <= 0;
	end
end

//��Ű� ��� ȸ��
always @(posedge clk) begin  
	if(reset == 0) begin
		rxd_buff <= 0;
		rx_data <= 0;
	end
	else begin
		if(state_rx == 1) begin
			if(rx_bit_cnt < 8 && rx_clk_cnt >= baud_rate)                    rxd_buff[rx_bit_cnt] <= rxd;
			else if(rx_bit_cnt >= 8 && rx_clk_cnt >= baud_rate && rxd == 1)  rx_data <= rxd_buff;
			else if (rx_bit_cnt >= 8 && rx_clk_cnt >= baud_rate && rxd != 1) rx_data <= 8'b0000_0000;
		end
	end
end

endmodule
