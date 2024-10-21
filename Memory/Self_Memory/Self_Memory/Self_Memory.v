module Self_Memory(clk,reset,add_sub,a,b,result,ovf);  //모듈 선언부

 input clk,reset,add_sub;  //입출력 선언부
 input [7:0]a,b;  //피연산자
 
 output [7:0]result;  //연산 값
 output ovf;  //캐리 발생 여부
 
 ADD_SUB u0(.clock(clk),.aclr(reset),.dataa(a),.datab(b),.add_sub(add_sub),.result(result),.overflow(ovf));
  
endmodule
