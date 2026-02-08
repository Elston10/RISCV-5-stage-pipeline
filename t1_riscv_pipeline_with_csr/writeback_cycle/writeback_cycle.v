module writeback_cycle(
  input [31:0]InstrM,
   input [2:0] ResultSrcW,
   input [31:0]ReadDataW,
   input [31:0]PCPlus4W
   input [31:0]ALUResultW,
   input [31:0]luAuiPCW,
   output [31:0]ResultW);
mux5 #(32) resultmux (
        .d0(ALUResultW),
        .d1(ReadDataW),
        .d2(PCPlus4W),
        .d3(luAuiPCW),
        .d4(),
        .sel(ResultSrcW),
        .y(ResultW)
    );
endmodule