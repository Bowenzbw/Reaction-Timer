`timescale 1ns / 1ps


module FSM(
    input clk,
    input reset,
    input pushButton1,
    input pushButton2, 
    input pushButton3,
    input [12:0]randomTime,
    output reg[4:0]counter_1,
    output reg[4:0]counter_2,
    output reg[4:0]counter_3,
    output reg[4:0]counter_4,
    output reg[4:0]counter_5 = 5'd9,
    output reg[4:0]counter_6 = 5'd9,
    output reg[4:0]counter_7 = 5'd9,
    output reg[4:0]counter_8 = 5'd19,
    output wire [15:0] led,
    output wire [2:0] fState
    );
    parameter idle = 3'b000;
    parameter preparation = 3'b001;
    parameter test = 3'b011;
    parameter result = 3'b010;
    parameter fail = 3'b100;
    parameter best = 3'b101;
    parameter null = 3'b110;
    
    reg [15:0] lighter;
    reg [13:0] counter_10;
    reg [11:0] counter_3s;
    reg [9:0] counter_light = 10'd1000;
    
    assign led = lighter;

    reg [2:0] state = idle, nextState;
    
    always @ (posedge clk) begin // Go into idle state if reset button been clicked
        if (reset) begin 
            state <= idle;
        end else begin
            state <= nextState;
        end            
    end
    
	always @(*) begin // The state change logic
        case(state)
            idle : begin // Which state to go with different input during idle state
                if (pushButton1 == 1) begin
                    nextState = preparation;                    
                end 
                else if (pushButton3 == 1) begin
                    nextState = best;
                end
                else begin
                    nextState = idle;
                end
            end
            preparation : begin // Which state to go with different input during preparation state
                if (randomTime == 13'd0) begin // Go to test state after random time
                    nextState = test;
                end else if (pushButton2 == 1) begin // Go to fail state if pushButton2 been clicked before test state
                    nextState = fail;
                end else begin
                    nextState = preparation;
                end
            end
            test : begin // Which state to go with different input during test state
                if (pushButton2 == 1) begin
                    nextState = result;
                end else if (counter_4 > 5'd20) begin // Go to fail state if over 10 seconds without any input
                    nextState = fail;
                end else begin
                    nextState = test;               
                end
            end
            fail : begin // Which state to go with different input during fail state
                if (reset) begin
                    nextState = idle;
                end else if (counter_3s == 12'b0) begin // Back to idle state after 3 seconds
                    nextState = idle;
                end else begin
                    nextState = fail;
                end
            end
            result : begin // Which state to go with different input during result state
                if (reset) begin
                    nextState = idle;
                end else if (pushButton3 == 1) begin // Go to best state when pushButton3 been clicked
                    nextState = best;
                end else if(counter_10 == 0)begin // Back to the idle state after 10s 
                    nextState = idle;
                end else begin
                    nextState = result;
                end
            end
            best : begin // Which state to go with different input during best state
                if (reset) begin
                    nextState = idle;
                end if (counter_5 == 5'd9 & counter_6 == 5'd9 & counter_7 == 5'd9 & counter_8 == 5'd19) begin
                    nextState = null; // If there is no best reaction time data store in counter, go to null state
                end else if (counter_3s == 12'b0) begin
                    nextState = idle; // Back to idle state after 3 seconds
                end
                else begin
                    nextState = best;
                end
            end
            null : begin  // Which state to go with different input during null state
                if (reset) begin
                    nextState = idle;
                end else if (counter_3s == 12'b0) begin
                    nextState = idle; // Back to idle state after 3 seconds
                end else begin
                    nextState = null;
                end
            end
//            default : nextState = idle;   
        endcase
    end
    

    always @(posedge clk) begin
        counter_light <= counter_light - 1'b1; // Create a 1 Hz circle for flash lights
        if (counter_light == 10'b0) begin // Initialize the counter after 1 second
            counter_light <= 10'd1000;
        end
        if (state == idle) begin // Show the flash leds in idle state
            counter_3s <= 12'd3000;
            if (counter_light <= 10'd1000 & counter_light > 10'd875) begin
                lighter <= 16'b0000_0001_1000_0000;
            end else if (counter_light <= 10'd875 & counter_light > 10'd750) begin
                lighter <= 16'b0000_0011_1100_0000;
            end else if (counter_light <= 10'd750 & counter_light > 10'd625) begin
                lighter <= 16'b0000_0111_1110_0000;
            end else if (counter_light <= 10'd625 & counter_light > 10'd500) begin
                lighter <= 16'b0000_1111_1111_0000;
            end else if (counter_light <= 10'd500 & counter_light > 10'd375) begin
                lighter <= 16'b0001_1111_1111_1000;
            end else if (counter_light <= 10'd375 & counter_light > 10'd250) begin
                lighter <= 16'b0011_1111_1111_1100;
            end else if (counter_light <= 10'd250 & counter_light > 10'd125) begin
                lighter <= 16'b0111_1111_1111_1110;
            end else if (counter_light <= 10'd125 & counter_light > 10'd0) begin
                lighter <= 16'b1111_1111_1111_1111;
            end
            counter_1 <= 5'd0;
            counter_2 <= 5'd0;
            counter_3 <= 5'd0;
            counter_4 <= 5'd0;
        end 
        else if (state == preparation) begin // Initialize counters in preparation state
                counter_light <= 10'd1000;
                counter_3s <= 12'd3000;
                lighter <= 16'b0;
                counter_1 <= 5'd0;
                counter_2 <= 5'd0;
                counter_3 <= 5'd0;
                counter_4 <= 5'd11;
        end
        else if (state == test) begin // Counter reaction time in test state
            lighter <= 16'b1111_1111_1111_1111;
            counter_10 <= 14'd10000;
            counter_light <= 10'd1000;
            counter_1 <= counter_1 + 1'b1;
            if (counter_1 >= 5'd10) begin
                counter_1 <= 5'd0;
                counter_2 <= counter_2 + 1'b1;
                if (counter_2 >= 5'd9) begin
                    counter_2 <= 5'd0;
                    counter_3 <= counter_3 + 1'b1;
                    if (counter_3 >= 5'd9) begin
                        counter_3 <= 5'd0;
                        counter_4 <= counter_4 + 1'b1;
                        
                    end
                end 
            end
        end
        else if (state == fail) begin // Counter 3 seconds to automaticly exit fail state
            lighter <= 16'b0;
            counter_light <= 10'd1000;
            if (counter_3s > 12'b0) begin
                counter_3s <= counter_3s - 1'b1;
            end
        end
        else if (state == result) begin// Counter 10 seconds to automaticly exit fail state
            lighter <= 16'b0;
            counter_light <= 10'd1000;
            counter_3s <= 12'd3000;
            if (counter_10 > 14'd0) begin
                counter_10 <= counter_10 - 1'b1;
            end
            if (counter_4 < counter_8) begin // Compare current reaction time with previous best time
                counter_8 <= counter_4;      // Store the best time in counter5,6,7,8
                counter_7 <= counter_3;
                counter_6 <= counter_2;
                counter_5 <= counter_1;
            end else if (counter_4 == counter_8) begin
                counter_8 <= counter_4;
                if (counter_3 < counter_7) begin
                    counter_7 <= counter_3;
                    counter_6 <= counter_2;
                    counter_5 <= counter_1;
                end else if (counter_3 == counter_7) begin
                    counter_7 <= counter_3;
                    if (counter_2 < counter_6) begin
                        counter_6 <= counter_2;
                        counter_5 <= counter_1;
                    end else if (counter_2 == counter_6) begin
                        counter_6 <= counter_2;
                        if (counter_1 <= counter_5) begin
                            counter_5 <= counter_1;
                        end
                    end
                end
            end
        end
        else if (state == best) begin // Counter 3 seconds to automaticly exit fail state
            counter_light <= 10'd1000;
            if (counter_3s > 12'b0) begin
                counter_3s <= counter_3s - 1'b1;
            end
            lighter <= 16'b0;

        end
        else if (state == null) begin // Counter 3 seconds to automaticly exit fail state
            counter_light <= 10'd1000;
            if (counter_3s > 12'b0) begin
                counter_3s <= counter_3s - 1'b1;
            end
            lighter <= 16'b0; // Show "null" in seven segment displayer when there is no data in counter
            counter_5 = 5'd24;
            counter_6 = 5'd24;
            counter_7 = 5'd26;
            counter_8 = 5'd25;
        end
    end                           
    
    
    assign fState = state;
endmodule

