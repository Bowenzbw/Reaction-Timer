`timescale 1ns / 1ps

module ClockDivider#(parameter integer THRESHOLD = 50_000) // Create a 1,000 Hz clock signal
    (input wire clk, enable, reset,
     output reg dividedClk
    );
    reg [31:0] counter;
    
    always@(posedge clk)begin
        if (reset == 1 || counter >= THRESHOLD-1) begin
            counter <= 32'd0;
        end else if (enable == 1 ) begin
            counter <= counter + 1;
        end else begin
            counter <= counter;
        end
            
    end
    
    always@(posedge clk)begin
        if (reset == 1) begin
            dividedClk <= 0;
        end else if (enable == 1 & counter >= THRESHOLD-1) begin
            dividedClk <= ~dividedClk;
        end
    end
    
endmodule
