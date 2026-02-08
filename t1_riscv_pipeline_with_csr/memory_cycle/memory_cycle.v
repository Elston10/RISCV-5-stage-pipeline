module memory_cycle(
input clk,rst,RegWriteM,MemWriteM
input [2:0] ResultSrcM,funct3,
input [31:0] ALUResultM,WriteDataM,PCPlus4M
input [4:0] RdM,
output [4:0] RdW,
output [31:0]PCPlus4W,
output RegWriteW,
output reg [31:0] ReadDataW,
output [1:0] ResultSrcW
)
reg [31:0] ReadDataM,ReadDataw_r,PCPlus4W_r;
reg [4:0] Rdw_r;
reg RegWritew_r;
reg [2:0]ResultSrcw_r;
data_mem dmem( .clk(clk),
              .wr_en(MemWriteM),
              .funct3(funct3),
              .wr_addr(ALUResultM),
              .wr_data(WriteDataM),
              .rd_data_mem(ReadDataM));
always @(posedge clk or posedge rst)begin
  if(rst)begin
    ReadDataw_r<=32'b0;
    PCPlus4W_r<=32'b0;
    Rdw_r<=5'b0;
    RegWritew_r<=1'b0;
    ResultSrcw_r<=2'b0;
  end else begin
    RegWritew_r<=RegWriteW;
    ReadDataw_r<=ReadDataM;
    ResultSrcw_r<=ResultSrcM;
    Rdw_r<=RdM;
    PCPlus4W_r<=PCPlus4M;
  end
end 
assign ReadDataW=(rst==1'b1)?32'b0:ReadData_wr;
assign PCPlus4W=(rst==1'b1)?32'b0:PCPlus4W_r;
assign RdW=(rst==1'b1)?5'b0:Rdw_r;
assign RegWriteW=(rst==1'b1)?1'b0: RegWritew_r;
assign ResultSrcW=(rst==1'b1)?3'b0:ResultSrcw_r;
endmodule