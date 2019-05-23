`timescale 1ps/1ps
module HazardUnit (
    IDEXMemRead, // just 1 bit
    MEMmemRead, // just 1 bit
    beq, 
    bne, 
    equal, //from comperator 
    jump, 
    EXERegWrite,
    IDRs, 
    IDRt, 
    EXERdOut, 
    MEMRd,
    IFIDWrite,
    pcWrite, 
    ifNop // and also IFFlush
    );

    input IDEXMemRead,
    MEMmemRead, 
    beq, 
    bne, 
    equal,
    jump,
    EXERegWrite;

    input [4:0] IDRs, 
    IDRt, 
    EXERdOut, 
    MEMRd;

    output reg IFIDWrite,
    pcWrite, 
    ifNop;

    reg stall = 0;
    wire LWCmdEXE, LWCmdMEM, DataDepEXE, DataDepMEM;
    assign LWCmdEXE = IDEXMemRead;
    assign LWCmdMEM = MEMmemRead;
    assign DataDepEXE = (EXERdOut != 5'b0 && (EXERdOut == IDRs || EXERdOut == IDRt));
    assign DataDepMEM = (MEMRd != 5'b0 && (MEMRd == IDRs || MEMRd == IDRt));

    always@(*) begin
        IFIDWrite = 1;
        pcWrite = 1;
        ifNop = 0;

        if (DataDepEXE && LWCmdEXE) begin
            //lw with data dependency -> stall
            stall = 1;
            IFIDWrite = 0;
            pcWrite = 0;
        end
        
        if (LWCmdMEM && DataDepMEM && (beq || bne)) begin
            //lw secound stall if beq bne
            stall = 1;
            IFIDWrite = 0;
            pcWrite = 0;
        end

        if (jump) 
            //flush after jump
            ifNop = 1;
        
        if ((beq && equal) || (bne && ~equal))
            //flush after beq bne
            ifNop = 1;

    end
    
endmodule
                  
