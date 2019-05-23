`timescale 1ps/1ps
module InstMemory (
    address,
    out
    );
    parameter WORD = 8, LENGTH = 32'd4294967295, PCL = 32;
    input [PCL-1:0]address;
    output [4*WORD-1:0]out;
    reg [WORD-1:0]memory[LENGTH-1:0];
    parameter NOP = 32'b00000100000000000000000000000000;
    integer i;
    initial begin
        for (i = 0; i < LENGTH; i = i + 4) begin
            {memory[i], memory[i+1], memory[i+2], memory[i+3]} = NOP;
        end
    end

    initial begin 
        $readmemb("instructions.txt", memory);
    end

    assign out = {memory[address], memory[address+1], memory[address+2], memory[address+3]};
endmodule
