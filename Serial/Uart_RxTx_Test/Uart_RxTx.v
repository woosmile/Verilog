/// below are for uart tx/rx
/// 9600bps serial input from PC terminal just output to PC back
/// so this is for Cyclone4's uart rx -> stored to ringbuffer -> uart tx


module Uart_RxTx_Test (
			input clk, input reset,
			input uart_rxd, output uart_txd,
			output reg [7:0]led
);
					
parameter CLOCKS_PER_BIT = 5624;					/// = 54Hz / 9600bps
parameter CLOCKS_WAIT_FOR_RECEIVE = 5624 / 2;
parameter MAX_tx_bit_cnt = 9;

reg [19:0] 	tx_clk_cnt;
reg [3:0]	tx_bit_cnt;							// [start bit | d0..7 | stop bit]

reg [7:0]	data_tx; // 송신할 데이터를 보관 하는 레지스터 

reg [7:0]	rx_data; //수신 데이터를 저장하는 레지스터 
reg [3:0]	rx_bit_cnt; //수신데이터 비트 카운터 0~9 10개 bit cnt
reg [19:0]	rx_clk_cnt; //데이터 수신 속도 (9600bps)

reg state_rx;  // state_rx=1 => receive mode

reg flag;

Serial_Test u0(.clk(clk),.reset(reset),.flag(flag),.tx_out(uart_txd),.tx_data(rx_data));

/*
// tx
always @(posedge clk,negedge reset) begin
	if (reset == 0) begin
		tx_clk_cnt = 0;
		tx_bit_cnt = 0;
		tx_bit = 1;				
		data_buffer_index = 0;
	end
	else begin
		/// tx if the ringbuffer still exist
		if (data_buffer_index != data_buffer_base) begin
			if (tx_clk_cnt == CLOCKS_PER_BIT) begin
			   tx_clk_cnt = 0;											// tx_clk reset
				if (tx_bit_cnt == 0) begin
					tx_bit = 1;												// idle bit
					tx_bit_cnt = 1;
					data_tx = data_buffer[data_buffer_index];
				end
				else if (tx_bit_cnt == 1) begin
					tx_bit = 0;												// start bit
					tx_bit_cnt = 2;
				end
				else if (tx_bit_cnt <= MAX_tx_bit_cnt) begin
					tx_bit = data_tx[tx_bit_cnt - 2];				// data bits
					tx_bit_cnt = tx_bit_cnt + 1;
				end
				else begin
					tx_bit = 1;												// stop bit
					data_buffer_index = data_buffer_index + 1;	// if the index exceeds, it must be zero. WHERE?
					tx_bit_cnt = 0;
				end
				
			end
			else tx_clk_cnt = tx_clk_cnt + 1;							// tx_clk increse
		end
	end
end
*/


// rx
always @(posedge clk) begin
	if (reset == 0) begin
		rx_clk_cnt = 0;
		rx_bit_cnt = 0;
		state_rx = 0;
		led = 0;
	end
	else begin
		// if not receive mode and start bit is detected
		if (state_rx == 0 && uart_rxd == 0) begin					
			state_rx = 1;													// enter receive mode
			rx_bit_cnt = 0;
			rx_clk_cnt = 0;
			flag = 0;
		end
		// if receive mode
		else if (state_rx == 1) begin	
          rx_clk_cnt = rx_clk_cnt + 1;
		
			if (rx_bit_cnt == 0 && rx_clk_cnt == CLOCKS_WAIT_FOR_RECEIVE) begin
				rx_bit_cnt = 1;
				rx_clk_cnt = 0;
			end
			else if (rx_bit_cnt < 9 && rx_clk_cnt == CLOCKS_PER_BIT) begin
				rx_data[rx_bit_cnt - 1] = uart_rxd;
				rx_bit_cnt = rx_bit_cnt + 1;
				rx_clk_cnt = 0;
			end
			// stop receiving
			else if (rx_bit_cnt == 9 && rx_clk_cnt == CLOCKS_PER_BIT && uart_rxd == 1) begin
				state_rx = 0;
				rx_bit_cnt = 0;
				rx_clk_cnt = 0;
				
				led = rx_data;
				flag = flag+1;  //flag 값 0~1 반복(수신 완료 될 때 마다)
				//transmit the received data back to PC.
			end
			// if stop bit is not received, clear the received data
			else if (rx_bit_cnt == 9 && rx_clk_cnt == CLOCKS_PER_BIT && uart_rxd != 1) begin
				state_rx = 0;
				rx_bit_cnt = 0;
				rx_clk_cnt = 0;
				rx_data = 8'b00000000;	// invalidate
			end
			
		end
	end
end

endmodule
