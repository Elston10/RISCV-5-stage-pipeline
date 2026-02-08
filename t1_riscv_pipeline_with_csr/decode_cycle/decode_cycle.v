module decode_cycle(
    input clk,rst,RegWriteW,FlushE,
    input [31:0] ResultW,
    input [4:0] RDW,
    input [31:0] InstrD,PCD,PCPlus4D,
    output RegWriteE,MemWriteE,BranchE,ALUSrcE,luiE,
    output [2:0] ALUControlE,ResultSrcE,
    output [1:0] JumpE,
    output [4:0] RdE,RS1E,RS2E,
    output [31:0] RD1E,RD2E,PCE,PCPlus4E,ImmExtE,InstrE
);
wire [2:0]ImmSrcD;
wire [1:0]JumpD;
wire [2:0]ResultSrcD;
reg [2:0] ResultSrc_r;
wire ALUSrcD,BranchD,MemWriteD;
reg RegWrite_r,MemWrite_r,Branch_r,ALUSrc_r;
wire lui_control_bit,final_RegWrite;
reg [1:0] Jump_r;
wire [31:0] RD1,,CSR_r;
reg [31:0] RD1_r,RD2_r,InstrD_r;

wire [2:0] ALUControlD;
reg [2:0]ALUControl_r;

wire [4:0] RdD;
reg [4:0] Rd_r,RS1_r,RS2_r;
wire Zero,ALUR31;

wire [31:0] ImmExtD;
reg [31:0] ImmExt_r;
reg lui_r;
reg [31:0]PC_r,PCPlus4_r;
assign RdD=InstrD[11:7];
assign Final_RegWrite=RdD!=5'b00000 ? RegWriteD : 1'b0; // Disable RegWrite if Rd is x0
assign lui_control_bit=InstrD[5];
controller c(
 .op(InstrD[6:0]),
 .funct3(InstrD[14:12]),
 .funct7b5(InstrD[30]),
  .ResultSrc(ResultSrcD),
  .MemWrite(MemWriteD),
  .ALUSrc(ALUSrcD),
  .Branch(BranchD),
  .RegWrite(RegWriteD),
  .Jump(JumpD),
  .ImmSrc(ImmSrcD),
  .ALUControl(ALUControlD));
  
reg_file reg1(.clk(clk),.wr_en(RegWriteW),
              .rd_addr1(InstrD[19:15]),
              .rd_addr2(InstrD[24:20]),
               .wr_addr(RDW),
               .wr_data(ResultW),
               .rd_data1(RD1),
               .rd_data2(RD2));
               
imm_extend ext(InstrD,
               ImmSrcD,
               ImmExtD);

always @(posedge clk or posedge rst)begin
  if(rst)begin 
    RegWrite_r<=1'b0;
    ALUSrc_r<=1'b0;
    MemWrite_r<=1'b0;
    ResultSrc_r<=3'b0;
    Jump_r<=2'b0;
    Branch_r<=1'b0;
    RD1_r<=32'h00000000;
    RD2_r<=32'h00000000;
    Rd_r<=32'h00000000;
    ImmExt_r<=32'h00000000;
    PC_r<=32'h00000000;
    PCPlus4_r<=32'h00000000;
    ALUControl_r<=2'b0;
    ImmExt_r<=32'h00000000;
    InstrD_r<=32'h00000000;
    RS1_r<=5'b00000;
    RS2_r<=5'b00000;
    lui_r<=1'b0;
    CSR_r<=32'b0;
 end else if (FlushE) begin
    // load-use bubble: insert NOP into EX (clear control/signals) 
    RegWrite_r   <= 1'b0;
    ALUSrc_r     <= 1'b0;
    MemWrite_r   <= 1'b0;
    ResultSrc_r  <= 3'b0;
    Jump_r       <= 2'b0;
    Branch_r     <= 1'b0;
    RD1_r        <= 32'h00000000;
    RD2_r        <= 32'h00000000;
    Rd_r         <= 5'b00000;
    ImmExt_r     <= 32'h00000000;
    ALUControl_r <= 3'b000;
    InstrD_r     <= 32'h00000000; // NOP
    RS1_r        <= 5'b00000;
    RS2_r        <= 5'b00000;
    lui_r        <= 1'b0;
    PC_r<=32'b0;
    PCPlus4_r<=32'b0;
    CSR_r<=32'b0;
   // IMPORTANT: do NOT change PC_r or PCPlus4_r here — preserve them
  end
 else begin 
    RegWrite_r<=Final_RegWrite;
    ALUSrc_r<=ALUSrcD;
    MemWrite_r<=MemWriteD;
    ResultSrc_r<=ResultSrcD;
    Jump_r<=JumpD;
    Branch_r<=BranchD;
    RD1_r<=RD1;
    RD2_r<=RD2;
    Rd_r<=RdD;
    PC_r<=PCD;
    PCPlus4_r<=PCPlus4D;
    ALUControl_r<=ALUControlD;
    ImmExt_r<=ImmExtD;
    InstrD_r<=InstrD;
    RS1_r<=InstrD[19:15];
    RS2_r<=InstrD[24:20];
    lui_r<=lui_control_bit;
    CSR_r<=CSRD;
 end
  end 
assign RegWriteE =RegWrite_r;
assign ALUSrcE =ALUSrc_r;
assign MemWriteE =MemWrite_r;
assign ResultSrcE =ResultSrc_r;
assign JumpE =Jump_r;
assign BranchE=Branch_r;
assign RD1E=RD1_r;
assign RD2E=RD2_r;
assign RdE=Rd_r;
assign PCE =PC_r;
assign PCPlus4E=PCPlus4_r;
assign ALUControlE=ALUControl_r;
assign ImmExtE=ImmExt_r;
assign InstrE=InstrD_r;
assign RS1E=RS1_r;
assign RS2E=RS2_r;
assign luiE=lui_r;
endmodule 