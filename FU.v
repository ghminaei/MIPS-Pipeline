module FU (
    MemWb,
    MemRd,
    WbWb,
    WbRd,
    ExRs,
    ExRt,

    selA,
    selB
);
input MemWb,
      WbWb;
input[4:0] MemRd,
           WbRd,
           ExRs,
           ExRt;
output reg[1:0] selA,
                selB;

assign selA = (MemWb == 1 && MemRd == ExRs && MemRd!=5'b0) ? 2'b01 :
	 (MemWb == 1 && WbRd == ExRs && WbRd!=5'b0 && (MemRd != ExRs | MemWb == 0)) ? 2'b10 :
	 2'b00;
assign selB = (MemWb == 1 &&  MemRd == ExRt && MemRd!=5'b0) ? 2'b01 :
	 (MemWb == 1 && WbRd == ExRt && WbRd!=5'b0 && (MemRd != ExRt | MemWb == 0)) ? 2'b10 :
	 2'b00;

endmodule