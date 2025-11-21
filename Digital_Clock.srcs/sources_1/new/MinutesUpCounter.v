`timescale 1ns / 1ps

module MinutesUpCounter(
    input clk, resetSW, load,
    input [5:0] data,
    output reg [5:0] count_minute
    );
    
    always@(posedge clk, negedge resetSW)
    begin
      if(~resetSW)
        count_minute <= 0; 
      else if(load)
        count_minute <= count_minute + 1;
    end
endmodule