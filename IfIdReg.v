`timescale 1ps/1ps
module IfIdReg(
    clk,
    rst,

    IfPc,
    IfInst,
    IfFlush,

    IfIdWrite,

    IdPc,
    IdInst
);

input clk,
      rst,
      IfFlush,
      IfIdWrite;
input[31:0] IfPc,IfInst;
output reg[31:0] IdPc,IdInst;

always@(posedge clk,posedge rst)begin
    if(rst) begin
        IdPc = 32'b0;
        IdInst = 32'b00000100000000000000000000000000;
    end
    else begin
        if(IfFlush) begin
            IdPc = 32'b0;
            IdInst = 32'b00000100000000000000000000000000;
        end
        else begin
            if(IfIdWrite)begin 
                IdInst = IfInst;
                IdPc = IfPc;
            end
            else begin
                IdInst = IdInst;
                IdPc = IdPc;
            end
        end
    end
end

endmodule