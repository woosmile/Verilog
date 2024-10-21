//Moore_Type FSM_Circuit(������ �������� ��ºи�)
/*
module FSM_Moore(clk,reset,control,y);  //��� �����

 input clk,reset,control;  //����� �����
 output [2:0]y;
 
 reg [2:0]y;
 reg [1:0]current_state=0;
 reg [1:0]next_state=0;
 
 parameter st0=2'b00, st1=2'b01;  
 parameter st2=2'b10, st3=2'b11;
 
 always@(current_state,control)  //�������¸� ����ȸ�ִ� ���ճ�ȸ��
  case(current_state)
   st0 : next_state=st1;
	st1 : 
	begin 
	 if(control==1) next_state=st3;
	 else next_state=st2;
	end
	st2 : next_state=st3;
	st3 : next_state=st0;
  endcase
  
 always@(posedge clk, posedge reset)  //�������¸� ������·� õ�̽����ִ� ������ȸ��
  if(reset==1) current_state<=st0;
  else current_state<=next_state;
  
 always@(current_state)  //������¿� ���� ����� �������� ���ճ�ȸ��9
  case(current_state)
   st0 : y=1;
	st1 : y=2;
	st2 : y=3;
	st3 : y=4;
  endcase
  
endmodule
*/

//�������¿� ������� ����

module FSM_Moore(clk,reset,control,y);  //��� �����

 input clk,reset,control;  //����� �����
 output [2:0]y;
 
 reg [2:0]y;
 reg [1:0]current_state=0;
 
 parameter st0=2'b00, st1=2'b01;  
 parameter st2=2'b10, st3=2'b11;
 
 always@(posedge clk,posedge reset)  //�������¸� ����ȸ�ִ� ���ճ�ȸ�� + �������� õ�� ������ȸ��
  if(reset==1) current_state<=st0;
  else begin
   case(current_state)
    st0 : current_state<=st1;
	 st1 : 
	 begin 
	  if(control==1)current_state<=st3;
	  else current_state<=st2;
	 end
	 st2 : current_state<=st3;
	 st3 : current_state<=st0;
   endcase
  end
 
 always@(current_state)  //������¿� ���� ����� �������� ���ճ�ȸ��
  case(current_state)
   st0 : y=1;
	st1 : y=2;
	st2 : y=3;
	st3 : y=4;
  endcase
  
endmodule

//�������¿� ��� ����
/*
module FSM_Moore(clk,reset,control,y);  //��� �����

 input clk,reset,control;  //����� �����
 output [2:0]y;
 
 reg [2:0]y;
 reg [1:0]current_state=0;
 reg [1:0]next_state=0;
 
 parameter st0=2'b00, st1=2'b01;  
 parameter st2=2'b10, st3=2'b11;
 
 always@(current_state,control)  //�������¸� ����ȸ�ִ� ���ճ�ȸ��
  case(current_state)
   st0 : begin y=1; next_state=st1; end
	st1 : 
	begin
	 y=2;
	 if(control==1) next_state=st3;
	 else next_state=st2;
	end
	st2 : begin y=3; next_state=st3; end
	st3 : begin y=4; next_state=st0; end
  endcase
  
 always@(posedge clk, posedge reset)  //�������¸� ������·� õ�̽����ִ� ������ȸ��
  if(reset==1) current_state<=st0;
  else current_state<=next_state;
  
endmodule
*/
