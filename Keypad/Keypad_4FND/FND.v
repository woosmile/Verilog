//��� �����
module FND(clk,reset,enable,temp_num,en,sel,data);

//����� �����
input clk,reset,enable;
input [7:0]temp_num;

output en;
output reg [3:0]sel;
output reg [7:0]data;

//FND ����
reg [27:0]scan_cnt;
reg [1:0]digit;

reg [1:0]key_cnt;
reg [4:0]temp_en;
reg [7:0]num[0:3];

//fnd enable Ȱ��ȭ
assign en = (!reset) ? 1'b1 : 1'b0;

//FND Scan ȸ��
always@(posedge clk, negedge reset) begin
	if(!reset) scan_cnt <= 0;
	else begin
		if(scan_cnt >= 134999)
			scan_cnt <= 0;
		else
			scan_cnt <= scan_cnt + 1;
	end
end

//Scan �ð��� ���� digit ���� ȸ��
always@(posedge clk, negedge reset) begin
	if(!reset) digit <= 0;
	else begin
		if(scan_cnt >= 134999)  //54000000 / 135000 = 400Hz -> 2.5ms
			digit <= digit + 1;
		else
			digit <= digit;
	end
end

//digit ���� ���� �� �ڸ��� ����
always@(digit) begin
	case(digit)
		0 : begin sel = 4'b1110; data = num[3]; end
		1 : begin sel = 4'b1101; data = num[2]; end
		2 : begin sel = 4'b1011; data = num[1]; end
		3 : begin sel = 4'b0111; data = num[0]; end
	endcase
end

//Ű�е� ä�͸� ȸ��
always@(posedge clk, negedge reset) begin
	if(!reset) temp_en <= 0;
	else temp_en <= {temp_en, enable};
end

//�� �ڸ� ���� �� �Ҵ� ȸ��
always@(posedge clk, negedge reset) begin
	if(!reset) begin
		key_cnt <= 0;
		{num[0],num[1],num[2],num[3]} <= 0;
	end
	else begin
		if(temp_en == 5'b00001) begin
			if(key_cnt >= 3) key_cnt <= 0;  //key_cnt ���� �κ�
			else key_cnt <= key_cnt + 1;
			if(key_cnt == 0) begin
				num[0] <= temp_num;  //õ�� �ڸ��� num[0]�� ���� Ű ���� ����
				{num[1],num[2],num[3]} <= 8'h00;  //100,10,1�� �ڸ��� fnd �ҵ�
			end
			else num[key_cnt] <= temp_num;
		end
	end
end

endmodule
