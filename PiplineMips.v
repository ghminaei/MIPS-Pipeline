`timescale 1ps/1ps
module PiplineMips(
    clk,
    rst
    );
    //IF----------------------:
    wire [31:0]pcOut, pcIn, iFPC, ifInst, jAdr, brAdr;
    wire ifFlush, pcWrite;
    wire [1:0]pcSrc;

    //ID----------------------:
    wire [31:0]idInst, idPC, idReadD1, idReadD2, idAdr, idAdrSh;
    wire [29:0]concat1Out;
    wire ifIdWrite, bne, beq, j, ifNop, eq;
    wire [5:0]funcOut;
    wire [4:0]idEX;
    wire [1:0]idWB;
    wire [1:0]idM;
    assign ifFlush = ifNop;
    //EX----------------------:
    wire [3:0]exWB;
    wire [1:0]exM;
    wire [4:0]exEX;
    wire [31:0]exReadD1, exRead2, exAdr;
    wire [4:0]exRd, exRt, exRs;
    //MEM--------------------:
    wire [3:0]memWB;
    wire [1:0]memM;
    //WB---------------------:
    wire [1:0]wbWB;
    //IF:
    InstMemory instMem (
    .address(pcOut),
    .out(ifInst)
    );

    register pcReg(
    .clk(clk),
    .rst(rst),
    .ld(pcWrite),
    .clr(1'b0),
    .inp(pcIn),
    .out(pcOut)
    );

    Adder adder1(
    .inp1(3'b100),
    .inp2(pcOut),
    .out(ifPc)
    );

    mux3 mux1(
    .sel(pcSrc),
    .inp1(ifPC),
    .inp2(brAdr),
    .inp3(jAdr),
    .out(pcIn)
    );

    //IFID:
    IfIdReg ifidReg(
    .clk(clk),
    .rst(rst),
    .IfPc(ifPC),
    .IfInst(ifInst),
    .IfFlush(ifFlush),
    .IfIdWrite(ifIdWrite),
    .IdPc(idPC),
    .IdInst(idInst)
    );

    //ID:
    HazardUnit hazardUnit(
    .IDEXMemRead(exM[0]), // just 1 bit
    .MEMmemRead(), // just 1 bit
    .beq(beq), 
    .bne(bne), 
    .equal(eq), //from comperator 
    .jump(j), 
    .EXERegWrite(exWB[3]),
    .IDRs(idInst[25:21]), 
    .IDRt(idInst[20:16]), 
    .EXERdOut(), 
    .MEMRd(),
    .IFIDWrite(ifIdWrite),
    .pcWrite(pcWrite), 
    .ifNop(ifNop)
    );

    CU cu (
    .rst(rst),
    .opcode(idInst[31:26]),
    .funcIn(idInst[5:0]),
    .funcOut(funcOut),
    .memRead(idM[0]),
    .memWrite(idMem[1]),
    .pcSrc(pcSrc),
    .aluSrc(idEX[4]),
    .regDst(idEX[3]),
    .regWrite(idWB[1]),
    .memToReg(idWB[0]),
    .eqRegs(eq),
    .beq(beq),
    .bne(bne),
    .j(j)
    );

    aluCU alucu(
    .rst(rst),
    .func(funcOut),
    .aluFunc(idEX[2:0]),
    );

    RegisterFile registerFile(
    .clk(clk), 
    .readReg1(idInst[25:21]),
    .readReg2(idInst[20:16]), 
    .writeReg(), 
    .writeData(), 
    .regWrite(wbWB[1]), 
    .readData1(idReadD1), 
    .readData2(idReadD2)
    );

    Comparator comp #(32)(
    .inp1(idReadD1),
    .inp2(idReadD2),
    .equal(eq)
    );

    SignExtender se(
    .inp(idInst[15:0]),
    .out(idAdr)
    );

    ShifterL shift(
    .inp(idAdr),
    .out(idAdrSh)
    );

    Adder adder2(
    .inp1(idPC),
    .inp2(idAdrSh),
    .out(brAdr)
    );

    Concatenator concatenator1 #(26, 4) (
    .inp(idInst[25:0]),
    .concatPart(idPC[31:28]),
    .out(concat1Out)
    );

    Concatenator concatenator2 #(2, 30) (
    .inp(2'b00),
    .concatPart(concat1Out),
    .out(jAdr)
    );

    //IDEX:
    IdExeReg idexReg(
    .clk(clk),
    .rst(rst),
    .IdWb(idWB),
    .IdM(idM),
    .IdEx(idEX),
    .IdReadD1(idReadD1),
    .IdReadD2(idReadD2),
    .IdAdr(idAdr),
    .IdRt(idInst[20:16]),
    .IdRd(idInst[15:11]),
    .IdRs(idInst[25:21]),
    .ExWb(exWB),
    .ExM(exM),
    .ExEx(exEX),
    .ExReadD1(exReadD1),
    .ExReadD2(ExReadD2),
    .ExAdr(exAdr),
    .ExRt(exRt),
    .ExRd(exRd),
    .ExRs(exRs)
    );
endmodule




