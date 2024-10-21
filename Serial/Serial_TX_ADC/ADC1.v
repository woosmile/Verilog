/*****           A/D변환 LED 표시  *****/

module ADC1(clk,	reset, adc_clk, ale, start, oe, eoc, adc_input, addr, adc_data);

input			      clk;
input			      reset;
input			      eoc;
input	      [7:0]	adc_input;   // ad변환 결과값 (8비트 2진 데이터)

output		      adc_clk;
output 		      oe;
output 		      ale;
output 		      start;
output      [2:0] addr;
output      [7:0] adc_data;    // led로 출력

reg 					adc_clk;
reg 					oe;
reg 					ale;
reg 					start;
reg     		[2:0] addr;
reg     		[7:0] adc_data;
reg  			[7:0] adc_time;
reg     		[7:0] clk_count;
reg		  			adc_capture;
reg         [2:0] state;

parameter [2:0]
	S_IDLE		= 3'b0,
	S_START 		= 3'd1,
	S_WAIT 		= 3'd2,         
	S_OE      	= 3'd3,
	S_CAPTURE	= 3'd4;
	

always @ (posedge clk) 
begin
	if(!reset) 
	begin
		clk_count <= 8'h00;
		adc_clk   <= 1'b0;
	end
	else 
	begin
		if(clk_count < 27) 
			clk_count <= clk_count + 1'b1;  //1Mhz
		else 
		begin
			clk_count <= 8'h00;
			adc_clk   <= ~adc_clk;
		end
	end	
end

always @ (posedge clk) begin
	if(!reset) begin
		state <= S_IDLE;	
	end
	
	else begin
		case(state)
			S_IDLE  : 	state <= S_START;

			S_START : 	if(adc_time > 100) state <= S_IDLE;					
			            else if(eoc == 0)	 state <= S_WAIT;
							else state <= S_START;
							
			S_WAIT:  if(eoc == 1)	state <= S_OE;

			S_OE : if(adc_time > 12)state <= S_CAPTURE;

			S_CAPTURE : state <= S_IDLE;
							
			default :	state <= S_IDLE;
			
		endcase
	end
end

always@(posedge clk)
begin
	case(state)
		S_IDLE : begin
						oe <= 0;
						ale <= 0;
						start	<= 0;
						addr	<= 0;
					end
		
		S_START : begin
						if(adc_time < 1) 
						begin
							ale	<= 0;     
							start	<= 0;
							addr	<= 0;  // 아날로그입력 어드레스 출력 
						end 
						else if(adc_time < 3) 
						begin
							ale <= 1;    // ale 신호 출력 
							start	<= 0;    //아날로그입력 어드레스 출력 
							addr <= 0;
						end 
						
						else if(adc_time < 5) 
						begin
							ale <= 1;  // ale 신호 출력 
							start <= 1;  // start 신호 출력 
							addr <= 0;
						end 
						
						else if(adc_time <12) 
						begin
							ale <= 0;
							start <= 1;  // start 신호 출력 
							addr <= 0;
						end 
						
						else  
						begin
							ale	<= 0;
							start	<= 0;
							addr	<= 0;
						end
					end
					
		S_WAIT : begin
						ale	<= 0;
						start	<= 0;
						addr	<= 0;
					end
		
		S_OE : if(adc_time < 10)	oe <= 1;
				 else	oe <= 0;
		
		S_CAPTURE : oe <= 1;
		
		default : begin
						ale <= 0;
						start <= 0;
						addr <= 0;
						oe <= 0;
					end
	endcase
end

always @ (posedge clk) 
begin
	if(!reset) 
	begin
		adc_time <= 0;
	end
	else 
	begin
		if((state == S_START)||(state == S_OE))
			adc_time <= adc_time + 1'b1;
		else
			adc_time <= 0;
	end
end


always @ (posedge clk) 
begin
	if(!reset) 
	begin
		adc_data <= 0;
	end
	else 
	begin
		if(state == S_CAPTURE)
			adc_data <= adc_input;
	end
end

endmodule 