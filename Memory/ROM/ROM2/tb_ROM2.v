/*
module tb_ROM2;

 reg [3:0]addr;
 reg inclk,outclk;
 
 wire [3:0]q;
 
 ROM2 u0(.addr(addr),.inclk(inclk),.outclk(outclk),.q(q));
 
 integer i;
 parameter sec=50;
 
 always #(sec) inclk=~inclk;
 always #60 outclk=~outclk;
 
 initial begin
  addr=0; inclk=0; outclk=0;
  
  for(i=0; i<=15; i=i+1) begin
   #90; addr=addr+1;
  end
  
  $stop;
 end
  
 
endmodule
*/


module tb_ROM2;

 reg [3:0]addr;
 //reg inclk,outclk;
 reg inclk;
 
 wire [3:0]q;
 
 //ROM2 u0(.addr(addr),.inclk(inclk),.outclk(outclk),.q(q));
 ROM2 u0(.addr(addr),.inclk(inclk),.q(q));
 
 integer i;
 parameter sec=50;
 
 always #(sec) inclk=~inclk;
 //always #60 outclk=~outclk;
 
 initial begin
  addr=0; inclk=0; //outclk=0;
  
  for(i=0; i<=15; i=i+1) begin
   #90; addr=addr+1;
  end
  
  $stop;
 end
  
 
endmodule

