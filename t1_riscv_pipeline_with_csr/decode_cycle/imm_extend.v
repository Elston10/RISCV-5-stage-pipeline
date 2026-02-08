module imm_extend (
    input  [31:0]  instr,     // Use the full 32-bit instruction
    input  [2:0]   immsrc,
    output reg [31:0] immext
);

always @(*) begin
    case(immsrc)
        // I-type (e.g. lw, addi, jalr)
        3'b000: immext = {{21{instr[31]}}, instr[30:20]};

        // S-type (e.g. sw)
        3'b001: immext = {{21{instr[31]}}, instr[30:25], instr[11:7]};

        // B-type (e.g. beq, bne)
        3'b010: immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};

        // J-type (e.g. jal)
        3'b011: immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};

        // U-type (e.g. lui, auipc)
        3'b100: immext = {instr[31:12], 12'b0};

        3'b101:immext={27'b0,instr[19:15]};
        
        default: immext = 32'bx; // undefined
    endcase
end

endmodule
