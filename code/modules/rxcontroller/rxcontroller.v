module rxcontroller(
	input wire clock,
	input wire reset,
	input wire rx,
	input wire done,
	input wire fullbaud, 
	input wire halfsignal, 
	output reg shift,
	output reg reset_baud,
	output reg parity_reset,
	output reg clear
);

  // Define states
  parameter RX_IDLE = 2'b00, RX_WAIT = 2'b10, RX_DATA  = 2'b11;
  reg	[1:0] p_state, n_state;

	always @(posedge clock) 
		begin
			if (~reset) // If reset, stay in state idle 
				p_state <= RX_IDLE;
			else // If not reset, update the state
				p_state <= n_state;
		end

	always @(p_state, fullbaud, halfsignal, rx, done) 
		begin
			n_state = p_state;
			shift = 1'b0;
			reset_baud = 1'b0;
			clear = 1'b0;
			parity_reset = 1'b0;
			case (p_state) 
				RX_IDLE: 
					begin 
						if (rx == 1'b0) 
							begin // If detect start bit rx=0
								reset_baud = 1'b1;
								parity_reset = 1'b1;
								n_state = RX_WAIT;
							end
					end
				RX_WAIT: 
					begin 
						if (halfsignal) 
							begin // If detect start bit rx=0
								reset_baud = 1'b1;
								n_state = RX_DATA;
							end
					end
				RX_DATA: 
					begin
						if (done == 1'b1) 
							begin // If done means counter tell that it is the end of recieving, so set clear equals 1 and move to state idle
								clear = 1'b1;
								n_state = RX_IDLE; 
							end
						else if (fullbaud == 1'b1) 
							begin // If baud, so set shift equals 1 and stay in state data
								shift = 1'b1;
								n_state = RX_DATA; 
							end
						
					end
			endcase
		end
 endmodule
 