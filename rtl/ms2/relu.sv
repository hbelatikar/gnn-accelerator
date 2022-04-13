module relu #(parameter RELU_SIZE = 5) 
    (   clk, in_ready,
        in0, in1, in2, in3,
        out0, out1, out2, out3,
        relu_ready
    );
    input clk, in_ready;
    input  signed [RELU_SIZE - 1 : 0] in0, in1, in2, in3;
    
    output logic relu_ready;
    output logic signed [RELU_SIZE - 1 : 0] out0, out1, out2, out3;

    //ReLu Function -> ReLu(x) = max (0, x)
	always_ff @(posedge clk) begin         
        if(in_ready) begin
            //If negative number then assign as 0 else assign y
            out0 <= (in0 [RELU_SIZE - 1]) ? 'b0 : in0;
            out1 <= (in1 [RELU_SIZE - 1]) ? 'b0 : in1;
            out2 <= (in2 [RELU_SIZE - 1]) ? 'b0 : in2;
            out3 <= (in3 [RELU_SIZE - 1]) ? 'b0 : in3;
        end
        relu_ready <= in_ready;
    end
endmodule