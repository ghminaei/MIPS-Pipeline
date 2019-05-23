`timescale 1ps/1ps
module mux3 (
    sel,
    inp1,
    inp2,
    inp3,
    out
    );
    parameter n;
    input [1:0]sel;
    input [n-1:0]inp1, inp2, inp3;
    output [n-1:0]out;
    assign out = sel == 2'b00 ? inp1 : 
                 sel == 2'b01 ? inp2 : 
                 sel == 2'b10 ? inp3 :
                 out;
endmodule