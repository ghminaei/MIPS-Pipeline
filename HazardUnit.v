`timescale 1ps/1ps
module HazardUnit (
    IDEXMemRead, // just 1 bit
    MEMmemRead, // just 1 bit
    beq, 
    bne, 
    equal, //from comperator 
    jump, 
    EXERegWrite,
    MEMRegWrite, //hereee
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

    always@(*) begin
        IFIDWrite = 1;
        pcWrite = 1;
        ifNop = 1;
        ifFlush = 0;
        stall = 0;

        if (DataDepEXE && LWCmdEXE) begin
            //lw with data dependency -> stall
            stall = 1;
            IFIDWrite = 0;
            pcWrite = 0;
            ifNop = 0;
        end
        
        if (LWCmdMEM && DataDepMEM && (beq || bne)) begin
            //lw secound stall if beq bne
            stall = 1;
            IFIDWrite = 0;
            pcWrite = 0;
            ifNop = 0;
        end

        if (RTypeCmdEXE && (beq || bne) && DataDepEXE) begin
            //Rtype & beq -> first stall
            stall = 1;
            IFIDWrite = 0;
            pcWrite = 0;
            ifNop = 0;
        end

        if (RTypeCmdMEM && (beq || bne) && DataDepMEM) begin
            //Rtype & beq -> sec stall
            stall = 1;
            IFIDWrite = 0;
            pcWrite = 0;
            ifNop = 0;
        end

        if (jump && ~stall) begin
            //flush after jump
            ifNop = 0;
            ifFlush = 1;
        end
        
        if ((beq && equal && ~stall) || (bne && ~equal && ~stall)) begin
            //flush after beq bne
            ifNop = 0;
            ifFlush = 1;
        end

    end
    
endmodule
                  
