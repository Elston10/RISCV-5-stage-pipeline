
// adder.v - logic /t1c_riscv_cpu_tb/uut/execute_stage/auipcadderfor adder

module adder #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,
    output      [WIDTH-1:0] sum
);

assign sum = a + b;

endmodule

