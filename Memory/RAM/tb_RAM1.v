`timescale 1ns/100ps
module tb_RAM1;

 reg clk,wr,rd;
 reg [3:0]addr;
 reg [3:0]data_in;
 wire [3:0]data_out;

 RAM1 u0(.clk(clk),.wr(wr),.rd(rd),.addr(addr),.data_in(data_in),.q(data_out));

 parameter step=100;
 integer i;

 always #(step/2) clk=~clk; 

 initial begin
  clk=1; wr=1; rd=1; addr=0; data_in=0; #(step-10);
  wr=0; addr=0; #step;
  
  for(i=0;i<=15;i=i+1) begin
   #step; addr=addr+1; data_in=data_in+1;
  end
  
  wr=1; addr=0; rd=0; #step;
  
  for(i=0;i<=15;i=i+1) begin
   #step; addr=addr+1;
  end
  
  rd=1;addr=0; #step; $stop;
  
 end

endmodule 