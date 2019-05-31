`timescale 1ps/1ps
module HazardUnit (
    IDEXMemRead,
    MEMmemRead,
    beq, 
    bne, 
    equal,
    jump, 
    EXERegWrite,
    MEMRegWrite,
    IDRs, 
    IDRt, 
    EXERdOut, 
    MEMRd,
    IFIDWrite,
    pcWrite, 
    ifNop,
    ifFlush
    );

    input IDEXMemRead,
    MEMmemRead, 
    beq, 
    bne, 
    equal,
    jump,
    EXERegWrite,
    MEMRegWrite;

    input [4:0] IDRs, 
    IDRt, 
    EXERdOut, 
    MEMRd;

    output reg IFIDWrite,
    pcWrite, 
    ifNop,
    ifFlush;

    reg stall = 0;
    wire LWCmdEXE, LWCmdMEM, DataDepEXE, DataDepMEM, RTypeCmdEXE, RTypeCmdMEM;
    assign LWCmdEXE = IDEXMemRead;
    assign LWCmdMEM = MEMmemRead;
    assign RTypeCmdEXE = EXERegWrite;
    assign RTypeCmdMEM = MEMRegWrite;
    assign DataDepEXE = (EXERdOut != 5'b0 && (EXERdOut == IDRs || EXERdOut == IDRt));
    assign DataDepMEM = (MEMRd != 5'b0 && (MEMRd == IDRs || MEMRd == IDRt));
    //Cases:
    //1- lw in EXE with data Dependency -> stall
    //2- lw in MEM with data Dependency with beq -> second stall
    //3- Rtype in EXE then beq -> stall
    //4- Rtype in MEM then beq -> stall
    //5,6- Flush after Jump, Beq, Bne
    always@(*) begin
        IFIDWrite = 1;
        pcWrite = 1;
        ifNop = 1;
        ifFlush = 0;
        stall = 0;
        //1-
        if (DataDepEXE && LWCmdEXE) begin
            stall = 1;
            IFIDWrite = 0;
            pcWrite = 0;
            ifNop = 0;
        end
        //2-
        if (LWCmdMEM && DataDepMEM && (beq || bne)) begin
            stall = 1;
            IFIDWrite = 0;
            pcWrite = 0;
            ifNop = 0;
        end
        //3-
        if (RTypeCmdEXE && (beq || bne) && DataDepEXE) begin
            stall = 1;
            IFIDWrite = 0;
            pcWrite = 0;
            ifNop = 0;
        end
        //4-
        if (RTypeCmdMEM && (beq || bne) && DataDepMEM) begin
            stall = 1;
            IFIDWrite = 0;
            pcWrite = 0;
            ifNop = 0;
        end
        //5-
        if (jump && ~stall) begin
            ifNop = 0;
            ifFlush = 1;
        end
        //6-
        if ((beq && equal && ~stall) || (bne && ~equal && ~stall)) begin
            ifNop = 0;
            ifFlush = 1;
        end

    end
    
endmodule
                  
