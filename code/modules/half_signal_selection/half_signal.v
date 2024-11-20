module half_signal(
	input wire half_baud,
	input wire half_ir,
	input sel,
	output half_signal
);

	assign half_signal = (sel == 1'b0) ? half_baud:
								(sel == 1'b1) ? half_ir:
								1'bx;
endmodule
