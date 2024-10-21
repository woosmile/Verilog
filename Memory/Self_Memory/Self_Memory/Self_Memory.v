module Self_Memory(clk,reset,add_sub,a,b,result,ovf);  //��� �����

 input clk,reset,add_sub;  //����� �����
 input [7:0]a,b;  //�ǿ�����
 
 output [7:0]result;  //���� ��
 output ovf;  //ĳ�� �߻� ����
 
 ADD_SUB u0(.clock(clk),.aclr(reset),.dataa(a),.datab(b),.add_sub(add_sub),.result(result),.overflow(ovf));
  
endmodule
