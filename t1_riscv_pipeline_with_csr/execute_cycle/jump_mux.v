// jump_mux.v
module jump_mux (
    input  [31:0] pc,       // Current PC
    input  [31:0] imm,      // Immediate value (sign-extended)
    input  [31:0] rs1,      // Value from rs1 register
    input  [1:0]  Jump,     // Jump control: 00 = no jump, 01 = JAL, 10 = JALR
    output reg [31:0] next_pc
);

always @(*) begin
    case (Jump)
        2'b00: next_pc = pc + 4;                 // No jump: default sequential PC
        2'b01: next_pc = pc + imm;               // JAL: PC-relative jump
        2'b10: next_pc = (rs1 + imm) & ~32'h1;   // JALR: Register-indirect jump, LSB cleared
        default: next_pc = 32'b0;                // Optional: trap or reset
    endcase
end

endmodule