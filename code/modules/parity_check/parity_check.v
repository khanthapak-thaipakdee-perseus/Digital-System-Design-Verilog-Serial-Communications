module parity_check(
	input wire clock,
	input wire reset,
	input wire parity_set,
	input wire parity_reset,
	input [11:0] data_in,
	output reg [3:0] data_out_msb,
	output reg [3:0] data_out_lsb,
	output reg parity_error,
	output reg framing_error
);

	// Define states
	parameter P_IDLE = 1'b0, P_CHECK= 1'b1;
  
	reg	p_state, n_state;
	
	
  
	always @(posedge clock) 
		begin
			if (~reset)
				p_state <= P_IDLE;		
			else
				p_state <= n_state;
		end
	
	always @(p_state, parity_set, parity_reset, data_in) 
		begin
			n_state = p_state;
			parity_error = 1'b0;
			framing_error = 1'b0;
			data_out_msb = 4'b0;
			data_out_lsb = 4'b0;
			case (p_state)
				P_IDLE:
					begin
						if (parity_set) 
							n_state = P_CHECK;
					end
				P_CHECK:
					begin
					data_out_msb = data_in[7:4];
					data_out_lsb = data_in[3:0];
						if (parity_reset) 
							n_state = P_IDLE;
						if (data_in[8] != ~(^data_in[7:0]))
							parity_error = 1'b1;
						if (data_in[9] != 1'b1)
							framing_error = 1'b1;
					end
			endcase
		end

endmodule
