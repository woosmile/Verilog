//��� �����
module Keypad(clk,reset,enable,portA,portB,col,row,data);

//����� �����
input clk,reset;
input [3:0]row;

output reg enable;
output reg [1:0]portA,portB;
output reg [2:0]col;
output reg [7:0]data;

//���� ����
reg [27:0]clk_cnt;
reg clk_div;

//���°� ����
reg [1:0]state;

//���°� ��� ����
parameter idle = 0;
parameter col_1 = 1;
parameter col_2 = 2;
parameter col_3 = 3;

//flag �߻���
assign stop = row[0] | row[1] | row[2] | row[3];

//portA, portB ���� ���� ȸ��
always@(posedge clk, negedge reset) begin
	if(!reset) begin
		portA <= 2'b10;
		portB <= 2'b11;
	end
	else begin
		portA <= 2'b00;
		portB <= 2'b01;
	end
end

//Ŭ�� ���� ȸ��
/*
always@(posedge clk, negedge reset) begin
	if(!reset) begin
		clk_cnt <= 0;
		clk_div <= 0;
	end
	else begin
		if(clk_cnt >= 5399) begin  //54000000 / 5400 = 10000
			clk_cnt <= 0;
			clk_div <= 1;
		end
		else begin
			clk_cnt <= clk_cnt + 1;
			clk_div <= 0;
		end
	end
end
*/
always@(posedge clk, negedge reset) begin
	if(!reset) begin
		clk_cnt <= 0;
		clk_div <= 0;
	end
	else begin
		if(clk_cnt >= 2699) begin
			clk_cnt <= 0;
			clk_div <= ~clk_div;
		end
		else clk_cnt <= clk_cnt + 1;
	end
end

//���� õ�� ȸ��
always@(posedge clk_div, negedge reset) begin
	if(!reset) begin
		enable <= 0;
		state <= idle;
	end
	else begin
		if(!stop) begin
			enable <= 0;
			case(state)
				idle : state <= col_1;
				col_1 : state <= col_2;
				col_2 : state <= col_3;
				col_3 : state <= col_1;
				default : state <= idle;
			endcase
		end
		else enable <= 1;
	end
end

//���°��� ���� data ��� ȸ��
always@(state,row) begin
	case(state)
		idle : data = 0;
		col_1 : begin
			case(row)
				4'b0001 : data = 8'h01;  //1
				4'b0010 : data = 8'h08;  //4
				4'b0100 : data = 8'h40;  //7
				4'b1000 : data = 8'hb0;  //*
				default : data = 8'h00;
			endcase
		end
		col_2 : begin
			case(row)
				4'b0001 : data = 8'h02;  //2
				4'b0010 : data = 8'h10;  //5
				4'b0100 : data = 8'h80;  //8
				4'b1000 : data = 8'ha0;  //0
				default : data = 8'h00;
			endcase
		end
		col_3 : begin
			case(row)
				4'b0001 : data = 8'h04;  //3
				4'b0010 : data = 8'h20;  //6
				4'b0100 : data = 8'h90;  //9
				4'b1000 : data = 8'hc0;  //#
				default : data = 8'h00;
			endcase
		end
		default : data = 8'h00;
	endcase
end

//���°��� ���� col�� ��� ȸ��
always@(state) begin
	case(state)
		idle : col = 3'b000;
		col_1 : col = 3'b001;  //1�� ����
		col_2 : col = 3'b010;  //2��
		col_3 : col = 3'b100;  //3��
		default : col = 3'b000;
	endcase
end

endmodule
