// Audrey Vo
// avo@hmc.edu
// 10/27/2024
// This code controls the 3 Leds on the development board and also calls the 7-segement display. In addition, code for the test benches of this file was added.

`timescale 1ns/1ns


module corebdtb();
 // Set up test signals
logic clk;
logic load;
logic [127:0] key;
logic [127:0] plaintext;
logic done;
logic [127:0] cyphertext;
logic [127:0] cyphertext_expected;


 // Instantiate the device under test
 aes_core dut(.clk(clk), .load(load), .key(key), .plaintext(plaintext), .done(done), .cyphertext(cyphertext));

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
	key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
	load = 1;
	plaintext = 128'h3243f6a8885a308d313198a2e0370734;
	cyphertext_expected = 128'ha49c7ff2689f352b6b5bea43026a5049;
	
     	#20;
	
	


	 
	

   end
  // Apply test vector on the rising edge of clk
 
endmodule
