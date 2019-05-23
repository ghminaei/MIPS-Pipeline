`timescale 1ps/1ps
module MemWbReg (
    clk,
    rst,
    MemWb,
    MemReadD,
    MemAdr,
    MemRd,

    WbWb,
    WbReadD,
    WbAdr,
    WbRd
    );
    input clk, rst;
    input [3:0]MemWb;
    input [31:0]MemReadD;
    input [31:0]MemAdr;
    input [4:0]MemRd;

    output reg [3:0]WbWb;
    output reg [31:0]WbReadD;
    output reg [31:0]WbAdr;
    output reg [4:0]WbRd;
    

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            WbWb = 4'b0;
            WbReadD = 32'b0;
            WbAdr = 32'b0;
            WbRd = 5'b0;
        end
        else begin
            WbWb = MemWb;
            WbReadD = MemReadD;
            WbAdr = MemAdr;
            WbRd = MemRd;
        end
    end 
endmodule




