`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2021 18:16:53
// Design Name: 
// Module Name: Camera_interface
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


module Camera_interface(
input  wire       clk           ,
input  wire       reset         ,
output wire       rstn          ,
input  wire       Dbun          ,

output wire       sccb_clk      ,
output wire       sccb_clk_en   ,
output wire       sccb_data_out ,
input  wire       sccb_data_in  ,
output wire       sccb_data_en  ,

input  wire       cam_in_clk    ,
input  wire       cam_vsynk     ,
input  wire       cam_href      ,
input  wire [7:0] cam_data      ,
output wire       cam_rstn      ,
output wire       cam_pwdn      ,

input  wire       SyncCamVsync  ,

output wire        WriteEn      ,
output wire [18:0] WriteAdd     ,
output wire [11:0] WriteData    ,

input  wire        usb_uart_rxd ,
output wire        usb_uart_txd
    );
    
assign cam_pwdn = (Dbun) ? 1'b1 : 1'b0;
reg [19:0] ResetDelay;
always @(posedge clk or negedge rstn)
    if (!rstn) ResetDelay <= 20'h00000;
     else if (Dbun == 1'b1) ResetDelay <= 20'h00000;
     else if (ResetDelay == 20'h80000) ResetDelay <= 20'h80000;
     else ResetDelay <= ResetDelay + 1;     
assign cam_rstn = (ResetDelay == 20'h80000) ? 1'b1 : 1'b0;

/////////////////////////////////////////////////
////////////    MB SoC System     ///////////////
/////////////////////////////////////////////////
// Outputs
wire [31:0] APB_M_0_paddr;		//output [31:0] APB_M_0_paddr;
wire APB_M_0_penable;		//output  APB_M_0_penable;
wire [0:0] APB_M_0_psel;		//output [0:0] APB_M_0_psel;
wire [31:0] APB_M_0_pwdata;		//output [31:0] APB_M_0_pwdata;
wire APB_M_0_pwrite;		//output  APB_M_0_pwrite;
//Inputs
wire [31:0] APB_M_0_prdata ;		//input [31:0] APB_M_0_prdata;
wire [0:0] APB_M_0_pready  ;		//input [0:0] APB_M_0_pready;
wire [0:0] APB_M_0_pslverr ;		//input [0:0] APB_M_0_pslverr;
SCCB_MB_BD SCCB_MB_BD_inst
(
.reset(reset),		//input  reset

.APB_M_0_paddr(APB_M_0_paddr),		//output [31:0] APB_M_0_paddr
.APB_M_0_penable(APB_M_0_penable),        //output  APB_M_0_penable
.APB_M_0_prdata(APB_M_0_prdata),        //input [31:0] APB_M_0_prdata
.APB_M_0_pready(APB_M_0_pready),        //input [0:0] APB_M_0_pready
.APB_M_0_psel(APB_M_0_psel),        //output [0:0] APB_M_0_psel
.APB_M_0_pslverr(APB_M_0_pslverr),        //input [0:0] APB_M_0_pslverr
.APB_M_0_pwdata(APB_M_0_pwdata),        //output [31:0] APB_M_0_pwdata
.APB_M_0_pwrite(APB_M_0_pwrite),        //output  APB_M_0_pwrite
.Clk(clk),		//input  Clk
.rstn(rstn),        //output [0:0] rstn

.usb_uart_rxd(usb_uart_rxd),        //input  usb_uart_rxd
.usb_uart_txd(usb_uart_txd)        //output  usb_uart_txd
);    
wire        Start   ;
wire        Busy    ;
wire [31:0] DataOut ;
wire [31:0] DataIn  ;
wire [3:0]  WR;
wire [15:0] ClockDiv;
wire [15:0] NegDel  ;
RegisterBlock RegisterBlock_inst
(
.clk(clk),		//input  clk
.rstn(rstn),        //input [0:0] rstn

.APB_M_0_paddr   (APB_M_0_paddr  ),		//input [31:0] APB_M_0_paddr
.APB_M_0_penable (APB_M_0_penable),        //input  APB_M_0_penable
.APB_M_0_prdata  (APB_M_0_prdata ),        //output [31:0] APB_M_0_prdata
.APB_M_0_pready  (APB_M_0_pready ),        //output [0:0] APB_M_0_pready
.APB_M_0_psel    (APB_M_0_psel   ),        //input [0:0] APB_M_0_psel
.APB_M_0_pslverr (APB_M_0_pslverr),        //output [0:0] APB_M_0_pslverr
.APB_M_0_pwdata  (APB_M_0_pwdata ),        //input [31:0] APB_M_0_pwdata
.APB_M_0_pwrite  (APB_M_0_pwrite ),        //input  APB_M_0_pwrite

.Start   (Start   ), //output        Start,
.Busy    (Busy    ), //input         Busy,
.DataOut (DataOut ), //output [31:0] DataOut,
.DataIn  (DataIn  ), //input  [31:0] DataIn,
.WR      (WR)     ,  //output [3:0]  WR,
.ClockDiv(ClockDiv), //output [15:0] ClockDiv
.NegDel  (NegDel  )  //output [15:0] NegDel
);
wire [7:0] ReadData;
SCCB SCCB_inst(
.clk (clk ),
.rstn(rstn),

.ClkDiv(ClockDiv),
.NegDel(NegDel  ),

.Start(Start),
.WR(WR),
.DataIn(DataOut),
.Busy(Busy),
.ReadData(ReadData),

.sccb_clk     (sccb_clk     ),
.sccb_clk_en  (sccb_clk_en  ),
.sccb_data_out(sccb_data_out),
.sccb_data_in (sccb_data_in ),
.sccb_data_en (sccb_data_en )
);
assign DataIn = {24'h000000,ReadData};

/////////////////////////////////////////////////
/////////   Camera data processing   ////////////
/////////////////////////////////////////////////
reg [18:0] Reg_writeAdd;
reg [9:0] LineCount;
reg [1:0] DevHsync;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) DevHsync <= 2'b00;
     else DevHsync <= {DevHsync[0],cam_href};
wire SyncCamHsyncUP = (DevHsync == 2'b01) ? 1'b1 :1'b0;
wire SyncCamHsyncDO = (DevHsync == 2'b10) ? 1'b1 :1'b0;

always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) LineCount <= 10'h000;
     else if (cam_vsynk) LineCount <= 10'h000;
     else if (SyncCamHsyncUP) LineCount <= LineCount + 1;
     
reg Reg_writeEn;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) Reg_writeEn <= 1'b0;
     else if (!cam_href) Reg_writeEn <= 1'b0;
     else Reg_writeEn <= ~Reg_writeEn;

reg bCamData;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) bCamData <= 1'b0;
     else if (SyncCamVsync) bCamData <= ~bCamData;
     else if (SyncCamHsyncDO) bCamData <= ~bCamData;
     else if (Reg_writeEn) bCamData <= ~bCamData;

always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) Reg_writeAdd <= 19'h00000;
     else if (cam_vsynk) Reg_writeAdd <= 19'h00000;
     else if (WriteEn) Reg_writeAdd <= Reg_writeAdd + 1;
     
reg [3:0] Reg_RED;
always @(posedge cam_in_clk or negedge rstn)
    if  (!rstn) Reg_RED <= 4'h0;
     else Reg_RED <= cam_data[3:0];   

assign WriteEn   = Reg_writeEn && bCamData;
assign WriteAdd  = Reg_writeAdd;     
assign WriteData = {cam_data[3:0],cam_data[7:4],Reg_RED};
    
endmodule
