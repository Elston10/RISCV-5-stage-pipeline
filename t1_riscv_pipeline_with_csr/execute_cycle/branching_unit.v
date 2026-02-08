module branching_unit (
    input  [2:0] funct3,
    input        zero,   // from ALU: result == 0
    input        sign,   // from ALU: result < 0 (or carry for unsigned)
    output reg   Branch  // whether branch is taken
); 

    always @(*) begin
        case (funct3)
            3'b000: Branch =  zero;     // BEQ
            3'b001: Branch = !zero;     // BNE
            3'b100: Branch =  sign;     // BLT
            3'b101: Branch = !sign;     // BGE
            3'b110: Branch =  sign;     // BLTU (using ALU unsigned flag)
            3'b111: Branch = !sign;     // BGEU
            default: Branch = 0;
        endcase
    end

endmodule
