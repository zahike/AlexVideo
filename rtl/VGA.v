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
input  wire [11:0] ROWdata,
output wire ReadMem,

output wire [3:0] RED,
output wire [3:0] GRN,
output wire [3:0] BLU,

output wire HSYNC,
output wire VSYNC

    );
    
wire       Start    ;
reg        RegVSYNC ;
reg        RegVTdisp;
reg        RegHSYNC ;
reg        RegHTdisp;
reg [11:0] Couter;
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

always @(posedge clk or negedge rstn)
    if (!rstn) RegVTdisp <= 1'b0;
     else if (Start &&(RegLine == 12'd30)) RegVTdisp <= 1'b1;
     else if (Start &&(RegLine == 12'd510)) RegVTdisp <= 1'b0;

always @(posedge clk or negedge rstn)
    if (!rstn) RegHTdisp <= 1'b0;
     else if (Couter == 12'd143) RegHTdisp <= 1'b1;
     else if (Couter == 12'd783) RegHTdisp <= 1'b0;
     
reg writeEN;
always @(posedge clk or negedge rstn)
    if (!rstn) writeEN <= 1'b0;
     else writeEN <= RegVTdisp && RegHTdisp;          

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
     else if (Couter == 120) Reg_readMem <= 1'b1;
//     else if (Couter == 782) Reg_readMem <= 1'b0;
     else if (Couter == 760) Reg_readMem <= 1'b0;

assign ReadMem = Reg_readMem;

assign HSYNC = RegHSYNC;
assign VSYNC = RegVSYNC;

//wire [11:0] StaticData = 
//                         ((Couter == 144) && (RegLine == 31 )) ? 12'hfff :
//                         ((Couter == 783) && (RegLine == 31 )) ? 12'hfff :
//                         ((Couter == 144) && (RegLine == 510 )) ? 12'hfff :
//                         ((Couter == 783) && (RegLine == 510 )) ? 12'hfff : 12'h00f;

assign RED = (!RegHTdisp) ? 4'h0 : ROWdata[3:0];
assign GRN = (!RegHTdisp) ? 4'h0 : ROWdata[7:4];
assign BLU = (!RegHTdisp) ? 4'h0 : ROWdata[11:8];
//assign RED = (!RegHTdisp) ? 4'h0 : StaticData[3:0];
//assign GRN = (!RegHTdisp) ? 4'h0 : StaticData[7:4];
//assign BLU = (!RegHTdisp) ? 4'h0 : StaticData[11:8];
    
endmodule
