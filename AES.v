`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2019 03:45:48 PM
// Design Name: 
// Module Name: AES
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


module AES(CLK,start,enc_dec,orgData,orgKey,outData,dataReady);
    input CLK,start,enc_dec;
    input [127:0]orgData,orgKey;
    output reg [127:0]outData;
    output reg dataReady;
    
    reg [3:0]rcKey,rcRound;
    reg [127:0]prevKey,datain,rKey;
    wire [127:0]nextKey,dataout;
    reg keyEnable,rEnable;
    reg [127:0]romKey[10:0];
    wire rReady; 
    reg [127:0]fKey;
    reg keyReady;
    
    KeyGeneration k(CLK,rcKey,keyEnable,prevKey,nextKey);
    rounds r(CLK,enc_dec,rEnable,rcRound,rKey,datain,dataout,rReady);
    
    
     always@(posedge start)begin
        if(keyReady)begin
            keyEnable = 1'b0;
            if(dataReady)begin
                rEnable = 1'b0;
            end
            else
                rEnable = 1'b1;
        end
        else
            keyEnable = 1'b1;
            
        /*if(dataReady)
            rEnable = 1'b0;*/
            
     end
       
       always@(posedge CLK)
        begin
            if(keyEnable)begin
               case (rcKey)
                   0:begin
                       prevKey = orgKey;
                       romKey[0] = orgKey;
                       rcKey = 4'h1;
                       //rEnable = 1'b0;
                       //dataReady = 1'b0;
                   end
                   1:begin
                       romKey[1] = nextKey;
                       prevKey = nextKey;
                       rcKey = 4'h2;
                   end
                   2:begin
                       romKey[2] = nextKey;
                       prevKey = nextKey;
                       rcKey = 4'h3;
                   end
                   3:begin
                       romKey[3] = nextKey;
                       prevKey = nextKey;
                       rcKey = 4'h4;
                   end
                   4:begin
                       romKey[4] = nextKey;
                       prevKey = nextKey;
                       rcKey = 4'h5;
                   end
                   5:begin
                       romKey[5] = nextKey;
                       prevKey = nextKey;
                       rcKey = 4'h6;                
                   end
                   6:begin
                       romKey[6] = nextKey;
                       prevKey = nextKey;
                       rcKey = 4'h7;                 
                   end
                   7:begin
                       romKey[7] = nextKey;
                       prevKey = nextKey;
                       rcKey = 4'h8;                 
                   end
                   8:begin
                       romKey[8] = nextKey;
                       prevKey = nextKey;
                       rcKey = 4'h9;                                
                   end
                   9:begin
                       romKey[9] = nextKey;
                       prevKey = nextKey;
                       rcKey = 4'ha;                                
                   end
                   10:begin
                       romKey[10] = nextKey;
                       //rEnable = 1'b1;
                       //keyEnable = 1'b0;
                       keyReady = 1'b1;                               
                   end
                   default: rcKey = 4'h0;
                   endcase
                
            end//key update
            
//        end//key CLK
//    always@(posedge CLK)
//             begin: rounds
             if(keyReady)begin
             
                 case (rcRound)
                 0:begin
                    fKey = enc_dec ? romKey[0]:romKey[10];
                    datain = orgData ^ fKey;            
                    rcRound = 4'h1;
                    rKey = enc_dec ? romKey[1]:romKey[9];
                    dataReady = 1'b0;
                 end
                 1:begin
                    if (rReady)begin
                    datain = dataout;
                    rcRound = 4'h2;
                    rKey = enc_dec ? romKey[2]:romKey[8];
                    end
                 end
                 2:begin
                    if (rReady)begin
                    datain = dataout;
                    rcRound = 4'h3;
                    rKey = enc_dec ? romKey[3]:romKey[7];
                    end
                 end
                 3:begin
                    if (rReady)begin
                    datain = dataout;
                    rcRound = 4'h4;
                    rKey = enc_dec ? romKey[4]:romKey[6];
                    end
                 end
                 4:begin
                    if (rReady)begin
                    datain = dataout;
                    rcRound = 4'h5;
                    rKey = romKey[5];
                    end
                 end
                 5:begin
                    if (rReady)begin
                    datain = dataout;
                    rcRound = 4'h6;
                    rKey = enc_dec ? romKey[6]:romKey[4];
                    end                
                 end
                 6:begin
                    if (rReady)begin
                    datain = dataout;
                    rcRound = 4'h7;
                    rKey = enc_dec ? romKey[7]:romKey[3];
                    end                 
                 end
                 7:begin
                    if (rReady)begin
                    datain = dataout;
                    rcRound = 4'h8;
                    rKey = enc_dec ? romKey[8]:romKey[2];
                    end              
                 end
                 8:begin
                    if (rReady)begin
                    datain = dataout;
                    rcRound = 4'h9;
                    rKey = enc_dec ? romKey[9]:romKey[1];
                    end                           
                 end
                 9:begin
                    if (rReady)begin
                    datain = dataout;
                    rcRound = 4'ha;
                    rKey = enc_dec ? romKey[10]:romKey[0];
                    end                          
                 end
                 10:begin
                    if (rReady)begin
                    outData = dataout;
                    dataReady = 1'b1;
                    rEnable = 1'b0;
                    rcRound = 4'h0;
                    end                              
                 end
                 default: rcRound = 4'h0;
                 endcase
                 
             end//round enable
             end//round CLK
endmodule
