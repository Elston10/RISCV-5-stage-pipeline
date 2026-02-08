module execute_cycle(
input clk,rst,
input RegWriteE, MemWriteE, BranchE, ALUSrcE, op7bit, luiE,
input [2:0] ALUControlE,funct3,ResultSrcE,
input [31:0]InstrE,CSRE,
input [1:0] JumpE,ForwardOp1,ForwardOp2,
input [4:0] RdE,
input [31:0] RD1E, RD2E, PCE, PCPlus4E, ImmExtE,ResultW,
output PCSrcE,RegWriteM,MemWriteM,Branch_or_Jump,
output [2:0] ResultSrcM,
output [4:0] RdM,
output [31:0] PCTargetE,WriteDataM,ALUResultM,PCPlus4M,luAuiPCM,InstrM
);
wire [31:0] Result_Final;
reg RegWrite_mr,MemWrite_mr;
wire is_lui,is_auipc;
reg [2:0] ResultSrc_mr;
wire [31:0] SrcA,SrcB,SrcB_Final,ALUResultE,csr_operand,new_csr;
wire ZeroE, ALUR31, Branch_type;
wire [31:0] BranchAddr,JumpTarget,WriteDataE,Auipc,lAuiPC;
assign WriteDataE=SrcB;
assign Branch_or_Jump=((JumpE!=2'b00)|BranchE)?1'b1:1'b0;
reg [31:0] WriteData_mr,PCPlus4_mr,ALUResult_mr,lAuiPC_r,InstrE_r,CSR_mr,CSRResult_mr,new_csr_mr;
reg[4:0] Rd_mr;
// Operand selection: either RD2E or ImmExtE
assign is_lui=(InstrE[6:0]==7'b0110111)?1'b1:1'b0;
assign is_auipc=(InstrE[6:0]==7'b0010111)?1'b1:1'b0;
always @(posedge clk or posedge rst)begin
if(rst)begin
RegWrite_mr<=1'b0;
MemWrite_mr<=1'b0;
ResultSrc_mr<=3'b0;
WriteData_mr<=32'b0;
Rd_mr<=32'b0;
PCPlus4_mr<=32'b0;
ALUResult_mr<=32'b0;
lAuiPC_r<=32'b0;
InstrE_r<=32'b0;
new_csr_mr<=32'b0;
end else begin
RegWrite_mr<=RegWriteE;
MemWrite_mr<=MemWriteE;
ResultSrc_mr<=ResultSrcE;
WriteData_mr<=WriteDataE;
Rd_mr<=RdE;
PCPlus4_mr<=PCPlus4E;
ALUResult_mr<=Result_Final;
lAuiPC_r<=lAuiPC;
InstrE_r<=InstrE;
end

end

mux4 #(32) ForwardOperand_1 (
.d0(RD1E), // 00 -> from register file (no forwarding)
.d1(ResultW), // 01 -> forward from WB stage
.d2(ALUResultM), // 10 -> forward from MEM stage <-- IMPORTANT
.d3(32'b0), // 11 -> unused
.sel(ForwardOp1),
.y(SrcA)
);
// Correct wiring for ForwardOperand_2 (SrcB)
mux4 #(32) ForwardOperand_2 (
.d0(RD2E), // 00 -> from register file
.d1(ResultW), // 01 -> forward from WB stage
.d2(ALUResultM), // 10 -> forward from MEM stage
.d3(32'b0),
.sel(ForwardOp2),
.y(SrcB)
);
mux2 operand_select(
.d0(SrcB),
.d1(ImmExtE),
.sel(ALUSrcE),
.y(SrcB_Final)
);
adder#(32) auipcadder(PCE,ImmExtE,Auipc);
mux2 #(32) luipcmux( Auipc,ImmExtE, luiE,lAuiPC);
// ALU computation
alu alu_unit(
.a(SrcA),
.b(SrcB_Final),
.alu_ctrl(ALUControlE),
.alu_out(ALUResultE),
.zero(ZeroE),
.op7bit(op7bit),
.funct3_bit(funct3[0])
);
mux2 #(32) hazrd_auipc_mux(.d0(ALUResultE),.d1(lAuiPC),.sel(is_auipc|is_lui),.y(Result_Final));
// ALU MSB (for signed comparisons)
assign ALUR31 = ALUResultE[31];
// Branch decision logic to decide whether we require branch
branching_unit branch(
.zero(ZeroE),
.funct3(funct3),
.sign(ALUR31),
.Branch(Branch_type)
);
// Branch address calculation: PC + Immediate
adder#(32) pcaddbranch(PCE, ImmExtE, BranchAddr);
assign PCTargetE = (JumpE != 2'b00) ? JumpTarget : BranchAddr;
// Final PC selection logic to fetch stage
assign PCSrcE = (Branch_type & BranchE) | (JumpE!=2'b00) ;
// PC selection
jump_mux jump_selector (
.pc(PCE),
.imm(ImmExtE),
.rs1(RD1E),
.Jump(JumpE),
.next_pc(JumpTarget)
);
mux2 #(32) op_csr_select(.d0(RD2E),
                         .d1(ImmExE),
                         .sel(Instr[14]),
                         .y(csr_operand));
csr_reg_file csr_reg(
    .clk(clk),
    .reset(rst),
    .csr_addr(InstrE[31:20]),
    .we(RegWriteE),
    .wdata(new_csr),
    .rdata(CSR_ResultE)
);
csr_exec csr_unit(
    .csr_old(csr_operand),
    .csr_wdata(CSRE),
    .funct3(Instr[14:12]),
    .csr_data(),
    .csr_new(new_csr)
);
assign RegWriteM = RegWrite_mr;
assign ResultSrcM = ResultSrc_mr;
assign WriteDataM = WriteData_mr;
assign ALUResultM =  ALUResult_mr;
assign RdM =  Rd_mr;
assign PCPlus4M = PCPlus4_mr;
assign luAuiPCM =lAuiPC_r;
assign InstrM=InstrE_r;
assign MemWriteM=MemWrite_mr;
endmodule