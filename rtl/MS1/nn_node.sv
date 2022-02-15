module nn_node (
    in0, in1, in2, in3, 
    w04, w05, w06, w07, 
    w14, w15, w16, w17, 
    w24, w25, w26, w27, 
    w34, w35, w36, w37, 
    w48, w58, w49, w59, 
    w68, w69, w78, w79, 
    out0, out1, 
    in_ready, out_ready, 
    clk
);
    input [15:0] in0, in1, in2, in3, w04, w05, w06, w07, w14, w15, w16, w17, w24, w25, w26, w27, w34, w35, w36, w37, w48, w58, w49, w59, w68, w69, w78, w79;
    input in_ready;
    input clk;
    output logic [15:0] out0, out1;
    output out_ready;
    // Implementation of the neural network

    logic [15:0] y4, y5, y6, y7;

    always_ff @(posedge clk ) begin
        if(in_ready) begin
            y4 <= in0 * w04 + in1 * w14 + in2 * w24 + in3 * w34;
            y5 <= in0 * w05 + in1 * w15 + in2 * w25 + in3 * w35;
            y6 <= in0 * w06 + in1 * w16 + in2 * w26 + in3 * w36;
            y7 <= in0 * w07 + in1 * w17 + in2 * w27 + in3 * w37;
            out0 <= y4 * w48 + y5 * w58 + y6 * w68 + y7 * w78;
            out1 <= y4 * w49 + y5 * w59 + y6 * w69 + y7 * w79;
        end
    end
endmodule