`define DDRAM 8'h80

// 모듈 선언부
module line_tracer(clk, reset, motor1, motor2, lcd_rs, lcd_rw,
lcd_en, lcd_data, sensor1, sensor2, uart_rxd, rx_en, led);

// 입출력 선언부
input clk, reset, uart_rxd;
input sensor1, sensor2;

output reg [7:0]lcd_data;
output reg [1:0]motor1, motor2;
output reg lcd_rs, lcd_en;
output lcd_rw;

output reg rx_en;
output [1:0]led;

// 모터 주파수 카운트
reg [20:0]m_cnt;
 
// LCD 관련 변수
reg [2:0]state;
reg [17:0]cnt_clk;
reg [4:0]cnt_100ms;
reg [8:0]cnt_50ms;
reg [5:0]line;

wire [17:0]cnt_half;

// 통신 관련 변수
reg [15:0]rx_clk_count;
reg [7:0]rx_data;
reg [7:0]data_out;
reg [3:0]rx_bit_count;
reg state_rx;

// 라인트레이서 동작 구현 변수
reg [31:0]stop_cnt;
reg [7:0]flag1;
reg [7:0]flag2;
reg [1:0]stop_flag;
reg stop;

// 50MHz 기준 통신 설정
parameter CLOCKS_PER_BIT = 5208;  // = 50MHz / 9600bps
parameter CLOCKS_WAIT_FOR_RECEIVE = 5208 / 2;

// LCD 상태 선언
parameter delay_100ms=0, function_set=1, clear_display=2;
parameter display_on=3, entry_mode=4, display_data=5, delay_50ms=6;

// 모터 Duty비 설정
reg [19:0]speed = 250000;
parameter speed1 = 130000;

// 센서 감지 확인
assign led = {sensor1, sensor2};

// LCD 관련 상수값 선언
assign lcd_rw = 1'b0;
assign cnt_half = 187500;

// motor1
always @ (posedge clk, negedge reset)
begin
	if(!reset)
		motor1 <= 2'b00;
	else
	begin
		if(stop)
			motor1 <= 2'b00;
		else
		begin
			if((sensor1 == 1 && sensor2 == 1)&&(speed > m_cnt))
				motor1 <= 2'b01;
			else if((sensor1 == 0 && sensor2 == 1)&&(speed > m_cnt))
				motor1 <= 2'b01;
			else if((sensor1 == 1 && sensor2 == 0)&&(speed1 > m_cnt))
				motor1 <= 2'b01;
			else
				motor1 <= 2'b00;
		end
	end
end

// motor2
always @ (posedge clk, negedge reset)
begin
	if(!reset)
		motor2 <= 2'b00;
	else
	begin
		if(stop)
			motor2 <= 2'b00;
		else
		begin
			if((sensor1 == 1 && sensor2 == 1)&&(speed > m_cnt))
				motor2 <= 2'b01;
			else if((sensor1 == 0 && sensor2 == 1)&&(speed1 > m_cnt))
				motor2 <= 2'b01;
			else if((sensor1 == 1 && sensor2 == 0)&&(speed > m_cnt))
				motor2 <= 2'b01;
			else
				motor2 <= 2'b00;
		end
	end
end

// 모터 주파수 발생 회로
always @ (posedge clk, negedge reset)	// 100Hz(모터 PWM)
begin
	if(!reset)
		m_cnt <= 0;
	else
	begin
		if(m_cnt >= 500000)
			m_cnt <= 0;
		else
			m_cnt <= m_cnt+1'b1;
	end
end

// 5ms 발생 회로
always @ (posedge clk, negedge reset)
begin
	if(!reset)
		cnt_clk <= 0;
	else
	begin
		if(cnt_clk == 249999)
			cnt_clk <= 1'b0;
		else
			cnt_clk <= cnt_clk+1'b1;
	end
end

// 100ms 발생 회로
always @ (posedge clk, negedge reset)
begin
	if(!reset)
		cnt_100ms <= 0;
	else
	begin
		if(state == delay_100ms)
		begin
			if(cnt_clk == 249999)
			begin
				if(cnt_100ms == 19)  //5ms * 20
					cnt_100ms <= 1'b0;
				else
					cnt_100ms <= cnt_100ms+1'b1;
			end
		end
		else
			cnt_100ms<=0;
	end
end

// 50ms 발생 회로
always @ (posedge clk, negedge reset)
begin
	if(!reset)
		cnt_50ms <= 0;
	else
	begin
		if(state == delay_50ms)
		begin
			if(cnt_clk == 249999)
			begin
				if(cnt_50ms == 9)  //5ms * 10
					cnt_50ms <= 1'b0;
				else
					cnt_50ms <= cnt_50ms+1'b1;
			end
		end
		else 
			cnt_50ms <= 0;
	end
end

// LCD 문자출력 회로
always @ (posedge clk, negedge reset)
begin
	if(!reset)
		line <= 0;
	else
	begin
		if(state == display_data)
		begin
			if(cnt_clk == 249999)
			begin
				if(line >= 34)
					line <= 1'b0;
				else
					line <= line+1'b1;
			end
		end
		else
			line <= 0;
	end
end

// LCD Enable 파형 생성 회로
always @ (posedge clk, negedge reset)
begin
	if(!reset)
		lcd_en <= 0;
	else
	begin
		if(state == delay_100ms || state == delay_50ms)
			lcd_en <= 0;
		else
		begin
			if(cnt_clk >= 62500 && cnt_clk <= cnt_half)
				lcd_en <= 1'b1;
			else
				lcd_en <= 1'b0;
		end
	end
end

// LCD 상태천이 회로
always @ (posedge clk, negedge reset)
begin
	if(!reset)
		state <= delay_100ms;
	else
	begin
		if(cnt_clk == 0)
		begin
			case(state)
				delay_100ms : if(cnt_100ms == 19) state <= function_set;
				function_set : state <= clear_display;
				clear_display : state <= display_on;
				display_on : state <= entry_mode;
				entry_mode : state <= display_data;
				display_data : if(line >= 34) state <= delay_50ms;
				delay_50ms : if(cnt_50ms == 9) state <= display_data;
			endcase
		end
	end
end

// LCD 상태에 따른 출력 회로
always @ (state, line, flag1, flag2)
begin
	case(state)
		delay_100ms : {lcd_rs, lcd_data} = 0;
		function_set : {lcd_rs, lcd_data} = 9'b0_0011_1000;
		clear_display : {lcd_rs, lcd_data} = 9'b0_0000_0001;
		display_on : {lcd_rs, lcd_data} = 9'b0_0000_1100;
		entry_mode : {lcd_rs, lcd_data} = 9'b0_0000_0110;
		display_data :
		begin
			case(line)
			0 : {lcd_rs, lcd_data} = {1'b0, `DDRAM};
			1 : {lcd_rs, lcd_data} = {1'b1, "B"};
			2 : {lcd_rs, lcd_data} = {1'b1, "U"};
			3 : {lcd_rs, lcd_data} = {1'b1, "S"};
			4 : {lcd_rs, lcd_data} = {1'b1, "-"};
			5 : {lcd_rs, lcd_data} = {1'b1, "S"};
			6 : {lcd_rs, lcd_data} = {1'b1, "T"};
			7 : {lcd_rs, lcd_data} = {1'b1, "O"};
			8 : {lcd_rs, lcd_data} = {1'b1, "P"};
			9 : {lcd_rs, lcd_data} = {1'b1, " "};
			10 : {lcd_rs, lcd_data} = {1'b1, "G"};
			11 : {lcd_rs, lcd_data} = {1'b1, " "};
			12 : {lcd_rs, lcd_data} = {1'b1, ":"};
			13 : {lcd_rs, lcd_data} = {1'b1, " "};
			14 : {lcd_rs, lcd_data} = {1'b1, flag1};  //정류장1의 스위치값 표기
			15 : {lcd_rs, lcd_data} = {1'b1, " "};
			16 : {lcd_rs, lcd_data} = {1'b1, " "};
			17 : {lcd_rs, lcd_data} = {1'b0, `DDRAM|8'h40};
			18 : {lcd_rs, lcd_data} = {1'b1, "B"};
			19 : {lcd_rs, lcd_data} = {1'b1, "U"};
			20 : {lcd_rs, lcd_data} = {1'b1, "S"};
			21 : {lcd_rs, lcd_data} = {1'b1, "-"};
			22 : {lcd_rs, lcd_data} = {1'b1, "S"};
			23 : {lcd_rs, lcd_data} = {1'b1, "T"};
			24 : {lcd_rs, lcd_data} = {1'b1, "O"};
			25 : {lcd_rs, lcd_data} = {1'b1, "P"};
			26 : {lcd_rs, lcd_data} = {1'b1, " "};
			27 : {lcd_rs, lcd_data} = {1'b1, "B"};
			28 : {lcd_rs, lcd_data} = {1'b1, " "};
			29 : {lcd_rs, lcd_data} = {1'b1, ":"};
			30 : {lcd_rs, lcd_data} = {1'b1, " "};
			31 : {lcd_rs, lcd_data} = {1'b1, flag2};  //정류장2의 스위치값 표기
			32 : {lcd_rs, lcd_data} = {1'b1, " "};
			33 : {lcd_rs, lcd_data} = {1'b1, " "};
			default : {lcd_rs, lcd_data} = {1'b0,8'h00};
			endcase
		end
		delay_50ms : {lcd_rs, lcd_data} = {1'b0,8'h00};
	endcase
end

// 통신(Receive)회로
always @ (posedge clk, negedge reset)
begin
	if(!reset)
	begin
		rx_clk_count <= 0;
		rx_bit_count <= 0;
		state_rx <= 0;
		data_out <= 0;
		rx_en <= 0;
	end
	else
	begin
	if(!state_rx)
		if (uart_rxd == 0 && rx_clk_count >= CLOCKS_WAIT_FOR_RECEIVE)
		begin
			state_rx <= 1;
			rx_bit_count <= 0;
			rx_clk_count <= 0;
			rx_data <= 0;	// start bit
			rx_en <= 0;
		end
		else
		begin
			rx_clk_count <= rx_clk_count+1'b1;
			state_rx <= 0;
		end
		else
		begin
			if(rx_bit_count < 8 && rx_clk_count >= CLOCKS_PER_BIT)
			begin
				state_rx <= 1;
				rx_data[rx_bit_count] <= uart_rxd;
				rx_bit_count <= rx_bit_count + 1'b1;
				rx_clk_count <= 0;
			end
			else if(rx_bit_count == 8 && rx_clk_count >= CLOCKS_PER_BIT && uart_rxd == 1)
			begin
				state_rx <= 0;
				rx_bit_count <= 0;
				rx_clk_count <= 0;
				rx_en <= 1;
				data_out <= rx_data;
			end
			else if(rx_bit_count == 8 && rx_clk_count >= CLOCKS_PER_BIT && uart_rxd != 1)
			begin
				state_rx <= 0;
				rx_bit_count <= 0;
				rx_clk_count <= 0;
				rx_en <= 0;
				rx_data <= 8'b0;
			end
			else
				rx_clk_count <= rx_clk_count + 1'b1;
		end
	end
end

// 통신 값 판별 회로
always @ (posedge clk, negedge reset)
begin
	if(!reset) begin
		flag1 <= "X";
		flag2 <= "X";
	end
	else begin
		if(data_out == "B")  //정류장1의 버스 예약
		begin
			flag1 <= "O";
			flag2 <= flag2;
		end
		else if(data_out == "D")  //정류장2의 버스 예약
		begin
			flag2 <= "O";
			flag1 <= flag1;
		end
		else if(data_out == "A" || (data_out=="E" && stop_cnt>=74999999))  //정류장 1의 버스 예약 취소
		begin
			flag1 <= "X";
			flag2 <= flag2;
		end
		else if(data_out == "C" || (data_out=="F" && stop_cnt>=74999999))  //정류장 2의 버스 예약 취소
		begin
			flag2 <= "X";
			flag1 <= flag1;
		end
		else
		begin
			flag1 <= flag1;
			flag2 <= flag2;
		end
	end
end

// Stop_flag 발생 회로
always @ (posedge clk, negedge reset)
begin
	if(!reset)
		stop_flag <= 0;
	else
	begin
		if(data_out == "E" && flag1 == "O") stop_flag <= 1;
		else if(data_out == "F" && flag2 == "O") stop_flag <= 2;
		else if(stop_cnt >= 74999999) stop_flag <= 0;
		else stop_flag <= 0;
	end
end

// 라인트레이서 멈춤 지연 시간 발생 회로
always @ (posedge clk, negedge reset)
begin
	if(!reset)
	begin
		stop_cnt <= 0;
		stop <= 0;
	end
	else
	begin
		if(stop_flag == 1 || stop_flag == 2)
		begin
			if(stop_cnt >= 74999999 || (flag1 == "X" && flag2 == "X"))
			begin
				stop <= 0;
				stop_cnt <= 0;
			end
			else
			begin
				stop <= 1;
				stop_cnt <= stop_cnt+1;
			end
		end
		else
		begin
			stop <= 0;
			stop_cnt <= 0;
		end
	end
end

endmodule
