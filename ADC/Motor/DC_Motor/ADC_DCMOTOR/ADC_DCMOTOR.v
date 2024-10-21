module ADC_DCMOTOR(clk,reset,dip_sw,eoc,start,ale,out_en,adc_clk,addr,result,fnd_data,fnd_en,fnd_sel,motor_en,motor,portc);

 input clk,reset;
 input eoc;
 input [7:0]result;
 input [7:0]dip_sw;
 
 output [2:0]addr;
 output start,ale,out_en,adc_clk;
 output [7:0]fnd_data;
 output fnd_en;
 output [3:0]fnd_sel;
 
 output motor_en;
 output [1:0]motor;
 output [1:0]portc;
 
 adc_1 u0(.clk(clk),.reset(reset),.eoc(eoc),.start(start),.ale(ale),.out_en(out_en),.adc_clk(adc_clk),.addr(addr),.result(result));
 DSP_4bitFND u1(.clk(clk),.rst(reset),.num(result),.fnd_data(fnd_data),.fnd_en(fnd_en),.fnd_sel(fnd_sel));
 
 assign portc=(!reset) ? 2'b00:2'b01;
 assign motor_en=(!reset) ? 1'b0:1'b1;
 assign motor=(result>dip_sw) ? 2'b10 : 2'b00;
 
endmodule
