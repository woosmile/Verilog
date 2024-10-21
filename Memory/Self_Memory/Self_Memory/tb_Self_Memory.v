module tb_Self_Memory;  //add_sub=0 ª©±‚ / add_sub=1 ¥ı«œ±‚ 

 reg clock,rst,ADD_SUB;
 reg [7:0]A,B;
 
 wire [7:0]out;
 wire overflow;
 
 Self_Memory u0(.clk(clock),.reset(rst),.add_sub(ADD_SUB),.a(A),.b(B),.result(out),.ovf(overflow));
 
 always #10 clock=~clock;
 
 initial begin
  clock=1; rst=1; ADD_SUB=0; A=0; B=0; #15;
 end
 
 initial fork
  #21 ADD_SUB=1;
  #35 rst=0; 
  #48 A=12; 
  #53 B=44;
  #66 A=151;
  #80 B=162;
  #99 rst=1;
  #110 ADD_SUB=0;
  #135 rst=0;
  #150 A=35;
  #178 B=13;
  #200 A=20;
  #243 B=56;
  #270 rst=1;
  #300 $stop;
 join

endmodule
