// Audrey Vo
// avo@hmc.edu
// 10/27/2024
// This code controls the 3 Leds on the development board and also calls the 7-segement display. In addition, code for the test benches of this file was added.

`timescale 1ns/1ns


module addRoundKeytb();
 // Set up test signals
logic clk;
logic [127:0] roundKey;
logic [127:0] a;
logic [127:0] y;
logic [127:0] y_expected;


 // Instantiate the device under test
 addRoundKey dut(.a(a), .roundKey(roundKey), .y(y));

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
	a = 128'h3243f6a8885a308d313198a2e0370734;
	roundKey = 128'h2b7e151628aed2a6abf7158809cf4f3c;
	y_expected = 128'h193de3bea0f4e22b9ac68d2ae9f84808;
	
     	#20;
	
	a = 128'h046681e5e0cb199a48f8d37a2806264c;
	roundKey = 128'ha0fafe1788542cb123a339392a6c7605;
	y_expected = 128'ha49c7ff2689f352b6b5bea43026a5049;


	 
	

   end
  // Apply test vector on the rising edge of clk
 
endmodule
