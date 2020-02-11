`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2019 03:50:53 PM
// Design Name: 
// Module Name: KeyGen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module KeyGeneration(CLK,rc,enable,prevKey,nextKey);
    
    input CLK,enable;
    input [3:0]rc;//round constant
    input [127:0]prevKey;
    output [127:0]nextKey;
    //output reg [127:0]nextKey;
   
    //reg [31:0] w0,w1,w2,w3;
    wire [31:0]tem,w0,w1,w2,w3;
    wire ready;
       

    
       aes_sbox_keyExp keysub({w3[23:16],w3[15:8],w3[7:0],w3[31:24]},tem);
       
       //subtop subing(CLK,{w3[23:16],w3[15:8],w3[7:0],w3[31:24]},tem,ready);
       
         
       //always@*
       //begin:keyGen   
       //if(enable)begin     
       assign w0 = prevKey[127:96];
       assign w1 = prevKey[95:64];
       assign w2 = prevKey[63:32];
       assign w3 = prevKey[31:0];
       
       
       assign nextKey[127:96]= w0 ^ tem ^ rcon(rc-1);
       assign nextKey[95:64] = w0 ^ tem ^ rcon(rc-1)^ w1;
       assign nextKey[63:32] = w0 ^ tem ^ rcon(rc-1)^ w1 ^ w2;
       assign nextKey[31:0]  = w0 ^ tem ^ rcon(rc-1)^ w1 ^ w2 ^ w3;
       
       //end//KeyGen
       //end

              
     function [31:0]	rcon;
      input	[3:0]	rc;
      case(rc)	
         4'h0: rcon=32'h01000000;
         4'h1: rcon=32'h02000000;
         4'h2: rcon=32'h04000000;
         4'h3: rcon=32'h08000000;
         4'h4: rcon=32'h10000000;
         4'h5: rcon=32'h20000000;
         4'h6: rcon=32'h40000000;
         4'h7: rcon=32'h80000000;
         4'h8: rcon=32'h1b000000;
         4'h9: rcon=32'h36000000;
         default: rcon=32'h00000000;
       endcase

     endfunction

endmodule
