module PWM(clk,reset,pwm_in,pwm_out);

 input clk,reset;
 input [7:0]pwm_in;
 output pwm_out;
 
 reg [7:0]cnt;
 
 always@(posedge clk, negedge reset)
  if(!reset) cnt<=8'b0;
  else begin
   cnt<=cnt+1;
  end
  
 assign pwm_out=(pwm_in>cnt);
 
endmodule
