`timescale 1ps/1ps
module SignExtender (
    inp,
    out
    );
    parameter n = 32, SIGNBit = 16;
    input [n-SIGNBit-1:0]inp;
    output [n-1:0]out;
    wire ext;
    assign ext = inp[n-1] ? {(SIGNBit){1'b1}} : 
                 {(SIGNBit){1'b0}};
    
    assign out = {ext, inp};
    
endmodule
                  
