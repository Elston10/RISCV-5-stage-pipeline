// main_decoder.v - control logic for pipelined RISC-V processor (Decode Stage)
module main_decoder (
    input  [6:0] op,
    output [2:0] ResultSrc,
    output       MemWrite, Branch, ALUSrc,
    output       RegWrite,
    output [2:0] ImmSrc,
    output [1:0] ALUOp,
    output [1:0] Jump
);

reg [14:0] controls; // Now 14-bit control vector

always @(*) begin
    casez (op)
        // Format: {RegWrite, ImmSrc[2:0], ALUSrc, MemWrite, ResultSrc[1:0], ALUOp[1:0], JumpType[1:0], Branch}

        7'b0000011: controls = 15'b1_000_1_0_001_00_00_0; // lw (I-type)
        7'b0100011: controls = 15'b0_001_1_1_000_00_00_0; // sw (S-type)
        7'b0110011: controls = 15'b1_xxx_0_0_000_10_00_0; // R-type (register-register ALU)
        7'b0010011: controls = 15'b1_000_1_0_000_10_00_0; // I-type ALU (e.g., addi)
        7'b1100011: controls = 15'b0_010_0_0_000_01_00_1; // Branch (B-type)
        7'b0110111: controls = 15'b1_100_1_0_011_00_00_0; // lui (U-type)
        7'b0010111: controls = 15'b1_100_1_0_011_00_00_0; // auipc (U-type)
        7'b1101111: controls = 15'b1_011_0_0_010_00_01_0; // jal (J-type)
        7'b1100111: controls = 15'b1_000_1_0_010_00_10_0; // jalr (I-type)
        7'b1110011: controls = 15'b1_000_1_0_100_00_00_0; // CSR instructions (I-type)
        
        default:    controls = 15'b0_000_0_0_00_00_00_0; // NOP or unknown
    endcase
end

// Assign outputs from control vector
assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUOp, Jump, Branch} = controls;

endmodule
