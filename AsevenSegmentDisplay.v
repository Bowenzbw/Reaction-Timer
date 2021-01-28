`timescale 1ns / 1ps

module AsevenSegmentDisplay (
	input [4:0] bcd,
	output reg [7:0] ssd
);

	// The SSD is 'active low', which means the various segments are illuminated 
	// when supplied with logic low '0'.

	always @(*) begin
		case(bcd)
			5'd0 : ssd = 8'b00000011;
			5'd1 : ssd = 8'b10011111;
			5'd2 : ssd = 8'b00100101;
			5'd3 : ssd = 8'b00001101;
			5'd4 : ssd = 8'b10011001;
			5'd5 : ssd = 8'b01001001;
			5'd6 : ssd = 8'b01000001;
			5'd7 : ssd = 8'b00011111;
			5'd8 : ssd = 8'b00000001;
			5'd9 : ssd = 8'b00001001;
			5'd10: ssd = 8'b00000011; 
			5'd11 : ssd = 8'b00000010; // the display of 5d'11 to 5d'20 are specially designed for counter_4, because 
            5'd12 : ssd = 8'b10011110; // we need to display the dot for counter_4.
            5'd13 : ssd = 8'b00100100; 
            5'd14 : ssd = 8'b00001100; 
            5'd15 : ssd = 8'b10011000;
            5'd16 : ssd = 8'b01001000;
            5'd17 : ssd = 8'b01000000;
            5'd18 : ssd = 8'b00011110;
            5'd19 : ssd = 8'b00000000;
            5'd20 : ssd = 8'b00001000;
            5'd21 : ssd = 8'b01110001;//F
            5'd22 : ssd = 8'b00010001;//A
            5'd23 : ssd = 8'b10011111;//I
            5'd24 : ssd = 8'b11100011;//L
            5'd25 : ssd = 8'b00010011;//N
            5'd26 : ssd = 8'b10000011;//U
            5'd27 : ssd = 8'b01100001;//E
            5'd28 : ssd = 8'b10000101;//D
            5'd30 : ssd = 8'b11111111;

			default : ssd = 8'b11111111;
		endcase
	end

	endmodule
