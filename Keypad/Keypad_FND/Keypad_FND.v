//¸ğµâ
module Keypad_FND(clk,reset,fnd_en,fnd_sel,fnd_data,portA,portB,col,row,led);

input clk,reset;
input [3:0]row;

output fnd_en;
output [3:0]fnd_sel;
output [7:0]fnd_data;
output [7:0]led;

output [1:0]portA,portB;
output [2:0]col;

wire [7:0]key_data;

assign led = key_data;

FND u0(.clk(clk),.reset(reset),.num(fnd_num(key_data)),.en(fnd_en),.sel(fnd_sel),.data(fnd_data));
Keypad u1(.clk(clk),.reset(reset),.portA(portA),.portB(portB),.col(col),.row(row),.data(key_data));

function [7:0]fnd_num;
	input [7:0]key_data;
	begin
		case(key_data)
			8'ha0 : fnd_num = 8'h3f;  //0
			8'h01 : fnd_num = 8'h06;  //1
			8'h02 : fnd_num = 8'h5b;  //2
			8'h04 : fnd_num = 8'h4f;  //3
			8'h08 : fnd_num = 8'h66;  //4
			8'h10 : fnd_num = 8'h6d;  //5
			8'h20 : fnd_num = 8'h7d;  //6
			8'h40 : fnd_num = 8'h07;  //7
			8'h80 : fnd_num = 8'h7f;  //8
			8'h90 : fnd_num = 8'h6f;  //9
			8'hb0 : fnd_num = 8'h77;  //*
			8'hc0 : fnd_num = 8'h7c;  //#
			default : fnd_num = 8'h00;
		endcase
	end
endfunction

endmodule
