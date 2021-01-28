`timescale 1ns / 1ps


module counterRandom( // Use this module to counter 3-2-1 and create a random time before the test state 
    input clk,
    input [2:0] fState,
    input pushButton1,
    output reg [11:0] counter_321,
    output reg [12:0] randomTime
    );
    
    reg [12:0] counter = 13'd2000;
    
    always @(posedge clk) begin
        if (fState == 3'b000) begin // Initialize the counter_321 while in idle state
            counter_321 <= 12'b1011_1011_1000;
        end
        else if (fState == 3'b001 & counter_321 > 12'b0) begin // Counter 3s to create a 3-2-1 signal
            counter_321 <= counter_321 - 1'b1;
        end 
    end
    always @(posedge clk) begin
        counter <= counter + 1; // Keep plus 1 of the counter 
        if (counter == 13'd5000) begin // Initialize counter to 2,000 if it reach 5,000
            counter <= 13'd2000;
        end
        if (pushButton1 == 1) begin // When goes into preparation state, read and store the value of counter
            randomTime <= counter;
        end
        if (fState == 3'b001 & counter_321 < 12'b11 & randomTime > 13'b0) begin // Counter the time and use it as random time
            randomTime <= randomTime - 1'b1;
        end
    end
     
endmodule
