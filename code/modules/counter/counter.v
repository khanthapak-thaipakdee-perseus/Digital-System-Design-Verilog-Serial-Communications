module counter (
  input clock,
  input reset,
  input inc,
  input clear,
  output reg done
);


	reg [3:0] p_count, n_count;

	always @(posedge clock) 
		begin
			if (~reset)
				p_count <= 4'b0;
			else
				p_count <= n_count;
		end

	always @(p_count, inc, clear) 
		begin
			n_count = p_count;
			done = 1'b0;
			if (clear)
				n_count = 4'b0;
			if (p_count == 4'd12) 
				done = 1'b1;
			else if (inc)
				n_count = p_count + 4'd1;
		end

endmodule


//always @(p_count, inc, clear) 
//		begin
//			n_count = p_count;
//			done = 1'b0;
//			if (p_count == 4'd12) 
//				done = 1'b1;
//			if (clear)
//				n_count = 4'b0;
//			else if (inc)
//					n_count = p_count + 4'd1;
//		end