`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2019 12:03:06 PM
// Design Name: 
// Module Name: mixColumns
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


module mixColumns(in,ed,out);
    input [31:0]in;
    input ed;
    output reg [31:0]out;
    
    always@(*)begin
        case(ed)
            0: out = inv_mixw(in);
            1: out = mixw(in);        
        endcase
    end

function [7 : 0] gm2(input [7 : 0] op);
            begin
              gm2 = {op[6 : 0], 1'b0} ^ (8'h1b & {8{op[7]}});
            end
          endfunction // gm2
        
          function [7 : 0] gm3(input [7 : 0] op);
            begin
              gm3 = gm2(op) ^ op;
            end
          endfunction // gm3
        
          function [7 : 0] gm4(input [7 : 0] op);
            begin
              gm4 = gm2(gm2(op));
            end
          endfunction // gm4
        
          function [7 : 0] gm8(input [7 : 0] op);
            begin
              gm8 = gm2(gm4(op));
            end
          endfunction // gm8
        
          function [7 : 0] gm09(input [7 : 0] op);
            begin
              gm09 = gm8(op) ^ op;
            end
          endfunction // gm09
        
          function [7 : 0] gm11(input [7 : 0] op);
            begin
              gm11 = gm8(op) ^ gm2(op) ^ op;
            end
          endfunction // gm11
        
          function [7 : 0] gm13(input [7 : 0] op);
            begin
              gm13 = gm8(op) ^ gm4(op) ^ op;
            end
          endfunction // gm13
        
          function [7 : 0] gm14(input [7 : 0] op);
            begin
              gm14 = gm8(op) ^ gm4(op) ^ gm2(op);
            end
          endfunction // gm14
        
          function [31 : 0] inv_mixw(input [31 : 0] w);
            reg [7 : 0] b0, b1, b2, b3;
            reg [7 : 0] mb0, mb1, mb2, mb3;
            begin
              b0 = w[31 : 24];
              b1 = w[23 : 16];
              b2 = w[15 : 08];
              b3 = w[07 : 00];
        
              mb0 = gm14(b0) ^ gm11(b1) ^ gm13(b2) ^ gm09(b3);
              mb1 = gm09(b0) ^ gm14(b1) ^ gm11(b2) ^ gm13(b3);
              mb2 = gm13(b0) ^ gm09(b1) ^ gm14(b2) ^ gm11(b3);
              mb3 = gm11(b0) ^ gm13(b1) ^ gm09(b2) ^ gm14(b3);
        
              inv_mixw = {mb0, mb1, mb2, mb3};
            end
          endfunction // invmixw
          
    function [31 : 0] mixw(input [31 : 0] w);
                  reg [7 : 0] b0, b1, b2, b3;
                  reg [7 : 0] mb0, mb1, mb2, mb3;
                  begin
                    b0 = w[31 : 24];
                    b1 = w[23 : 16];
                    b2 = w[15 : 08];
                    b3 = w[07 : 00];
              //multiplying out
                    mb0 = gm2(b0) ^ gm3(b1) ^ b2      ^ b3;
                    mb1 = b0      ^ gm2(b1) ^ gm3(b2) ^ b3;
                    mb2 = b0      ^ b1      ^ gm2(b2) ^ gm3(b3);
                    mb3 = gm3(b0) ^ b1      ^ b2      ^ gm2(b3);
              
                    mixw = {mb0, mb1, mb2, mb3};// final row
                  end
                endfunction // mixw
endmodule
