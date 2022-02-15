module tb_top();

reg [15:0] x0, x1, x2, x3;
reg [15:0] w04, w14, w24, w34;
reg [15:0] w05, w15, w25, w35;
reg [15:0] w06, w16, w26, w36;
reg [15:0] w07, w17, w27, w37;
reg [15:0] w48, w58, w68, w78;
reg [15:0] w49, w59, w69, w79;

reg clk;

wire [15:0] out0, out1;
wire out10_ready, out11_ready;

reg in_ready;
// Top module
// Instantiation of top module
// Please replace the instantiation with the top module of your gate level model 


nn_node DUT0(   .x0(x0), .x1(x1), .x2(x2), .x3(x3), 
                .w04(w04), .w14(w14), .w24(w24), .w34(w34), 
                .w05(w05), .w15(w15), .w25(w25), .w35(w35),
                .w06(w06), .w16(w16), .w26(w26), .w36(w36),
                .w07(w07), .w17(w17), .w27(w27), .w37(w37),
                .w48(w48), .w58(w58), .w68(w68), .w78(w78),
                .w49(w49), .w59(w59), .w69(w69), .w79(w79),
                .out0(out0), .out1(out1),
                .in_ready(in_ready), .
                (out10_ready), .out11_ready(out11_ready),
                .clk(clk));

initial begin

    clk = 0;
    in_ready = 1; 
    
    x0 = 15'b0100;
    x1 = 15'b0010;
    x2 = 15'b0100;
    x3 = 15'b0001;
    w04 = 15'b0011;
    w14 = 15'b0010;
    w24 = 15'b1101;
    w34 = 15'b0;
    w05 = 15'b0;
    w15 = 15'b0;
    w25 = 15'b0;
    w35 = 15'b1110;
    w06 = 15'b0011;
    w16 = 15'b0110;
    w26 = 15'b0000;
    w36 = 15'b1111;
    w07 = 15'b1001;
    w17 = 15'b0;
    w27 = 15'b1111;
    w37 = 15'b0;
    w48 = 15'b0;
    w58 = 15'b0;
    w68 = 15'b0011;
    w78 = 15'b1011;
    w49 = 15'b1100;
    w59 = 15'b0;
    w69 = 15'b0;
    w79 = 15'b0110;

end


always
    #1 clk = !clk;


initial
    #100 $finish;


endmodule
