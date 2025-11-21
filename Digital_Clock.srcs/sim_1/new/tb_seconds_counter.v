`timescale 1ns / 1ps

module tb_seconds_counter;
    reg clk, resetSW, load, upcount;
    reg [5:0] data;
    wire [5:0] count_second;
    
    SecondsUpCounter uut(.clk(clk), 
                         .resetSW(resetSW), 
                         .load(load), 
                         .upcount(upcount), 
                         .data(data), 
                         .count_second(count_second));
                         
    always #5 clk = ~clk;
    
    initial begin
    resetSW = 0;
    clk = 0;
    //load = 0;
    //data = 'd39;
    //upcount = 0;
    
    #5 load = 1; upcount = 0;
    #15 resetSW = 1; load = 0; upcount = 1;
    #15 resetSW = 0; load = 1; upcount = 0;
    #15 resetSW = 1; load = 0; upcount = 1;
    end

endmodule
