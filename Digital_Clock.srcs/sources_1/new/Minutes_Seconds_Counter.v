`timescale 1ns / 1ps

module Minutes_Seconds_Counter(
    input clk, resetSW, 
    output reg [5:0] min, sec
    );
    
    always@(posedge clk, posedge resetSW)
    begin
      if(resetSW)
        begin
          sec <= 0;
          min <= 0;
        end
       else if(sec == 59)
       begin
        sec <= 0;
        min <= min + 1;
       end
       else if(min == 59)
       begin
        min <= 0;
       end
       else
        sec <= sec + 1;
    end
endmodule
