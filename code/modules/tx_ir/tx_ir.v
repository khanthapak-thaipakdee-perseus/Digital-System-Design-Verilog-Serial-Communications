module tx_ir(
	input wire tx, ir, sel,
	output reg tx_ir
);

		
	always @(tx, ir, sel)
		begin
			if (sel)
				tx_ir = ~tx & ir; 
			else
				tx_ir = 0; 
		end
	
endmodule
