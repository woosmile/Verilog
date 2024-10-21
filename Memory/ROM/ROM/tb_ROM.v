module tb_ROM;

 reg clk,cs,rd;
 reg [3:0]addr;
 wire [7:0]rom_data;
 
 ROM u0(clk,cs,rd,addr,rom_data);
 
 always #50 clk=~clk;
 
 integer i;
 
 initial begin
  clk=1; cs=0; rd=0; addr=0;
  #60 cs=1; rd=1;
  
  for(i=0;i<=15;i=i+1) begin
   #100 addr=addr+1;
  end
  
  #60 cs=0; rd=1;
  
  for(i=0;i<=15;i=i+1) begin
   #100 addr=addr+1;
  end
  
  #60 cs=1; rd=0;
  
  for(i=0;i<=15;i=i+1) begin
   #100 addr=addr+1;
  end
  
  $stop;
 end
 
endmodule
