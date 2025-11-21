`timescale 1ns / 1ps

module BCD_to_sseg_Decoder(
    input [3:0] BCD,
    output reg [6:0] sseg
    );
    
    always @(*)
  begin
    case (BCD)         //gfedcba
      4'b0000: sseg = 7'b1000000;
      4'b0001: sseg = 7'b1111001;
      4'b0010: sseg = 7'b0100100;
      4'b0011: sseg = 7'b0110000;
      4'b0100: sseg = 7'b0011001;
      4'b0101: sseg = 7'b0010010;
      4'b0110: sseg = 7'b0000010;
      4'b0111: sseg = 7'b1111000;
      4'b1000: sseg = 7'b0000000;
      4'b1001: sseg = 7'b0010000;
      default: sseg = 7'bxxxxxxx;
    endcase
  end
endmodule