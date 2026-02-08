

module instr_mem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter MEM_SIZE   = 512
) (
    input  [ADDR_WIDTH-1:0] instr_addr,
    output [DATA_WIDTH-1:0] instr
);

  // Internal instruction memory array
  reg [DATA_WIDTH-1:0] instr_ram [0:MEM_SIZE-1];

  // Assign instruction based on word-aligned address
  assign instr = (instr_addr[31:2] < MEM_SIZE) ? instr_ram[instr_addr[31:2]] : 32'h00000000;

  // Load from memory file
  initial begin
    $readmemh("instr_mem.mem", instr_ram);
  end

endmodule