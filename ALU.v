`timescale 1ps/1ps
module ALU (
    inp1,
    inp2,
    func,
    out,
    );
    parameter n = 32;
    input signed [n-1:0]inp1, inp2;
    input signed [2:0]func;
    output signed [n-1:0]out;

    parameter  ADD = 3'b010, SUB = 3'b110, 
               AND = 3'b000, OR = 3'b001,
               SLT = 3'b111, NOP = 3'b011;

    assign out = (func == ADD) ? inp1 + inp2 :
                 (func == SUB) ? inp1 - inp2 :
                 (func == AND) ? inp1 & inp2 :
                 (func == OR) ? inp1 | inp2 :
                 (func == SLT) ? ((inp1 < inp2) ? 32'd1 : 32'b0) :
                 (func == NOP) ? out :
                 out;         
endmodule