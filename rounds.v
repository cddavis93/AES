`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2019 05:06:06 PM
// Design Name: 
// Module Name: rounds
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


module rounds(CLK,ed,rEnable,rcRound,rKey,din,dout,mclR);
    input CLK, rEnable, ed;
    input [3:0]rcRound;
    input [127:0]rKey,din;
    output reg [127:0]dout;
    output mclR;
    
    reg [1:0]s;
    wire [1:0]smux;
    reg [31:0]sr;
    wire [31:0]mcl,sb;
    wire [31:0]R0,R1,R2,R3;
    wire [31:0]RCB1,RCB3,SCB1,SCB3;
    wire [31:0]RS0,RS1,RS2,RS3;
    wire [31:0]arkIn,arkOut,mxIn,mxOut,pKey,pRoundOut;
    reg [1:0]mclRI;
    wire rc10,arkSW,rOutSW;
    
    assign rc10 = (rcRound[3] ~^ 1'b1) & (rcRound[2] ~^ 1'b0) & (rcRound[1] ~^ 1'b1) & (rcRound[0] ~^ 1'b0);
    assign arkSW = rc10 | ~ed;
    assign rOutSW = rc10 | ed;
    
    assign R0 = {din[127:120],din[95:88],din[63:56],din[31:24]};
    assign R1 = {din[119:112],din[87:80],din[55:48],din[23:16]};
    assign R2 = {din[111:104],din[79:72],din[47:40],din[15:8]};
    assign R3 = {din[103:96],din[71:64],din[39:32],din[7:0]};
    
    cbSwitch CB1(R1,R3,ed,RCB1,RCB3);
    
    assign RS0 = R0;
    assign SCB1 = {RCB1[7:0],RCB1[31:24],RCB1[23:16],RCB1[15:8]};
    assign RS2 = {R2[15:8],R2[7:0],R2[31:24],R2[23:16]};
    assign SCB3 = {RCB3[23:16],RCB3[15:8],RCB3[7:0],RCB3[31:24]};
    
    cbSwitch CB2(SCB1,SCB3,ed,RS1,RS3);
    
    bSbox S0(sr[31:24],ed,sb[31:24]);
    bSbox S1(sr[23:16],ed,sb[23:16]);
    bSbox S2(sr[15:8],ed,sb[15:8]);
    bSbox S3(sr[7:0],ed,sb[7:0]);
    
    mux2_1 M0(sb,arkOut,ed,mxIn);
    mux2_1 M1(sb,mxOut,arkSW,arkIn);   
    mixColumns mx0(mxIn,ed,mxOut);
    ARK AR0(arkIn,pKey,arkOut);
    mux2_1 M2(arkOut,mxOut,rOutSW,pRoundOut);    
    mux16_4 M3(rKey,s,pKey);
    
    assign mclR = mclRI[1];
    
    always@(din)begin
            s = 3;
            mclRI = 0;
        end
        always@(posedge CLK)begin
            s = s + 2'b01;
            //sr = sbox_func(sb);
            //mcl = mixw(sr);
//        end
        
//        always@(s)begin
        case (s)
        0:begin 
            sr = {RS0[31:24],RS1[31:24],RS2[31:24],RS3[31:24]};
            dout[31:0] = pRoundOut;
            mclRI = mclRI + 1'b1;
            //mclR = mclRI[1];
//            mclR = 0;
            end
            
        1:begin
            sr = {RS0[23:16],RS1[23:16],RS2[23:16],RS3[23:16]};
            dout[127:96] = pRoundOut; 
            //mclR = mclRI[1];
//            mclR = 0;
            end
            
        2:begin
            sr = {RS0[15:8],RS1[15:8],RS2[15:8],RS3[15:8]};
            dout[95:64] = pRoundOut;
            //mclR = mclRI[1]; 
//            mclR = 0;
            end
            
        3:begin
            sr = {RS0[7:0],RS1[7:0],RS2[7:0],RS3[7:0]};
            dout[63:32] = pRoundOut; 
            //mclR = mclRI[1];
//            mclR = 1;
            end
        endcase
        end
    
    
endmodule


module cbSwitch(A,B,S,Out1,Out2);
    input [31:0]A,B;
    input S;
    output reg [31:0]Out1,Out2;
    
    always@(*)begin
        case(S)
        0: begin
            Out1 = A;
            Out2 = B;
        end
        1: begin
            Out1 = B;
            Out2 = A;
        end
        endcase
    end
endmodule

module ARK(in,key,out);
    input [31:0]in,key;
    output [31:0]out;
    
    assign out = in ^ key;
    
endmodule