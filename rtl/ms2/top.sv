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

    input [4:0] x0_node0, x1_node0, x2_node0, x3_node0;
    input [4:0] x0_node1, x1_node1, x2_node1, x3_node1;
    input [4:0] x0_node2, x1_node2, x2_node2, x3_node2;
    input [4:0] x0_node3, x1_node3, x2_node3, x3_node3;

    input [4:0] w04, w14, w24, w34;
    input [4:0] w05, w15, w25, w35;
    input [4:0] w06, w16, w26, w36;
    input [4:0] w07, w17, w27, w37;
    input [4:0] w48, w58, w68, w78;
    input [4:0] w49, w59, w69, w79;
    
    input clk;
    
    output [16:0] out0_node0, out1_node0;
    output [16:0] out0_node1, out1_node1;
    output [16:0] out0_node2, out1_node2;
    output [16:0] out0_node3, out1_node3;
    
    output out10_ready_node0, out11_ready_node0;
    output out10_ready_node1, out11_ready_node1;
    output out10_ready_node2, out11_ready_node2;
    output out10_ready_node3, out11_ready_node3;
    
    //Implementation of GNN
    logic [6:0] x0_node0_aggr, x0_node1_aggr, x0_node2_aggr, x0_node3_aggr,
                x1_node0_aggr, x1_node1_aggr, x1_node2_aggr, x1_node3_aggr,
                x2_node0_aggr, x2_node1_aggr, x2_node2_aggr, x2_node3_aggr,
                x3_node0_aggr, x3_node1_aggr, x3_node2_aggr, x3_node3_aggr;

    mac_node MN0 (  .x0 (x0_node0_aggr) , .x1(x1_node0_aggr), .x2(x2_node0_aggr)  , .x3(x3_node0_aggr)  , 
                    .w04(w04), .w14(w14), .w24(w24), .w34(w34), 
                    .w05(w05), .w15(w15), .w25(w25), .w35(w35),
                    .w06(w06), .w16(w16), .w26(w26), .w36(w36),
                    .w07(w07), .w17(w17), .w27(w27), .w37(w37),
                    .w48(w48), .w58(w58), .w68(w68), .w78(w78),
                    .w49(w49), .w59(w59), .w69(w69), .w79(w79),
                    .out0(out0_node0), .out1(out0_node0),
                    .in_ready(in_ready), .out0_ready(out10_ready), .out1_ready(out11_ready),
                    .clk(clk));


endmodule