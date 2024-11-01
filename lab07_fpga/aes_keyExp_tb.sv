// Audrey Vo
// avo@hmc.edu
// 10/27/2024
// This code controls the 3 Leds on the development board and also calls the 7-segement display. In addition, code for the test benches of this file was added.

`timescale 1ns/1ns


module keyExptb();
 // Set up test signals
logic clk;
logic [127:0] key;
logic [3:0] round;
logic [127:0] roundKey;
logic [127:0] roundkey_expected;



 // Instantiate the device under test
 keyExpansion dut(.key(key), .round(round), .clk(clk), .roundKey(roundKey));

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
	round = 4'h1;
	roundkey_expected = 128'ha0fafe1788542cb123a339392a6c7605;
	
     	#20;
	
	key = 128'hac7766f319fadc2128d12941575c006e;
	round = 4'h0a;
	roundkey_expected = 128'hd014f9a8c9ee2589e13f0cc8b6630ca6;


	 
	

   end
  // Apply test vector on the rising edge of clk
 
endmodule
