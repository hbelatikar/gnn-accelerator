module mac_4n #(parameter MAC4_IN_SIZE = 7, parameter MAC4_OUT_SIZE = 13, parameter MAC4_W_SIZE = 5) (
    x0_n0, x1_n0, x2_n0, x3_n0, 
    x0_n1, x1_n1, x2_n1, x3_n1, 
    x0_n2, x1_n2, x2_n2, x3_n2, 
    x0_n3, x1_n3, x2_n3, x3_n3, 
    w04, w05, w06, w07, 
    w14, w15, w16, w17, 
    w24, w25, w26, w27, 
    w34, w35, w36, w37, 
    out0_n0, out1_n0, out2_n0, out3_n0,
    out0_n1, out1_n1, out2_n1, out3_n1,
    out0_n2, out1_n2, out2_n2, out3_n2,
    out0_n3, out1_n3, out2_n3, out3_n3,
    in_ready, mac_ready, 
    clk
);  
    //Inputs
    input clk, in_ready;
    input signed [MAC4_IN_SIZE - 1:0]   x0_n0, x1_n0, x2_n0, x3_n0, 
                                        x0_n1, x1_n1, x2_n1, x3_n1, 
                                        x0_n2, x1_n2, x2_n2, x3_n2, 
                                        x0_n3, x1_n3, x2_n3, x3_n3; 
    
    input signed [MAC4_W_SIZE -  1:0]	w04, w05, w06, w07, 
                                        w14, w15, w16, w17, 
                                        w24, w25, w26, w27, 
                                        w34, w35, w36, w37;
    // Outputs
    output mac_ready;
    output signed [MAC4_OUT_SIZE - 1:0] out0_n0, out1_n0, out2_n0, out3_n0, //Signed output bits of the MAC
                                        out0_n1, out1_n1, out2_n1, out3_n1,
                                        out0_n2, out1_n2, out2_n2, out3_n2,
                                        out0_n3, out1_n3, out2_n3, out3_n3; 

    //Internal Logic Declarations
    logic out_ready_mac_0, out_ready_mac_1, out_ready_mac_2, out_ready_mac_3; 

    //Instantiations
    mac     #(.MAC_IN_SIZE(MAC4_IN_SIZE), .MAC_OUT_SIZE(MAC4_OUT_SIZE), .W_SIZE(MAC4_W_SIZE))
        M0  (.clk(clk), .in_ready(in_ready), 
            .x0 (x0_n0), .x1(x1_n0), .x2(x2_n0), .x3(x3_n0), 
            .w04(w04),   .w14(w14),  .w24(w24),  .w34(w34), 
            .w05(w05),   .w15(w15),  .w25(w25),  .w35(w35),
            .w06(w06),   .w16(w16),  .w26(w26),  .w36(w36),
            .w07(w07),   .w17(w17),  .w27(w27),  .w37(w37),
            .out0(out0_n0), .out1(out1_n0), .out2(out2_n0), .out3(out3_n0),
            .mac_ready(out_ready_mac_0));
    
    mac     #(.MAC_IN_SIZE(MAC4_IN_SIZE), .MAC_OUT_SIZE(MAC4_OUT_SIZE), .W_SIZE(MAC4_W_SIZE))
        M1  (.clk(clk), .in_ready(in_ready), 
            .x0 (x0_n1), .x1(x1_n1), .x2(x2_n1), .x3(x3_n1), 
            .w04(w04),   .w14(w14),  .w24(w24),  .w34(w34), 
            .w05(w05),   .w15(w15),  .w25(w25),  .w35(w35),
            .w06(w06),   .w16(w16),  .w26(w26),  .w36(w36),
            .w07(w07),   .w17(w17),  .w27(w27),  .w37(w37),
            .out0(out0_n1), .out1(out1_n1), .out2(out2_n1), .out3(out3_n1),
            .mac_ready(out_ready_mac_1));

    mac     #(.MAC_IN_SIZE(MAC4_IN_SIZE), .MAC_OUT_SIZE(MAC4_OUT_SIZE), .W_SIZE(MAC4_W_SIZE))
        M2  (.clk(clk), .in_ready(in_ready), 
            .x0 (x0_n2), .x1(x1_n2), .x2(x2_n2), .x3(x3_n2), 
            .w04(w04),   .w14(w14),  .w24(w24),  .w34(w34), 
            .w05(w05),   .w15(w15),  .w25(w25),  .w35(w35),
            .w06(w06),   .w16(w16),  .w26(w26),  .w36(w36),
            .w07(w07),   .w17(w17),  .w27(w27),  .w37(w37),
            .out0(out0_n2), .out1(out1_n2), .out2(out2_n2), .out3(out3_n2),
            .mac_ready(out_ready_mac_2));

    mac     #(.MAC_IN_SIZE(MAC4_IN_SIZE), .MAC_OUT_SIZE(MAC4_OUT_SIZE), .W_SIZE(MAC4_W_SIZE))
        M3  (.clk(clk), .in_ready(in_ready), 
            .x0 (x0_n3), .x1(x1_n3), .x2(x2_n3), .x3(x3_n3), 
            .w04(w04),   .w14(w14),  .w24(w24),  .w34(w34), 
            .w05(w05),   .w15(w15),  .w25(w25),  .w35(w35),
            .w06(w06),   .w16(w16),  .w26(w26),  .w36(w36),
            .w07(w07),   .w17(w17),  .w27(w27),  .w37(w37),
            .out0(out0_n3), .out1(out1_n3), .out2(out2_n3), .out3(out3_n3),
            .mac_ready(out_ready_mac_3));
    
    //Logic
    assign mac_ready = out_ready_mac_0 & out_ready_mac_1 & out_ready_mac_2 & out_ready_mac_3; 

endmodule