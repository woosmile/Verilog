////모듈 선언부
//module Dot_Matrix2(clk,reset,portA,portB,row,col);
//
////입출력 선언부
//input clk,reset;
//output reg [1:0]portA,portB;
//output reg [6:0]row;
//output reg [4:0]col;
//
////카운트 변수
//reg [31:0]scan_cnt;  //스캔 시간 변수
//reg [15:0]cnt_500ms;
//reg [3:0]position;
//
////portA, portB를 출력방향 버퍼로 설정
//always@(posedge clk, negedge reset) begin
//	if(!reset) begin
//		portA <= 0;
//		portB <= 0;
//	end
//	else begin
//		portA <= 2'b01;
//		portB <= 2'b01;
//	end
//end
//
////scan_cnt 증가 회로(주기 생성 회로)
//always@(posedge clk, negedge reset) begin
//	if(!reset) scan_cnt <= 0;
//	else begin
//		if(scan_cnt >= 5399) scan_cnt <= 0;
//		else scan_cnt <= scan_cnt + 1;
//	end
//end
//
////열 자리 증가 회로(col)
//always@(posedge clk, negedge reset) begin
//	if(!reset) col <= 5'b00000;
//	else begin
//		if(scan_cnt >= 5399) begin
//			if(col == 5'b01111) col <= 5'b11110;
//			else col <= (col << 1) | 5'b00001;
//		end
//		else col <= col;
//	end
//end
//
////0.5초 발생회로(0.1ms * 5000)
//always@(posedge clk, negedge reset) begin
//	if(!reset) cnt_500ms <= 0;
//	else begin
//		if(scan_cnt >= 5399) begin
//			if(cnt_500ms >= 4999) cnt_500ms <= 0;
//			else cnt_500ms <= cnt_500ms + 1;
//		end
//		else cnt_500ms <= cnt_500ms;
//	end
//end
//
////자릿수 발생 회로
//always @(posedge clk, negedge reset) begin
//	if(!reset) position <= 0;
//	else begin
//		if(scan_cnt >= 5399) begin
//			if(cnt_500ms >= 4999) begin
//				if(position >= 9) position <= 0;
//				else position <= position + 1;
//			end
//		end
//		else position <= position;
//	end
//end
//
////digit 값에 따른 출력
//always@(position, col) begin
//	if(position == 0) begin
//		case(col)
//			5'b11110 : row = 7'b001_1111;
//			5'b11101 : row = 7'b010_0000;
//			5'b11011 : row = 7'b110_0000;
//			5'b10111 : row = 7'b010_0000;
//			5'b01111 : row = 7'b001_1111;
//			default : row = 7'b0000000;
//		endcase
//	end
//	else if(position == 1) begin
//		case(col)
//			5'b11110 : row = 7'b111_1111;
//			5'b11101 : row = 7'b100_1001;
//			5'b11011 : row = 7'b100_1001;
//			5'b10111 : row = 7'b100_1001;
//			5'b01111 : row = 7'b100_1001;
//			default : row = 7'b0000000;
//		endcase
//	end
//	else if(position == 2) begin
//		case(col)
//			5'b11110 : row = 7'b111_1111;
//			5'b11101 : row = 7'b001_0001;
//			5'b11011 : row = 7'b001_0001;
//			5'b10111 : row = 7'b010_1001;
//			5'b01111 : row = 7'b100_0110;
//			default : row = 7'b0000000;
//		endcase
//	end
//	else if(position == 3) begin
//		case(col)
//			5'b11110 : row = 7'b100_0001;
//			5'b11101 : row = 7'b100_0001;
//			5'b11011 : row = 7'b111_1111;
//			5'b10111 : row = 7'b100_0001;
//			5'b01111 : row = 7'b100_0001;
//			default : row = 7'b0000000;
//		endcase
//	end
//	else if(position == 4) begin
//		case(col)
//			5'b11110 : row = 7'b111_1111;
//			5'b11101 : row = 7'b100_0000;
//			5'b11011 : row = 7'b100_0000;
//			5'b10111 : row = 7'b100_0000;
//			5'b01111 : row = 7'b100_0000;
//			default : row = 7'b0000000;
//		endcase
//	end
//	else if(position == 5) begin
//		case(col)
//			5'b11110 : row = 7'b011_1110;
//			5'b11101 : row = 7'b100_0001;
//			5'b11011 : row = 7'b100_0001;
//			5'b10111 : row = 7'b100_0001;
//			5'b01111 : row = 7'b011_1110;
//			default : row = 7'b0000000;
//		endcase
//	end
//	else if(position == 6) begin
//		case(col)
//			5'b11110 : row = 7'b001_1110;
//			5'b11101 : row = 7'b010_0001;
//			5'b11011 : row = 7'b010_1001;
//			5'b10111 : row = 7'b000_1001;
//			5'b01111 : row = 7'b111_1010;
//			default : row = 7'b0000000;
//		endcase
//	end
//	else if(position == 7) begin
//		case(col)
//			5'b11110 : row = 7'b111_1111;
//			5'b11101 : row = 7'b000_1000;
//			5'b11011 : row = 7'b000_1000;
//			5'b10111 : row = 7'b000_1000;
//			5'b01111 : row = 7'b111_1111;
//			default : row = 7'b0000000;
//		endcase
//	end
//	else if(position == 8) begin
//		case(col)
//			5'b11110 : row = 7'b111_1111;
//			5'b11101 : row = 7'b100_0001;
//			5'b11011 : row = 7'b100_0001;
//			5'b10111 : row = 7'b100_0001;
//			5'b01111 : row = 7'b011_1110;
//			default : row = 7'b0000000;
//		endcase
//	end
//	else if(position == 9) begin
//		case(col)
//			5'b11110 : row = 7'b111_1111;
//			5'b11101 : row = 7'b100_0000;
//			5'b11011 : row = 7'b100_0000;
//			5'b10111 : row = 7'b100_0000;
//			5'b01111 : row = 7'b100_0000;
//			default : row = 7'b0000000;
//		endcase
//	end
//	else begin
//		case(col)
//			5'b11110 : row = 7'b0000000;
//			5'b11101 : row = 7'b0000000;
//			5'b11011 : row = 7'b0000000;
//			5'b10111 : row = 7'b0000000;
//			5'b01111 : row = 7'b0000000;
//			default : row = 7'b0000000;
//		endcase
//	end
//end
//	
//endmodule

/*
//모듈 선언부(1차원 배열 사용)
module Dot_Matrix2(clk,reset,portA,portB,row,col);

//입출력 선언부
input clk,reset;
output reg [1:0]portA,portB;
output reg [6:0]row;
output reg [4:0]col;

//카운트 변수
reg [31:0]scan_cnt;  //스캔 시간 변수
reg [15:0]cnt_500ms;
reg [7:0]position;

//메모리 변수
reg [7:0]MEM[0:49];

initial begin
	MEM[0] = 7'b001_1111;
	MEM[1] = 7'b010_0000;
	MEM[2] = 7'b110_0000;
	MEM[3] = 7'b010_0000;
	MEM[4] = 7'b001_1111;

	MEM[5] = 7'b111_1111;
	MEM[6] = 7'b100_1001;
	MEM[7] = 7'b100_1001;
	MEM[8] = 7'b100_1001;
	MEM[9] = 7'b100_1001;

	MEM[10] = 7'b111_1111;
	MEM[11] = 7'b001_0001;
	MEM[12] = 7'b001_0001;
	MEM[13] = 7'b010_1001;
	MEM[14] = 7'b100_0110;

	MEM[15] = 7'b100_0001;
	MEM[16] = 7'b100_0001;
	MEM[17] = 7'b111_1111;
	MEM[18] = 7'b100_0001;
	MEM[19] = 7'b100_0001;

	MEM[20] = 7'b111_1111;
	MEM[21] = 7'b100_0000;
	MEM[22] = 7'b100_0000;
	MEM[23] = 7'b100_0000;
	MEM[24] = 7'b100_0000;

	MEM[25] = 7'b011_1110;
	MEM[26] = 7'b100_0001;
	MEM[27] = 7'b100_0001;
	MEM[28] = 7'b100_0001;
	MEM[29] = 7'b011_1110;
	
	MEM[30] = 7'b001_1110;
	MEM[31] = 7'b010_0001;
	MEM[32] = 7'b010_1001;
	MEM[33] = 7'b000_1001;
	MEM[34] = 7'b111_1010;

	MEM[35] = 7'b111_1111;
	MEM[36] = 7'b000_1000;
	MEM[37] = 7'b000_1000;
	MEM[38] = 7'b000_1000;
	MEM[39] = 7'b111_1111;

	MEM[40] = 7'b111_1111;
	MEM[41] = 7'b100_0001;
	MEM[42] = 7'b100_0001;
	MEM[43] = 7'b100_0001;
	MEM[44] = 7'b011_1110;

	MEM[45] = 7'b111_1111;
	MEM[46] = 7'b100_0000;
	MEM[47] = 7'b100_0000;
	MEM[48] = 7'b100_0000;
	MEM[49] = 7'b100_0000;
end

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
		if(scan_cnt >= 5399) scan_cnt <= 0;
		else scan_cnt <= scan_cnt + 1;
	end
end

//열 자리 증가 회로(col)
always@(posedge clk, negedge reset) begin
	if(!reset) col <= 5'b00000;
	else begin
		if(scan_cnt >= 5399) begin
			if(col == 5'b01111) col <= 5'b11110;
			else col <= (col << 1) | 5'b00001;
		end
		else col <= col;
	end
end

//0.5초 발생회로(0.1ms * 5000)
always@(posedge clk, negedge reset) begin
	if(!reset) cnt_500ms <= 0;
	else begin
		if(scan_cnt >= 5399) begin
			if(cnt_500ms >= 4999) cnt_500ms <= 0;
			else cnt_500ms <= cnt_500ms + 1;
		end
		else cnt_500ms <= cnt_500ms;
	end
end

//자릿수 발생 회로
always @(posedge clk, negedge reset) begin
	if(!reset) position <= 0;
	else begin
		if(scan_cnt >= 5399) begin
			if(cnt_500ms >= 4999) begin
				if(position >= 45) position <= 0;
				else position <= position + 5;
			end
		end
		else position <= position;
	end
end

//digit 값에 따른 출력(1차원 배열 사용)
always@(position, col) begin
	case(col)
		5'b11110 : row = MEM[position];
		5'b11101 : row = MEM[position+1];
		5'b11011 : row = MEM[position+2];
		5'b10111 : row = MEM[position+3];
		5'b01111 : row = MEM[position+4];
		default : row = 7'b000_0000;
	endcase
end
		
endmodule
*/
/*
//모듈 선언부(2차원 배열 사용)
module Dot_Matrix2(clk,reset,portA,portB,row,col);

//입출력 선언부
input clk,reset;
output reg [1:0]portA,portB;
output reg [6:0]row;
output reg [4:0]col;

//카운트 변수
reg [31:0]scan_cnt;  //스캔 시간 변수
reg [15:0]cnt_500ms;
reg [3:0]position;

//메모리 변수
reg [7:0]MEM[0:9][0:4];

initial begin
	MEM[0][0] = 7'b001_1111;
	MEM[0][1] = 7'b010_0000;
	MEM[0][2] = 7'b110_0000;
	MEM[0][3] = 7'b010_0000;
	MEM[0][4] = 7'b001_1111;

	MEM[1][0] = 7'b111_1111;
	MEM[1][1] = 7'b100_1001;
	MEM[1][2] = 7'b100_1001;
	MEM[1][3] = 7'b100_1001;
	MEM[1][4] = 7'b100_1001;

	MEM[2][0] = 7'b111_1111;
	MEM[2][1] = 7'b001_0001;
	MEM[2][2] = 7'b001_0001;
	MEM[2][3] = 7'b010_1001;
	MEM[2][4] = 7'b100_0110;

	MEM[3][0] = 7'b100_0001;
	MEM[3][1] = 7'b100_0001;
	MEM[3][2] = 7'b111_1111;
	MEM[3][3] = 7'b100_0001;
	MEM[3][4] = 7'b100_0001;

	MEM[4][0] = 7'b111_1111;
	MEM[4][1] = 7'b100_0000;
	MEM[4][2] = 7'b100_0000;
	MEM[4][3] = 7'b100_0000;
	MEM[4][4] = 7'b100_0000;

	MEM[5][0] = 7'b011_1110;
	MEM[5][1] = 7'b100_0001;
	MEM[5][2] = 7'b100_0001;
	MEM[5][3] = 7'b100_0001;
	MEM[5][4] = 7'b011_1110;
	
	MEM[6][0] = 7'b001_1110;
	MEM[6][1] = 7'b010_0001;
	MEM[6][2] = 7'b010_1001;
	MEM[6][3] = 7'b000_1001;
	MEM[6][4] = 7'b111_1010;

	MEM[7][0] = 7'b111_1111;
	MEM[7][1] = 7'b000_1000;
	MEM[7][2] = 7'b000_1000;
	MEM[7][3] = 7'b000_1000;
	MEM[7][4] = 7'b111_1111;

	MEM[8][0] = 7'b111_1111;
	MEM[8][1] = 7'b100_0001;
	MEM[8][2] = 7'b100_0001;
	MEM[8][3] = 7'b100_0001;
	MEM[8][4] = 7'b011_1110;

	MEM[9][0] = 7'b111_1111;
	MEM[9][1] = 7'b100_0000;
	MEM[9][2] = 7'b100_0000;
	MEM[9][3] = 7'b100_0000;
	MEM[9][4] = 7'b100_0000;
end

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
		if(scan_cnt >= 5399) scan_cnt <= 0;
		else scan_cnt <= scan_cnt + 1;
	end
end

//열 자리 증가 회로(col)
always@(posedge clk, negedge reset) begin
	if(!reset) col <= 5'b00000;
	else begin
		if(scan_cnt >= 5399) begin
			if(col == 5'b01111) col <= 5'b11110;
			else col <= (col << 1) | 5'b00001;
		end
		else col <= col;
	end
end

//0.5초 발생회로(0.1ms * 5000)
always@(posedge clk, negedge reset) begin
	if(!reset) cnt_500ms <= 0;
	else begin
		if(scan_cnt >= 5399) begin
			if(cnt_500ms >= 4999) cnt_500ms <= 0;
			else cnt_500ms <= cnt_500ms + 1;
		end
		else cnt_500ms <= cnt_500ms;
	end
end

//자릿수 발생 회로
always@(posedge clk, negedge reset) begin
	if(!reset) position <= 0;
	else begin
		if(scan_cnt >= 5399) begin
			if(cnt_500ms >= 4999) begin
				if(position >= 9) position <= 0;
				else position <= position + 1;
			end
		end
		else position <= position;
	end
end

//digit 값에 따른 출력(2차원 배열 사용)
always@(position, col) begin
	case(col)
		5'b11110 : row = MEM[position][0];
		5'b11101 : row = MEM[position][1];
		5'b11011 : row = MEM[position][2];
		5'b10111 : row = MEM[position][3];
		5'b01111 : row = MEM[position][4];
		default : row = 7'b000_0000;
	endcase
end

endmodule
*/
//모듈 선언부(1차원 배열 사용)
module Dot_Matrix2(clk,reset,portA,portB,row,col);

//입출력 선언부
input clk,reset;
output reg [1:0]portA,portB;
output reg [6:0]row;
output reg [4:0]col;

//카운트 변수
reg [31:0]scan_cnt;  //스캔 시간 변수
reg [15:0]cnt_500ms;
reg [7:0]position;

//메모리 변수
reg [7:0]MEM[0:49];

initial begin
	MEM[0] = 7'b001_1111;
	MEM[1] = 7'b010_0000;
	MEM[2] = 7'b110_0000;
	MEM[3] = 7'b010_0000;
	MEM[4] = 7'b001_1111;

	MEM[5] = 7'b111_1111;
	MEM[6] = 7'b100_1001;
	MEM[7] = 7'b100_1001;
	MEM[8] = 7'b100_1001;
	MEM[9] = 7'b100_1001;

	MEM[10] = 7'b111_1111;
	MEM[11] = 7'b001_0001;
	MEM[12] = 7'b001_0001;
	MEM[13] = 7'b010_1001;
	MEM[14] = 7'b100_0110;

	MEM[15] = 7'b100_0001;
	MEM[16] = 7'b100_0001;
	MEM[17] = 7'b111_1111;
	MEM[18] = 7'b100_0001;
	MEM[19] = 7'b100_0001;

	MEM[20] = 7'b111_1111;
	MEM[21] = 7'b100_0000;
	MEM[22] = 7'b100_0000;
	MEM[23] = 7'b100_0000;
	MEM[24] = 7'b100_0000;

	MEM[25] = 7'b011_1110;
	MEM[26] = 7'b100_0001;
	MEM[27] = 7'b100_0001;
	MEM[28] = 7'b100_0001;
	MEM[29] = 7'b011_1110;
	
	MEM[30] = 7'b001_1110;
	MEM[31] = 7'b010_0001;
	MEM[32] = 7'b010_1001;
	MEM[33] = 7'b000_1001;
	MEM[34] = 7'b111_1010;

	MEM[35] = 7'b111_1111;
	MEM[36] = 7'b000_1000;
	MEM[37] = 7'b000_1000;
	MEM[38] = 7'b000_1000;
	MEM[39] = 7'b111_1111;

	MEM[40] = 7'b111_1111;
	MEM[41] = 7'b100_0001;
	MEM[42] = 7'b100_0001;
	MEM[43] = 7'b100_0001;
	MEM[44] = 7'b011_1110;

	MEM[45] = 7'b111_1111;
	MEM[46] = 7'b100_0000;
	MEM[47] = 7'b100_0000;
	MEM[48] = 7'b100_0000;
	MEM[49] = 7'b100_0000;
end

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
		if(scan_cnt >= 5399) scan_cnt <= 0;
		else scan_cnt <= scan_cnt + 1;
	end
end

//열 자리 증가 회로(col)
always@(posedge clk, negedge reset) begin
	if(!reset) col <= 5'b00000;
	else begin
		if(scan_cnt >= 5399) begin
			if(col == 5'b01111) col <= 5'b11110;
			else col <= (col << 1) | 5'b00001;
		end
		else col <= col;
	end
end

//0.5초 발생회로(0.1ms * 5000)
always@(posedge clk, negedge reset) begin
	if(!reset) cnt_500ms <= 0;
	else begin
		if(scan_cnt >= 5399) begin
			if(cnt_500ms >= 4999) cnt_500ms <= 0;
			else cnt_500ms <= cnt_500ms + 1;
		end
		else cnt_500ms <= cnt_500ms;
	end
end

//자릿수 발생 회로
always @(posedge clk, negedge reset) begin
	if(!reset) position <= 0;
	else begin
		if(scan_cnt >= 5399) begin
			if(cnt_500ms >= 4999) begin
				if(position >= 61) position <= 0;
				else position <= position + 1;
			end
		end
		else position <= position;
	end
end

//digit 값에 따른 출력(1차원 배열 사용)
always@(position, col) begin
	case(col)
		5'b11110 : row = MEM[position];
		5'b11101 : row = MEM[position+1];
		5'b11011 : row = MEM[position+2];
		5'b10111 : row = MEM[position+3];
		5'b01111 : row = MEM[position+4];
		default : row = 7'b000_0000;
	endcase
end
		
endmodule
