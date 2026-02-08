module csr_exec
(
  input  [31:0] csr_old,    // Current CSR value
  input  [31:0] csr_wdata,  // Data from register or immediate to write/set/clear
  input  [2:0]  funct3,     // CSR instruction funct3 field
  output reg [31:0] csr_data,  // Data read from CSR (to be written into rd)
  output reg [31:0] csr_new    // New value to write back into CSR
);

always @(*) begin
  case(funct3)
    3'b001: begin // csrrw - atomic read/write
      csr_data = csr_old;     // Return old CSR
      csr_new  = csr_wdata;   // Write new data
    end

    3'b010: begin // csrrs - atomic read and set bits
      csr_data = csr_old;
      csr_new  = csr_old | csr_wdata;
    end

    3'b011: begin // csrrc - atomic read and clear bits
      csr_data = csr_old;
      csr_new  = csr_old & ~csr_wdata;
    end

    3'b101: begin // csrrwi - atomic read/write immediate
      csr_data = csr_old;
      csr_new  = csr_wdata;
    end

    3'b110: begin // csrrsi - atomic read and set immediate
      csr_data = csr_old;
      csr_new  = csr_old | csr_wdata;
    end

    3'b111: begin // csrrci - atomic read and clear immediate
      csr_data = csr_old;
      csr_new  = csr_old & ~csr_wdata;
    end

    default: begin
      csr_data = 32'b0;
      csr_new  = csr_old;  // No change
    end
  endcase
end

endmodule
