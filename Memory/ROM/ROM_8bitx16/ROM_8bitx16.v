/*
module ROM_8bitx16(clk, reset, fnd_en, fnd_sel, fnd_data);

 input clk, reset;
 
 output fnd_en;
 output [3:0]fnd_sel;
 output [7:0]fnd_data;
 
 reg [3:0]addr;
 wire [7:0]data_out;
 
 reg [31:0]cnt;
 
 ROM1 u0(.address(addr),.clock(clk),.q(data_out));
 
 assign fnd_en=(!reset) ? 1'b1:1'b0;
 assign fnd_sel=4'b1110;
 assign fnd_data=data_out;

 always@(posedge clk, negedge reset)
  if(!reset) {cnt,addr}<=0;
  else begin
   if(cnt>=26999999) begin
	 cnt<=0;
	 addr<=addr+1;
	end
	else cnt<=cnt+1;
  end
  
endmodule
*/

module ROM_8bitx16(clk, reset, fnd_en, fnd_sel, fnd_data);  //모듈선언부

 input clk, reset;  //입력선언
 
 output fnd_en;  //fnd 관련 출력선언
 output [3:0]fnd_sel;
 output [7:0]fnd_data;
 
 reg [3:0]addr;  //ROM을 읽기 위한 주소 변수
 reg [31:0]cnt;  //0.5초를 위한 카운트 변수
 
 ROM1 u0(.address(addr),.clock(clk),.q(fnd_data));  //megawizard를 사용한 ROM
 
 assign fnd_en=(!reset) ? 1'b1:1'b0; //FND 활성화
 assign fnd_sel=4'b1110;  //1의 자리 ON

 always@(posedge clk, negedge reset)  //0.5초씩마다 addr값을 1씩 증가
  if(!reset) {cnt,addr}<=0;
  else begin
   if(cnt>=26999999) begin
	 cnt<=0;
	 addr<=addr+1;
	end
	else cnt<=cnt+1;
  end
  
endmodule


 
	