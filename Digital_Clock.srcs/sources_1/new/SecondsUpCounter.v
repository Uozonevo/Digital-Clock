`timescale 1ns / 1ps

module SecondsUpCounter(
    input clk, resetSW, 
    output reg [5:0] count_second
    );
    
    always@(negedge clk or negedge resetSW)
    begin
      if (~resetSW)
         count_second <= 0;
    else if (count_second == 59)
                count_second <= 0;            
            else 
               count_second <= count_second + 1;
    end
endmodule
