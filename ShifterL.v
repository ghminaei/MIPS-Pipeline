`timescale 1ps/1ps
module ShifterL (
    clk,
    rst,
    inp,
    out
    );
    parameter n;
    parameter SH = 2;
    input clk, rst;
    input [n-1:0]inp;
    output reg [n-1:0]out;
    wire [n-1:0]shifted;

    always @(posedge clk, posedge rst) begin
            if(rst) out <= {(n){1'b0}};
            else out <= shifted;
    end
    assign shifted = {inp[n-1-SH:0] ,{(SH){1'b0}}};
endmodule

