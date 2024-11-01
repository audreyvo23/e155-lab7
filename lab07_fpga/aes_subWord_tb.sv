// Audrey Vo
// avo@hmc.edu
// 10/27/2024
// This code controls the 3 Leds on the development board and also calls the 7-segement display. In addition, code for the test benches of this file was added.

`timescale 1ns/1ns


module subWordtb();
 // Set up test signals
logic clk;
logic [31:0] a;
logic [31:0] y;
logic [31:0] y_expected;



 // Instantiate the device under test
 subWord dut(.a(a), .clk(clk), .y(y));

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
	 a = 32'hcf4f3c09;
	y_expected = 32'h8a84eb01;
	
     	#20;

	a = 32'h6c76052a;
	y_expected = 32'h50386be5;

	 
	

   end
  // Apply test vector on the rising edge of clk
 
endmodule
