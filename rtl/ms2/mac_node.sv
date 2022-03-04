module mac_node #(IN_SIZE = 5) (
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
    input signed [IN_SIZE - 1:0]  x0, x1, x2, x3, 
                        w04, w05, w06, w07, 
                        w14, w15, w16, w17, 
                        w24, w25, w26, w27, 
                        w34, w35, w36, w37, 
                        w48, w58, w49, w59, 
                        w68, w69, w78, w79;
    input in_ready;
    input clk;

    output logic signed [16:0] out0, out1;
    output logic out0_ready, out1_ready;

    /////////////////////////////////////////
    // Implementation of the MAC operation//
    ///////////////////////////////////////
    
    //Signed output bits for the middle layer
    //Middle layer has an extra bit
    logic signed [(IN_SIZE * 2) + 1:0] y4, y5, y6, y7; 

    //Signed output of ReLu activation
    logic signed [(IN_SIZE * 2) + 1:0] z4, z5, z6, z7; 
	
    //Pipelined ready signals.
    logic y_ready, z_ready; 

    //Input MAC operation -> y(j) = ∑ x(i) × w(i,j)
    always_ff @(posedge clk) 
	begin
        if(in_ready) begin
            y4 <= x0 * w04 + x1 * w14 + x2 * w24 + x3 * w34;
            y5 <= x0 * w05 + x1 * w15 + x2 * w25 + x3 * w35;
            y6 <= x0 * w06 + x1 * w16 + x2 * w26 + x3 * w36;
            y7 <= x0 * w07 + x1 * w17 + x2 * w27 + x3 * w37;
		end
		y_ready <= in_ready;
	end
	
    //ReLu Function -> ReLu(x) = max (0, x)
	always_ff @(posedge clk) 
	begin         
        //If negative number then assign as 0 else assign y
        z4 <= (y4[(IN_SIZE * 2) + 1]) ? 'b0 : y4;
        z5 <= (y5[(IN_SIZE * 2) + 1]) ? 'b0 : y5;
        z6 <= (y6[(IN_SIZE * 2) + 1]) ? 'b0 : y6;
        z7 <= (y7[(IN_SIZE * 2) + 1]) ? 'b0 : y7;
		z_ready <= y_ready;
    end

    // //Output MAC operation
	// always_ff @(posedge clk) 
	// begin	
    //     out0 <= z4 * w48 + z5 * w58 + z6 * w68 + z7 * w78;
    //     out1 <= z4 * w49 + z5 * w59 + z6 * w69 + z7 * w79;    
    // end

    //Set reset flip flop for output indicators.    
    always_ff@(posedge clk)
    begin
        if(z_ready) begin
            out0_ready <= 1'b1;
            out1_ready <= 1'b1;
        end else begin
            out0_ready <= 1'b0;
            out1_ready <= 1'b0;
        end
    end
endmodule