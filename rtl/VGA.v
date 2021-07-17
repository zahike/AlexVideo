`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2021 19:16:59
// Design Name: 
// Module Name: VGA
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


module VGA(
input clk,
input rstn,

input SyncVsync,
output wire [18:0] ReadAdd,
input  wire [11:0] ReadData,
//output wire ReadMem,

output wire [3:0] RED,
output wire [3:0] GRN,
output wire [3:0] BLU,

output wire HSYNC,
output wire VSYNC

    );
    
wire       Start    ;
reg        RegVSYNC ;
reg        RegHSYNC ;
reg [11:0] Couter   ;
reg [11:0] RegLine  ;


// Counters
always @(posedge clk or negedge rstn)
    if (!rstn) Couter <= 12'h000;
     else if (SyncVsync) Couter <= 12'h000;
     else if (Couter == 12'd799) Couter <= 12'h000;
     else Couter <= Couter + 1;
	 
assign Start = (Couter == 12'd799) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rstn)
    if (!rstn) RegLine <= 12'h000;
     else if (SyncVsync) RegLine <= 12'h000;
     else if (Start && (RegLine == 12'd520)) RegLine <= 12'h000;
     else if (Start) RegLine <= RegLine + 1;

// signal genratuion 
always @(posedge clk or negedge rstn)
    if (!rstn) RegHSYNC <= 1'b1;
     else if (Start) RegHSYNC <= 1'b0;
     else if (Couter == 12'd95) RegHSYNC <= 1'b1;
     else if (Couter == 12'd784) RegHSYNC <= 1'b0;

always @(posedge clk or negedge rstn)
    if (!rstn) RegVSYNC <= 1'b0;
     else if (SyncVsync)  RegVSYNC <= 1'b0;
     else if (Start && (RegLine == 12'd520)) RegVSYNC <= 1'b0;
     else if (Start && (RegLine == 12'd001)) RegVSYNC <= 1'b1;

assign HSYNC = RegHSYNC;
assign VSYNC = RegVSYNC;

// read Mem signal
reg blockLines;
always @(posedge clk or negedge rstn)
    if (!rstn) blockLines <= 1'b0;
     else if (RegLine == 31) blockLines <= 1'b1;
     else if (RegLine == 511) blockLines <= 1'b0;
     
reg Reg_readMem;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_readMem <= 1'b0;
     else if (!blockLines) Reg_readMem <= 1'b0;
//     else if (Couter == 142) Reg_readMem <= 1'b1;
     else if (Couter == 110) Reg_readMem <= 1'b1;
//     else if (Couter == 782) Reg_readMem <= 1'b0;
     else if (Couter == 750) Reg_readMem <= 1'b0;

//wire ReadMem;
reg [19:0] Reg_ReadAdd;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_ReadAdd <= 20'h00000;
     else if (!VSYNC) Reg_ReadAdd <= 20'h00000;
     else if (Reg_readMem) Reg_ReadAdd <= Reg_ReadAdd + 1;
assign ReadAdd = Reg_ReadAdd[19:1];

reg SendVGA;
always @(posedge clk or negedge rstn)
    if (!rstn) SendVGA <= 1'b0;
     else SendVGA <= Reg_readMem;
reg bVGA;
always @(posedge clk or negedge rstn)
    if (!rstn) bVGA <= 1'b0;
     else if (SyncVsync) bVGA <= ~bVGA;
     else if (!SendVGA && Reg_readMem) bVGA <= ~bVGA;
     else if (SendVGA) bVGA <= ~bVGA; 
wire [11:0] VGAdata = (SendVGA && !bVGA) ? ReadData : 12'h000;

//wire [11:0] StaticData = 
//                         ((Couter == 144) && (RegLine == 31 )) ? 12'hfff :
//                         ((Couter == 783) && (RegLine == 31 )) ? 12'hfff :
//                         ((Couter == 144) && (RegLine == 510 )) ? 12'hfff :
//                         ((Couter == 783) && (RegLine == 510 )) ? 12'hfff : 12'h00f;

assign RED = (SendVGA) ?  VGAdata[3:0]  : 4'h0;
assign GRN = (SendVGA) ?  VGAdata[7:4]  : 4'h0;
assign BLU = (SendVGA) ?  VGAdata[11:8] : 4'h0;
//assign RED = (SendVGA) ? StaticData[3:0]  : 4'h0;
//assign GRN = (SendVGA) ? StaticData[7:4]  : 4'h0;
//assign BLU = (SendVGA) ? StaticData[11:8] : 4'h0;
    
endmodule
