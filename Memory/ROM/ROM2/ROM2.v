/*
module ROM2(addr,inclk,outclk,q);

 input [3:0]addr;
 input inclk,outclk;
 
 output [3:0]q;
 
 lpm_rom u0(.address(addr),.inclock(inclk),.outclock(outclk),.q(q));
 
 defparam u0.lpm_width=4;
 defparam u0.lpm_widthad=4;
 defparam u0.lpm_file="initial.mif";
 defparam u0.lpm_outdata="REGISTERED";
 
endmodule
*/

module ROM2(addr,inclk,q);

 input [3:0]addr;
 //input inclk,outclk;
 input inclk;
 
 output [3:0]q;
 
 //lpm_rom u0(.address(addr),.inclock(inclk),.outclock(outclk),.q(q));
 lpm_rom u0(.address(addr),.inclock(inclk),.q(q));
 
 defparam u0.lpm_width=4;
 defparam u0.lpm_widthad=4;
 defparam u0.lpm_file="initial.mif";
 defparam u0.lpm_outdata="UNREGISTERED";
 
endmodule
