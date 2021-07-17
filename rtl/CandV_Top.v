`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2021 12:07:48
// Design Name: 
// Module Name: CandV_Top
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


module CandV_Top(
input  wire reset            ,
input  wire sys_clock        ,
input  wire Dbun             ,
input  wire Ubun             ,
input  wire Rbun             ,

// Camera interface 
output wire SCCB_CLK         ,
inout  wire SCCB_DATA        ,

output wire       cam_clk    ,
input  wire       cam_in_clk ,
input  wire       cam_vsynk  ,
input  wire       cam_href   ,
input  wire [7:0] cam_data   ,
output wire       cam_rstn   ,
output wire       cam_pwdn   ,

// VGA interface
output wire [3:0] RED        ,
output wire [3:0] GRN        ,
output wire [3:0] BLU        ,

output wire HSYNC            ,
output wire VSYNC            ,            

output wire DeBug_cam_clk    ,
output wire DeBug_cam_in_clk ,

input  wire usb_uart_rxd     ,
output wire usb_uart_txd

    );

assign DeBug_cam_clk    = cam_clk   ;
assign DeBug_cam_in_clk = cam_in_clk;

wire clk;		//output  clk;
wire rstn;		//output [0:0] rstn;
wire ila_clk;
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
  clk_wiz_0 pll_inst
   (
    // Clock out ports
    .clk_out1(clk),     // output clk_out1
    .clk_out2(cam_clk),     // output clk_out2
    .clk_out3(ila_clk),     // output clk_out3
   // Clock in ports
    .clk_in1(sys_clock));      // input clk_in1
// SCCB signals
wire sccb_clk      ;
wire sccb_clk_en   ;
wire sccb_data_out ;
wire sccb_data_in  ;
wire sccb_data_en  ;
assign SCCB_CLK  = (sccb_clk_en) ? sccb_clk : 1'b1;
assign SCCB_DATA = (~sccb_data_en) ? sccb_data_out : 1'bz;
assign sccb_data_in = SCCB_DATA;

reg [1:0] DevCamVsync;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) DevCamVsync <= 2'b00;
     else DevCamVsync <= {DevCamVsync[0],cam_vsynk};
wire SyncCamVsync = (DevCamVsync == 2'b01) ? 1'b1 :1'b0;

wire        WriteEn      ;
wire [18:0] WriteAdd     ;
wire [11:0] WriteData    ;

Camera_interface Camera_interface_inst(
.clk           (clk          ),// input  wire       clk           ,
.reset         (reset        ),// input  wire       reset         ,
.rstn          (rstn         ),// output wire       rstn          ,
.Dbun          (Dbun         ),// input  wire       Dbun          ,

.sccb_clk      (sccb_clk     ),// output wire       sccb_clk      ,
.sccb_clk_en   (sccb_clk_en  ),// output wire       sccb_clk_en   ,
.sccb_data_out (sccb_data_out),// output wire       sccb_data_out ,
.sccb_data_in  (sccb_data_in ),// input  wire       sccb_data_in  ,
.sccb_data_en  (sccb_data_en ),// output wire       sccb_data_en  ,

.cam_in_clk    (cam_in_clk   ),// input  wire       cam_in_clk    ,
.cam_vsynk     (cam_vsynk    ),// input  wire       cam_vsynk     ,
.cam_href      (cam_href     ),// input  wire       cam_href      ,
.cam_data      (cam_data     ),// input  wire [7:0] cam_data      ,
.cam_rstn      (cam_rstn     ),// output wire       cam_rstn      ,
.cam_pwdn      (cam_pwdn     ),// output wire       cam_pwdn      ,

.SyncCamVsync  (SyncCamVsync ),// input  wire       SyncCamVsync  ,

.WriteEn      ( WriteEn     ),// output wire        WriteEn      ,
.WriteAdd     ( WriteAdd    ),// output wire [18:0] WriteAdd     ,
.WriteData    ( WriteData   ),// output wire [11:0] WriteData    ,

.usb_uart_rxd ( usb_uart_rxd),// input  wire        usb_uart_rxd ,
.usb_uart_txd ( usb_uart_txd) // output wire        usb_uart_txd  
    );

wire [18:0] VGAReadAdd ;
wire [11:0] VGAReadData;

MemoryBlock MemoryBlock_inst(
.clk      (cam_in_clk),       // input  clk,               

.WriteEn  (WriteEn  ),   // input  WriteEn,           
.WriteAdd (WriteAdd ),   // input  [18:0] WriteAdd,   
.WriteData(WriteData),   // input  [11:0] WriteData,  

.ReadAdd  (VGAReadAdd),     // input  [18:0] ReadAdd,    
.ReadData (VGAReadData)           // output [11:0] ReadData    
    );
     
VGA VGA_inst(
.clk  (cam_in_clk  ),
.rstn (rstn ),

.SyncVsync(SyncCamVsync),
.ReadAdd (VGAReadAdd ),  // output wire [18:0] ReadAdd, 
.ReadData(VGAReadData),  // input  wire [11:0] ReadData,

.RED  (RED  ),
.GRN  (GRN  ),
.BLU  (BLU  ),

.HSYNC(HSYNC),
.VSYNC(VSYNC)
    );
    
reg [31:0] CamTimeCount;
always @(posedge ila_clk or negedge rstn)
    if (!rstn) CamTimeCount <= 32'h00000000;
     else if (SyncCamVsync) CamTimeCount <= 32'h00000000;
     else CamTimeCount <= CamTimeCount + 1;
     
////----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
//     ila_0 Cam_ila (
//         .clk(ila_clk), // input wire clk
 
// 	     .probe0(cam_vsynk), // input wire [0:0]  probe0  
//         .probe1(cam_href ), // input wire [0:0]  probe1 
//         .probe2(writeAdd), // input wire [19:0]  probe2 
//         .probe3(VSYNC), // input wire [0:0]  probe3 
//         .probe4(HSYNC), // input wire [0:0]  probe4 
//         .probe5(ROMadd) // input wire [19:0]  probe5
//     );
     

/*
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ila_1 SCCB_ila (
	.clk(ila_clk), // input wire clk


	.probe0(sccb_clk     ), // input wire [0:0]  probe0  
	.probe1(sccb_clk_en  ), // input wire [0:0]  probe1 
	.probe2(sccb_data_out), // input wire [0:0]  probe2 
	.probe3(sccb_data_in ), // input wire [0:0]  probe3 
	.probe4(sccb_data_en ), // input wire [0:0]  probe4 
	.probe5(ReadData) // input wire [7:0]  probe5
);
    */
endmodule
