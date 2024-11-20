module sevseg(
    input wire [3:0] dataIn,       // 4-bits hexadecimal input
    output reg [6:0] seven_seg0   // 7-segment display segments 
);

always @(*) 
	begin
		case (dataIn[3:0])  // Display 4 bits data
		  4'b0000: seven_seg0 = 7'b1000000; // Hex '0' 
		  4'b0001: seven_seg0 = 7'b1111001; // Hex '1' 
		  4'b0010: seven_seg0 = 7'b0100100; // Hex '2' 
		  4'b0011: seven_seg0 = 7'b0110000; // Hex '3' 
		  4'b0100: seven_seg0 = 7'b0011001; // Hex '4' 
		  4'b0101: seven_seg0 = 7'b0010010; // Hex '5' 
		  4'b0110: seven_seg0 = 7'b0000010; // Hex '6' 
		  4'b0111: seven_seg0 = 7'b1111000; // Hex '7' 
		  4'b1000: seven_seg0 = 7'b0000000; // Hex '8' 
		  4'b1001: seven_seg0 = 7'b0011000; // Hex '9'
		  4'b1010: seven_seg0 = 7'b0001000; // Hex 'A' 
		  4'b1011: seven_seg0 = 7'b0000011; // Hex 'B' 
		  4'b1100: seven_seg0 = 7'b1000110; // Hex 'C' 
		  4'b1101: seven_seg0 = 7'b0100001; // Hex 'D'
		  4'b1110: seven_seg0 = 7'b0000110; // Hex 'E' 
		  4'b1111: seven_seg0 = 7'b0001110; // Hex 'F' 
		  default: seven_seg0 = 7'bxxxxxxx; // Don't care
		endcase
	end
endmodule
