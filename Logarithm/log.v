`timescale 1ns / 1ps

module log (input [13:0] x0, input clk, reset, start,output [13:0] xf, yf);
	 
wire [13:0] x1,x2,x3,x4,x5,y1,y2,y3,y4,ln1,ln2,ln3;
wire [9:0] ln;
wire [3:0] it,it1,it2;
assign reset1 = reset | tc2;
DFF df(start1,clk,reset,start|tc2);
DFF df1(start2,clk,reset,start1);
pg pg1(start|tc2,tc,en,clk,reset);
count4 cnt1(it,4'b0000,tc,en,clk,reset,tc,4'b1001);//Adress for ROMs
DFF df2(tc1,clk,reset,tc);
DFF df3(tc2,clk,reset,tc1);

reg4 rg5(it1,clk,reset,it);
reg4 rg6(it2,clk,reset,it1);//Delayed to create correct it0 signal

Rom rm1(clk,it,ln,en);///Memory for positive numbers

assign ln1 = {4'b000,ln};
reg12 rg1(ln2,clk,reset,ln1);
mux12 mux1(14'b0000_0000000000,ln2,~x4[10],ln3);
adsub ad(1'b1,yf,ln3,y2);
reg12 rg3(yf,clk,reset1,y2);

reg12 rg2(x1,clk,reset,x0);
mux12 mux2(xf,x1,start2,x2);

VRSH_14 vrsh(x2,x3,it2);
adsub ad1(1'b0,x2,x3,x4);
mux12 mux3(x2,x4,~x4[10],x5);
reg12 rg4(xf,clk,reset1,x5);

endmodule

module Rom(clk,addres,data_out,en);
input clk,en;
input [3:0] addres;
output reg [9:0] data_out;
reg [9:0] mem [0:15];
initial begin data_out = 10'b0000000000; end
always @ (addres)
case (addres)
4'b0000 : mem[addres] = 10'b10110_00110;
4'b0001 : mem[addres] = 10'b01100_11111;
4'b0010 : mem[addres] = 10'b00111_00100;
4'b0011 : mem[addres] = 10'b00011_11001;
4'b0100 : mem[addres] = 10'b00001_11110;
4'b0101 : mem[addres] = 10'b00001_00000;
4'b0110 : mem[addres] = 10'b00000_10000;
4'b0111 : mem[addres] = 10'b00000_01000;
4'b1000 : mem[addres] = 10'b00000_00100;
4'b1001 : mem[addres] = 10'b00000_00010;
4'b1010 : mem[addres] = 10'b00000_00001;
default : mem[addres] = 10'b00000_00000;
endcase
always@(posedge clk)
if(en)
data_out <= mem[addres];
else
data_out <= data_out;
endmodule


module reg12(y,clk,reset,a);
    input [13:0] a;
    output [13:0] y;
    input clk,reset;
 
DFF d1(y[0],clk,reset,a[0]);
DFF d2(y[1],clk,reset,a[1]);
DFF d3(y[2],clk,reset,a[2]);
DFF d4(y[3],clk,reset,a[3]);
DFF d5(y[4],clk,reset,a[4]);
DFF d6(y[5],clk,reset,a[5]);
DFF d7(y[6],clk,reset,a[6]);
DFF d8(y[7],clk,reset,a[7]);
DFF d9(y[8],clk,reset,a[8]);
DFF d10(y[9],clk,reset,a[9]);
DFF d11(y[10],clk,reset,a[10]);
DFF d12(y[11],clk,reset,a[11]);
DFF d13(y[12],clk,reset,a[12]);
DFF d14(y[13],clk,reset,a[13]);
endmodule

module reg4(y,clk,reset,a);
    input [3:0] a;
    output [3:0] y;
    input clk,reset;
 
DFF d1(y[0],clk,reset,a[0]);
DFF d2(y[1],clk,reset,a[1]);
DFF d3(y[2],clk,reset,a[2]);
DFF d4(y[3],clk,reset,a[3]);
endmodule

module DFF(q,clk,reset,d);
    input d,clk,reset;
    output reg q;
//initial begin q=0; end
always @ (posedge (clk)) begin
 if (reset)
  q <= 0;
 else  
 q<= d ;
end
endmodule

module adsub (sel,c,a,p);
  input sel;
  input [13:0] a,c;
  output [13:0] p;
 assign p = (sel)?(c-a):(c+a);
endmodule

module count4(out,data,load,en,clk,reset,tc,lmt);
output [3:0] out;
output reg tc;
input [3:0] data,lmt;
input load, en, clk,reset;
reg [3:0] out;
//parameter reset=0;

initial begin out=4'b0000; tc =0;end
always @(posedge clk)
if (reset) begin
  out <= 4'b0000 ;
end else if (load) begin
  out <= data;
end else if (en)
  out <= out + 4'b0001;
else out <= out;
always @(posedge clk)
if (out ==lmt)
tc=1;
else tc=0;
endmodule

module pg(start,tc,q,clk,reset);
	 input start,tc,clk,reset;
	 output  q;
	 
	 wire t1,t2;
	 parameter vdd=1'b1;
	 parameter gnd=1'b0;
    Mux M1(t2,vdd,start,q);
	 Mux M2(q,gnd,tc,t1);
	 DFF d2(t2,clk,reset,t1);
//    assign  s1 = (start|tc);
endmodule


module Mux(a,b,s,y);
    input  a,b,s;
    output y;
wire sbar;
assign y = (a&sbar)|(s&b);
assign sbar = ~s;
endmodule

module mux12(A,B,S,Y);

    input [13:0] A,B;
    output [13:0] Y;
    input S;

assign Y = (S)? B : A;
endmodule


module CRSH1_14(a,b,s);
input [13:0] a;
output [13:0] b;
input s;
//Mux m1(a[17],a[17],s,b[17]);
//Mux m2(a[16],a[17],s,b[16]);
//Mux m3(a[15],a[16],s,b[15]);
//Mux m4(a[14],a[15],s,b[14]);
Mux m5(a[13],a[13],s,b[13]);
Mux m6(a[12],a[13],s,b[12]);
Mux m7(a[11],a[12],s,b[11]);
Mux m8(a[10],a[11],s,b[10]);
Mux m9(a[9],a[10],s,b[9]);
Mux m10(a[8],a[9],s,b[8]);
Mux m11(a[7],a[8],s,b[7]);
Mux m12(a[6],a[7],s,b[6]);
Mux m13(a[5],a[6],s,b[5]);
Mux m14(a[4],a[5],s,b[4]);
Mux m15(a[3],a[4],s,b[3]);
Mux m16(a[2],a[3],s,b[2]);
Mux m17(a[1],a[2],s,b[1]);
Mux m18(a[0],a[1],s,b[0]);
endmodule



module CRSH2_14(a,b,s);
input [13:0] a;
output [13:0] b;
input s;
//Mux m1(a[17],a[17],s,b[17]);
//Mux m2(a[16],a[17],s,b[16]);
//Mux m3(a[15],a[17],s,b[15]);
//Mux m4(a[14],a[16],s,b[14]);
Mux m5(a[13],a[13],s,b[13]);
Mux m6(a[12],a[13],s,b[12]);
Mux m7(a[11],a[13],s,b[11]);
Mux m8(a[10],a[12],s,b[10]);
Mux m9(a[9],a[11],s,b[9]);
Mux m10(a[8],a[10],s,b[8]);
Mux m11(a[7],a[9],s,b[7]);
Mux m12(a[6],a[8],s,b[6]);
Mux m13(a[5],a[7],s,b[5]);
Mux m14(a[4],a[6],s,b[4]);
Mux m15(a[3],a[5],s,b[3]);
Mux m16(a[2],a[4],s,b[2]);
Mux m17(a[1],a[3],s,b[1]);
Mux m18(a[0],a[2],s,b[0]);
endmodule



module CRSH4_14(a,b,s);
input [13:0] a;
output [13:0] b;
input s;
//Mux m1(a[17],a[17],s,b[17]);
//Mux m2(a[16],a[17],s,b[16]);
//Mux m3(a[15],a[17],s,b[15]);
//Mux m4(a[14],a[17],s,b[14]);
Mux m5(a[13],a[13],s,b[13]);
Mux m6(a[12],a[13],s,b[12]);
Mux m7(a[11],a[13],s,b[11]);
Mux m8(a[10],a[13],s,b[10]);
Mux m9(a[9],a[13],s,b[9]);
Mux m10(a[8],a[12],s,b[8]);
Mux m11(a[7],a[11],s,b[7]);
Mux m12(a[6],a[10],s,b[6]);
Mux m13(a[5],a[9],s,b[5]);
Mux m14(a[4],a[8],s,b[4]);
Mux m15(a[3],a[7],s,b[3]);
Mux m16(a[2],a[6],s,b[2]);
Mux m17(a[1],a[5],s,b[1]);
Mux m18(a[0],a[4],s,b[0]);
endmodule



module CRSH8_14(a,b,s);
input [13:0] a;
output [13:0] b;
input s;
//Mux m1(a[17],a[17],s,b[17]);
//Mux m2(a[16],a[17],s,b[16]);
//Mux m3(a[15],a[17],s,b[15]);
//Mux m4(a[14],a[17],s,b[14]);
Mux m5(a[13],a[13],s,b[13]);
Mux m6(a[12],a[13],s,b[12]);
Mux m7(a[11],a[13],s,b[11]);
Mux m8(a[10],a[13],s,b[10]);
Mux m9(a[9],a[13],s,b[9]);
Mux m10(a[8],a[13],s,b[8]);
Mux m11(a[7],a[13],s,b[7]);
Mux m12(a[6],a[13],s,b[6]);
Mux m13(a[5],a[13],s,b[5]);
Mux m14(a[4],a[12],s,b[4]);
Mux m15(a[3],a[11],s,b[3]);
Mux m16(a[2],a[10],s,b[2]);
Mux m17(a[1],a[9],s,b[1]);
Mux m18(a[0],a[8],s,b[0]);
endmodule



module VRSH_14(a,b,s);
input [13:0] a;
output [13:0]b;
input [3:0] s;
wire [13:0] t1,t2,t3;
CRSH1_14 m1(a,t1,s[0]);
CRSH2_14 m2(t1,t2,s[1]);
CRSH4_14 m3(t2,t3,s[2]);
CRSH8_14 m4(t3,b,s[3]);
endmodule
