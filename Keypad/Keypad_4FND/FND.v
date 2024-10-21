//모듈 선언부
module FND(clk,reset,enable,temp_num,en,sel,data);

//입출력 선언부
input clk,reset,enable;
input [7:0]temp_num;

output en;
output reg [3:0]sel;
output reg [7:0]data;

//FND 변수
reg [27:0]scan_cnt;
reg [1:0]digit;

reg [1:0]key_cnt;
reg [4:0]temp_en;
reg [7:0]num[0:3];

//fnd enable 활성화
assign en = (!reset) ? 1'b1 : 1'b0;

//FND Scan 회로
always@(posedge clk, negedge reset) begin
	if(!reset) scan_cnt <= 0;
	else begin
		if(scan_cnt >= 134999)
			scan_cnt <= 0;
		else
			scan_cnt <= scan_cnt + 1;
	end
end

//Scan 시간에 따른 digit 증가 회로
always@(posedge clk, negedge reset) begin
	if(!reset) digit <= 0;
	else begin
		if(scan_cnt >= 134999)  //54000000 / 135000 = 400Hz -> 2.5ms
			digit <= digit + 1;
		else
			digit <= digit;
	end
end

//digit 값에 따른 각 자릿수 선택
always@(digit) begin
	case(digit)
		0 : begin sel = 4'b1110; data = num[3]; end
		1 : begin sel = 4'b1101; data = num[2]; end
		2 : begin sel = 4'b1011; data = num[1]; end
		3 : begin sel = 4'b0111; data = num[0]; end
	endcase
end

//키패드 채터링 회로
always@(posedge clk, negedge reset) begin
	if(!reset) temp_en <= 0;
	else temp_en <= {temp_en, enable};
end

//각 자리 변수 값 할당 회로
always@(posedge clk, negedge reset) begin
	if(!reset) begin
		key_cnt <= 0;
		{num[0],num[1],num[2],num[3]} <= 0;
	end
	else begin
		if(temp_en == 5'b00001) begin
			if(key_cnt >= 3) key_cnt <= 0;  //key_cnt 증가 부분
			else key_cnt <= key_cnt + 1;
			if(key_cnt == 0) begin
				num[0] <= temp_num;  //천의 자리인 num[0]는 눌린 키 값을 받음
				{num[1],num[2],num[3]} <= 8'h00;  //100,10,1의 자리는 fnd 소등
			end
			else num[key_cnt] <= temp_num;
		end
	end
end

endmodule
