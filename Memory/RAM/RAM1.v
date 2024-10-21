module RAM1(clk,wr,rd,addr,data_in,q);

 input clk, wr, rd;
 input [3:0]addr,data_in;
 output [3:0]q;

 //reg [3:0]q;
 reg [3:0]SRAM [15:0];
 /*
 always@(posedge clk)
  if(!rd) q<=SRAM[addr];
  else q<=4'bz;
 */
 
 assign q=(rd==0) ? SRAM[addr] : 4'bz;
 
 always@(posedge clk)
  if(!wr) SRAM[addr]<=data_in;
  
endmodule
