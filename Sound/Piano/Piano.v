module Piano(clk,reset,sw,spk,portA,led);  //모듈 선언부

 input clk, reset;
 input [7:0]sw;
 output [1:0]portA;
 output reg [7:0]led;
 output reg spk;
 
 reg [31:0]cnt,melody;
 
 assign portA=(!reset) ? 2'b11:2'b01;  //포트 방향 설정
 
 always@(sw)
  case(sw)
   8'h80 : begin melody=206107; led=8'h80; end  //도
	8'h40 : begin melody=183673; led=8'h80; end  //레
	8'h20 : begin melody=163636; led=8'h80; end  //미
	8'h10 : begin melody=154727; led=8'h80; end  //파
	8'h08 : begin melody=137755; led=8'h80; end  //솔
	8'h04 : begin melody=122727; led=8'h80; end  //라
	8'h02 : begin melody=109312; led=8'h80; end  //시
	8'h01 : begin melody=103201; led=8'h80; end  //도(H)
	default begin melody=0; led=8'b0; end
  endcase

 always@(posedge clk, negedge reset)
  if(!reset) begin
   spk<=1'b0;
	cnt<=32'b0;
  end
  else begin
	if(cnt>=melody) begin  //분주
	 cnt<=0;
	 spk<=~spk;
	end
	else cnt<=cnt+1;
  end
 
endmodule

/*
module Piano(clk,reset,sw,speaker1,speaker2,portA,portB);
	input clk,reset;
	input [1:0]sw;
	output speaker1,speaker2;
	output [1:0]portA,portB;
	
	reg start;
	reg spk1=0,spk2=0;
	reg [7:0] addr1=0,addr2=0;
	reg [27:0] play_time1=0,play_time2=0;
	reg [27:0] sound_cnt1=0,sound_cnt2=0;
	integer cnt=0;
	
	assign portA=(!reset) ? 2'b11:2'b01;
	assign portB=(!reset) ? 2'b11:2'b01;
	assign speaker1=spk1;
	assign speaker2=spk2;
	
	parameter do=103200, re=91941, mi=81910, fa=77313, sfa=72972;
	parameter sol=68878, ra=61363, si=54668, shim=0;
	parameter nasi=109355, nara=122727, nasol=137755, nafa=154635, nami=163834;
	parameter nodo=51600, nore=45965, nomi=40950, nofa=38655;
	parameter nosol=34438, nora=30681, nosi=27334, nnodo=25800;
	parameter snodo=48700;
	parameter N32=2700000, N16=N32*2, ND16=N32*3, N8=N32*4, ND8=N32*6, N4=N32*8, ND4=N32*12, N2=N32*16, ND2=N32*24, N1=N32*32;
	parameter R32=2700000, R16=R32*2, RD16=R32*3, R8=R32*4, RD8=R32*6, R4=R32*8, RD4=R32*12, R2=R32*16, RD2=R32*24, R1=R32*32, R48=R32/2;
	parameter N5=N4/5;

	reg [31:0] scale1 [119:0];
	initial
		begin
			scale1[0]=nodo; scale1[1]=nomi; scale1[2]=nosol; scale1[3]=si; 
			scale1[4]=nodo; scale1[5]=nore; scale1[6]=nodo;  scale1[7]=nora;
			scale1[8]=nosol; scale1[9]=nnodo; scale1[10]=nosol; scale1[11]=nofa;
			scale1[12]=nosol; scale1[13]=nofa; scale1[14]=nomi; scale1[15]=nofa;
			scale1[16]=nomi; scale1[17]=ra; scale1[18]=si; scale1[19]=nodo;
			scale1[20]=nore; scale1[21]=nomi; scale1[22]=nofa; scale1[23]=nosol;
			scale1[24]=nora; scale1[25]=nosol; scale1[26]=nofa; scale1[27]=nomi;
			scale1[28]=nore; scale1[29]=nodo; scale1[30]=si; scale1[31]=ra;
			scale1[32]=sol; scale1[33]=ra; scale1[34]=si; scale1[35]=nodo;
			scale1[36]=nore; scale1[37]=nomi; scale1[38]=nofa; scale1[39]=nosol;
			scale1[40]=nofa; scale1[41]=nomi; scale1[42]=nore; scale1[43]=nodo;
			scale1[44]=si; scale1[45]=ra; scale1[46]=sol; scale1[47]=fa;
			scale1[48]=sol; scale1[49]=ra; scale1[50]=si; scale1[51]=nodo; 
			scale1[52]=nore; scale1[53]=nomi;scale1[54]=nofa; scale1[55]=nomi; 
			scale1[56]=nore; scale1[57]=nodo; scale1[58]=si; scale1[59]=ra; 
			scale1[60]=sol; scale1[61]=fa; scale1[62]=mi; scale1[63]=fa; 
			scale1[64]=sol; scale1[65]=ra; scale1[66]=si; scale1[67]=nodo; 
			scale1[68]=nore; scale1[69]=nomi; scale1[70]=nore; scale1[71]=nodo; 
			scale1[72]=si; scale1[73]=ra; scale1[74]=sol; scale1[75]=fa; 
			scale1[76]=mi; scale1[77]=re; scale1[78]=mi; scale1[79]=fa;
			scale1[80]=sol; scale1[81]=ra; scale1[82]=si; scale1[83]=snodo;
			scale1[84]=nore; scale1[85]=ra; scale1[86]=si; scale1[87]=snodo;
			scale1[88]=nore; scale1[89]=nomi; scale1[90]=nofa; scale1[91]=nosol;
			scale1[92]=nora; scale1[93]=nosi; scale1[94]=nnodo; scale1[95]=nosi;
			scale1[96]=nora; scale1[97]=nosol; scale1[98]=nofa; scale1[99]=nomi;
			scale1[100]=nofa; scale1[101]=nosol; scale1[102]=nora; scale1[103]=nosol;
			scale1[104]=nofa; scale1[105]=nomi; scale1[106]=nore; scale1[107]=nodo;
			scale1[108]=si; scale1[109]=nosol; scale1[110]=nomi; scale1[111]=nodo;
			scale1[112]=nore; scale1[113]=nosol; scale1[114]=nomi; scale1[115]=nodo;
			scale1[116]=nore; scale1[117]=nosol; scale1[118]=sol; scale1[119]=shim;
	                                          
		end
		
	reg [31:0] tone1 [119:0];
	initial
		begin
			tone1[0]=N2; tone1[1]=N4; tone1[2]=N4; tone1[3]=ND4;
			tone1[4]=N16; tone1[5]=N16; tone1[6]=N2; tone1[7]=N2;
			tone1[8]=N4; tone1[9]=N4; tone1[10]=N4; tone1[11]=N5;
			tone1[12]=N5; tone1[13]=N5; tone1[14]=N5; tone1[15]=N5;
			tone1[16]=N2; tone1[17]=R8; tone1[18]=N16; tone1[19]=N16;
			tone1[20]=N16; tone1[21]=N16; tone1[22]=N16; tone1[23]=N16;
			tone1[24]=N16; tone1[25]=N16; tone1[26]=N16; tone1[27]=N16;
			tone1[28]=N16; tone1[29]=N16; tone1[30]=N16; tone1[31]=N16;
			tone1[32]=R8; tone1[33]=N16; tone1[34]=N16; tone1[35]=N16;
			tone1[36]=N16; tone1[37]=N16; tone1[38]=N16; tone1[39]=N16;
			tone1[40]=N16; tone1[41]=N16; tone1[42]=N16; tone1[43]=N16;
			tone1[44]=N16; tone1[45]=N16; tone1[46]=N16; tone1[47]=R8;
			tone1[48]=N16; tone1[49]=N16; tone1[50]=N16; tone1[51]=N16;
			tone1[52]=N16; tone1[53]=N16; tone1[54]=N16; tone1[55]=N16;
			tone1[56]=N16; tone1[57]=N16; tone1[58]=N16; tone1[59]=N16;
			tone1[60]=N16; tone1[61]=N16; tone1[62]=R8; tone1[63]=N16; 
			tone1[64]=N16; tone1[65]=N16; tone1[66]=N16; tone1[67]=N16; 
			tone1[68]=N16; tone1[69]=N16; tone1[70]=N16; tone1[71]=N16; 
			tone1[72]=N16; tone1[73]=N16; tone1[74]=N16; tone1[75]=N16; 
			tone1[76]=N16; tone1[77]=R8; tone1[78]=N16; tone1[79]=N16;
			tone1[80]=N16; tone1[81]=N16; tone1[82]=N16; tone1[83]=N16;
			tone1[84]=N16; tone1[85]=N16; tone1[86]=N16; tone1[87]=N16; 
			tone1[88]=N16; tone1[89]=N16; tone1[90]=N16; tone1[91]=N16; 
			tone1[92]=N16; tone1[93]=N16; tone1[94]=N16; tone1[95]=N16; 
			tone1[96]=N16; tone1[97]=N16; tone1[98]=N16; tone1[99]=N16; 
			tone1[100]=N16; tone1[101]=N16; tone1[102]=N16; tone1[103]=N16; 
			tone1[104]=N16; tone1[105]=N16; tone1[106]=N16; tone1[107]=N16; 
			tone1[108]=N8; tone1[109]=N8; tone1[110]=N8; tone1[111]=N8; 
			tone1[112]=N8; tone1[113]=N8; tone1[114]=N8; tone1[115]=N8;
			tone1[116]=N4; tone1[117]=N4; tone1[118]=N4; tone1[119]=N4; 
				
		end
		
		
		
		reg [31:0] scale2 [71:0];
	initial
		begin
			scale2[0]=do; scale2[1]=sol; scale2[2]=mi; scale2[3]=sol; 
			scale2[4]=do; scale2[5]=sol; scale2[6]=mi; scale2[7]=sol;
			scale2[8]=re; scale2[9]=sol; scale2[10]=fa; scale2[11]=sol;
			scale2[12]=do; scale2[13]=sol; scale2[14]=mi; scale2[15]=sol;
			scale2[16]=do; scale2[17]=ra; scale2[18]=fa; scale2[19]=ra;
			scale2[20]=do; scale2[21]=sol; scale2[22]=mi; scale2[23]=sol;
			scale2[24]=nasi; scale2[25]=sol; scale2[26]=re; scale2[27]=sol;
			scale2[28]=do; scale2[29]=sol; scale2[30]=mi; scale2[31]=sol;
			scale2[32]=fa; scale2[33]=shim; scale2[34]=do; scale2[35]=shim;
			scale2[36]=do; scale2[37]=shim; scale2[38]=do; scale2[39]=shim;
			scale2[40]=do; scale2[41]=shim; scale2[42]=nasi; scale2[43]=shim;
			scale2[44]=do; scale2[45]=shim; scale2[46]=mi; scale2[47]=shim;
			scale2[48]=ra; scale2[49]=fa; scale2[50]=sol; scale2[51]=ra; 
			scale2[52]=sfa; scale2[53]=nasol; scale2[54]=nasi; scale2[55]=re; 
			scale2[56]=sol; scale2[57]=nasol; scale2[58]=do; scale2[59]=mi; 
			scale2[60]=sol; scale2[61]=nasol; scale2[62]=nasi; scale2[63]=re; 
			scale2[64]=sol; scale2[65]=nasol; scale2[66]=do; scale2[67]=mi; 
			scale2[68]=sol; scale2[69]=nasol; scale2[70]=sol; scale2[71]=nasol;                                         
		end 
		
		reg [31:0] tone2 [71:0];
	initial
		begin
			tone2[0]=N8; tone2[1]=N8; tone2[2]=N8; tone2[3]=N8;
			tone2[4]=N8; tone2[5]=N8; tone2[6]=N8; tone2[7]=N8;
			tone2[8]=N8; tone2[9]=N8; tone2[10]=N8; tone2[11]=N8;
			tone2[12]=N8; tone2[13]=N8; tone2[14]=N8; tone2[15]=N8;
			tone2[16]=N8; tone2[17]=N8; tone2[18]=N8; tone2[19]=N8;
			tone2[20]=N8; tone2[21]=N8; tone2[22]=N8; tone2[23]=N8;
			tone2[24]=N8; tone2[25]=N8; tone2[26]=N8; tone2[27]=N8;
			tone2[28]=N8; tone2[29]=N8; tone2[30]=N8; tone2[31]=N8;
			tone2[32]=N4; tone2[33]=R2; tone2[34]=N8; tone2[35]=R8;
			tone2[36]=N4; tone2[37]=R2; tone2[38]=N8; tone2[39]=R8;
			tone2[40]=N4; tone2[41]=R2; tone2[42]=N8; tone2[43]=R8;
			tone2[44]=N4; tone2[45]=R2; tone2[46]=N8; tone2[47]=R8;
			tone2[48]=N1; tone2[49]=ND4; tone2[50]=N8; tone2[51]=ND4;
			tone2[52]=N8; tone2[53]=N16; tone2[54]=N16; tone2[55]=N16;
			tone2[56]=N16; tone2[57]=N16; tone2[58]=N16; tone2[59]=N16;
			tone2[60]=N16; tone2[61]=N16; tone2[62]=R16; tone2[63]=N16; 
			tone2[64]=N16; tone2[65]=N16; tone2[66]=N16; tone2[67]=N16; 
			tone2[68]=N16; tone2[69]=N4; tone2[70]=N4; tone2[71]=N4; 
			
		end 
   
	always @ (posedge clk, negedge reset)
	 if(!reset) start<=0;
	 else begin
	  if(sw[0]) start<=1;
	  else if(sw[1]) start<=0;
	 end
		
	always @ (posedge clk, negedge reset)
	begin
		if(!reset)
			begin
				play_time1<=0;
				addr1<=0;
			end
		else
			begin
				if(start)
					begin
						if(play_time1>=tone1[addr1])
							begin
								play_time1<=0;
								addr1<=(addr1+1)%119;
							end
						else play_time1<=play_time1+1;
					end
				else
					begin
						play_time1<=0;
						addr1<=0;
					end
			end
	end
	
	always @ (posedge clk, negedge reset)
	begin
		if(!reset)
			begin
				sound_cnt1<=0;
				spk1<=0;
			end
		else
			begin
				if(start)
					begin
						if(sound_cnt1>=scale1[addr1])
							begin
								spk1<=~spk1;
								sound_cnt1<=0;
							end
						else  sound_cnt1<=sound_cnt1+1;	
					end
				else
					begin
						spk1<=0;
						sound_cnt1<=0;
					end
			end
	end


always @ (posedge clk, negedge reset)
	begin
		if(!reset)
			begin
				play_time2<=0;
				addr2<=0;
			end
		else
			begin
				if(start)
					begin
						if(play_time2>=tone2[addr2])
							begin
								play_time2<=0;
								addr2<=(addr2+1)%72;
							end
						else 	play_time2 <= play_time2+1;
					end
				else
					begin
						play_time2<=0;
						addr2<=0;
					end
			end
	end
	
	always @ (posedge clk, negedge reset)
	begin
		if(!reset)
			begin
				sound_cnt2<=0;
				spk2<=0;
			end
		else
			begin
				if(start)
					begin
						sound_cnt2<=sound_cnt2+1;
						if(sound_cnt2>=scale2[addr2])
							begin
								spk2<=~spk2;
								sound_cnt2<=0;
							end
					end
				else
					begin
						spk2<=0;
						sound_cnt2<=0;
					end
			end
	end	
	
endmodule
*/