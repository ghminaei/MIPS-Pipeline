`timescale 1ps/1ps
module ShifterL (
    inp,
    out
    );
    parameter n;
    parameter SH = 2;
    input [n-1:0]inp;
    output [n-1:0]out;

    assign out = {inp[n-1-SH:0] ,{(SH){1'b0}}};
endmodule

