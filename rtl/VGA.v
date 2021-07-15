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

output wire [18:0] ROMadd,
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
reg [11:0] RegLine  ;

always @(posedge clk or negedge rstn)
    if (!rstn) RegVSYNC <= 1'b1;
     else if (Start && (RegLine == 12'd520)) RegVSYNC <= 1'b0;
     else if (Start && (RegLine == 12'd001)) RegVSYNC <= 1'b1;

always @(posedge clk or negedge rstn)
    if (!rstn) RegLine <= 12'h000;
     else if (Start && (RegLine == 12'd520)) RegLine <= 12'h000;
     else if (Start) RegLine <= RegLine + 1;

always @(posedge clk or negedge rstn)
    if (!rstn) RegVTdisp <= 1'b0;
     else if (Start &&(RegLine == 12'd30)) RegVTdisp <= 1'b1;
     else if (Start &&(RegLine == 12'd510)) RegVTdisp <= 1'b0;
     
reg [11:0] Couter;
always @(posedge clk or negedge rstn)
    if (!rstn) Couter <= 12'h000;
     else if (Couter == 12'd799) Couter <= 12'h000;
     else Couter <= Couter + 1;
     
assign Start = (Couter == 12'd799) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rstn)
    if (!rstn) RegHSYNC <= 1'b1;
     else if (Start) RegHSYNC <= 1'b0;
     else if (Couter == 12'd95) RegHSYNC <= 1'b1;

always @(posedge clk or negedge rstn)
    if (!rstn) RegHTdisp <= 1'b0;
     else if (Couter == 12'd143) RegHTdisp <= 1'b1;
     else if (Couter == 12'd783) RegHTdisp <= 1'b0;
     
reg [18:0] RegROMadd;
always @(posedge clk or negedge rstn)
    if (!rstn) RegROMadd <= 19'h00000;
     else if (!RegVSYNC) RegROMadd <= 19'h00000;
     else if (RegVTdisp && RegHTdisp) RegROMadd <= RegROMadd + 1;

assign ROMadd = RegROMadd;

reg writeEN;
always @(posedge clk or negedge rstn)
    if (!rstn) writeEN <= 1'b0;
     else writeEN <= RegVTdisp && RegHTdisp;          
reg [18:0] writeAdd;
always @(posedge clk or negedge rstn)
    if (!rstn) writeAdd <= 19'h00000;
     else writeAdd <= ROMadd;    
     
reg [18:0] EOLadd;
always @(posedge clk or negedge rstn)
    if (!rstn) EOLadd <= 19'd639;
     else if (writeAdd == 307199) EOLadd <= 19'd639;
     else if (writeAdd == EOLadd) EOLadd <= EOLadd + 19'd640;

reg switchFrame;
always @(posedge clk or negedge rstn)   
    if (!rstn) switchFrame <= 1'b0;
     else if (Start && (RegLine == 12'h000)) switchFrame <= ~switchFrame;
reg LineOn;
always @(posedge clk or negedge rstn)
    if (!rstn) LineOn <= 1'b0;
     else if (!RegVSYNC) LineOn <= switchFrame;
     else if (RegVTdisp && Start) LineOn <= ~LineOn; 

wire [14:0] LineDataON  = (LineOn) ? 15'h000f : 15'h0000;       
wire [14:0] LineDataOFF = (LineOn) ? 15'h0000 : 15'h000f;       
reg [14:0] writeData;
always @(posedge clk or negedge rstn)
    if (!rstn) writeData <= 15'h0000;
     else if (!RegVSYNC) writeData <= 15'h0000;
     else if (writeEN) writeData <= writeData + 1;

///////////////////////
reg blockLines;
always @(posedge clk or negedge rstn)
    if (!rstn) blockLines <= 1'b0;
     else if (RegLine == 31) blockLines <= 1'b1;
     else if (RegLine == 511) blockLines <= 1'b0;
     
reg Reg_readMem;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_readMem <= 1'b0;
     else if (!blockLines) Reg_readMem <= 1'b0;
     else if (Couter == 142) Reg_readMem <= 1'b1;
     else if (Couter == 782) Reg_readMem <= 1'b0;

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
