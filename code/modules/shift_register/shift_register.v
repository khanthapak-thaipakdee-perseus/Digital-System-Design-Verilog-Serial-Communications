module shift_register (
  input wire clock,
  input wire preset,
  input wire shift,
  input wire load,
  input wire [11:0] d_in,
  input wire rx,
  output tx,
  output [11:0] d_out
);

	reg [11:0] p_reg_data, n_reg_data;

	assign tx = p_reg_data[0];
	assign d_out = p_reg_data;
 
	initial
		p_reg_data <= 12'hFFF;	
 
 	always @(posedge clock) 
		begin
			if (~preset)
				p_reg_data <= 12'hFFF;
			else
				p_reg_data <= n_reg_data;
		end	
 
	always @(p_reg_data, load, shift, d_in, rx) 
		begin
			n_reg_data = p_reg_data;
			if (load) 
				n_reg_data = d_in; 
			else if (shift)
				begin
					n_reg_data = {1'b1,n_reg_data[11:1]};
					n_reg_data[11] = rx;
				end
		end

endmodule
