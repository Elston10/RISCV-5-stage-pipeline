module hazard_detection_unit(
   input rst,RegWriteM,RegWriteW,Branch_or_Jump,
   input [4:0] RD_M,RD_W,Rs1_E,Rs2_E;
   output [1:0] ForwardOp1,ForwardOp2,FlushD,FlushE    // Signal to stall the pipeline
);
assign ForwardOp1 = (RegWriteM && (RD_M != 0) && (RD_M == Rs1_E)) ? 2'b10 : 
                    (RegWriteW && (RD_W != 0) && (RD_W == Rs1_E)) ? 2'b01 : 2'b00;
assign ForwardOp2 = (RegWriteM && (RD_M != 0) && (RD_M == Rs2_E)) ? 2'b10 : 
                    (RegWriteW && (RD_W != 0) && (RD_W == Rs2_E)) ? 2'b01 : 2'b00;

assign FlushE=Branch_or_Jump;
assign FlushD= Branch_or_Jump;                                                                               
endmodule 