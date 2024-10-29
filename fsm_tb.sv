// Audrey Vo
// avo@hmc.edu
// 9/14/2024
// This is a testbench for the oscillator module.
`timescale 1ns/1ns


module fsm_tb();
 // Set up test signals
logic clk, load;
logic [127:0] plaintext;
logic [127:0] key;
logic done;
logic [127:0] cyphertext;
logic [127:0] exp_cyphertext;


 // Instantiate the device under test
 fsm dut(.clk(clk), .load(load), .plaintext(plaintext), .key(key), .done(done), .cyphertext(cyphertext));


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
	load = 0;
	#10
	load = 1;
	#10
	load = 0;

	key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
	plaintext = 128'h3243f6a8885a308d313198a2e0370734;
	exp_cyphertext = 128'ha49c7ff2689f352b6b5bea43026a5049;


	

   end
  // Apply test vector on the rising edge of clk
 
endmodule
