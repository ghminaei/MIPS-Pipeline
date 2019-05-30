`timescale 1ps/1ps
module PiplineMips(
    clk,
    rst
    );

    input clk, rst;
    //IF----------------------:
    wire [31:0]pcOut, pcIn, ifPC, ifInst, jAdr, brAdr;
    wire ifFlush, pcWrite;
    wire [1:0]pcSrc;

    //ID----------------------:
    wire [31:0]idInst, idPC, idReadD1, idReadD2, idAdr, idAdrSh;
    wire [29:0]concat1Out;
    wire ifIdWrite, bne, beq, j, ifNop, eq;
    wire [8:0]ctrlIn, ctrlOut;
    wire [5:0]funcOut;
    wire [4:0]idEX;
    wire [1:0]idWB;
    wire [1:0]idM;
    //assign ifFlush = ~ifNop;
    //EX----------------------:
    wire [3:0]exWB;
    wire [1:0]exM;
    wire [4:0]exEX;
    wire [31:0]exReadD1, exReadD2, exAdr,exAluD,aluIn1,aluIn2, aluRes;
    wire [4:0]exRd, exRt, exRs, exRdOut;
    wire [1:0] selA,selB;
    //MEM--------------------:
    wire [3:0]memWB;
    wire [1:0]memM;
    wire [4:0]memRd;
    wire [31:0]memAdr,memData,memOut;
    //WB---------------------:
    wire [1:0]wbWB;
    wire [31:0]wbReadD, wbAdr, wbWriteD;
    wire [4:0]wbRd;
    //IF:
    InstMemory instMem (
    .address(pcOut),
    .out(ifInst)
    );

    register #(32) pcReg(
    .clk(clk),
    .rst(rst),
    .ld(pcWrite),
    .clr(1'b0),
    .inp(pcIn),
    .out(pcOut)
    );

    Adder adder1(
    .inp1(32'd4),
    .inp2(pcOut),
    .out(ifPC)
    );

    mux3 #(32) m1(
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
    .MEMmemRead(memM[0]), // just 1 bit
    .beq(beq), 
    .bne(bne), 
    .equal(eq), //from comperator 
    .jump(j), 
    .EXERegWrite(exWB[1]),
    .MEMRegWrite(memWB[1]),
    .IDRs(idInst[25:21]), 
    .IDRt(idInst[20:16]), 
    .EXERdOut(exRdOut), 
    .MEMRd(memRd),
    .IFIDWrite(ifIdWrite),
    .pcWrite(pcWrite), 
    .ifNop(ifNop),
    .ifFlush(ifFlush)
    );

    mux2 #(9) m2 (
    .sel(ifNop),
    .inp1(9'b0),
    .inp2(ctrlIn),
    .out(ctrlOut)
    );
    wire[2:0] aluOp;
    wire memRead,memWrite,aluSrc,regDst,regWrite,memToReg;
    assign ctrlIn = {aluSrc,regDst,aluOp ,memWrite,memRead,regWrite,memToReg};
    assign idEX = ctrlOut[8:4];
    assign idM = ctrlOut[3:2];
    assign idWB = ctrlOut[1:0];
    CU cu (
    .rst(rst),
    .opcode(idInst[31:26]),
    .funcIn(idInst[5:0]),
    .funcOut(funcOut),
    .memRead(memRead),
    .memWrite(memWrite),
    .pcSrc(pcSrc),
    .aluSrc(aluSrc),
    .regDst(regDst),
    .regWrite(regWrite),
    .memToReg(memToReg),
    .eqRegs(eq),
    .beq(beq),
    .bne(bne),
    .j(j)
    );
    
    aluCU alucu(
    .rst(rst),
    .func(funcOut),
    .aluFunc(aluOp)
    );

    RegisterFile registerFile(
    .clk(clk), 
    .readReg1(idInst[25:21]),
    .readReg2(idInst[20:16]), 
    .writeReg(wbRd), 
    .writeData(wbWriteD), 
    .regWrite(wbWB[1]), 
    .readData1(idReadD1), 
    .readData2(idReadD2)
    );

    Comparator #(32) comp (
    .inp1(idReadD1),
    .inp2(idReadD2),
    .equal(eq)
    );

    SignExtender se(
    .inp(idInst[15:0]),
    .out(idAdr)
    );

    ShifterL #(32) shift(
    .inp(idAdr),
    .out(idAdrSh)
    );

    Adder adder2(
    .inp1(idPC),
    .inp2(idAdrSh),
    .out(brAdr)
    );

    Concatenator #(26, 4) concatenator1 (
    .inp(idInst[25:0]),
    .concatPart(idPC[31:28]),
    .out(concat1Out)
    );

    Concatenator #(2, 30) concatenator2 (
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
    .ExReadD2(exReadD2),
    .ExAdr(exAdr),
    .ExRt(exRt),
    .ExRd(exRd),
    .ExRs(exRs)
    );
    mux3 #(32) m3(
    .sel(selA),
    .inp1(exReadD1),
    .inp2(memAdr),
    .inp3(wbWriteD),
    .out(aluIn1)
    );

    mux3 #(32) m4(
    .sel(selB),
    .inp1(exReadD2),
    .inp2(memAdr),
    .inp3(wbWriteD),
    .out(exAluD)
    );
    mux2 #(32) m5(
    .sel(exEX[4]),
    .inp1(exAluD),
    .inp2(exAdr),
    .out(aluIn2)
    );

    mux2 #(5) m6(
    .sel(exEX[3]),
    .inp1(exRt),
    .inp2(exRd),
    .out(exRdOut)
    );

    ALU alu(
    .inp1(aluIn1),
    .inp2(aluIn2),
    .func(exEX[2:0]),
    .out(aluRes)
    );

    FU fu(
    .MemWb(memWB[1]),
    .MemRd(memRd),
    .WbWb(wbWB[1]),
    .WbRd(wbRd),
    .ExRs(exRs),
    .ExRt(exRt),
    .selA(selA),
    .selB(selB)
    );

    //EXMEM:
    ExeMemReg exmemReg(
    .clk(clk),
    .rst(rst),
    .ExWb(exWB),
    .ExMem(exM),
    .ExAluRes(aluRes),
    .ExWriteD(exAluD),
    .ExRd(exRdOut),
    .MemWb(memWB),
    .MemMem(memM),
    .MemAluRes(memAdr),
    .MemWriteD(memData),
    .MemRd(memRd)
    );
    //MEM:
    DataMemory dataMem(
    .address(memAdr),
    .writeData(memData),
    .readData(memOut),
    .memWrite(memM[1]),
    .memRead(memM[0]),
    .clk(clk)
    );
    //MEMWB:
    MemWbReg memwbReg (
    .clk(clk),
    .rst(rst),
    .MemWb(memWB),
    .MemReadD(memOut),
    .MemAdr(memAdr),
    .MemRd(memRd),
    .WbWb(wbWB),
    .WbReadD(wbReadD),
    .WbAdr(wbAdr),
    .WbRd(wbRd)
    );
    //WB:
    mux2 #(32) m7(
    .sel(wbWB[0]),
    .inp1(wbAdr),
    .inp2(wbReadD),
    .out(wbWriteD)
    );
endmodule




