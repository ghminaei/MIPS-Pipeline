module IdExeReg(
    clk,
    rst,

    IdWb,
    IdM,
    IdEx,
    IdReadD1,
    IdReadD2,
    IdAdr,
    IdRt,
    IdRd,
    IdRs,

    ExWb,
    ExM,
    ExEx,
    ExReadD1,
    ExReadD2,
    ExAdr,
    ExRt,
    ExRd,
    ExRs

);
input rst,clk;
input[1:0] IdWb;
input[1:0] IdM;
input[4:0] IdEx , IdRs , IdRd, IdRt;
input[31:0] IdReadD1,IdReadD2,IdAdr;

output reg[1:0] ExWb;
output reg[1:0] ExM;
output reg[4:0] ExEx , ExRt , ExRd, ExRs;
output reg[31:0] ExReadD1,ExReadD2,ExAdr;

always@(posedge clk,posedge rst)begin
    if(rst) begin
        ExWb = 2'b0;
        ExM = 2'b0;
        ExEx = 5'b0;
        ExReadD1 = 32'b0;
        ExReadD2 = 32'b0;
        ExAdr = 32'b0;
        ExRt = 5'b0;
        ExRd = 5'b0;
        ExRs = 5'b0;
        end
    else begin
        ExWb = IdWb;
        ExM = IdM;
        ExEx = IdEx;
        ExReadD1 = IdReadD1;
        ExReadD2 = IdReadD2;
        ExAdr = IdAdr;
        ExRt = IdRt;
        ExRd = IdRd;
        ExRs = IdRs;
        end
end
endmodule

