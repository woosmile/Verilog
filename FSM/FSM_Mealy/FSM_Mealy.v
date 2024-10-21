//다음상태 현재상태 출력회로(3개)
module FSM_Mealy(clk,reset,w,z);

 input clk,reset,w;
 output z;
 
 reg z;
 reg next_state=0, current_state=0;
 
 parameter A=1'b0, B=1'b1;
 
 always@(current_state,w)  //다음상태 결정회로
  case(current_state)
   A : 
	begin 
	 if(w==1) next_state=B;
    else next_state=A;
	end
	B : 
	begin 
	 if(w==0) next_state=A;
	 else next_state=B;
	end
  endcase
  
 always@(posedge clk, posedge reset)  //다음상태를 현재상태로 천이
  if(reset==1) current_state<=A;
  else current_state<=next_state;
  
 always@(current_state,w)  //출력회로
  case(current_state)
   A : 
	begin 
	 if(w==1) z=0;
	 else     z=0;
	end
	B :
	begin 
	 if(w==1) z=1;
	 else     z=0;
	end
  endcase
  
endmodule

//현재상태와 다음상태 결합, 출력 분리
/*
module FSM_Mealy(clk,reset,w,z);

 input clk,reset,w;
 output z;
 
 reg z;
 reg current_state=0;
 
 parameter A=1'b0, B=1'b1;
 
 always@(posedge clk, posedge reset)  //다음상태+현재상태
  if(reset==1) current_state<=A;
  else begin
   case(current_state)
	 A :
	 begin
	  if(w==1) current_state<=B;
	  else current_state<=A;
	 end
	 B : 
	 begin
	  if(w==0) current_state<=A;
	  else     current_state<=B;
	 end
	endcase
  end
  
 always@(current_state,w)  //출력회로
  case(current_state)
   A : 
	begin 
	 if(w==1) z=0;
	 else     z=0;
	end
	B :
	begin 
	 if(w==1) z=1;
	 else     z=0;
	end
  endcase
  
endmodule
*/
//다음상태와 출력 결합, 현재상태 제외
/*
module FSM_Mealy(clk,reset,w,z);

 input clk,reset,w;
 output z;
 
 reg z;
 reg next_state=0, current_state=0;
 
 parameter A=1'b0, B=1'b1;
 
 always@(current_state,w)  //다음상태 결정 및 출력회로
  case(current_state)
   A : 
	begin 
	 if(w==1) begin
	  z=0;
	  next_state=B;
	 end
    else begin
	  z=0;
	  next_state=A;
	 end
	end
	B : 
	begin 
	 if(w==0) begin
	  z=0;
	  next_state=A;
	 end
	 else begin
	  z=1;
	  next_state=B;
	 end
	end
  endcase
  
 always@(posedge clk, posedge reset)  //다음상태를 현재상태로 천이
  if(reset==1) current_state<=A;
  else current_state<=next_state;
  
endmodule
*/
