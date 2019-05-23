`timescale 1ps/1ps
module ExeMemReg (
    clk,
    rst,
    ExWb,
    ExMem,
    ExAluRes,
    ExWriteD,
    ExRd,

    MemWb,
    MemMem,

    MemAluRes,
    MemWriteD,
    MemRd
    );
    input clk, rst;
    input [1:0]ExWb;
    input [1:0]ExMem;
    input [31:0]ExAluRes,
    ExWriteD;
    input [4:0]ExRd;
    
    output reg [1:0]MemWb;
    output reg [1:0]MemMem;
    output reg [31:0]MemAluRes,
    MemWriteD;
    output reg [4:0]MemRd;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            MemWb = 2'b0;
            MemMem = 2'b0;
            MemAluRes = 32'b0;
            MemWriteD = 32'b0;
            MemRd = 5'b0;
        end
        else begin
            MemWb = ExWb;
            MemMem = ExMem;
            MemAluRes = ExAluRes;
            MemWriteD = ExWriteD;
            MemRd = ExRd;
        end
    end
endmodule




