`timescale 1ps/1ps
module Comparator (
    inp1,
    inp2,
    equal
    );
    parameter n;
    input [n-1:0]inp1, inp2;
    output equal;
    assign equal = (inp1 == inp2);
endmodule




