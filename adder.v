`timescale 1ps/1ps
module Adder (
    inp1,
    inp2,
    out
    );
    parameter n = 32;
    input signed [n-1:0]inp1,
    inp2;
    output signed [n-1:0]out;
    assign out = inp1+inp2;
    
endmodule
                  
