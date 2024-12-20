module baud_ir   (
	input wire clock,
	input wire reset, 
	input wire reset_baud,
	output halftick,
	output halfir,
	output ir,
	output tick 
);

	parameter BAUD_RATE = 19200; //Baud rate = 19200 
	//parameter BAUD_RATE = 200000; //Use 200000 for simulating 5us 
	//pulse rx_ir = 2.5 us
	//parameter BAUD_RATE = 125000; //Use 125000for simulating 8us 
	//parameter BAUD_RATE = 1000000; //Use 1000000 for simulating 1us 
	parameter CLOCK_FREQUENCY = 50000000; // Assuming a 50 MHz clock 20ns

  // Calculate the clock divisor
	localparam CLOCK_DIVISOR = CLOCK_FREQUENCY / BAUD_RATE;

  // Internal counter for baud rate generation
	reg [11:0] p_baud_counter,n_baud_counter;   //log2(2604) = 12

	assign tick = (p_baud_counter == (CLOCK_DIVISOR - 1));
	assign halftick = (p_baud_counter == (CLOCK_DIVISOR/2 - 1));
	assign ir = (p_baud_counter <= (3*(CLOCK_DIVISOR/16) - 1));
	assign halfir = (p_baud_counter == 12'd59);
	
	always @(posedge clock) 
		begin
			if (~reset) 
				p_baud_counter <= 0;
			else 
				p_baud_counter <= n_baud_counter;
		end
		
	always @(reset_baud, p_baud_counter) 
		begin
			n_baud_counter = p_baud_counter;
			if(reset_baud)
				n_baud_counter = 0;
			else if (p_baud_counter == (CLOCK_DIVISOR - 1)) 
				n_baud_counter = 12'd0;
			else
				n_baud_counter = p_baud_counter + 12'd1;   
		end
endmodule
