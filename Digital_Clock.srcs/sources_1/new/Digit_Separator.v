`timescale 1ns / 1ps

module Digit_Separator(
    input [5:0] min, sec,
    output reg [3:0] Ones, Tens, Hundreds, Thousands
    );
    
    always@(sec)
    begin
        Ones <= sec % 10;
        Tens <= sec /10;
    end
    always@(min)
    begin
        Hundreds <= min % 10;
        Thousands <= min / 10;
    end
endmodule
