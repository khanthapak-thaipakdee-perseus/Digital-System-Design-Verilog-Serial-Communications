module oddparity(
  input wire [7:0] data_in,
  output reg [11:0] data_out
);

  
    always @(*) begin
      data_out[0] <= 1'b1; // stop_bit
      data_out[1] <= 1'b0; // start_bit
      data_out[9:2] <= data_in;
      data_out[10] <= ~(^data_in); // odd parity_bit
      data_out[11] <= 1'b1; // stop_bit
    
  end

endmodule
