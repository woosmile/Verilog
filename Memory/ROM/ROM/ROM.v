module ROM(clk,cs,rd,addr,rom_data);

 input clk,cs,rd;
 input [3:0]addr;
 
 output [7:0]rom_data;
 
 reg [7:0]rom_data;
 reg [7:0]rom[15:0];
 
 initial begin
  rom[0]=8'b0000_1010;
  rom[1]=8'b0010_1000;
  rom[2]=8'b0001_1110;
  rom[3]=8'b0010_1000;
  rom[4]=8'b0011_0010;
  rom[5]=8'b0011_1100;
  rom[6]=8'b0100_0110;
  rom[7]=8'b0101_0000;
  rom[8]=8'b0101_1010;
  rom[9]=8'b0110_0100;
  rom[10]=8'b0110_1110;
  rom[11]=8'b0111_1000;
  rom[12]=8'b1000_0010;
  rom[13]=8'b1000_1100;
  rom[14]=8'b1001_0110;
  rom[15]=8'b1010_0000;
 end
 
 always@(posedge clk)
  if(cs==1&&rd==1) rom_data=rom[addr];
  else rom_data=8'bz;

endmodule
