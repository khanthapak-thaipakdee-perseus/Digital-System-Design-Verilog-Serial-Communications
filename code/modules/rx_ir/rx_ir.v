module rx_ir(
	input rx_uart, rx_ir, sel,
	output wire rx
);


	assign rx = 	(rx_uart & ~sel)|
						(rx_ir & sel);
	
endmodule
