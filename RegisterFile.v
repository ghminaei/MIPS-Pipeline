`timescale 1ps/1ps
module RegisterFile(
    clk, 
    readReg1,
    readReg2, 
    writeReg, 
    writeData, 
    regWrite, 
    readData1, 
    readData2
    );
	input [4:0] readReg1, readReg2, writeReg;
	input [31:0] writeData;
	input regWrite, clk;
	
	output [31:0] readData1, readData2;
	reg [31:0]Registers[0:31];
	
	integer i;
	initial begin
        for(i = 0; i < 32; i = i+1)
            Registers[i] = 32'b0;
		    // Registers[1] = 32'd1;
		    // Registers[6] = 32'd2;
	end
	
	
	always @(negedge clk) begin
		if (regWrite) begin
            if (writeReg != 5'b0)
			    Registers[writeReg] = writeData;
		end
	end
	
	// always @(negedge clk)
	// begin
	assign readData1 = Registers[readReg1];
	assign readData2 = Registers[readReg2];
	//end
	
endmodule
