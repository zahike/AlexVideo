`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2021 10:21:04 AM
// Design Name: 
// Module Name: SCCB
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


module SCCB(
input clk,
input rstn,

input [15:0] ClkDiv,
input [15:0] NegDel,

input Start,
input [25:0] DataIn,
output Busy,
output [7:0] ReadData,

output sccb_clk,
output sccb_clk_en,
output sccb_data_out,
input  sccb_data_in,
output sccb_data_en

    );
    
// Clock divider
reg [15:0] Reg_Clock_Counter;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_Clock_Counter <= 16'h0000;
     else if (Reg_Clock_Counter == ClkDiv) Reg_Clock_Counter <= 16'h0000;
     else Reg_Clock_Counter <= Reg_Clock_Counter + 1;

reg SCCBclk;
always @(posedge clk or negedge rstn) 
    if (!rstn) SCCBclk <= 1'b0;
     else if (Reg_Clock_Counter == ClkDiv) SCCBclk <= ~SCCBclk;

wire posSCCBclk = (!SCCBclk && (Reg_Clock_Counter == ClkDiv)) ? 1'b1 : 1'b0;     
wire negSCCBclk = ( SCCBclk && (Reg_Clock_Counter == ClkDiv)) ? 1'b1 : 1'b0;     

reg Reg_NegDel;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_NegDel <= 1'b0;
     else if (!SCCBclk && (Reg_Clock_Counter == NegDel)) Reg_NegDel <= 1'b1;
     else Reg_NegDel <= 1'b0;
     
reg Reg_Start;
always @(posedge clk or negedge rstn) 
    if (!rstn) Reg_Start <= 1'b0;
     else if (Start) Reg_Start <= 1'b1;
     else if (Reg_NegDel) Reg_Start <= 1'b0;

//////////////////////////////////////////////////////////////////////////////////
// Write Transaction 
//
// SB,ID[7:1],W(0),X,Sub-add[7:0],X,Data[7:0],X,SB
// 
// Write befor read
// SB,ID[7:1],W(0),X,Sub-add[7:0],X,SB
// Read Transaction
// SB,ID[7:1],R(1),X,Sub-add[7:0],X,SB
//reg [28:0] SCCBshift;     

wire SB = 1'b0;
wire W = 1'b0;
wire R = 1'b1;
wire X = 1'b1;
wire NA = 1'b1;
wire [7:1] IDadd = DataIn[23:17];
wire [7:0] Sub_Add = DataIn[15:8];
wire [7:0] Wdata = DataIn[7:0];
//wire Read = DataIn[24];
wire Write_sig = (DataIn[25:24] == 2'b00) ? 1'b1 : 1'b0;
wire Read1_sig = (DataIn[25:24] == 2'b01) ? 1'b1 : 1'b0;
wire Read2_sig = (DataIn[25:24] == 2'b10) ? 1'b1 : 1'b0;
reg [28:0] SCCBshift;     
always @(posedge clk or negedge rstn)
    if (!rstn) SCCBshift <= 36'h000000000;
     else if (Write_sig && (Start || Reg_Start)) SCCBshift <= {SB,IDadd,W,X,Sub_Add,X,Wdata,X,SB};
     else if (Read1_sig && (Start || Reg_Start)) SCCBshift <= {SB,IDadd,W,X,Sub_Add,X,SB,1'b0,8'h00};
     else if (Read2_sig && (Start || Reg_Start)) SCCBshift <= {SB,IDadd,R,X,8'hff,NA,SB,1'b0,8'h00};
     else  if (Reg_NegDel) SCCBshift <= {SCCBshift[27:0],1'b0};
     
reg [5:0] Bit_Counter;
reg Reg_Busy;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_Busy <= 1'b0;
     else if (Reg_Start && Reg_NegDel) Reg_Busy <= 1'b1;     
     else if ( Write_sig && (Bit_Counter == 6'd29) && Reg_NegDel) Reg_Busy <= 1'b0;     
     else if (!Write_sig && (Bit_Counter == 6'd20) && Reg_NegDel) Reg_Busy <= 1'b0;     
always @(posedge clk or negedge rstn)
    if (!rstn) Bit_Counter <= 6'h00;
     else if (!Reg_Busy) Bit_Counter <= 6'h00;
     else if (Reg_NegDel) Bit_Counter <= Bit_Counter + 1;

reg Reg_clkEn;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_clkEn <= 1'b0;
     else if (!Reg_Busy) Reg_clkEn <= 1'b0;     
     else if ((Bit_Counter == 6'd00) && posSCCBclk) Reg_clkEn <= 1'b1;     
     else if ( Write_sig && (Bit_Counter == 6'd28) && posSCCBclk) Reg_clkEn <= 1'b0;     
     else if (!Write_sig && (Bit_Counter == 6'd19) && posSCCBclk) Reg_clkEn <= 1'b0;     

reg Reg_w_dataEn;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_w_dataEn <= 1'b0;
     else if (!Reg_Busy) Reg_w_dataEn <= 1'b0;     
     else if (Reg_NegDel && (Bit_Counter == 6'd08)) Reg_w_dataEn <= 1'b1;     
     else if (Reg_NegDel && (Bit_Counter == 6'd17)) Reg_w_dataEn <= 1'b1;     
     else if (Reg_NegDel && (Bit_Counter == 6'd26)) Reg_w_dataEn <= 1'b1;     
     else if (Reg_NegDel) Reg_w_dataEn <= 1'b0;     

reg Reg_r_dataEn;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_r_dataEn <= 1'b0;
     else if (!Reg_Busy) Reg_r_dataEn <= 1'b0;     
     else if (Reg_NegDel && (Bit_Counter == 6'd8)) Reg_r_dataEn <= 1'b1;     
     else if (Reg_NegDel && (Bit_Counter == 6'd18)) Reg_r_dataEn <= 1'b0;     

reg [11:0] Reg_ReadData;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_ReadData <= 12'h000;
     else if (Reg_r_dataEn && posSCCBclk) Reg_ReadData <= {Reg_ReadData[10:0],sccb_data_in};
assign ReadData = Reg_ReadData[8:1];

assign Busy = Reg_Start || Reg_Busy;
    
assign sccb_clk      = SCCBclk    ;
assign sccb_clk_en   = Reg_clkEn  ;
assign sccb_data_out = (Reg_Busy)  ? SCCBshift[28] : 1'b1;
assign sccb_data_en  = (Read2_sig) ? Reg_r_dataEn : Reg_w_dataEn;

       
endmodule
