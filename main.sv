module register #(
	parameter DATA_WIDTH = 4
)(
	input CLK,
	input [DATA_WIDTH-1:0] X,
	output reg [DATA_WIDTH-1:0] Q
);

always @(posedge CLK) begin
	Q <= X;
end
endmodule

module main #(
	parameter N = 4,
	parameter DATA_WIDTH = 4,
	parameter COEFF_WIDTH = 4,
	parameter OUTPUT_WIDTH = 10
)(
	input CLK,
	input [DATA_WIDTH-1:0] X,
	input [N*COEFF_WIDTH-1:0] h,
	output reg [OUTPUT_WIDTH-1:0] y
);

wire [DATA_WIDTH-1:0] reg_out [N-1:0];

genvar i;
generate for (i = 0; i < N; i = i + 1) begin : reg_chain
	if (i == 0) begin
		register reg_inst(
			.CLK(CLK),
			.X(X),
			.Q(reg_out[i])
		);
	end else begin
		register reg_inst(
			.CLK(CLK),
			.X(reg_out[i-1]),
			.Q(reg_out[i])
		);
	end
end
endgenerate

integer j;
reg [OUTPUT_WIDTH-1:0] sum;
always @(posedge CLK) begin
	sum = 0;
	for (j = 0; j < N; j = j + 1) begin
		sum = sum + reg_out[j] * h[j*COEFF_WIDTH +: COEFF_WIDTH];
	end
	y <= sum;
end
endmodule


module testbench();
	reg CLK;
	reg [3:0] X;
	reg [15:0] h;  // 4 coefficients * 4 bits each
	wire [9:0] y;

	main #(
		.N(4),
        	.DATA_WIDTH(4),
	        .COEFF_WIDTH(4),
    	    .OUTPUT_WIDTH(10)
	) uut (
	        .CLK(CLK),
	        .X(X),
	        .h(h),
	        .y(y)
	);

	initial begin
        // Initialize inputs
        	CLK = 0;
        	h = {4'b1111, 4'b1111, 4'b1111, 4'b1111};
        	repeat(1000) begin
        		#10 X = 4'b0001 + noise();
        		#20 X = 4'b0001 + noise();
        		#20 X = 4'b1111 + noise();
        		#20 X = 4'b1111 + noise();
        		#20 X = 4'b0001 + noise();
        		#20 X = 4'b0001 + noise();
        	end
    	end

    	function [1:0] noise;
        	begin
          		noise = $random % 2;  // Generates a random value between 0 and 1
        	end
    	endfunction
    	always #5 CLK = ~CLK;
endmodule
