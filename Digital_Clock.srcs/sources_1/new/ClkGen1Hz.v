`timescale 1ns / 1ps

module ClkGen1Hz(clk, resetSW, outsignal);
    input clk;
    input resetSW; 
    output outsignal;
    
    reg [26:0] counter;
    reg outsignal;
    
    always @ (posedge clk)
    begin
        if (resetSW)
            begin
                counter=0;
                outsignal=0;
            end
        else
            begin
                counter = counter +1;
                if (counter == 50000000) //why is this a 400 Hz?
                    begin
                        outsignal=~outsignal;
                        counter =0;
                    end
            end
    end
endmodule
