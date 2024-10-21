module tb_FSM_Moore;

 reg clock,rst,ctrl;
 wire [2:0]y;
 
 FSM_Moore u0(.clk(clock),.reset(rst),.control(ctrl),.y(y));
 
 parameter step=50;
 
 always #step clock=~clock;
 
 initial begin
  clock=0; rst=0; ctrl=0;
  
  #110 ctrl=1;
  #120 ctrl=0;
  #150 rst=1;
  #50 rst=0;
  #200 $stop;
 end

endmodule
 