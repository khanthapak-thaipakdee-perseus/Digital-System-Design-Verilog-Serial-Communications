module single_pulser (clock,reset,key_n,key_p);
    input clock;
    input reset;
    input key_n;
    tri0 reset;
    tri0 key_n;
    output key_p;
    reg key_p;
	 reg [1:0]n_state;
    reg [1:0]p_state;
    parameter WAIT_H=0,WAIT_L=1;

    always @(posedge clock)
		begin
         p_state <= n_state;
		end

    always @(p_state or reset or key_n)
		begin
			if (~reset) 
				begin
					n_state = WAIT_H;
					key_p = 1'b0;
				end
        else 
				begin
					key_p = 1'b0;
					n_state = p_state;
					case (p_state)
						WAIT_H: 
							begin
								if (~(key_n))
									begin
										n_state = WAIT_L;
										key_p = 1'b1;
									end
								else if (key_n)
									n_state = WAIT_H;
							end
						WAIT_L: 
							begin
								if (key_n)
									n_state = WAIT_H;
								else if (~(key_n))
									n_state = WAIT_L;
							end
                default: 
						begin
							key_p = 1'bx;
						end
					endcase
				end
		end
endmodule // single_pulser
