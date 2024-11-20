module txcontroller(
  input wire clock,
  input wire reset,
  input wire baud,
  input wire done,
  input wire pulse, //pulse is high because it is the output signal from pulsedetect (not sw2 button that active low)
  output reg shift,
  output reg load,
  output reg clear
);

  // Define states
  parameter TX_IDLE = 1'b0;
  parameter TX_DATA = 1'b1;

  reg	p_state, n_state;

	always @(posedge clock) 
		begin
			if (~reset) 
				begin // If reset, stay in state idle and make all outputs equal 0
					p_state <= TX_IDLE;
				end 
			else 
				begin // If not reset, stay in state idle
					p_state <= n_state;
				end
		end

	always @(p_state, baud, done, pulse) 
		begin
			n_state = p_state;
			shift = 1'b0;
			load = 1'b0;
			clear = 1'b0;
			case (p_state) 
				TX_IDLE: 
					begin 
						if (pulse) 
							begin // If detect pulse, set load equals 1 , move to state data
								load = 1'b1;
								n_state = TX_DATA;
							end
					end
				TX_DATA: 
					begin 
						if (done == 1'b1) 
							begin // If done means counter tell that it is the end of transmition, so set clear equals 1 and move to state idle
								clear = 1'b1;
								n_state = TX_IDLE; 
							end
						else if (baud == 1'b1) 
							shift = 1'b1; // If baud, so set shift equals 1 and stay in state data
					end
			endcase
		end
 endmodule
