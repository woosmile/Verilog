/*module FAN(clk,reset,sw1,sw2,sw3,sw4,portc,motor,led,);

 input clk, reset;
 input sw1, sw2, sw3, sw4;
 
 output [1:0]portc;
 output [2:0]motor;
 output [2:0]led;
 
 reg [7:0]stop, level1, level2, level3;
 reg [2:0]led;
 
 reg [19:0]cnt,pwm;
 
 assign portc=2'b01;
 assign motor[2]=(pwm>cnt);
 assign motor[1]=1'b0;
 assign motor[0]=1'b1;
 
 always@(posedge clk, negedge reset)  //ä�͸� ȸ��
  if(!reset) {stop,level1,level2,level3}<=0;
  else begin
   stop<={stop[6:0],sw1};
	level1<={level1[6:0],sw2};
	level2<={level2[6:0],sw3};
	level3<={level3[6:0],sw4};
  end
  
 always@(posedge clk, negedge reset) //���ļ� ���� ȸ��
  if(!reset) cnt<=0;
  else begin
   if(cnt>269999) cnt<=0;
	else cnt<=cnt+1;
  end
  
 always@(posedge clk, negedge reset) //pwm �� ����ȸ�� �� led ����ǥ��
  if(!reset) {pwm,led}<=0;
  else begin
   if(stop==1) begin
	 pwm<=0;
	 led<=3'b0;
	end
	
	else if(level1==1) begin
	 pwm<=70000;
	 led<=3'b100;
	end
	
	else if(level2==1) begin
	 pwm<=150000;
	 led<=3'b010;
	end
	
	else if(level3==1) begin
	 pwm<=250000;
	 led<=3'b001;
	end
  end

endmodule
*/


module FAN(clk,reset,sw1,sw2,sw3,sw4,sw5,mode,portc,motor,led,fnd_data,fnd_sel,fnd_en);

 input clk, reset;  //����� �����
 input sw1, sw2, sw3, sw4, sw5, mode;
 
 output [7:0]fnd_data;
 output [3:0]fnd_sel;
 output [2:0]motor;
 output [2:0]led;
 output [1:0]portc;
 output fnd_en;
 
 reg [7:0]fnd_data;
 reg [3:0]fnd_sel;
 
 reg [7:0]stop, level1, level2, level3, time_set;  //ä�͸� ���� ��������
 reg [7:0]min, sec;  //�ð�(��,��)
 reg [3:0]fnd_num;   //�ɰ� ���ڸ� �������ִ� ��������
 reg [2:0]led;      
 reg [2:0]digit;     //fnd �ڸ����� �������ִ� ��������
 
 reg [27:0]timer_cnt,scan_cnt;  //ī���� ��������
 reg [19:0]cnt,pwm;  //���� �ӵ� ���� ��������
 reg flag_stop;      //���� ���� �÷���
  
 assign portc=(!reset) ? 2'b00:2'b01;  //����� ���� ����
 assign motor[2]=(pwm>cnt);  //pwm ���� ���� ���� �ӵ� ����
 assign motor[1]=1'b0;       //������
 assign motor[0]=(!reset) ? 1'b0:1'b1;       //���� enable
 
 assign fnd_en=(mode==1) ? 1'b0:1'b1;
 
 always@(posedge clk, negedge reset)  //ä�͸� ȸ��
  if(!reset) {stop,level1,level2,level3}<=0;
  else begin
   stop<={stop[6:0],sw1};
	level1<={level1[6:0],sw2};
	level2<={level2[6:0],sw3};
	level3<={level3[6:0],sw4};
	time_set<={time_set[6:0],sw5};
  end
  
 always@(posedge clk, negedge reset) //���ļ� ���� ȸ��(200hz)
  if(!reset) cnt<=0;
  else begin
   if(cnt>269999) cnt<=0;
	else cnt<=cnt+1;
  end
  
 always@(posedge clk, negedge reset) //pwm �� ����ȸ�� �� ledǥ��
  if(!reset) {pwm,led}<=0;
  else begin
   if(stop==1||flag_stop==1) begin
	 pwm<=0;
	 led<=3'b0;
	end
	else if(level1==1) begin
	 pwm<=70000;
	 led<=3'b100;
	end
	else if(level2==1) begin
	 pwm<=150000;
	 led<=3'b010;
	end
	else if(level3==1) begin
	 pwm<=250000;
	 led<=3'b001;
	end
  end
 
 always@(posedge clk, negedge reset)  //1���� ���ļ��� ������ִ� ȸ�� �� �ð� ����
  if(!reset) {timer_cnt,min,sec,flag_stop}<=0;
  else begin
   if(mode==1) begin
	 if(time_set==1) min<=(min+10)%90;  //sw5�� ���� �� ���� 10�о� ����(90���� �Ѿ�� �ʱ�ȭ)
    if(timer_cnt>=53999999) begin      //1���� ���ļ�
	  timer_cnt<=0;
	  if(sec==0) begin
	   if(min!=0) sec<=59;  //�ð� �ڵ����� ����
	   if(min==0) begin
	    min<=0;
		 //sec<=0;
		 flag_stop<=1;  //�ð��� 0�� 0�ʰ� �Ǹ� flag_stop�� 1��
	   end
	   else min<=min-1;
	  end
	  else begin  //�ð��� ����(flag_stop�� 0���� -> ������ ����)
	   flag_stop<=0;
		sec<=sec-1;
	  end
	 end
	 else timer_cnt<=timer_cnt+1;
   end
	else {timer_cnt,min,sec,flag_stop}<=0;  //mode�� 0�̵Ǹ� ���� �ʱ�ȭ
  end
  
 always@(posedge clk, negedge reset) //��ĵ���ļ�(400hz)���� fnd�ڸ� ����(��ĵ���)
  if(!reset) {scan_cnt,digit}<=0;
  else begin
   if(mode==1) begin
    if(scan_cnt>=134999) begin
	  scan_cnt<=0;
	  digit<=(digit+1)%4;
	 end
	 else scan_cnt<=scan_cnt+1;
   end
	else {scan_cnt,digit}<=0; //mode�� 0�̵Ǹ� �ʱ�ȭ
  end
  
 always@(posedge clk, negedge reset)  //digit���� ���� �ڸ���(digit ���� 400hz�������� ��ȭ�Ѵ�.)
  if(!reset) begin
   fnd_num<=0;
	fnd_sel<=4'b1111;  //fnd�� ���� ����.
  end
  else begin
   case(digit)
    0 : begin fnd_num=(sec/1)%10;  fnd_sel=4'b1110; end  //1���ڸ�(��)
	 1 : begin fnd_num=(sec/10)%10; fnd_sel=4'b1101; end  //10���ڸ�(��)
	 2 : begin fnd_num=(min/1)%10;  fnd_sel=4'b1011; end  //1���ڸ�(��)
	 3 : begin fnd_num=(min/10)%10; fnd_sel=4'b0111; end  //10���ڸ�(��)
   endcase
  end
  
 always@(fnd_num)  //fnd���ڴ�
  if(digit==2) begin  //���� 1���ڸ��� dotǥ��
   case(fnd_num)
    4'b0000 : fnd_data = 8'b1011_1111; //0
	 4'b0001 : fnd_data = 8'b1000_0110; //1
	 4'b0010 : fnd_data = 8'b1101_1011; //2
	 4'b0011 : fnd_data = 8'b1100_1111; //3
    4'b0100 : fnd_data = 8'b1110_0110; //4
	 4'b0101 : fnd_data = 8'b1110_1101; //5
	 4'b0110 : fnd_data = 8'b1111_1101; //6
	 4'b0111 : fnd_data = 8'b1000_0111; //7
	 4'b1000 : fnd_data = 8'b1111_1111; //8
	 4'b1001 : fnd_data = 8'b1110_1111; //9
	 default : fnd_data = 8'b1000_0000; //null
   endcase
  end
  else begin
   case(fnd_num)
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
