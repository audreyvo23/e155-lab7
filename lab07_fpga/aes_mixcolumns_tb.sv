// Audrey Vo
// avo@hmc.edu
// 10/27/2024
// This code controls the 3 Leds on the development board and also calls the 7-segement display. In addition, code for the test benches of this file was added.

`timescale 1ns/1ns


module mixcolumnstb();
 // Set up test signals
logic clk;
logic [127:0] a;
logic [127:0] y;
logic [127:0] y_expected;



 // Instantiate the device under test
 mixcolumns dut(.a(a), .y(y));

 // Generate clock signal with a period of 10 timesteps.
 always
   begin
     clk = 1; #5;
     clk = 0; #5;
   end
  
 // At the start of the simulation:
 //  - Load the testvectors
 //  - Pulse the reset line (if applicable)
 initial
   begin
	 a = 128'hd4bf5d30e0b452aeb84111f11e2798e5;
	y_expected = 128'h046681e5e0cb199a48f8d37a2806264c;
	
     	#20;

	a = 128'h49db873b453953897f02d2f177de961a;
	y_expected = 128'h584dcaf11b4b5aacdbe7caa81b6bb0e5;

	 
	

   end
  // Apply test vector on the rising edge of clk
 
endmodule
