module nn_node (
    x0, x1, x2, x3, 
    w04, w05, w06, w07, 
    w14, w15, w16, w17, 
    w24, w25, w26, w27, 
    w34, w35, w36, w37, 
    w48, w58, w49, w59, 
    w68, w69, w78, w79, 
    out0, out1, 
    in_ready, out0_ready, out1_ready, 
    clk
);
    input [4:0] x0, x1, x2, x3, w04, w05, w06, w07, w14, w15, w16, w17, w24, w25, w26, w27, w34, w35, w36, w37, w48, w58, w49, w59, w68, w69, w78, w79;
    input in_ready;
    input clk;
    output logic [16:0] out0, out1;
    output out0_ready, out1_ready;
    
    // Implementation of the neural network

    logic [4:0] y4, y5, y6, y7;
    //Output of ReLu activation
    logic [4:0] z4, z5, z6, z7;

    always_ff @(posedge clk ) begin
        if(in_ready) begin
            y4 <= x0 * w04 + x1 * w14 + x2 * w24 + x3 * w34;
            y5 <= x0 * w05 + x1 * w15 + x2 * w25 + x3 * w35;
            y6 <= x0 * w06 + x1 * w16 + x2 * w26 + x3 * w36;
            y7 <= x0 * w07 + x1 * w17 + x2 * w27 + x3 * w37;
            
            //If negative number then assign z4-z7 as 0 else assign y to z
            z4 <= (y4[16] == 1'b1) ? 17'b0 : y4;
            z5 <= (y5[16] == 1'b1) ? 17'b0 : y5;
            z6 <= (y6[16] == 1'b1) ? 17'b0 : y6;
            z7 <= (y7[16] == 1'b1) ? 17'b0 : y7;
            
            out0 <= z4 * w48 + z5 * w58 + z6 * w68 + z7 * w78;
            out1 <= z4 * w49 + z5 * w59 + z6 * w69 + z7 * w79;
            
        end
    end
endmodule
