module FND(clk,reset,num,en,sel,data);

input clk,reset;
input [7:0]num;

output en;
output reg [3:0]sel;
output reg [7:0]data;

reg [27:0]scan_cnt;
reg [1:0]digit;

assign en = (!reset) ? 1'b1 : 1'b0;

always@(posedge clk, negedge reset) begin
	if(!reset) scan_cnt <= 0;
	else begin
		if(scan_cnt >= 134999)
			scan_cnt <= 0;
		else
			scan_cnt <= scan_cnt + 1;
	end
end

always@(posedge clk, negedge reset) begin
	if(!reset) digit <= 0;
	else begin
		if(scan_cnt >= 134999)
			digit <= digit + 1;
		else
			digit <= digit;
	end
end

always@(digit) begin
	case(digit)
		0 : begin sel = 4'b1110; data = num; end
		//1 : begin sel = 4'b1101; data = num; end
		//2 : begin sel = 4'b1011; data = num; end
		//3 : begin sel = 4'b0111; data = num; end
	endcase
end

endmodule
