
module csr_reg_file (
    input         clk,
    input         reset,

    input  [11:0] csr_addr,   // 12-bit CSR address field
    input  [31:0] wdata,      // value to write
    input         we,         // write enable
    output reg [31:0] rdata   // read value (old CSR value)
);

    // Four custom timer preset registers per task (4 tasks)
    reg [31:0] mrTEVi0, mrTEVi1, mrTEVi2, mrTEVi3;
    reg [31:0] mrWDEVi0, mrWDEVi1, mrWDEVi2, mrWDEVi3;
    reg [31:0] mrD1EVi0, mrD1EVi1, mrD1EVi2, mrD1EVi3;
    reg [31:0] mrD2EVi0, mrD2EVi1, mrD2EVi2, mrD2EVi3;
    reg [31:0] crTR0,crTR1,crTR2,crTR3;
    reg [31:0] crEV0,crEV1,crEV2,crEV3;

    // CSR address ranges for 4 tasks (each task has 4 CSRs)
    // Task 0: 0x7E0 - 0x7E3
    // Task 1: 0x7E4 - 0x7E7
    // Task 2: 0x7E8 - 0x7EB
    // Task 3: 0x7EC - 0x7EF

    always @(*) begin
        case (csr_addr)
            12'h7E0: rdata = mrTEVi0;
            12'h7E1: rdata = mrWDEVi0;
            12'h7E2: rdata = mrD1EVi0;
            12'h7E3: rdata = mrD2EVi0;
            12'h7E4: rdata= crTR0;
            12'h7E5: rdata=crEV0;
            12'h7E6: rdata=mrCntSleep0;
            12'h7E7: rdata=mrCntRun0;
            
            12'h7F0: rdata = mrTEVi1;
            12'h7F1: rdata = mrWDEVi1;
            12'h7F2: rdata = mrD1EVi1;
            12'h7F3: rdata = mrD2EVi1;
            12'h7F4: rdata = crTR1;
            12'h7F5: rdata = crEV1;
            12'h7F6: rdata = mrCntSleep1;
            12'h7F7: rdata = mrCntRun1;

            12'h800: rdata = mrTEVi2;
            12'h801: rdata = mrWDEVi2;
            12'h802: rdata = mrD1EVi2;
            12'h803: rdata = mrD2EVi2;
            12'h804: rdata = crTR2;
            12'h805: rdata = crEV2;
            12'h806: rdata = mrCntSleep2;
            12'h807: rdata = mrCntRun2;



            12'h900: rdata = mrTEVi3;
            12'h901: rdata = mrWDEVi3;
            12'h902: rdata = mrD1EVi3;
            12'h903: rdata = mrD2EVi3;
            12'h904: rdata = crTR2;
            12'h905: rdata = crEV2;
            12'h906: rdata = mrCntSleep2;
            12'h907: rdata = mrCntRun2;


            default: rdata = 32'b0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mrTEVi0  <= 32'b0; mrWDEVi0 <= 32'b0; mrD1EVi0 <= 32'b0; mrD2EVi0 <= 32'b0;
            mrTEVi1  <= 32'b0; mrWDEVi1 <= 32'b0; mrD1EVi1 <= 32'b0; mrD2EVi1 <= 32'b0;
            mrTEVi2  <= 32'b0; mrWDEVi2 <= 32'b0; mrD1EVi2 <= 32'b0; mrD2EVi2 <= 32'b0;
            mrTEVi3  <= 32'b0; mrWDEVi3 <= 32'b0; mrD1EVi3 <= 32'b0; mrD2EVi3 <= 32'b0;
        end else if (we) begin
            case (csr_addr)
                12'h7E0: mrTEVi0  <= wdata;
                12'h7E1: mrWDEVi0 <= wdata;
                12'h7E2: mrD1EVi0 <= wdata;
                12'h7E3: mrD2EVi0 <= wdata;
                12'h7E4: crTR0    <= wdata;

                12'h7F0: mrTEVi1  <= wdata;
                12'h7F1: mrWDEVi1 <= wdata;
                12'h7F2: mrD1EVi1 <= wdata;
                12'h7F3: mrD2EVi1 <= wdata;
                12'h7F4: crTR1    <= wdata;

                12'h800: mrTEVi2  <= wdata;
                12'h801: mrWDEVi2 <= wdata;
                12'h802: mrD1EVi2 <= wdata;
                12'h803: mrD2EVi2 <= wdata;
                12'h804: crTR2    <= wdata;

                12'h900: mrTEVi3  <= wdata;
                12'h901: mrWDEVi3 <= wdata;
                12'h902: mrD1EVi3 <= wdata;
                12'h903: mrD2EVi3 <= wdata;
                12'h904: crTR3    <= wdata;
            endcase
        end
    end

endmodule