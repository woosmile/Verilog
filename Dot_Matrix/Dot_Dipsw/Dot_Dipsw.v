//��� �����
module Dot_Dipsw(clk,reset,dipsw,portA,portB,row,col);

//����� �����
input clk,reset;
input [7:0]dipsw;
output reg [1:0]portA,portB;
output reg [6:0]row;
output reg [4:0]col;

//ī��Ʈ ����
integer scan_cnt;  //��ĵ �ð� ����

//portA, portB�� ��¹��� ���۷� ����
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

//scan_cnt ���� ȸ��(�ֱ� ���� ȸ��)
always@(posedge clk, negedge reset) begin
	if(!reset) scan_cnt <= 0;
	else begin
		if(scan_cnt >= 5399) scan_cnt <= 0;
		else scan_cnt <= scan_cnt + 1;
	end
end

//�� ��ĵ ȸ��(col)
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

//col, dipsw ���� ���� ���
always@(col,dipsw) begin
	if(dipsw==8'h01) begin
		case(col)
			5'b11110 : row = 7'b0000000;  //1
			5'b11101 : row = 7'b1000010;
			5'b11011 : row = 7'b1111111;
			5'b10111 : row = 7'b1111111;
			5'b01111 : row = 7'b1000000;
			default : row = 7'b0000000;
		endcase
	end
	else if(dipsw==8'h02) begin
		case(col)
			5'b11110 : row = 7'b1000010;  //2
			5'b11101 : row = 7'b1100001;
			5'b11011 : row = 7'b1010001;
			5'b10111 : row = 7'b1001001;
			5'b01111 : row = 7'b1000110;
			default : row = 7'b0000000;
		endcase
	end
	else if(dipsw==8'h04) begin
		case(col)
			5'b11110 : row = 7'b0100010;  //3
			5'b11101 : row = 7'b1000001;
			5'b11011 : row = 7'b1000001;
			5'b10111 : row = 7'b1001001;
			5'b01111 : row = 7'b0110110;
			default : row = 7'b0000000;
		endcase
	end
	else if(dipsw==8'h08) begin
		case(col)
			5'b11110 : row = 7'b0111110;  //4
			5'b11101 : row = 7'b0100001;
			5'b11011 : row = 7'b0100000;
			5'b10111 : row = 7'b1111111;
			5'b01111 : row = 7'b0100000;
			default : row = 7'b0000000;
		endcase
	end
	else if(dipsw==8'h10) begin
		case(col)
			5'b11110 : row = 7'b0100111;  //5
			5'b11101 : row = 7'b1000101;
			5'b11011 : row = 7'b1000101;
			5'b10111 : row = 7'b1000101;
			5'b01111 : row = 7'b0111001;
			default : row = 7'b0000000;
		endcase
	end
	else if(dipsw==8'h20) begin
		case(col)
			5'b11110 : row = 7'b0111110;  //6
			5'b11101 : row = 7'b1001001;
			5'b11011 : row = 7'b1001001;
			5'b10111 : row = 7'b1001001;
			5'b01111 : row = 7'b0110010;
			default : row = 7'b0000000;
		endcase
	end
	else if(dipsw==8'h40) begin
		case(col)
			5'b11110 : row = 7'b0000011;  //7
			5'b11101 : row = 7'b0000001;
			5'b11011 : row = 7'b0000001;
			5'b10111 : row = 7'b1111001;
			5'b01111 : row = 7'b0000111;
			default : row = 7'b0000000;
		endcase
	end
	else if(dipsw==8'h80) begin
		case(col)
			5'b11110 : row = 7'b0110110;  //8
			5'b11101 : row = 7'b1001001;
			5'b11011 : row = 7'b1001001;
			5'b10111 : row = 7'b1001001;
			5'b01111 : row = 7'b0110110;
			default : row = 7'b0000000;
		endcase
	end
	else row = 7'b0000000;
end
	
endmodule
