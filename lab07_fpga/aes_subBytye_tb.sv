// Audrey Vo
// avo@hmc.edu
// 10/27/2024
// This code controls the 3 Leds on the development board and also calls the 7-segement display. In addition, code for the test benches of this file was added.

`timescale 1ns/1ns


module subBytetb();
 // Set up test signals
logic clk;
logic [127:0] a;
logic [127:0] y;
logic [127:0] y_expected;



 // Instantiate the device under test
 subByte dut(.a(a), .clk(clk), .y(y));

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
	 a = 128'h193de3bea0f4e22b9ac68d2ae9f84808;
	 y_expected = 128'hd42711aee0bf98f1b8b45de51e415230;
	
     	#20;

	a = 128'ha49c7ff2689f352b6b5bea43026a5049;
	y_expected = 128'h49ded28945db96f17f39871a7702533b;

   end
  // Apply test vector on the rising edge of clk
 
endmodule
