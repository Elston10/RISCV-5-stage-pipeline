module data_mem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter MEM_SIZE = 64
) (
    input wire clk,
    input wire wr_en,
    input wire [2:0] funct3,
    input wire [ADDR_WIDTH-1:0] wr_addr,
    input wire [DATA_WIDTH-1:0] wr_data,
    output reg [DATA_WIDTH-1:0] rd_data_mem
);

    // Memory array to store data
    reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

    // Calculate word address (aligned to word boundary)
    wire [ADDR_WIDTH-1:0] word_addr = wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE;
    always @(posedge clk) begin
        if (wr_en) begin
            case (funct3)
                3'b000: begin // Store byte (sb)
                    case (wr_addr[1:0])
                        2'b00: mem[word_addr][7:0] <= wr_data[7:0];
                        2'b01: mem[word_addr][15:8] <= wr_data[7:0];
                        2'b10: mem[word_addr][23:16] <= wr_data[7:0];
                        2'b11: mem[word_addr][31:24] <= wr_data[7:0];
                    endcase
                end
                3'b001: begin // Store halfword (sh)
                    case (wr_addr[1:0])
                        2'b00: mem[word_addr][15:0] <= wr_data[15:0]; // Lower halfword
                        2'b10: mem[word_addr][31:16] <= wr_data[15:0]; // Upper halfword
                    endcase
                end
                3'b010: begin // Store word (sw)
                    mem[word_addr] <= wr_data;
                end
                default: begin
       
                end
            endcase
        end
    end

    always @(*) begin
	 
        case (funct3)
            3'b000: begin // Load byte (lb)
                case (wr_addr[1:0])
					 
					 
                    2'b00: rd_data_mem <= {{24{mem[word_addr][7]}}, mem[word_addr][7:0]};
						  
                    2'b01: rd_data_mem <= {{24{mem[word_addr][15]}}, mem[word_addr][15:8]};
                    2'b10: rd_data_mem <= {{24{mem[word_addr][23]}}, mem[word_addr][23:16]};
                    2'b11: rd_data_mem <= {{24{mem[word_addr][31]}}, mem[word_addr][31:24]};
						  
						  
                endcase
            end
            3'b100: begin // Load byte unsigned (lbu)
                case (wr_addr[1:0])
                    2'b00: rd_data_mem <= {24'b0, mem[word_addr][7:0]};
                    2'b01: rd_data_mem <= {24'b0, mem[word_addr][15:8]};
                    2'b10: rd_data_mem <= {24'b0, mem[word_addr][23:16]};
                    2'b11: rd_data_mem <= {24'b0, mem[word_addr][31:24]};
                endcase
            end
            3'b010: begin // Load word (lw)
                rd_data_mem <= mem[word_addr];
            end
            3'b001: begin 
				// Load halfword (lh)
                case (wr_addr[1:0])
		      2'b00: rd_data_mem <= {{16{mem[word_addr][15]}}, mem[word_addr][15:0]}; // Lower halfword
                    2'b10: rd_data_mem <= {{16{mem[word_addr][31]}}, mem[word_addr][31:16]}; // Upper halfword
                endcase
            end
            3'b101: begin
				// Load halfword unsigned (lhu)
                case (wr_addr[1:0])
                    2'b00: rd_data_mem <= {16'b0, mem[word_addr][15:0]}; // Lower halfword
                    2'b10: rd_data_mem <= {16'b0, mem[word_addr][31:16]}; // Upper halfword
                endcase
            end
            default: begin
				

                rd_data_mem <= 32'b0;
            end
        endcase
    end

endmodule