/////////////////////////////////////////////
// aes
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////

module aes(input  logic clk,
           input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
           output logic done);
                    
    logic [127:0] key, plaintext, cyphertext;
            
    aes_spi spi(sck, sdi, sdo, done, key, plaintext, cyphertext);   
    aes_core core(clk, load, key, plaintext, done, cyphertext);
endmodule

/////////////////////////////////////////////
// aes_spi
//   SPI interface.  Shifts in key and plaintext
//   Captures ciphertext when done, then shifts it out
//   Tricky cases to properly change sdo on negedge clk
/////////////////////////////////////////////

module aes_spi(input  logic sck, 
               input  logic sdi,
               output logic sdo,
               input  logic done,
               output logic [127:0] key, plaintext,
               input  logic [127:0] cyphertext);

    logic         sdodelayed, wasdone;
    logic [127:0] cyphertextcaptured;
               
    // assert load
    // apply 256 sclks to shift in key and plaintext, starting with plaintext[127]
    // then deassert load, wait until done
    // then apply 128 sclks to shift out cyphertext, starting with cyphertext[127]
    // SPI mode is equivalent to cpol = 0, cpha = 0 since data is sampled on first edge and the first
    // edge is a rising edge (clock going from low in the idle state to high).
    always_ff @(posedge sck)
        if (!wasdone)  {cyphertextcaptured, plaintext, key} = {cyphertext, plaintext[126:0], key, sdi};
        else           {cyphertextcaptured, plaintext, key} = {cyphertextcaptured[126:0], plaintext, key, sdi}; 
    
    // sdo should change on the negative edge of sck
    always_ff @(negedge sck) begin
        wasdone = done;
        sdodelayed = cyphertextcaptured[126];
    end
    
    // when done is first asserted, shift out msb before clock edge
    assign sdo = (done & !wasdone) ? cyphertext[127] : sdodelayed;
endmodule

/////////////////////////////////////////////
// aes_core
//   top level AES encryption module
//   when load is asserted, takes the current key and plaintext
//   generates cyphertext and asserts done when complete 11 cycles later
// 
//   See FIPS-197 with Nk = 4, Nb = 4, Nr = 10
//
//   The key and message are 128-bit values packed into an array of 16 bytes as
//   shown below
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Equivalently, the values are packed into four words as given
//        [127:96]  [95:64] [63:32] [31:0]      w[0]    w[1]    w[2]    w[3]
/////////////////////////////////////////////

module aes_core(input  logic         clk, 
                input  logic         load,
                input  logic [127:0] key, 
                input  logic [127:0] plaintext, 
                output logic         done, 
                output logic [127:0] cyphertext);

    // TODO: Your code goes here
    
endmodule


/////////////////////////////////////////////
// sbox
//   Infamous AES byte substitutions with magic numbers
//   Synchronous version which is mapped to embedded block RAMs (EBR)
//   Section 5.1.1, Figure 7
/////////////////////////////////////////////
module sbox_sync(
	input		logic [7:0] a,
	input	 	logic 			clk,
	output 	logic [7:0] y);
            
  // sbox implemented as a ROM
  // This module is synchronous and will be inferred using BRAMs (Block RAMs)
  logic [7:0] sbox [0:255];

  initial   $readmemh("sbox.txt", sbox);
	
	// Synchronous version
	always_ff @(posedge clk) begin
		y <= sbox[a];
	end
endmodule

module subByte(input logic [127:0] a,
              output logic [127:0] y);

  // row 0
  sbox_sync sB00(a[127:120], clk, y[127:120]);
  sbox_sync sB01(a[95:88], clk, y[95:88]);
  sbox_sync sB02(a[63:56], clk, y[63:56]);
  sbox_sync sB03(a[31:24], clk, y[31:24]);

  // row 1
  sbox_sync sB10(a[119:112], clk, y[119:112]);
  sbox_sync sB11(a[87:80], clk, y[87:80]);
  sbox_sync sB12(a[55:48], clk, y[55:48]);
  sbox_sync sB13(a[23:16], clk, y[23:16]);

  // row 2
  sbox_sync sB20(a[111:104], clk, y[111:104]);
  sbox_sync sB21(a[79:72], clk, y[79:72]);
  sbox_sync sB22(a[47:40], clk, y[47:40]);
  sbox_sync sB23(a[15:8], clk, y[15:8]);
 
  // row 3
  sbox_sync sB30(a[103:96], clk, y[103:96]);
  sbox_sync sB31(a[71:64], clk, y[71:64]);
  sbox_sync sB32(a[39:32], clk, y[39:32]);
  sbox_sync sB33(a[7:0], clk, y[7:0]);

// do I need ff block here??
endmodule 

module shiftRows(input logic [127:0] a,
                output logic [127:0] y);

  /* {a[127:120], a[95:88], a[63:56], a[31:24]};
  {a[87:80], a[55:48], a[23:16], a[119:112]};
  {a[47:40], a[15:8], a[111:104], a[79:72]};
  {a[7:0], a[103:96], a[71:64], a[39:32]};
  */

  assign y[127:120] = a[127:120];
  assign y[95:88] = a[95:88];
  assign y[63:56] = a[63:56];
  assign y[31:24] = a[31:24];

  assign y[119:112] = a[87:80];
  assign y[87:80] = a[55:48];
  assign y[55:48] = a[23:16];
  assign y[23:16] = a[119:112];

  assign y[111:104] = a[47:40];
  assign y[79:72] = a[15:8];
  assign y[47:40] = a[111:104];
  assign y[15:8] = a[79:72];

  assign y[103:96] = a[7:0];
  assign y[71:64] = a[103:96];
  assign y[39:32] = a[71:64];
  assign y[7:0] = a[39:32];

endmodule

/////////////////////////////////////////////
// mixcolumns
//   Even funkier action on columns
//   Section 5.1.3, Figure 9
//   Same operation performed on each of four columns
/////////////////////////////////////////////

module mixcolumns(input  logic [127:0] a,
                  output logic [127:0] y);

  mixcolumn mc0(a[127:96], y[127:96]);
  mixcolumn mc1(a[95:64],  y[95:64]);
  mixcolumn mc2(a[63:32],  y[63:32]);
  mixcolumn mc3(a[31:0],   y[31:0]);
endmodule

/////////////////////////////////////////////
// mixcolumn
//   Perform Galois field operations on bytes in a column
//   See EQ(4) from E. Ahmed et al, Lightweight Mix Columns Implementation for AES, AIC09
//   for this hardware implementation
/////////////////////////////////////////////

module mixcolumn(input  logic [31:0] a,
                 output logic [31:0] y);
                      
        logic [7:0] a0, a1, a2, a3, y0, y1, y2, y3, t0, t1, t2, t3, tmp;
        
        assign {a0, a1, a2, a3} = a;
        assign tmp = a0 ^ a1 ^ a2 ^ a3;
    
        galoismult gm0(a0^a1, t0);
        galoismult gm1(a1^a2, t1);
        galoismult gm2(a2^a3, t2);
        galoismult gm3(a3^a0, t3);
        
        assign y0 = a0 ^ tmp ^ t0;
        assign y1 = a1 ^ tmp ^ t1;
        assign y2 = a2 ^ tmp ^ t2;
        assign y3 = a3 ^ tmp ^ t3;
        assign y = {y0, y1, y2, y3};    
endmodule

/////////////////////////////////////////////
// galoismult
//   Multiply by x in GF(2^8) is a left shift
//   followed by an XOR if the result overflows
//   Uses irreducible polynomial x^8+x^4+x^3+x+1 = 00011011
/////////////////////////////////////////////

module galoismult(input  logic [7:0] a,
                  output logic [7:0] y);

    logic [7:0] ashift;
    
    assign ashift = {a[6:0], 1'b0};
    assign y = a[7] ? (ashift ^ 8'b00011011) : ashift;
endmodule

module rotWord(input logic [31:0] a,
                output logic [31:0] y); 

  logic [7:0] a0, a1, a2, a3;
  assign {a0, a1, a2, a3} = a;

  assign y = {a1, a2, a3, a0};
 
endmodule 

module subWord(input logic [31:0] a,
                input logic clk,
                output logic [31:0] y); 

  logic [7:0] a0, a1, a2, a3, y0, y1, y2, y3;

  sbox_sync sba0(a0, clk, y0);
  sbox_sync sba1(a1, clk, y1);
  sbox_sync sba2(a2, clk, y2);
  sbox_sync sba3(a3, clk, y3);

  assign y = {y0, y1, y2, y3};    

endmodule

module keyExpansion(input logic [127:0] key,
                    input logic [3:0] round,
                    input logic clk,
                    output logic [127:0] roundKey);

  logic [31:0] key0, key1, key2, key3;
  logic [31:0] rkey0, rkey1, rkey2, rkey3;
  logic [31:0] rcon;
  logic [7:0] j, rcon1, rcon2, rcon3;
  logic [31:0] rotKey, subKey;

  assign {key0, key1, key2, key3} = key;

  assign j = 2^(round-1);
  assign rcon1 = 0;
  assign rcon2 = 0;
  assign rcon3 = 0;

  assign rcon = {j, rcon1, rcon2, rcon3};

  rotWord r1(key3, rotKey);

  subWord s1(rotKey, clk, subKey);

  assign rkey0 = key0 ^ subKey ^ rcon;
  assign rkey1 = key1 ^ rkey0;
  assign rkey2 = key2 ^ rkey1;
  assign rkey3 = key3 ^ rkey2;

  assign roundKey = {rkey0, rkey1, rkey2, rkey3};


endmodule

module addRoundKey(input logic [127:0] a,
                    input logic [127:0] roundKey,
                    output logic [127:0] y);

  logic [31:0] a0, a1, a2, a3;
  logic [31:0] rkey0, rkey1, rkey2, rkey3;
  logic [31:0] y0, y1, y2, y3;

  assign {a0, a1, a2, a3} = a;
  assign {rkey0, rkey1, rkey2, rkey3} = roundKey;

  assign y0 = a0 ^ rkey0;
  assign y1 = a1 ^ rkey1;
  assign y2 = a2 ^ rkey2;
  assign y3 = a3 ^ rkey3;

  assign y = {y0, y1, y2, y3};


endmodule