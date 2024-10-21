module DSP_4bitFND(clk,rst,num,fnd_data,fnd_en,fnd_sel);

 input [10:0]num;
 input clk,rst;
 
 output [7:0]fnd_data;
 output fnd_en;
 output [3:0]fnd_sel;
 
 reg [7:0]fnd_data;
 reg [27:0]scan_cnt;
 reg [3:0]fnd_sel,temp;
 reg [1:0]digit;
 
 assign fnd_en=0;
 
 always@(posedge clk, negedge rst)
 begin
  if(!rst) begin
   scan_cnt<=0;
	digit<=0;
  end
  
  else begin
   if(scan_cnt==134999) begin
	 digit<=(digit+1)%4;
	 scan_cnt<=0;
	end
	else scan_cnt<=scan_cnt+1;
  end
 end
 
 always@(posedge clk, negedge rst)
 begin
  if(!rst) begin
	fnd_sel<=4'b0000;
	temp<=0;
  end

  else begin
   case(digit)
	 0 : begin temp<=num%10; fnd_sel<=4'b1110; end
	 1 : begin temp<=(num/10)%10; fnd_sel<=4'b1101; end
	 2 : begin temp<=(num/100)%10; fnd_sel<=4'b1011; end
	 3 : begin temp<=(num/1000); fnd_sel<=4'b0111; end
	 default : begin temp<=0; fnd_sel<=4'b0000; end
	endcase
  end
 end

 always@(temp)
 begin
  case(temp)
   4'b0000 : fnd_data = 8'b0011_1111; //0
	4'b0001 : fnd_data = 8'b0000_0110; //1
	4'b0010 : fnd_data = 8'b0101_1011; //2
	4'b0011 : fnd_data = 8'b0100_1111; //3
   4'b0100 : fnd_data = 8'b0110_0110; //4
	4'b0101 : fnd_data = 8'b0110_1101; //5
	4'b0110 : fnd_data = 8'b0111_1101; //6
	4'b0111 : fnd_data = 8'b0000_0111; //7
	4'b1000 : fnd_data = 8'b0111_1111; //8
	4'b1001 : fnd_data = 8'b0110_1111; //9
	default : fnd_data = 8'b0000_0000; //null
  endcase
 end
 
endmodule
