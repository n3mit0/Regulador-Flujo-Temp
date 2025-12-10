`timescale 1ns / 1ps
module servo(
    input  wire clk,        // 25 MHz clock
    output wire servo_out,
    output wire led
);

//25 MHz clock onBoard
//20 ms counter.
//      1/25,000,000 Hz            = 40 ns (each posedge)
//      (20,000,000 ns)/(40 ns)    = 500,000
//
//      (19 bits) (2^19 - 1)       = 524,287 (from 0 to 524,287)
//                  Therefore, counter needs 19 bits [18:0]
//                  Count up to 499,999 (0 included)
//
//Assumed Max (180 deg) 2 ms        = 50,000 clks
//Assumed Min (0 deg)   1 ms        = 25,000 clks
//Positions      50,000 - 25,000    = 25,000
//Resolution     (180 deg)/25,000   = 0.0072 deg

//essential registers
reg [18:0] counter = 0;
reg servo_reg = 0;

//Test control registers 
reg [15:0] control = 0;    
reg toggle = 1;

always @(posedge clk) begin

    // PWM period counter
    counter <= counter + 1;
    if(counter == 19'd499999)
        counter <= 0;

    // Servo PWM output
    if(counter < (19'd25000 + control))
        servo_reg <= 1;
    else
        servo_reg <= 0;

    /////////////////////////////////////////
    // Test movement 
    /////////////////////////////////////////

    if(control == 16'd25000)
        toggle <= 0;
    if(control == 0)
        toggle <= 1;

    if(counter == 0) begin
        if(toggle == 0)
            control <= control - 16'd1000;
        else
            control <= control + 16'd1000;
    end

end

assign servo_out = servo_reg;
assign led = toggle;

endmodule
