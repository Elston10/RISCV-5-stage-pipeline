`timescale 1ns / 1ps

module instr_fetch(
    input clk,
    input rst,FlushD,
    input  PCSrcE,
    input [31:0] PCTargetE,
    output  [31:0] InstrD,
    output  [31:0] PCD,
    output [31:0] PCPlus4D
);

  wire [31:0] PCPlus4F, PCF_1, PCF;
  reg  [31:0] PCF_reg, PCPlus4F_reg, InstrF_reg;
  wire [31:0] InstrF;

  // PC + 4
  adder pc_adder (
    .a(PCF), 
    .b(32'd4), 
    .sum(PCPlus4F)
  );

  // PC mux (select between branch target and next instruction)
  mux2 pc_mux (
    .d0(PCPlus4F), 
    .d1(PCTargetE), 
    .sel(PCSrcE), 
    .y(PCF_1)
  );

  // Instruction memory
  instr_mem mem1 (
    .instr_addr(PCF), 
    .instr(InstrF)
  );
reset_ff PC_update (
    .clk(clk),
    .rst(rst),
    .d(PCF_1),
    .q(PCF)
);
  // PC register update
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      PCF_reg <= 32'b0;
      PCPlus4F_reg <= 32'b0;
      InstrF_reg <= 32'b0;
    end else if(FlushD) begin
      InstrF_reg <= 32'b0;
      PCF_reg <= 32'b0; 
      PCPlus4F_reg <= 32'b0;
    end else begin
      PCF_reg <= PCF;
      PCPlus4F_reg <= PCPlus4F;
      InstrF_reg <= InstrF;
    end
  end
assign PCD       = PCF_reg;
assign PCPlus4D  =  PCPlus4F_reg;
assign InstrD    =  InstrF_reg;
endmodule

