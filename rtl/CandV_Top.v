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

output wire  DeBug_cam_clk    ,
output wire  DeBug_cam_in_clk ,
output wire  DeBug_cam_vsynk ,
output wire  DeBug_VSYNC     ,
output wire  DeBug_cam_href  ,
output wire  DeBug_HSYNC     ,

input  wire usb_uart_rxd     ,
output wire usb_uart_txd

    );
assign DeBug_cam_clk    = cam_clk   ;
assign DeBug_cam_in_clk = cam_in_clk;
assign DeBug_cam_vsynk  = cam_vsynk   ;
assign DeBug_VSYNC      = VSYNC;
assign DeBug_cam_href   = cam_href   ;
assign DeBug_HSYNC      = HSYNC;


wire clk;		//output  clk;
wire rstn;		//output [0:0] rstn;
wire ila_clk;
wire Cila_clk;
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
  clk_wiz_0 pll_inst
   (
    // Clock out ports
    .clk_out1(clk),     // output clk_out1
    .clk_out2(cam_clk),     // output clk_out2
    .clk_out3(ila_clk),     // output clk_out3
    .clk_out4(Cila_clk),     // output clk_out4
    
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

//assign DeBug_cam_clk    = SCCB_CLK   ;
//assign DeBug_cam_in_clk = sccb_data_in;

reg [15:0] DevCamVsync;
//always @(posedge cam_in_clk or negedge rstn)
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) DevCamVsync <= 16'h0000;
     else DevCamVsync <= {DevCamVsync[6:0],(cam_vsynk && !cam_href)};
wire SyncCamVsync =   (DevCamVsync[7:0] == 8'h7f) ? 1'b1 :1'b0;
wire cam_vsynk_sync = (DevCamVsync[7:0] == 8'hff) ? 1'b1 :1'b0;

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
.cam_vsynk     (cam_vsynk_sync    ),// input  wire       cam_vsynk     ,
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
.Rclk     (ila_clk),            

.WriteEn  (WriteEn  ),   // input  WriteEn,           
.WriteAdd (WriteAdd ),   // input  [18:0] WriteAdd,   
.WriteData(WriteData),   // input  [11:0] WriteData,  

.ReadAdd  (VGAReadAdd),     // input  [18:0] ReadAdd,    
.ReadData (VGAReadData)           // output [11:0] ReadData    
    );

reg Div_cam_in_clk;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) Div_cam_in_clk <= 1'b0;
     else Div_cam_in_clk <= ~Div_cam_in_clk;
           
VGA VGA_inst(
//.clk  (cam_in_clk  ),
//.clk  (Div_cam_in_clk  ),
.clk  (ila_clk  ),
.rstn (rstn ),

.SyncVsync(1'b0),//SyncCamVsync),
.ReadAdd (VGAReadAdd ),  // output wire [18:0] ReadAdd, 
.ReadData(VGAReadData),  // input  wire [11:0] ReadData,

.RED  (RED  ),
.GRN  (GRN  ),
.BLU  (BLU  ),

.HSYNC(HSYNC),
.VSYNC(VSYNC)
    );

reg [7:0] dev_cam_href;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) dev_cam_href <= 8'h00;
     else dev_cam_href <= {dev_cam_href[6:0],cam_href};
wire Start_cam_href = (dev_cam_href == 8'h7f) ? 1'b1 : 1'b0;
wire Pulse_cam_href = (dev_cam_href == 8'hff) ? 1'b1 : 1'b0;
     

reg [15:0] cam_href_count;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) cam_href_count <= 16'h0000;
     else if (SyncCamVsync) cam_href_count <= 16'h0000;
     else if (Start_cam_href) cam_href_count <= cam_href_count + 1;
     
reg [31:0] OutCamTimeCount;
always @(posedge cam_clk or negedge rstn)
    if (!rstn) OutCamTimeCount <= 32'h00000000;
     else if (cam_vsynk_sync) OutCamTimeCount <= 32'h00000000;
     else OutCamTimeCount <= OutCamTimeCount + 1;
reg [31:0] InCamTimeCount;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) InCamTimeCount <= 32'h00000000;
     else if (SyncCamVsync) InCamTimeCount <= 32'h00000000;
     else InCamTimeCount <= InCamTimeCount + 1;

reg [15:0] Cam_hsyncCounter;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) Cam_hsyncCounter <= 16'h0000;
     else if (!cam_href) Cam_hsyncCounter <= 16'h0000;
     else Cam_hsyncCounter <= Cam_hsyncCounter + 1;

wire [31:0] CounterSub = OutCamTimeCount - InCamTimeCount;
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ila_0 Cam_ila (
    .clk(Cila_clk), // input wire clk

	.probe0(cam_clk    ), // input wire [0:0]  probe0  
	.probe1(cam_in_clk ), // input wire [0:0]  probe1 
	.probe2(cam_vsynk_sync  ), // input wire [0:0]  probe2 
	.probe3(cam_href   ), // input wire [0:0]  probe3 
	.probe4(cam_data   ), // input wire [7:0]  probe4 
	.probe5(cam_rstn   ), // input wire [0:0]  probe5 
	.probe6(cam_pwdn   ), // input wire [0:0]  probe6 
	.probe7(OutCamTimeCount), // input wire [31:0]  probe7
	.probe8(InCamTimeCount), // input wire [31:0]  probe8
	.probe9({cam_href_count,Cam_hsyncCounter}), // input wire [31:0]  probe9
	.probe10(WriteEn  ), // input wire [0:0]  probe10 
    .probe11(WriteAdd ), // input wire [18:0]  probe11 
    .probe12(WriteData) // input wire [11:0]  probe12
	     );
     
reg [1:0] DecSCCB_CLK;
always @(posedge clk or negedge rstn)
    if (!rstn) DecSCCB_CLK <= 2'b00;
     else DecSCCB_CLK <= {DecSCCB_CLK[0],SCCB_CLK};

reg [9:0] Reg_ReadData;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_ReadData <= 8'h00;
    else if (DecSCCB_CLK == 2'b01) Reg_ReadData <= {Reg_ReadData[8:0],sccb_data_in};
  
/*
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ila_1 SCCB_ila (
	.clk(cam_clk), // input wire clk

	.probe0(sccb_clk     ), // input wire [0:0]  probe0  
	.probe1(sccb_clk_en  ), // input wire [0:0]  probe1 
	.probe2(sccb_data_out), // input wire [0:0]  probe2 
	.probe3(sccb_data_in ), // input wire [0:0]  probe3 
	.probe4(sccb_data_en ), // input wire [0:0]  probe4 
	.probe5(Reg_ReadData[9:2]) // input wire [7:0]  probe5
);
*/    
endmodule
