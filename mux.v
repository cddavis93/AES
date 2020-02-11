`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2019 02:41:32 PM
// Design Name: 
// Module Name: mux
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


module mux2_1(A,B,S,Out);
    input [31:0]A,B;
    input S;
    output reg [31:0]Out;
    
    always@(*)begin
        case(S)
            0: Out = B;
            1: Out = A;
        endcase
    end
endmodule

module mux16_4(A,s,Out);
    input [127:0]A;
    input [1:0]s;
    output reg [31:0]Out;
    
    always@(*)begin
        case(s)
            0: Out = A[127:96];
            1: Out = A[95:64];
            2: Out = A[63:32];
            3: Out = A[31:0];
        endcase
    end
endmodule