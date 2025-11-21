`timescale 1ns / 1ps

module Alarm_Clock(   // Top Module
    input CLK, 
    input BTNC, 
    input AlarmSwitch,
            
    output CA, CB, CC, CD, CE, CF, CG,
    output [7:0] AN,
    output audioOut,
    output aud_sd, 
    output AlarmLED
    );
    
    assign aud_sd = 1'b1;
        
    //DIGITAL CLOCK - wires
    wire c1, c2;
    wire [2:0] counter_to_decoder;
    wire [2:0] counter_to_mux;
    wire [5:0] min_counter_to_digit_separator;
    wire [5:0] sec_counter_to_digit_separator;
    wire [4:0] Ones, Tens, Hundreds, Thousands;
    wire [6:0] digit1, digit2, digit3, digit4;
    wire [6:0] sseg;
    // ALARM CLOCK - wires
    wire [6:0] digit5, digit6, digit7, digit8;
    
    // wire junctions
    assign counter_to_decoder = counter_to_mux;
    
    // clock generators
    ClkGen400Hz clock1(.clk(CLK), 
                       .resetSW(BTNC), 
                       .outsignal(c1));
    ClkGen1Hz clock2(.clk(CLK), 
                     .resetSW(BTNC), 
                     .outsignal(c2));
    
    // clock 400Hz to 3-bit counter
    Counter3bit counter(.Resetn(BTNC), 
                         .Clock(c1), 
                         .E(1'b1), 
                         .Q(counter_to_decoder));
    
    // 3-bit counter to decoder
    Decoder3to8 decoder(.W(counter_to_decoder), 
                         .En(1'b1), 
                         .Y(AN[7:0]));
    
    // minutes and seconds counter
    Minutes_Seconds_Counter MinSecCount(.clk(c2), 
                                        .resetSW(BTNC), 
                                        .min(min_counter_to_digit_separator), 
                                        .sec(sec_counter_to_digit_separator));
    
    // separate the ones, tens, hundreds, and thousands digits                                    
    Digit_Separator Separator(.min(min_counter_to_digit_separator),
                              .sec(sec_counter_to_digit_separator),
                              .Ones(Ones),
                              .Tens(Tens),
                              .Hundreds(Hundreds),
                              .Thousands(Thousands));
     
     // instantiate the bcd decoder 8 times
     // digital clock: 00:00 - 59:59
     BCD_to_sseg_Decoder BCD_Decoder0(.BCD(Ones), .sseg(digit1));
     BCD_to_sseg_Decoder BCD_Decoder1(.BCD(Tens), .sseg(digit2));
     BCD_to_sseg_Decoder BCD_Decoder2(.BCD(Hundreds), .sseg(digit3));
     BCD_to_sseg_Decoder BCD_Decoder3(.BCD(Thousands), .sseg(digit4));
     // alarm clock: 00:53
     BCD_to_sseg_Decoder BCD_Decoder4(.BCD(4'b0011), .sseg(digit5));
     BCD_to_sseg_Decoder BCD_Decoder5(.BCD(4'b0101), .sseg(digit6));
     BCD_to_sseg_Decoder BCD_Decoder6(.BCD(4'b0000), .sseg(digit7));
     BCD_to_sseg_Decoder BCD_Decoder7(.BCD(4'b0000), .sseg(digit8));
     
     // digit separator and 3x8 decoder to mux1                         
     mux8to1 MUX1(.in0(digit1), 
                  .in1(digit2), 
                  .in2(digit3), 
                  .in3(digit4),
                  .in4(digit5), 
                  .in5(digit6), 
                  .in6(digit7), 
                  .in7(digit8), 
                  .sel(counter_to_mux) , 
                  .out(sseg));
    
    // wire connections from 8x1 mux to sseg diplay
    assign CA = sseg[0];
    assign CB = sseg[1];
    assign CC = sseg[2];
    assign CD = sseg[3];
    assign CE = sseg[4];
    assign CF = sseg[5];
    assign CG = sseg[6];
    
    
    reg playSound;
    reg [29:0] songPeriod = 0;
    
    // Playsound for the ALARM
    SongPlayer ALARM(.clock(CLK), 
                     .BTNC(BTNC), 
                     .playSound(playSound), 
                     .audioOut(audioOut), 
                     .aud_sd(aud_sd)); 
    // Alarm LED
    LED_Control LED_Driver(.AlarmSwitch(AlarmSwitch),
                           .LED(AlarmLED));                                 
                     
    always@(posedge CLK)
    begin
    playSound <= 0;
        if(AlarmSwitch)
        begin
            if(digit1 == digit5 && digit2 == digit6 && digit3 == digit7 && digit4 == digit8) 
            begin
                playSound <= 1;
                if(songPeriod < 1000000000) 
                begin
                    songPeriod <= songPeriod + 1;
                end else begin
                    songPeriod <= 0;
                    playSound <= 0;
                end
            end else begin
                songPeriod <= 0;
            end
        end
    end      
endmodule
