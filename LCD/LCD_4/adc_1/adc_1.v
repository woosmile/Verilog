module adc_1(clk,reset,eoc,start,ale,out_en,adc_clk,addr,result,led);  //모듈 선언부
 
 input clk,reset;  //입출력 선언부
 input eoc;
 input [7:0]result;
 
 output reg [7:0]led;  
 output reg [2:0]addr;
 output reg start,ale,out_en,adc_clk;
 
 reg [7:0]clk_cnt,adc_delay;  //카운트 변수
 reg [2:0]c_state,n_state;
 
 parameter s_idle=3'b000, s_start=3'b001, s_wait=3'b010;  //상태값
 parameter s_oe_sig=3'b011, s_capture=3'b100;
 
 always@(posedge clk, negedge reset)  //1Mhz 발생 회로
  if(!reset) begin
   clk_cnt<=8'b0;
	adc_clk<=0;
  end
  else begin
   if(clk_cnt>=26) begin
	 clk_cnt<=8'b0;
	 adc_clk=~adc_clk;
	end
	else clk_cnt<=clk_cnt+1;
  end

 always@(posedge clk, negedge reset)  //타이밍 발생 회로
  if(!reset) adc_delay<=8'b0;
  else begin
   if(c_state==s_start || c_state==s_oe_sig)
	 adc_delay<=adc_delay+1;
	else adc_delay<=8'b0;
  end
  
 always@(c_state,adc_delay)  //상태에 따른 출력값 회로
   case(c_state)
    s_idle : begin
	  start<=0;
	  ale<=0;
	  addr<=0;
	  out_en<=0;
	 end
    s_start : begin
	  if(adc_delay<1) begin
	   ale<=0;
		start<=0;
		addr<=0;
	  end
	  else if(adc_delay<3) begin
	   ale<=1;
		start<=0;
		addr<=0;
	  end
	  else if(adc_delay<5) begin
	   ale<=1;
		start<=1;
		addr<=0;
	  end
	  else if(adc_delay<11) begin
	   ale<=0;
		start<=1;
		addr<=0;
	  end
	  else if(adc_delay<13) begin
	   ale<=0;
		start<=0;
		addr<=0;
	  end
	  else begin
	   ale<=0;
		start<=0;
		addr<=0;
	  end
	 end
	 s_oe_sig : begin
	  if(adc_delay<10) out_en<=1;
	  else out_en<=0;	   
	 end
	 s_capture : out_en<=1;
	 default : begin
	  start<=0;
	  ale<=0;
	  addr<=0;
	  out_en<=0;
	 end
	endcase
  
 always@(posedge clk, negedge reset)  //상태 레지스터
  if(!reset) c_state<=s_idle;
  else c_state<=n_state;
	  
 always@(c_state,eoc,adc_delay)  //상태 천이 회로
  case(c_state)
	s_idle : n_state=s_start;
	s_start : begin
	 if(eoc==0) n_state=s_wait;
	 else if(adc_delay>100) n_state=s_idle;
	 else n_state=s_start;
	end
	s_wait : begin
	 if(eoc==1) n_state=s_oe_sig;
	 else n_state<=s_wait;
	end
	s_oe_sig : begin
	 if(adc_delay>12) n_state=s_capture;
	 else n_state<=s_oe_sig;
	end
	s_capture : n_state=s_idle;
	default : n_state=s_idle;
  endcase
  
 always@(posedge clk, negedge reset)  //LED 출력 회로
  if(!reset) led<=8'b0;
  else begin
   if(c_state==s_capture) led<=result;
	else led<=led;
  end

endmodule
