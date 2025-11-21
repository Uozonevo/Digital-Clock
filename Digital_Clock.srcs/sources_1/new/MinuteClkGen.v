`timescale 1ns / 1ps

module MinuteClkGen(clk, load, outsignal);
    input [5:0] clk;
    output load;
    output reg outsignal;

    reg [26:0] counter;

    always @ (posedge clk)
    begin
      if (clk)
        begin
          counter=0;
          outsignal=0;
        end
      else
        begin
          counter = counter +1;
          if (counter == 50000000) //why is this a 0.5 Hz?
            begin
              outsignal=~outsignal;
              counter =0;
            end
        end
    end
endmodule