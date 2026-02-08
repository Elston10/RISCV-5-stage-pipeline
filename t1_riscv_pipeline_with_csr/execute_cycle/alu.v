module alu #(parameter WIDTH = 32) (
    input [WIDTH-1:0] a, b,
    input [2:0] alu_ctrl,
    output reg [WIDTH-1:0] alu_out,
    output zero,
    input op7bit, funct3_bit
);

wire signed [31:0] a_s;


always @(*) begin
    case (alu_ctrl)
        3'b000: alu_out <= a + b; // ADDI
        3'b001: alu_out <= a - b; // SUB
        3'b010: alu_out <= a & b; // ANDI
        3'b011: alu_out <= a | b; // ORI\
		  3'b100: alu_out <= a << b[4:0]; // SLLI
        3'b101: begin 
            case (funct3_bit)
                1'b0: begin
                    if (a[31] != b[31])
                        alu_out <= a[31] ? 1 : 0; 
							
                    else
                        alu_out <= (a < b) ? 1 : 0; 
								
								
								
                end
                1'b1: alu_out <= (a < {20'b0, b[11:0]}) ? 1 : 0;
					 
					 
					 
            endcase
        end
        
        3'b110: begin // SRLI and SRAI
		  
            if (op7bit == 1'b0)
                alu_out <= (a >> b[4:0]); // SRLI (logical shift right)
            else
                alu_out <= (a_s >>> b[4:0]); // SRAI (arithmetic shift right)
        end
		  
        3'b111: alu_out <= a ^ b; 
		  
		  
        default: alu_out <= 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;
assign a_s = a;
endmodule