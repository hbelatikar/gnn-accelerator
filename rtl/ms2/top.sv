module top (    x0_node0, x1_node0, x2_node0, x3_node0,
                x0_node1, x1_node1, x2_node1, x3_node1,
                x0_node2, x1_node2, x2_node2, x3_node2,
                x0_node3, x1_node3, x2_node3, x3_node3,
                w04, w14, w24, w34,
                w05, w15, w25, w35,
                w06, w16, w26, w36,
                w07, w17, w27, w37,
                w48, w58, w68, w78,
                w49, w59, w69, w79,
                out0_node0, out1_node0,
                out0_node1, out1_node1,
                out0_node2, out1_node2,
                out0_node3, out1_node3,
                in_ready,
                out10_ready_node0, out11_ready_node0,
                out10_ready_node1, out11_ready_node1,
                out10_ready_node2, out11_ready_node2,
                out10_ready_node3, out11_ready_node3,
                clk);
    //Inputs
    input signed [4:0] x0_node0, x1_node0, x2_node0, x3_node0;
    input signed [4:0] x0_node1, x1_node1, x2_node1, x3_node1;
    input signed [4:0] x0_node2, x1_node2, x2_node2, x3_node2;
    input signed [4:0] x0_node3, x1_node3, x2_node3, x3_node3;

    input signed [4:0] w04, w14, w24, w34;
    input signed [4:0] w05, w15, w25, w35;
    input signed [4:0] w06, w16, w26, w36;
    input signed [4:0] w07, w17, w27, w37;
    input signed [4:0] w48, w58, w68, w78;
    input signed [4:0] w49, w59, w69, w79;
    
    input clk, in_ready;
    
    //Outputs
    output logic signed [20:0] out0_node0, out1_node0;
    output logic signed [20:0] out0_node1, out1_node1;
    output logic signed [20:0] out0_node2, out1_node2;
    output logic signed [20:0] out0_node3, out1_node3;
    
    output logic out10_ready_node0, out11_ready_node0;
    output logic out10_ready_node1, out11_ready_node1;
    output logic out10_ready_node2, out11_ready_node2;
    output logic out10_ready_node3, out11_ready_node3;
    
    //////////////////////////////
    //Local Params Declarations//
    ////////////////////////////
    localparam WEIGHT_WIDTH = 5;
    localparam AGGR_IN_WIDTH_1 = 5;
    localparam AGGR_OUT_WIDTH_1 = AGGR_IN_WIDTH_1 + 2;     //7 [6:0]   -> Possible min value  (-48)dec
    localparam MAC_IN_WIDTH_1 = AGGR_OUT_WIDTH_1;          
    localparam MAC_OUT_WIDTH_1 = (MAC_IN_WIDTH_1 * 2) - 1; //13 [12:0] -> Possible max output (3072)dec
    localparam RELU_WIDTH_1 = MAC_OUT_WIDTH_1;    
    localparam AGGR_IN_WIDTH_2 = RELU_WIDTH_1;          
    localparam AGGR_OUT_WIDTH_2 = RELU_WIDTH_1 + 2;     //15 [14:0] -> Possible max output (9216)dec
    
    ////////////////////////////////
    //Internal Logic Declarations//
    //////////////////////////////

    //Aggregate of Inputs declaration
    logic signed [AGGR_OUT_WIDTH_1 - 1:0]   x0_n0_aggr, x0_n1_aggr, x0_n2_aggr, x0_n3_aggr,
                                            x1_n0_aggr, x1_n1_aggr, x1_n2_aggr, x1_n3_aggr,
                                            x2_n0_aggr, x2_n1_aggr, x2_n2_aggr, x2_n3_aggr,
                                            x3_n0_aggr, x3_n1_aggr, x3_n2_aggr, x3_n3_aggr;
    logic out_ready_aggr_1;
    
    //Internal logic for MAC Layer 1
    logic signed [MAC_OUT_WIDTH_1 -1 : 0]   y0_n0_mac, y1_n0_mac, y2_n0_mac, y3_n0_mac,
                                            y0_n1_mac, y1_n1_mac, y2_n1_mac, y3_n1_mac,
                                            y0_n2_mac, y1_n2_mac, y2_n2_mac, y3_n2_mac,
                                            y0_n3_mac, y1_n3_mac, y2_n3_mac, y3_n3_mac;
    logic out_ready_mac_1;

    //Internal logic for ReLU Layer 1
    logic signed [RELU_WIDTH_1 -1 : 0]  y0_n0_relu, y1_n0_relu, y2_n0_relu, y3_n0_relu,
                                        y0_n1_relu, y1_n1_relu, y2_n1_relu, y3_n1_relu,
                                        y0_n2_relu, y1_n2_relu, y2_n2_relu, y3_n2_relu,
                                        y0_n3_relu, y1_n3_relu, y2_n3_relu, y3_n3_relu;
    logic out_ready_relu_1;

    //Second layer Aggregate declaration
    logic signed [AGGR_OUT_WIDTH_2 - 1:0]   A0_n0, A0_n1, A0_n2, A0_n3,
                                            A1_n0, A1_n1, A1_n2, A1_n3,
                                            A2_n0, A2_n1, A2_n2, A2_n3,
                                            A3_n0, A3_n1, A3_n2, A3_n3;
    logic out_ready_aggr_2;

    /////////////////////////////
    //Component Instantiations//
    ///////////////////////////

    //Aggregator for node inputs x
    aggr    #(.AGGR_IN_SIZE(AGGR_IN_WIDTH_1), .AGGR_OUT_SIZE(AGGR_OUT_WIDTH_1))
        A0  (.clk(clk), .in_ready_aggr(in_ready),
            .x0_n0(x0_node0), .x1_n0(x1_node0), .x2_n0(x2_node0), .x3_n0(x3_node0),
            .x0_n1(x0_node1), .x1_n1(x1_node1), .x2_n1(x2_node1), .x3_n1(x3_node1),
            .x0_n2(x0_node2), .x1_n2(x1_node2), .x2_n2(x2_node2), .x3_n2(x3_node2),
            .x0_n3(x0_node3), .x1_n3(x1_node3), .x2_n3(x2_node3), .x3_n3(x3_node3),
            .x0_n0_aggr(x0_n0_aggr), .x0_n1_aggr(x0_n1_aggr), .x0_n2_aggr(x0_n2_aggr), .x0_n3_aggr(x0_n3_aggr),
            .x1_n0_aggr(x1_n0_aggr), .x1_n1_aggr(x1_n1_aggr), .x1_n2_aggr(x1_n2_aggr), .x1_n3_aggr(x1_n3_aggr),
            .x2_n0_aggr(x2_n0_aggr), .x2_n1_aggr(x2_n1_aggr), .x2_n2_aggr(x2_n2_aggr), .x2_n3_aggr(x2_n3_aggr),
            .x3_n0_aggr(x3_n0_aggr), .x3_n1_aggr(x3_n1_aggr), .x3_n2_aggr(x3_n2_aggr), .x3_n3_aggr(x3_n3_aggr),
            .out_ready_aggr(out_ready_aggr_1));

    //MAC for aggregated node inputs
    mac_4n  #(.MAC4_IN_SIZE(MAC_IN_WIDTH_1), .MAC4_OUT_SIZE(MAC_OUT_WIDTH_1), .MAC4_W_SIZE(WEIGHT_WIDTH))
        MF0 (.clk(clk), .in_ready(out_ready_aggr_1), 
            .x0_n0 (x0_n0_aggr), .x1_n0(x1_n0_aggr), .x2_n0(x2_n0_aggr), .x3_n0(x3_n0_aggr), 
            .x0_n1 (x0_n1_aggr), .x1_n1(x1_n1_aggr), .x2_n1(x2_n1_aggr), .x3_n1(x3_n1_aggr), 
            .x0_n2 (x0_n2_aggr), .x1_n2(x1_n2_aggr), .x2_n2(x2_n2_aggr), .x3_n2(x3_n2_aggr), 
            .x0_n3 (x0_n3_aggr), .x1_n3(x1_n3_aggr), .x2_n3(x2_n3_aggr), .x3_n3(x3_n3_aggr), 
            .w04(w04), .w14(w14), .w24(w24), .w34(w34), 
            .w05(w05), .w15(w15), .w25(w25), .w35(w35),
            .w06(w06), .w16(w16), .w26(w26), .w36(w36),
            .w07(w07), .w17(w17), .w27(w27), .w37(w37),
            .out0_n0(y0_n0_mac), .out1_n0(y1_n0_mac), .out2_n0(y2_n0_mac), .out3_n0(y3_n0_mac),
            .out0_n1(y0_n1_mac), .out1_n1(y1_n1_mac), .out2_n1(y2_n1_mac), .out3_n1(y3_n1_mac),
            .out0_n2(y0_n2_mac), .out1_n2(y1_n2_mac), .out2_n2(y2_n2_mac), .out3_n2(y3_n2_mac),
            .out0_n3(y0_n3_mac), .out1_n3(y1_n3_mac), .out2_n3(y2_n3_mac), .out3_n3(y3_n3_mac),
            .mac_ready(out_ready_mac_1));

    //RELU for primary MAC data
    relu_4n #(.RELU4_SIZE(RELU_WIDTH_1)) 
        RF0 (.clk(clk), .in_ready(out_ready_mac_1),
            .in0_n0(y0_n0_mac) , .in1_n0(y1_n0_mac) , .in2_n0(y2_n0_mac) , .in3_n0(y3_n0_mac) ,
            .in0_n1(y0_n1_mac) , .in1_n1(y1_n1_mac) , .in2_n1(y2_n1_mac) , .in3_n1(y3_n1_mac) ,
            .in0_n2(y0_n2_mac) , .in1_n2(y1_n2_mac) , .in2_n2(y2_n2_mac) , .in3_n2(y3_n2_mac) ,
            .in0_n3(y0_n3_mac) , .in1_n3(y1_n3_mac) , .in2_n3(y2_n3_mac) , .in3_n3(y3_n3_mac) ,
            .out0_n0(y0_n0_relu), .out1_n0(y1_n0_relu), .out2_n0(y2_n0_relu), .out3_n0(y3_n0_relu),
            .out0_n1(y0_n1_relu), .out1_n1(y1_n1_relu), .out2_n1(y2_n1_relu), .out3_n1(y3_n1_relu),
            .out0_n2(y0_n2_relu), .out1_n2(y1_n2_relu), .out2_n2(y2_n2_relu), .out3_n2(y3_n2_relu),
            .out0_n3(y0_n3_relu), .out1_n3(y1_n3_relu), .out2_n3(y2_n3_relu), .out3_n3(y3_n3_relu),
            .relu_ready(out_ready_relu_1));
    
    //Final Aggregrate function
    aggr    #(.AGGR_IN_SIZE(AGGR_IN_WIDTH_2), .AGGR_OUT_SIZE(AGGR_OUT_WIDTH_2))
        A1  (.clk(clk), .in_ready_aggr(out_ready_relu_1),
            .x0_n0(y0_n0_relu), .x1_n0(y1_n0_relu), .x2_n0(y2_n0_relu), .x3_n0(y3_n0_relu),
            .x0_n1(y0_n1_relu), .x1_n1(y1_n1_relu), .x2_n1(y2_n1_relu), .x3_n1(y3_n1_relu),
            .x0_n2(y0_n2_relu), .x1_n2(y1_n2_relu), .x2_n2(y2_n2_relu), .x3_n2(y3_n2_relu),
            .x0_n3(y0_n3_relu), .x1_n3(y1_n3_relu), .x2_n3(y2_n3_relu), .x3_n3(y3_n3_relu),
            .x0_n0_aggr(A0_n0), .x0_n1_aggr(A0_n1), .x0_n2_aggr(A0_n2), .x0_n3_aggr(A0_n3),
            .x1_n0_aggr(A1_n0), .x1_n1_aggr(A1_n1), .x1_n2_aggr(A1_n2), .x1_n3_aggr(A1_n3),
            .x2_n0_aggr(A2_n0), .x2_n1_aggr(A2_n1), .x2_n2_aggr(A2_n2), .x2_n3_aggr(A2_n3),
            .x3_n0_aggr(A3_n0), .x3_n1_aggr(A3_n1), .x3_n2_aggr(A3_n2), .x3_n3_aggr(A3_n3),
            .out_ready_aggr(out_ready_aggr_2));
    
    ///////////////////
    //Internal Logic//
    /////////////////

    //Output MAC operation
    always_ff @(posedge clk) 
	begin
        if(out_ready_aggr_2) begin
            //Node 0 Output
            out0_node0 <= A0_n0 * w48 + A1_n0 * w58 + A2_n0 * w68 + A3_n0 * w78;
            out1_node0 <= A0_n0 * w49 + A1_n0 * w59 + A2_n0 * w69 + A3_n0 * w79;
            
            //Node 1 Output
            out0_node1 <= A0_n1 * w48 + A1_n1 * w58 + A2_n1 * w68 + A3_n1 * w78;
            out1_node1 <= A0_n1 * w49 + A1_n1 * w59 + A2_n1 * w69 + A3_n1 * w79;

            //Node 2 Output
            out0_node2 <= A0_n2 * w48 + A1_n2 * w58 + A2_n2 * w68 + A3_n2 * w78;
            out1_node2 <= A0_n2 * w49 + A1_n2 * w59 + A2_n2 * w69 + A3_n2 * w79;

            //Node 3 Output
            out0_node3 <= A0_n3 * w48 + A1_n3 * w58 + A2_n3 * w68 + A3_n3 * w78;
            out1_node3 <= A0_n3 * w49 + A1_n3 * w59 + A2_n3 * w69 + A3_n3 * w79;
        end
        out10_ready_node0 <= out_ready_aggr_2;
        out11_ready_node0 <= out_ready_aggr_2;
        out10_ready_node1 <= out_ready_aggr_2;
        out11_ready_node1 <= out_ready_aggr_2;
        out10_ready_node2 <= out_ready_aggr_2;
        out11_ready_node2 <= out_ready_aggr_2;
        out10_ready_node3 <= out_ready_aggr_2;
        out11_ready_node3 <= out_ready_aggr_2;
    end
endmodule