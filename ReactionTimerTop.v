`timescale 1ns / 1ps

module ReactionTimerTop(
    input clk,
    input reset,
    input pushButton1,
    input pushButton2,
    input pushButton3,
    output wire [7:0] ssdCathode,
    output reg [7:0] ssdAnode,
    output wire [15:0]led
    );
    
    wire [11:0] counter_321;
    wire [12:0] randomTime; 
    wire [2:0] fState;
    reg [1:0]activeDisplay;
    wire [4:0]counter_1;
    wire [4:0]counter_2;
    wire [4:0]counter_3;
    wire [4:0]counter_4;
    wire [4:0]counter_5;
    wire [4:0]counter_6;
    wire [4:0]counter_7;
    wire [4:0]counter_8;
    reg [4:0] ssdNumber;
    wire dClk;
    wire dereset;
    wire depushButton1;
    wire depushButton2;
    wire depushButton3;
    parameter idle = 3'b000;
    parameter preparation = 3'b001;
    parameter result = 3'b010;
    parameter test = 3'b011;
    parameter fail = 3'b100;
    parameter best = 3'b101;
    parameter null = 3'b110;
    
    ClockDivider(
    .clk(clk),
    .enable(1'b1),
    .reset(1'b0),
    .dividedClk(dClk)
    );
    
    counterRandom(
    .clk(dClk),
    .fState(fState),
    .pushButton1(depushButton1),
    .counter_321(counter_321),
    .randomTime(randomTime)   
    );
    
    FSM(
    .clk(dClk),
    .reset(dereset),
    .counter_1(counter_1),
    .counter_2(counter_2),
    .counter_3(counter_3),
    .counter_4(counter_4),
    .counter_5(counter_5),
    .counter_6(counter_6),
    .counter_7(counter_7),
    .counter_8(counter_8),
    .pushButton1(depushButton1),
    .pushButton2(depushButton2),
    .pushButton3(depushButton3),
    .randomTime(randomTime),
    .fState(fState),
    .led(led)
    );   

    AsevenSegmentDisplay(
    .bcd(ssdNumber),
    .ssd(ssdCathode)
    );   
    
    debouncer(
    .clk(dClk),
    .buttonIn(reset),
    .buttonOut(dereset)
    );
    
    debouncer2(
    .clk(dClk),
    .buttonIn(pushButton1),
    .buttonOut(depushButton1)
    );
    
    debouncer3(
    .clk(dClk),
    .buttonIn(pushButton2),
    .buttonOut(depushButton2)    
    );

    debouncer4(
    .clk(dClk),
    .buttonIn(pushButton3),
    .buttonOut(depushButton3)    
    );
     always@(posedge dClk)begin
         activeDisplay <= activeDisplay + 1; 
     end   
     
     always@(*)begin // The logic of what to show in seven segment display part
         case(activeDisplay)
             2'd0 : begin // What the first seven segment displayer need to show in each state
                if (fState == idle) begin // Show "E" in idle state
                    ssdAnode = 8'b1111_1110;
                    ssdNumber = 5'd27;
                end
                else if (fState == preparation) begin // Show 3-2-1 in preparation state
                    ssdAnode = 8'b1111_1110;
                    if (counter_321 < 12'b1011_1011_1001 & counter_321 > 12'b111_1101_0000) begin
                        ssdNumber = 3;
                    end else if (counter_321 < 12'b111_1101_0001 & counter_321 > 12'b011_1110_1000) begin
                        ssdNumber = 2;
                    end else if (counter_321 < 12'b011_1110_1001 & counter_321 > 12'b0) begin
                        ssdNumber = 1;
                    end else if (counter_321 == 12'b0) begin
                        ssdNumber = 5'd30;
                    end
                end else if (fState == fail) begin // Show "L" in fail state
                    ssdNumber = 5'd24;
                    ssdAnode = 8'b1111_1110;
                end else if (fState == test) begin // Show nothing in test state
                    ssdNumber = 5'd30;
                    ssdAnode = 8'b1111_1110;
                end else if (fState == result) begin // Show the number of counter_4 in result state
                    ssdNumber = counter_1;
                    ssdAnode = 8'b1111_1110;
                end else if (fState == best | fState == null) begin // Show the data in counter_5 while in best and null state
                    ssdNumber = counter_5;
                    ssdAnode = 8'b1111_1110;
                end
             end
             2'd1 : begin // What the second seven segment displayer need to show in each state
                if (fState == idle) begin // Show "L" in idel state
                    ssdAnode = 8'b1111_1101;
                    ssdNumber = 5'd24;
                end             
                else if (fState == preparation) begin // Show nothing in preparation state
                    ssdNumber = 5'd30;
                    ssdAnode = 8'b1111_1101;
                end else if (fState == fail) begin // Show "I" in fail state
                    ssdNumber = 5'd23;
                    ssdAnode = 8'b1111_1101;
                end else if (fState == test) begin // Show nothing in test state
                    ssdNumber = 5'd30;
                    ssdAnode = 8'b1111_1101;
                end else if (fState == result) begin // Show the number of counter_3 in result state
                    ssdNumber = counter_2;
                    ssdAnode = 8'b1111_1101;
                end else if (fState == best | fState == null) begin // Show the data in counter_6 while in best and null state
                    ssdNumber = counter_6;
                    ssdAnode = 8'b1111_1101;
                end
             end
             2'd2 : begin // What the third seven segment displayer need to show in each state
                if (fState == idle) begin // Show "D" in idel state
                    ssdAnode = 8'b1111_1011;
                    ssdNumber = 5'd28;
                end
                else if (fState == preparation) begin // Show nothing in preparation state
                    ssdNumber = 5'd30;
                    ssdAnode = 8'b1111_1011;
                end else if (fState == fail) begin // Show "A" in fail state
                    ssdNumber = 5'd22;
                    ssdAnode = 8'b1111_1011;
                end else if (fState == test) begin // Show nothing in test state
                    ssdNumber = 5'd30;
                    ssdAnode = 8'b1111_1011;                    
                end else if (fState == result) begin // Show the number of counter_2 in result state
                    ssdNumber = counter_3;
                    ssdAnode = 8'b1111_1011;
                end else if (fState == best | fState == null) begin // Show the data in counter_7 while in best and null state
                    ssdNumber = counter_7;
                    ssdAnode = 8'b1111_1011;
                end
             end
             2'd3 : begin // What the fourth seven segment displayer need to show in each state
                if (fState == idle) begin // Show "I" in idel state
                    ssdAnode = 8'b1111_0111;
                    ssdNumber = 5'd23;
                end             
                else if (fState == preparation) begin // Show nothing in preparation state
                    ssdNumber = 5'd30;
                    ssdAnode = 8'b1111_0111;
                end else if (fState == fail) begin // Show "F" in fail state
                    ssdNumber = 5'd21;
                    ssdAnode = 8'b1111_0111;
                end else if (fState == test) begin // Show nothing in test state
                    ssdNumber = 5'd30;
                    ssdAnode = 8'b1111_0111;                    
                end else if (fState == result) begin // Show the number of counter_1 in result state
                    ssdNumber = counter_4;
                    ssdAnode = 8'b1111_0111;
                end else if (fState == best | fState == null) begin // Show the data in counter_8 while in best and null state
                    ssdNumber = counter_8;
                    ssdAnode = 8'b1111_0111;
                end
             end
         endcase  
    end

    

    endmodule
