module tb_FSM_Mealy;

 reg clock,rst,w;
 wire z;
 
 FSM_Mealy u0(.clk(clock),.reset(rst),.w(w),.z(z));
 
 parameter step=50;
 
 always #step clock=~clock;
 always #(step-15) w=~w;
 
 initial begin
  clock=0; rst=1; w=0; #40;
  
  rst=0; #400;
  
  $stop;
 end
 
endmodule

  

