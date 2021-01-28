`timescale 1ns / 1ps

module edgeDetector (
	input wire clk,
	input wire signalIn,
	output wire signalOut,
	output reg risingEdge,
	output reg fallingEdge
);

	reg [1:0] pipeline;

	always @(*) begin
		pipeline[0] = signalIn;
	end

	always @(posedge clk) begin
		pipeline[1] <= pipeline[0];
	end

	always @(*) begin
		if (pipeline == 2'b01) begin
			risingEdge <= 1;
		end 
		else if (pipeline == 2'b10) begin
			fallingEdge <= 1;
		end 
		else begin
			risingEdge <= 0;
			fallingEdge <= 0;
		end
	end

	assign signalOut = pipeline[1];

endmodule
