// mux5.v - logic for 5-to-1 multiplexer

module mux5 #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] d0, d1, d2, d3, d4,
    input  [2:0]       sel,        // needs 3 bits for 5 choices
    output [WIDTH-1:0] y
);

assign y = (sel == 3'b000) ? d0 :
           (sel == 3'b001) ? d1 :
           (sel == 3'b010) ? d2 :
           (sel == 3'b011) ? d3 :
           (sel == 3'b100) ? d4 :
           {WIDTH{1'b0}}; // default to 0 for safety

endmodule
