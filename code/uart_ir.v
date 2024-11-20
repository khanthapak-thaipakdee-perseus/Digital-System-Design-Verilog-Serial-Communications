module uart_ir (
	input wire clk,
	input wire rst,
	input wire button,
	input wire [7:0] sw,
	input wire rx_in,
	input wire rx_ir,
	input wire sel_switch,
	output [6:0] seven_seg5, //HEX5 Sender MSB
	output [6:0] seven_seg6, //HEX6 Sender LSB
	output [6:0] seven_seg0, //HEX0 Receiver MSB
	output [6:0] seven_seg1, //HEX1 Receiver LSB
	output tx_out,
	output tx_ir,
	
//	output button_check, // for checking simulation
//	output rst_check,
	
//	output [3:0] data_msb, // for checking simulation
//	output [3:0] data_lsb,
//	
//	output baud_check, // this set of output are for checking simulation
//	output halfbaud_check, 
//	output reset_baud_check, 
//	output ir_check, /
//	output half_ir_check, 
//	output rx_pulse_check, 
//	output load_sender_check, 
//	output done_sender_check, /
//	output done_receiver_check, 
//	output shift_sender_check,
//	output shift_receiver_check,
//	output clear_sender_check,
//	output clear_receiver_check,
//	output button_syn_check,
//	output button_meta_check,
//	output start_sending_check, // for checking simulation
	
	
	output parity_check,
	output framing_check
);
	
	wire button_meta;
	wire button_syn;
	wire baud_clk;
	wire halfbaud_clk;
	wire half_ir;
	wire half_signal;
	wire ir;
	wire rx_pulse;
	wire tx_ir_out;
	
	wire pulse_s; //sender
	wire shift_s;
	wire load_s;
	wire clear_s;
	wire done_s;
	wire [11:0] data_out_parity;
	wire [11:0] data_out_receiver;
	wire shift_r; //receiver
	wire clear_r;
	wire done_r;
	wire reset_baud_r;
	wire parity_reset;
	
	wire [3:0] data_msb;
	wire [3:0] data_lsb;
  
// //this set of assign are for checking simulation
// // uncomment all these for simulation
//	assign button_check = ~button;
//	assign rst_check = ~rst;
//  
//	assign rx_pulse_check = rx_pulse;
//	
//	assign baud_check = baud_clk;
//	assign halfbaud_check = halfbaud_clk;
//	assign reset_baud_check = reset_baud_r;
//	assign ir_check = ir;
//	assign half_ir_check = half_ir;
//	
//	assign button_syn_check = button_syn;
//	assign button_meta_check = button_meta;
//	assign start_sending_check = pulse_s;
//	
//	assign load_sender_check = load_s;
//	assign done_sender_check = done_s;
//	assign done_receiver_check = done_r;
//	assign shift_sender_check = shift_s;
//	assign shift_receiver_check = shift_r;
//	assign clear_sender_check = clear_s;
//	assign clear_receiver_check = clear_r;
  
baud_ir b (
	.clock(clk),
	.reset(rst),
	.reset_baud(reset_baud_r),  
	.tick(baud_clk),
	.halftick(halfbaud_clk),
	.halfir(half_ir),
	.ir(ir)
);

sevseg sender1(
	.dataIn(sw[3:0]),
	.seven_seg0(seven_seg5)
);

sevseg sender2(
	.dataIn(sw[7:4]),
	.seven_seg0(seven_seg6)
);
sevseg receiver1(
	.dataIn(data_msb[3:0]),
	.seven_seg0(seven_seg1)
);

sevseg receiver2(
	.dataIn(data_lsb[3:0]),
	.seven_seg0(seven_seg0)
);

single_pulser pulsedetect(
	.clock(clk),
	.reset(rst),
	.key_n(button_syn),
	.key_p(pulse_s)
);

counter senderbit(
	.clock(clk),
	.reset(rst),
	.inc(shift_s),
	.clear(clear_s),
	.done(done_s)
);

counter receiverbit(
	.clock(clk),
	.reset(rst),
	.inc(shift_r),
	.clear(clear_r),
	.done(done_r)
);

txcontroller txcont(
	.clock(clk),
	.reset(rst),
	.baud(baud_clk),
	.done(done_s),
	.pulse(pulse_s), 
	.shift(shift_s),
	.load(load_s),
	.clear(clear_s)
); 

rxcontroller rxcont(
	.clock(clk),
	.reset(rst),
	.rx(rx_pulse),
	.done(done_r),
	.fullbaud(baud_clk), 
	.halfsignal(half_signal), 
	.shift(shift_r),
	.reset_baud(reset_baud_r),
	.parity_reset(parity_reset),
	.clear(clear_r)
); 

shift_register sendershift(
	.clock(clk),
	.preset(rst),
	.shift(shift_s),
	.load(load_s),
	.d_in(data_out_parity[11:0]),
	.tx(tx_out),
	.rx(rx_in)
);

shift_register receivershift(
	.clock(clk),
	.preset(rst),
	.shift(shift_r),
	.rx(rx_pulse),
	.d_out(data_out_receiver[11:0])
);

oddparity paritygen(
	.data_in(sw[7:0]),
	.data_out(data_out_parity[11:0])
);

parity_check paritycheck(
	.clock(clk),
	.reset(rst),
	.parity_set(clear_r),
	.parity_reset(parity_reset),
	.data_in(data_out_receiver[11:0]),
	.data_out_msb(data_msb[3:0]),
	.data_out_lsb(data_lsb[3:0]),
	.parity_error(parity_check),
	.framing_error(framing_check)
);

dflipflop d1(
	.clock(clk),
	.D(button),
	.Q(button_meta)
);

dflipflop d2(
	.clock(clk),
	.D(button_meta),
	.Q(button_syn)
);

dflipflop d3(
	.clock(clk),
	.D(tx_ir_out),
	.Q(tx_ir)
);

tx_ir ir_encode(
	.tx(tx_out),
	.ir(ir),
	.sel(sel_switch),
	.tx_ir(tx_ir_out)
);

rx_ir ir_decode(
	.rx_uart(rx_in), 
	.rx_ir(rx_ir), 
	.sel(sel_switch),
	.rx(rx_pulse)
);

half_signal hf_selection(
	.half_baud(halfbaud_clk),
	.half_ir(half_ir),
	.sel(sel_switch),
	.half_signal(half_signal)
);

endmodule
