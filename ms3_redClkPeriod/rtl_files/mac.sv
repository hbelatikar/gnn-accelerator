module mac #(parameter MAC_IN_SIZE = 5, parameter MAC_OUT_SIZE = 13, parameter W_SIZE = 5) (
    x0, x1, x2, x3, 
    w04, w05, w06, w07, 
    w14, w15, w16, w17, 
    w24, w25, w26, w27, 
    w34, w35, w36, w37, 
    out0, out1, out2, out3,
    in_ready, mac_ready,
    clk
);
    // Inputs
    input clk, in_ready;

    input signed [MAC_IN_SIZE - 1:0]    x0, x1, x2, x3; 
    input signed [W_SIZE -  1:0]	w04, w05, w06, w07, 
                                    w14, w15, w16, w17, 
                                    w24, w25, w26, w27, 
                                    w34, w35, w36, w37;
    // Outputs
    output logic mac_ready;
    output logic signed [MAC_OUT_SIZE - 1:0] out0, out1, out2, out3; //Signed output bits of the MAC

    /////////////////////////////////////////
    // Implementation of the MAC operation//
    ///////////////////////////////////////

    //Input MAC operation -> y(j) = ∑ x(i) × w(i,j)
    always_ff @(posedge clk) 
	begin
        if(in_ready) begin
            out0 <= x0 * w04 + x1 * w14 + x2 * w24 + x3 * w34;
            out1 <= x0 * w05 + x1 * w15 + x2 * w25 + x3 * w35;
            out2 <= x0 * w06 + x1 * w16 + x2 * w26 + x3 * w36;
            out3 <= x0 * w07 + x1 * w17 + x2 * w27 + x3 * w37;
		end
		mac_ready <= in_ready;
	end
endmodule