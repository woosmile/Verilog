`include "music_define.v"

/*module melody(clk,reset,sw,portA,spk);  //모듈 선언부

 input clk,reset,sw;  //입출력 선언부
 
 output [1:0]portA;
 output reg spk;
 
 reg [27:0]tone_cnt,time_cnt;  //음계와 박자발생 카운트
 integer addr;
 
 assign portA=(!reset) ? 2'b00:2'b01;  //출력방향 설정
 
 reg [27:0]scale [31:0];  //음계 초기화
 initial begin
  scale[0]=`sol;  scale[1]=`mi;  scale[2]=`sol;  scale[3]=`mi;
  scale[4]=`sol;  scale[5]=`ra;  scale[6]=`sol;  scale[7]=`shim;
  scale[8]=`mi;   scale[9]=`sol; scale[10]=`mi;  scale[11]=`do;
  scale[12]=`re;  scale[13]=`mi; scale[14]=`re;  scale[15]=`shim;
  scale[16]=`sol; scale[17]=`mi; scale[18]=`sol; scale[19]=`mi;
  scale[20]=`sol; scale[21]=`ra; scale[22]=`sol; scale[23]=`shim;
  scale[24]=`do;  scale[25]=`ra; scale[26]=`sol; scale[27]=`mi; 
  scale[28]=`re;  scale[29]=`mi; scale[30]=`do;  scale[31]=`shim;
 end
 
 reg [27:0]note [31:0];  //음표 초기화
 initial begin
  note[0]=`n8; note[1]=`n8; note[2]=`n8; note[3]=`n8;
  note[4]=`n8; note[5]=`n8; note[6]=`n4; note[7]=`gap;
  note[8]=`n8; note[9]=`n8; note[10]=`n8; note[11]=`n8;
  note[12]=`n8; note[13]=`n8; note[14]=`n4; note[15]=`gap;
  note[16]=`n8; note[17]=`n8; note[18]=`n8; note[19]=`n8;
  note[20]=`n8; note[21]=`n8; note[22]=`n4; note[23]=`gap;
  note[24]=`n8; note[25]=`n8; note[26]=`n8; note[27]=`n8;
  note[28]=`n8; note[29]=`n8; note[30]=`n4; note[31]=`gap;
 end
 
 always@(posedge clk, negedge reset)  //주파수 발생(음계 발생)
  if(!reset) begin
   tone_cnt<=28'b0;
	spk<=1'b0;
  end
  else begin
   if(sw==1) begin
	 if(tone_cnt>scale[addr]) begin
	  tone_cnt<=28'b0;
	  spk<=~spk;
	 end
	 else tone_cnt<=tone_cnt+1;
	end
	else begin
	 tone_cnt<=28'b0;
	 spk<=1'b0;
	end
  end
  
 always@(posedge clk, negedge reset)  //지연시간 발생(박자 발생)
  if(!reset) begin
   time_cnt<=28'b0;
   addr<=32'b0;
  end
  else begin
   if(sw==1) begin
	 if(time_cnt>note[addr]) begin
	  time_cnt<=28'b0;
	  if(addr>=31) addr<=32'b0;
	  else addr<=addr+1;
	 end
	 else time_cnt<=time_cnt+1;
	end
	else begin
	 time_cnt<=28'b0;
	 addr<=32'b0;
	end
  end
  
endmodule
*/

module melody(clk,reset,sw,portA,spk);  //모듈 선언부

 input clk,reset,sw;  //입출력 선언부
 
 output [1:0]portA;
 output reg spk;
 
 reg [27:0]tone_cnt,time_cnt;  //음계와 박자발생 카운트
 integer addr;
 
 assign portA=(!reset) ? 2'b00:2'b01;  //출력방향 설정
 
 reg [27:0]scale [134:0];  //음계 초기화
 initial begin
  scale[0]=`shim; scale[1]=`do; scale[2]=`mi; scale[3]=`sol;
  scale[4]=`shim; scale[5]=`fa; scale[6]=`sol; scale[7]=`fa;
  scale[8]=`mi; scale[9]=`shim; scale[10]=`mi; scale[11]=`re;
  scale[12]=`do; scale[13]=`shim; scale[14]=`do; scale[15]=`do_4;
  scale[16]=`ra_half; scale[17]=`sol_half; scale[18]=`sol;  scale[19]=`fa;
  scale[20]=`sol; scale[21]=`shim; scale[22]=`fa; scale[23]=`sol;
  scale[24]=`sol_half; scale[25]=`shim; scale[26]=`do_4; scale[27]=`ra_half;
  scale[28]=`sol_half; scale[29]=`sol; scale[30]=`shim; scale[31]=`do;
  scale[32]=`shim; scale[33]=`do; scale[34]=`re; scale[35]=`mi;
  scale[36]=`fa; scale[37]=`sol_half; scale[38]=`sol; scale[39]=`shim;
  scale[40]=`shim; scale[41]=`do; scale[42]=`shim; scale[43]=`do;
  scale[44]=`mi; scale[45]=`sol; scale[46]=`shim; scale[47]=`fa;
  scale[48]=`shim; scale[49]=`fa; scale[50]=`sol; scale[51]=`sol_half;
  scale[52]=`sol; scale[53]=`shim; scale[54]=`sol; scale[55]=`shim;
  scale[56]=`sol; scale[57]=`re_4_half; scale[58]=`re_4; scale[59]=`do_4;
  scale[60]=`ra_half; scale[61]=`re_4; scale[62]=`do_4; scale[63]=`shim;
  scale[64]=`re_4_half; scale[65]=`shim; scale[66]=`re_4_half;
  scale[67]=`shim; scale[68]=`re_4_half; scale[69]=`shim; scale[70]=`re_4_half;
  scale[71]=`shim; scale[72]=`re_4_half; scale[73]=`do_4; scale[74]=`re_4; 
  scale[75]=`shim; scale[76]=`re_4_half; scale[77]=`shim; scale[78]=`re_4_half; 
  scale[79]=`shim; scale[80]=`re_4_half; scale[81]=`shim; scale[82]=`re_4_half; 
  scale[83]=`shim; scale[84]=`re_4_half; scale[85]=`re_4; scale[86]=`do_4;
  scale[87]=`shim; scale[88]=`re_4; scale[89]=`shim; scale[90]=`re_4; 
  scale[91]=`shim; scale[92]=`re_4; scale[93]=`ra_half; scale[94]=`do_4; 
  scale[95]=`shim; scale[96]=`sol_4; scale[97]=`fa_4; scale[98]=`re_4_half; 
  scale[99]=`fa_4; scale[100]=`re_4_half; scale[101]=`re_4; scale[102]=`re_4_half; 
  scale[103]=`shim; scale[104]=`re_4_half; scale[105]=`re_4; scale[106]=`do_4;
  scale[107]=`re_4; scale[108]=`do_4; scale[109]=`ra_half; scale[110]=`sol_4;
  scale[111]=`fa_4; scale[112]=`re_4_half; scale[113]=`fa_4; scale[114]=`re_4_half;
  scale[115]=`re_4; scale[116]=`re_4_half; scale[117]=`shim; scale[118]=`re_4_half;
  scale[119]=`re_4; scale[120]=`do_4; scale[121]=`re_4; scale[122]=`do_4; 
  scale[123]=`ra_half; scale[124]=`do_4; scale[125]=`shim; scale[126]=`do_4;
  scale[127]=`shim; scale[128]=`do_4; scale[129]=`shim; scale[130]=`do_4;
  scale[131]=`re_4; scale[132]=`ra_half; scale[133]=`do_4; scale[134]=`shim;
 end
 
 reg [27:0]note [134:0];  //음표 초기화
 initial begin
  note[0]=`r8; note[1]=`n4; note[2]=`n8; note[3]=`n2;
  note[4]=`r8; note[5]=`n8; note[6]=`n8; note[7]=`n8;
  note[8]=`n4; note[9]=`gap; note[10]=`n8; note[11]=`n8;
  note[12]=`nd4; note[13]=`gap; note[14]=`n8; note[15]=`nd4;
  note[16]=`n8; note[17]=`n4; note[18]=`n8;  note[19]=`n8;
  note[20]=`n2; note[21]=`r8; note[22]=`n4; note[23]=`n8;
  note[24]=`n2; note[25]=`r8; note[26]=`n8; note[27]=`n8; 
  note[28]=`n8; note[29]=`n2; note[30]=`r8; note[31]=`n8;
  note[32]=`gap; note[33]=`n8; note[34]=`n8; note[35]=`n4;
  note[36]=`n8; note[37]=`n8; note[38]=`nd2; note[39]=`r4; 
  note[40]=`r8; note[41]=`n8; note[42]=`gap; note[43]=`n8; 
  note[44]=`n8; note[45]=`n2; note[46]=`r8; note[47]=`n8;
  note[48]=`gap; note[49]=`n8; note[50]=`n8; note[51]=`n2; 
  note[52]=`n8; note[53]=`gap; note[54]=`n8; note[55]=`gap; 
  note[56]=`n8; note[57]=`n8; note[58]=`n8; note[59]=`n8;
  note[60]=`n8; note[61]=`n8; note[62]=`nd2; note[63]=`r4;
  note[64]=`n8; note[65]=`gap; note[66]=`n8; note[67]=`gap; 
  note[68]=`n8; note[69]=`gap; note[70]=`n8; note[71]=`gap;
  note[72]=`n4; note[73]=`n8; note[74]=`n8; note[75]=`r8;
  note[76]=`n8; note[77]=`gap; note[78]=`n8; note[79]=`gap;
  note[80]=`n8; note[81]=`gap; note[82]=`n8; note[83]=`gap;
  note[84]=`n8; note[85]=`n8; note[86]=`n8; note[87]=`r8;
  note[88]=`n4; note[89]=`gap; note[90]=`n8; note[91]=`gap;
  note[92]=`n4; note[93]=`n4; note[94]=`nd2; note[95]=`r4;
  note[96]=`n4; note[97]=`n8; note[98]=`n8; note[99]=`n8;
  note[100]=`n8; note[101]=`n4; note[102]=`n8; note[103]=`gap;
  note[104]=`n8; note[105]=`n8; note[106]=`n8; note[107]=`n8;
  note[108]=`n8; note[109]=`n4; note[110]=`n4; note[111]=`n8;
  note[112]=`n8; note[113]=`n8; note[114]=`n8; note[115]=`n4;
  note[116]=`n8; note[117]=`gap; note[118]=`n8; note[119]=`n8; 
  note[120]=`n8; note[121]=`n8; note[122]=`n8; note[123]=`n4;
  note[124]=`n8; note[125]=`gap; note[126]=`n8; note[127]=`gap;
  note[128]=`n8; note[129]=`gap; note[130]=`n8; note[131]=`n4;
  note[132]=`n4; note[133]=`nd2; note[134]=`r8;
 end
 
 always@(posedge clk, negedge reset)  //주파수 발생(음계 발생)
  if(!reset) begin
   tone_cnt<=28'b0;
	spk<=1'b0;
  end
  else begin
   if(sw==1) begin
	 if(tone_cnt>scale[addr]) begin
	  tone_cnt<=28'b0;
	  spk<=~spk;
	 end
	 else tone_cnt<=tone_cnt+1;
	end
	else begin
	 tone_cnt<=28'b0;
	 spk<=1'b0;
	end
  end
  
 always@(posedge clk, negedge reset)  //지연시간 발생(박자 발생)
  if(!reset) begin
   time_cnt<=28'b0;
   addr<=32'b0;
  end
  else begin
   if(sw==1) begin
	 if(time_cnt>note[addr]) begin
	  time_cnt<=28'b0;
	  if(addr>=134) addr<=32'b0;
	  else addr<=addr+1;
	 end
	 else time_cnt<=time_cnt+1;
	end
	else begin
	 time_cnt<=28'b0;
	 addr<=32'b0;
	end
  end
  
endmodule

/*
module melody(clk,reset,sw,push_sw,portA,spk);  //모듈 선언부

 input clk,reset,sw,push_sw;  //입출력 선언부
 
 output [1:0]portA;
 output reg spk;
 
 reg [27:0]tone_cnt,time_cnt;  //음계와 박자발생 카운트
 reg [7:0]sw_buff;
 reg flag;
 integer addr;
 
 assign portA=(!reset) ? 2'b00:2'b01;  //출력방향 설정
 
 reg [27:0]scale0 [134:0];  //음계 초기화
 initial begin
  scale0[0]=`shim; scale0[1]=`do; scale0[2]=`mi; scale0[3]=`sol;
  scale0[4]=`shim; scale0[5]=`fa; scale0[6]=`sol; scale0[7]=`fa;
  scale0[8]=`mi; scale0[9]=`shim; scale0[10]=`mi; scale0[11]=`re;
  scale0[12]=`do; scale0[13]=`shim; scale0[14]=`do; scale0[15]=`do_4;
  scale0[16]=`ra_half; scale0[17]=`sol_half; scale0[18]=`sol;  scale0[19]=`fa;
  scale0[20]=`sol; scale0[21]=`shim; scale0[22]=`fa; scale0[23]=`sol;
  scale0[24]=`sol_half; scale0[25]=`shim; scale0[26]=`do_4; scale0[27]=`ra_half;
  scale0[28]=`sol_half; scale0[29]=`sol; scale0[30]=`shim; scale0[31]=`do;
  scale0[32]=`shim; scale0[33]=`do; scale0[34]=`re; scale0[35]=`mi;
  scale0[36]=`fa; scale0[37]=`sol_half; scale0[38]=`sol; scale0[39]=`shim;
  scale0[40]=`shim; scale0[41]=`do; scale0[42]=`shim; scale0[43]=`do;
  scale0[44]=`mi; scale0[45]=`sol; scale0[46]=`shim; scale0[47]=`fa;
  scale0[48]=`shim; scale0[49]=`fa; scale0[50]=`sol; scale0[51]=`sol_half;
  scale0[52]=`sol; scale0[53]=`shim; scale0[54]=`sol; scale0[55]=`shim;
  scale0[56]=`sol; scale0[57]=`re_4_half; scale0[58]=`re_4; scale0[59]=`do_4;
  scale0[60]=`ra_half; scale0[61]=`re_4; scale0[62]=`do_4; scale0[63]=`shim;
  scale0[64]=`re_4_half; scale0[65]=`shim; scale0[66]=`re_4_half;
  scale0[67]=`shim; scale0[68]=`re_4_half; scale0[69]=`shim; scale0[70]=`re_4_half;
  scale0[71]=`shim; scale0[72]=`re_4_half; scale0[73]=`do_4; scale0[74]=`re_4; 
  scale0[75]=`shim; scale0[76]=`re_4_half; scale0[77]=`shim; scale0[78]=`re_4_half; 
  scale0[79]=`shim; scale0[80]=`re_4_half; scale0[81]=`shim; scale0[82]=`re_4_half; 
  scale0[83]=`shim; scale0[84]=`re_4_half; scale0[85]=`re_4; scale0[86]=`do_4;
  scale0[87]=`shim; scale0[88]=`re_4; scale0[89]=`shim; scale0[90]=`re_4; 
  scale0[91]=`shim; scale0[92]=`re_4; scale0[93]=`ra_half; scale0[94]=`do_4; 
  scale0[95]=`shim; scale0[96]=`sol_4; scale0[97]=`fa_4; scale0[98]=`re_4_half; 
  scale0[99]=`fa_4; scale0[100]=`re_4_half; scale0[101]=`re_4; scale0[102]=`re_4_half; 
  scale0[103]=`shim; scale0[104]=`re_4_half; scale0[105]=`re_4; scale0[106]=`do_4;
  scale0[107]=`re_4; scale0[108]=`do_4; scale0[109]=`ra_half; scale0[110]=`sol_4;
  scale0[111]=`fa_4; scale0[112]=`re_4_half; scale0[113]=`fa_4; scale0[114]=`re_4_half;
  scale0[115]=`re_4; scale0[116]=`re_4_half; scale0[117]=`shim; scale0[118]=`re_4_half;
  scale0[119]=`re_4; scale0[120]=`do_4; scale0[121]=`re_4; scale0[122]=`do_4; 
  scale0[123]=`ra_half; scale0[124]=`do_4; scale0[125]=`shim; scale0[126]=`do_4;
  scale0[127]=`shim; scale0[128]=`do_4; scale0[129]=`shim; scale0[130]=`do_4;
  scale0[131]=`re_4; scale0[132]=`ra_half; scale0[133]=`do_4; scale0[134]=`shim;
 end
 reg [27:0]note0 [134:0];  //음표 초기화
 initial begin
  note0[0]=`r8; note0[1]=`n4; note0[2]=`n8; note0[3]=`n2;
  note0[4]=`r8; note0[5]=`n8; note0[6]=`n8; note0[7]=`n8;
  note0[8]=`n4; note0[9]=`gap; note0[10]=`n8; note0[11]=`n8;
  note0[12]=`nd4; note0[13]=`gap; note0[14]=`n8; note0[15]=`nd4;
  note0[16]=`n8; note0[17]=`n4; note0[18]=`n8;  note0[19]=`n8;
  note0[20]=`n2; note0[21]=`r8; note0[22]=`n4; note0[23]=`n8;
  note0[24]=`n2; note0[25]=`r8; note0[26]=`n8; note0[27]=`n8; 
  note0[28]=`n8; note0[29]=`n2; note0[30]=`r8; note0[31]=`n8;
  note0[32]=`gap; note0[33]=`n8; note0[34]=`n8; note0[35]=`n4;
  note0[36]=`n8; note0[37]=`n8; note0[38]=`nd2; note0[39]=`r4; 
  note0[40]=`r8; note0[41]=`n8; note0[42]=`gap; note0[43]=`n8; 
  note0[44]=`n8; note0[45]=`n2; note0[46]=`r8; note0[47]=`n8;
  note0[48]=`gap; note0[49]=`n8; note0[50]=`n8; note0[51]=`n2; 
  note0[52]=`n8; note0[53]=`gap; note0[54]=`n8; note0[55]=`gap; 
  note0[56]=`n8; note0[57]=`n8; note0[58]=`n8; note0[59]=`n8;
  note0[60]=`n8; note0[61]=`n8; note0[62]=`nd2; note0[63]=`r4;
  note0[64]=`n8; note0[65]=`gap; note0[66]=`n8; note0[67]=`gap; 
  note0[68]=`n8; note0[69]=`gap; note0[70]=`n8; note0[71]=`gap;
  note0[72]=`n4; note0[73]=`n8; note0[74]=`n8; note0[75]=`r8;
  note0[76]=`n8; note0[77]=`gap; note0[78]=`n8; note0[79]=`gap;
  note0[80]=`n8; note0[81]=`gap; note0[82]=`n8; note0[83]=`gap;
  note0[84]=`n8; note0[85]=`n8; note0[86]=`n8; note0[87]=`r8;
  note0[88]=`n4; note0[89]=`gap; note0[90]=`n8; note0[91]=`gap;
  note0[92]=`n4; note0[93]=`n4; note0[94]=`nd2; note0[95]=`r4;
  note0[96]=`n4; note0[97]=`n8; note0[98]=`n8; note0[99]=`n8;
  note0[100]=`n8; note0[101]=`n4; note0[102]=`n8; note0[103]=`gap;
  note0[104]=`n8; note0[105]=`n8; note0[106]=`n8; note0[107]=`n8;
  note0[108]=`n8; note0[109]=`n4; note0[110]=`n4; note0[111]=`n8;
  note0[112]=`n8; note0[113]=`n8; note0[114]=`n8; note0[115]=`n4;
  note0[116]=`n8; note0[117]=`gap; note0[118]=`n8; note0[119]=`n8; 
  note0[120]=`n8; note0[121]=`n8; note0[122]=`n8; note0[123]=`n4;
  note0[124]=`n8; note0[125]=`gap; note0[126]=`n8; note0[127]=`gap;
  note0[128]=`n8; note0[129]=`gap; note0[130]=`n8; note0[131]=`n4;
  note0[132]=`n4; note0[133]=`nd2; note0[134]=`r8;
 end
 
 reg [27:0]scale1 [31:0];  //음계 초기화
 initial begin
  scale1[0]=`sol;  scale1[1]=`mi;  scale1[2]=`sol;  scale1[3]=`mi;
  scale1[4]=`sol;  scale1[5]=`ra;  scale1[6]=`sol;  scale1[7]=`shim;
  scale1[8]=`mi;   scale1[9]=`sol; scale1[10]=`mi;  scale1[11]=`do;
  scale1[12]=`re;  scale1[13]=`mi; scale1[14]=`re;  scale1[15]=`shim;
  scale1[16]=`sol; scale1[17]=`mi; scale1[18]=`sol; scale1[19]=`mi;
  scale1[20]=`sol; scale1[21]=`ra; scale1[22]=`sol; scale1[23]=`shim;
  scale1[24]=`do;  scale1[25]=`ra; scale1[26]=`sol; scale1[27]=`mi; 
  scale1[28]=`re;  scale1[29]=`mi; scale1[30]=`do;  scale1[31]=`shim;
 end
 reg [27:0]note1 [31:0];  //음표 초기화
 initial begin
  note1[0]=`n8; note1[1]=`n8; note1[2]=`n8; note1[3]=`n8;
  note1[4]=`n8; note1[5]=`n8; note1[6]=`n4; note1[7]=`gap;
  note1[8]=`n8; note1[9]=`n8; note1[10]=`n8; note1[11]=`n8;
  note1[12]=`n8; note1[13]=`n8; note1[14]=`n4; note1[15]=`gap;
  note1[16]=`n8; note1[17]=`n8; note1[18]=`n8; note1[19]=`n8;
  note1[20]=`n8; note1[21]=`n8; note1[22]=`n4; note1[23]=`gap;
  note1[24]=`n8; note1[25]=`n8; note1[26]=`n8; note1[27]=`n8;
  note1[28]=`n8; note1[29]=`n8; note1[30]=`n4; note1[31]=`gap;
 end
 
 always@(posedge clk, negedge reset)
  if(!reset) sw_buff<=8'b0;
  else sw_buff<={sw_buff[6:0],push_sw};
  
 always@(posedge clk, negedge reset)
  if(!reset) flag<=1'b0;
  else begin
   if(sw==1) begin
	 if(sw_buff==1) flag<=~flag;  //flag값 변화로 인한 노래 변경
	end
  end
 
 always@(posedge clk, negedge reset)  //주파수 발생(음계 발생)
  if(!reset) begin
   tone_cnt<=28'b0;
	spk<=1'b0;
  end
  else begin
   if(sw==1) begin
	 if(flag==1) begin
	  if(tone_cnt>scale0[addr]) begin
	   tone_cnt<=28'b0;
	   spk<=~spk;
	  end
	  else tone_cnt<=tone_cnt+1;
	 end
	 else begin
	  if(tone_cnt>scale1[addr]) begin
	   tone_cnt<=28'b0;
	   spk<=~spk;
	  end
	  else tone_cnt<=tone_cnt+1;
	 end
	end
	else begin
	 tone_cnt<=28'b0;
	 spk<=1'b0;
	end
  end
  
 always@(posedge clk, negedge reset)  //지연시간 발생(박자 발생)
  if(!reset) begin
   time_cnt<=28'b0;
   addr<=32'b0;
  end
  else begin
   if(sw==1) begin
	 if(sw_buff==1) addr<=0;  //스위치가 눌리면 addr 초기화
	 
	 if(flag==1) begin
	  if(time_cnt>note0[addr]) begin
	   time_cnt<=28'b0;
	   if(addr>=134) addr<=32'b0;
	   else addr<=addr+1;
	  end
	  else time_cnt<=time_cnt+1;
	 end
	 
	 else begin
	  if(time_cnt>note1[addr]) begin
	   time_cnt<=28'b0;
	   if(addr>=31) addr<=32'b0;
	   else addr<=addr+1;
	  end
	  else time_cnt<=time_cnt+1;
	 end
	end
	else begin
	 time_cnt<=28'b0;
	 addr<=32'b0;
	end
  end
  
endmodule
*/
