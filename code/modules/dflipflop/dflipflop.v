module dflipflop(
	input wire clock,
	input wire D,
	output reg Q
);

initial
		Q <= 1'b1;	
		
	always @(posedge clock)
		begin
			Q <= D;
		end
endmodule
