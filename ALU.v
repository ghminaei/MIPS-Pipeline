`timescale 1ps/1ps
module ALU (
    inp1,
    inp2,
    func,
    out,
    );
    parameter n = 32;
    input [n-1:0]inp1, inp2;
    input [2:0]func;
    output [n-1:0]out;

    parameter  ADD = 3'b010, SUB = 3'b110, 
               AND = 3'b000, OR = 3'b001,
               SLT = 3'b111;

    assign out = (func == ADD) ? inp1 + inp2 :
                 (func == SUB) ? inp1 - inp2 ://chi ro bayad too mips az chi kam konim ?
                 (func == AND) ? inp1 & inp2 :
                 (func == OR) ? inp1 | inp2 ://is this or correct?
                 (func == SLT) ? ((inp1 < inp2) ? inp1 : inp2) :
                 out;         
endmodule