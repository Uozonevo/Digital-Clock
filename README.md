# Digital Clock
I created a digital clock in Vivado using verilog that would count up from 00:00 to 59:59.
The board I used is the Nexys8 and the block diagram for the digital is shown below.
**insert block diagram**

## Top Module - DigitalClock.v

## Generate 1kHz Clock
<details>
The system clock for the Nexys8 board runs at ...MHz, so in module ClkGen1kHz, the system clock is converted to a 1kHz clock.
```verilog
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
```
</details>

## Minute Clock Generation
## Minutes and Seconds Counter
<details>
```verilog
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
```
### Seconds Up Counter
```verilog
always@(negedge clk or negedge resetSW)
    begin
      if (~resetSW)
         count_second <= 0;
    else if (count_second == 59)
                count_second <= 0;            
            else 
               count_second <= count_second + 1;
    end
```
### Minutes Up Counter
```verilog
always@(posedge clk, negedge resetSW)
    begin
      if(~resetSW)
        count_minute <= 0; 
      else if(load)
        count_minute <= count_minute + 1;
    end
```
</details>
          
## Digit Separator
<details>
```verilog
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
```
</details>
          
## Binary-to-Seven-Segment Decoder
<details>
```verilog
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
```
</details>
