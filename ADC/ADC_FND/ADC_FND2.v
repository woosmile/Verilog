module ADC_FND2(clk,reset,eoc,start,ale,out_en,adc_clk,addr,result,led,fnd_data,fnd_en,fnd_sel);

 input clk,reset;
 input eoc;
 input [7:0]result;
 
 output [2:0]addr;
 output start,ale,out_en,adc_clk;
 output [7:0]led;
 output [7:0]fnd_data;
 output fnd_en;
 output [3:0]fnd_sel;
 
 reg [10:0]resistor;
 
 adc_1 u0(.clk(clk),.reset(reset),.eoc(eoc),.start(start),.ale(ale),.out_en(out_en),.adc_clk(adc_clk),.addr(addr),.result(result),.led(led));
 DSP_4bitFND u1(.clk(clk),.rst(reset),.num(resistor),.fnd_data(fnd_data),.fnd_en(fnd_en),.fnd_sel(fnd_sel));
 
 always@(posedge clk, negedge reset)
  if(!reset) resistor<=8'b0;
  else resistor<=(1000*result)/255;
 
endmodule
