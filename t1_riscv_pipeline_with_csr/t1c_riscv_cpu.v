`timescale 1ns/ 1ps
module t1c_riscv_cpu(
    input clk,
    input rst
);

    // *** WIRE DECLARATIONS ***
    wire PCSrcE;
    reg  PCSrc_reg;
    wire PC_exec;
    
    //Signals for Flushing
    wire FlushD,FlushE,Branch_or_Jump;
    // Fetch to Decode
    wire [31:0] InstrD, PCD, PCPlus4D;

    // Decode to Execute
    wire RegWriteE, MemWriteE, BranchE, ALUSrcE;
    wire [2:0] ALUControlE,ResultSrcE;
    wire [1:0] JumpE;
    wire [4:0] RdE,RS1E,RS2E;
    wire [31:0] RD1E, RD2E, PCE, PCPlus4E, ImmExtE,InstrE,luiE;

    // Execute to Memory
    wire RegWriteM, MemWriteM;
    wire [1:0] ForwardOp1,ForwardOp2;
    wire [2:0] ResultSrcM;
    wire [4:0] RdM;
    wire [31:0] WriteDataM, ALUResultM, PCPlus4M, PCTargetE;
    wire [31:0] luAuiPCM,InstrM;

    // Memory to Writeback
    wire RegWriteW;
    wire [2:0] ResultSrcW;
    wire [4:0] RdW;
    wire [31:0] ReadDataW, PCPlus4W, ALUResultW, luAuiPCW, ResultW,InstrW;

    // -------------------- BRANCH PIPELINE REGISTER --------------------
   
    // -------------------- FETCH STAGE --------------------
    instr_fetch fetch_stage (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .FlushD(FlushD)
    );

    // -------------------- DECODE STAGE --------------------
    decode_cycle decode_stage (
        .clk(clk),
        .rst(rst),
        .RegWriteW(RegWriteW),
        .RDW(RdW),
        .ResultW(ResultW),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .JumpE(JumpE),
        .ResultSrcE(ResultSrcE),
        .RdE(RdE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .ImmExtE(ImmExtE),
        .InstrE(InstrE),
        .RS1E(RS1E),
        .RS2E(RS2E),
        .luiE(luiE),
        .FlushE(FlushE)
    );

    // -------------------- EXECUTE STAGE --------------------
    execute_cycle execute_stage (
        .clk(clk),
        .rst(rst),
        .InstrE(InstrE),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .op7bit(InstrD[30]),
        .funct3(InstrD[14:12]),
        .ALUControlE(ALUControlE),
        .JumpE(JumpE),
        .ResultSrcE(ResultSrcE),
        .RdE(RdE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .ImmExtE(ImmExtE),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .RdM(RdM),
        .luAuiPCM(luAuiPCM),
        .WriteDataM(WriteDataM),
        .ALUResultM(ALUResultM),
        .PCPlus4M(PCPlus4M),
        .InstrM(InstrM),
        .MemWriteM(MemWriteM),
        .ForwardOp1(ForwardOp1),
        .ForwardOp2(ForwardOp2),
        .ResultW(ResultW),
        .luiE(luiE),
        .Branch_or_Jump(Branch_or_Jump)
    );

    // -------------------- MEMORY STAGE --------------------
    memory_cycle mem_cycle_inst (
        .InstrM(InstrM),
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .funct3(InstrD[14:12]),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .PCPlus4M(PCPlus4M),
        .luAuiPCM(luAuiPCM),
        .RdM(RdM),
        .RdW(RdW),
        .PCPlus4W(PCPlus4W),
        .RegWriteW(RegWriteW),
        .ReadDataW(ReadDataW),
        .ALUResultW(ALUResultW),
        .luAuiPCW(luAuiPCW),
        .ResultSrcW(ResultSrcW),
        .InstrW(InstrW)
    );

    // -------------------- WRITEBACK STAGE --------------------
    writeback_cycle wb_stage (
        .ResultSrcW(ResultSrcW),
        .ReadDataW(ReadDataW),
        .PCPlus4W(PCPlus4W),
        .ALUResultW(ALUResultW),
        .luAuiPCW(luAuiPCW),
        .ResultW(ResultW),
        .InstrW(InstrW)
    );

    hazard_detection_unit hdu (
        .rst(rst),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .RD_M(RdM),
        .RD_W(RdW),
        .Rs1_E(RS1E),
        .Rs2_E(RS2E),
        .Branch_or_Jump(PCSrcE),
        .ForwardOp1(ForwardOp1),
        .ForwardOp2(ForwardOp2),
        .FlushD(FlushD),
        .FlushE(FlushE)
    );

endmodule
