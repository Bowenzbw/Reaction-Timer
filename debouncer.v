`timescale 1ns / 1ps

module debouncer #(
    parameter integer THRESHOLD = 5
)(
    input clk,
    input buttonIn,
    output buttonOut
);
    wire dividedClk, dividedClk_risingEdge;
    reg prevDividedClk;
    reg [7:0] shiftReg;
    
    ClockDivider #(
        .THRESHOLD(THRESHOLD)
    ) DEBOUNCE_CLOCK (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .dividedClk(dividedClk)
    );
    
    edgeDetector DEBOUNCE_CLOCK_EDGE (
        .clk(clk),
        .signalIn(dividedClk),
        .risingEdge(dividedClk_risingEdge),
        .fallingEdge(),
        .signalOut()
    );
    
    always @(posedge clk) begin
        shiftReg[0] <= buttonIn;

        if (dividedClk_risingEdge) begin
            shiftReg[7:1] <= shiftReg[6:0];
        end
    end
    
    assign buttonOut = &shiftReg[7:1];

endmodule