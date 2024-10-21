//모듈 선언부
module Data_Storage (clk, reset, RS232_EN, RX_DATA,
							data0, data1, data2, data3, data4,
							data5, data6, data7, data8, data9,
							dataA, dataB, dataC, dataD, dataE,
							dataF
);

//입출력 선언부
input clk, reset, RS232_EN; 
input [7:0]RX_DATA;
	
output reg [7:0]data0, data1, data2, data3, data4;
output reg [7:0]data5, data6, data7, data8, data9;
output reg [7:0]dataA, dataB, dataC, dataD, dataE;
output reg [7:0]dataF;

//레지스터 선택(포인터 역할)
integer addr;

reg [1:0]temp_en;

//최초의 1값만 받는 회로
always@(posedge clk, negedge reset) begin
	if(!reset) temp_en <= 0;
	else begin
		temp_en <= {temp_en[0], RS232_EN};
	end
end

//번지수 증가 회로
always@(posedge clk, negedge reset) begin
	if(!reset) addr <= 0;
	else begin
		if(temp_en == 2'b01) begin
			if(RX_DATA[6:0] == 7'h0d) addr <= 0;
			else if(RX_DATA[6:0] == 7'h08) begin
				if(addr != 0) addr <= addr - 1;
				else addr <= addr;
			end
			else begin
				if(addr >= 16) addr <= addr;
				else addr <= addr + 1;
			end
		end
	end
end

//번지수에 따른 출력 회로
always@(posedge clk, negedge reset) begin
	if(!reset) begin
		data0 <= 8'h20; data1 <= 8'h20; data2 <= 8'h20; data3 <= 8'h20;
		data4 <= 8'h20; data5 <= 8'h20; data6 <= 8'h20; data7 <= 8'h20;
		data8 <= 8'h20; data9 <= 8'h20; dataA <= 8'h20; dataB <= 8'h20;
		dataC <= 8'h20; dataD <= 8'h20; dataE <= 8'h20; dataF <= 8'h20;
	end
	else begin
		if(temp_en == 2'b01) begin
			if(RX_DATA[6:0] == 7'h0d) begin  //enter
				data0 <= 8'h20;
				data1 <= 8'h20;
				data2 <= 8'h20;
				data3 <= 8'h20;
				data4 <= 8'h20;
				data5 <= 8'h20;
				data6 <= 8'h20;
				data7 <= 8'h20;
				data8 <= 8'h20;
				data9 <= 8'h20;
				dataA <= 8'h20;
				dataB <= 8'h20;
				dataC <= 8'h20;
				dataD <= 8'h20;
				dataE <= 8'h20;
				dataF <= 8'h20;
			end
			else if(RX_DATA[6:0] == 7'h08) begin  //back space
				case(addr)
				0 : ;
				1 : data0 <= " ";
				2 : data1 <= " ";
				3 : data2 <= " ";
				4 : data3 <= " ";
				5 : data4 <= " ";
				6 : data5 <= " ";
				7 : data6 <= " ";
				8 : data7 <= " ";
				9 : data8 <= " ";
				10 : data9 <= " ";
				11 : dataA <= " ";
				12 : dataB <= " ";
				13 : dataC <= " ";
				14 : dataD <= " ";
				15 : dataE <= " ";
				16 : dataF <= " ";
				endcase
			end
			else if(addr == 16) begin  //왼쪽으로 시프트
				data0 <= data1;
				data1 <= data2;
				data2 <= data3;
				data3 <= data4;
				data4 <= data5;
				data5 <= data6;
				data6 <= data7;
				data7 <= data8;
				data8 <= data9;
				data9 <= dataA;
				dataA <= dataB;
				dataB <= dataC;
				dataC <= dataD;
				dataD <= dataE;
				dataE <= dataF;
				dataF <= RX_DATA;
			end
			else begin  //글자 쓸 때
				case(addr)
				0 : data0 <= RX_DATA;
				1 : data1 <= RX_DATA;
				2 : data2 <= RX_DATA;
				3 : data3 <= RX_DATA;
				4 : data4 <= RX_DATA;
				5 : data5 <= RX_DATA;
				6 : data6 <= RX_DATA;
				7 : data7 <= RX_DATA;
				8 : data8 <= RX_DATA;
				9 : data9 <= RX_DATA;
				10 : dataA <= RX_DATA;
				11 : dataB <= RX_DATA;
				12 : dataC <= RX_DATA;
				13 : dataD <= RX_DATA;
				14 : dataE <= RX_DATA;
				15 : dataF <= RX_DATA;
				endcase
			end
		end
	end
end

endmodule
