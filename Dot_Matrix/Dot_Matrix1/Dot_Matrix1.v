//모듈 선언부
module Dot_Matrix1(clk,reset,portA,portB,row,col);

//입출력 선언부
input clk,reset;
output reg [1:0]portA,portB;
output reg [6:0]row;
output reg [4:0]col;

//카운트 변수
reg [31:0]scan_cnt;  //스캔 시간 변수

//portA, portB를 출력방향 버퍼로 설정
always@(posedge clk, negedge reset) begin
	if(!reset) begin
		portA <= 0;
		portB <= 0;
	end
	else begin
		portA <= 2'b01;
		portB <= 2'b01;
	end
end

//scan_cnt 증가 회로(주기 생성 회로)
always@(posedge clk, negedge reset) begin
	if(!reset) scan_cnt <= 0;
	else begin
		if(scan_cnt >= 5399999) scan_cnt <= 0;
		else scan_cnt <= scan_cnt + 1;
	end
end

//열 자리 증가 회로(col)
always@(posedge clk, negedge reset) begin
	if(!reset) col <= 5'b00000;
	else begin
		if(scan_cnt >= 5399999) begin
			if(col == 5'b01111) col <= 5'b11110;
			else col <= (col << 1) | 5'b00001;
		end
		else col <= col;
	end
end

//digit 값에 따른 출력
always@(col) begin
	case(col)
		5'b11110 : row = 7'b1111100;
		5'b11101 : row = 7'b0010010;
		5'b11011 : row = 7'b0010001;
		5'b10111 : row = 7'b0010010;
		5'b01111 : row = 7'b1111100;
		default : row = 7'b0000000;
	endcase
end
	
endmodule
