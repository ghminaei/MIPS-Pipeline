`timescale 1ps/1ps
module CU (
    rst,
    opcode,
    funcIn,

    funcOut,

    memRead,
    memWrite,
    pcSrc,

    aluSrc,
    regDst,

    regWrite,
    memToReg,

    eqRegs,
    beq,
    bne,
    j
    );
    input rst ,eqRegs;
    input [5:0]opcode;
    input [5:0]funcIn;
    output reg [5:0]funcOut;
    output reg[1:0]pcSrc;
    output reg memRead,
    memWrite,

    aluSrc,
    regDst,

    regWrite,
    memToReg,
    beq,
    bne,
    j;


    parameter LW = 6'b100011, SW = 6'b101011,
              BEQ = 6'b000100, RTYPE = 6'b000000,
              BNE = 6'b000101,  J = 6'b000010;
    
    parameter ADDF = 6'b100000, NOPF = 6'b000000; 

    always @(*) begin
        if (rst) begin
            memRead = 0;
            memWrite = 0;
            pcSrc = 2'b00;

            aluSrc = 0;
            funcOut = NOPF;
            regDst = 0;

            regWrite = 0;
            memToReg = 0;
            beq = 0;
            bne = 0;
        end
        else begin
            
            case(opcode)
            LW: begin //registere 1 o 2 too lw koodoomas?
                aluSrc = 1; 
                memToReg = 1;
                regWrite = 1;
                memRead = 1;
                regDst = 0; // bastegi dare
                memWrite = 0;
                funcOut = ADDF;
                pcSrc = 2'b00;
                beq = 0;
                bne = 0;
                j = 0;
                  end
            SW: begin 
                aluSrc = 1; 
                regWrite = 0;
                memRead = 0;
                memWrite = 1;
                funcOut = ADDF;
                pcSrc = 2'b00;
                beq = 0;
                bne = 0;
                j = 0;
                  end
            BEQ:begin  
                aluSrc = 0; 
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                funcOut = NOPF;
                if(eqRegs == 1)pcSrc = 2'b01; 
                else pcSrc = 2'b00;
                beq = 1;
                bne = 0;
                j = 0;
                  end
            RTYPE: begin 
                aluSrc = 0; 
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                regDst = 1; 
                memWrite = 0;
                funcOut = funcIn;
                pcSrc = 2'b00;
                beq = 0;
                bne = 0;
                j = 0; 
                   end
            BNE: begin
                aluSrc = 0; 
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                funcOut = NOPF;
                if(eqRegs == 1)
                   pcSrc = 2'b00; 
              
                else pcSrc = 2'b01;
                beq = 0;
                bne = 1;
                j = 0;
                    end
            J: begin
                pcSrc = 2'b10;
                funcOut = NOPF;
                beq = 0;
                bne = 0;
                j = 1;
              end
            endcase
        end
    end
endmodule
