// Audrey Vo
// avo@hmc.edu
// 10/27/2024
// This code controls the 3 Leds on the development board and also calls the 7-segement display. In addition, code for the test benches of this file was added.

`timescale 1ns/1ns


module shiftRowstb();
 // Set up test signals
logic clk;
logic [127:0] a;
logic [127:0] y;
logic [127:0] y_expected;



 // Instantiate the device under test
 shiftRows dut(.a(a), .y(y));

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
	 a = 128'hd42711aee0bf98f1b8b45de51e415230;
	y_expected = 128'hd4bf5d30e0b452aeb84111f11e2798e5;
	
     	#20;

	 
	

   end
  // Apply test vector on the rising edge of clk
 
endmodule
