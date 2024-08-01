module register(
	input CLK,
	input [3:0] x,
	output reg [3:0] Q
);

always @(posedge CLK) begin
	Q <= x;
end
endmodule

module main(
	input CLK,
	input [3:0] x,
	input [3:0] h [3:0],
	output reg [9:0] y
);

wire [3:0] reg1out;
wire [3:0] reg2out;
wire [3:0] reg3out;
wire [3:0] reg4out;

register reg1(
	.CLK(CLK),
	.x(x),
	.Q(reg1out)
);

register reg2(
	.CLK(CLK),
	.x(reg1out),
	.Q(reg2out)
);

register reg3(
	.CLK(CLK),
	.x(reg2out),
	.Q(reg3out)
);

register reg4(
	.CLK(CLK),
	.x(reg3out),
	.Q(reg4out)
);

always @(posedge CLK) begin
	y <= (reg1out * h[3]) + (reg2out * h[2]) + (reg3out * h[1]) + (reg4out * h[0]);
end
endmodule
