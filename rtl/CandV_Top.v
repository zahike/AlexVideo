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

input  usb_uart_rxd,
output  usb_uart_txd

    );

assign DeBug_cam_clk    = cam_clk   ;
assign DeBug_cam_in_clk = cam_in_clk;
//assign DeBug_cam_clk    = cam_vsynk   ;
//assign DeBug_cam_in_clk = VSYNC;

wire clk;		//output  clk;
wire rstn;		//output [0:0] rstn;
// Camera reset & PowerDown
assign cam_pwdn = (Dbun) ? 1'b1 : 1'b0;
reg [19:0] ResetDelay;
always @(posedge cam_clk or negedge rstn)
    if (!rstn) ResetDelay <= 20'h00000;
     else if (Dbun == 1'b1) ResetDelay <= 20'h00000;
     else if (ResetDelay == 20'h80000) ResetDelay <= 20'h80000;
     else ResetDelay <= ResetDelay + 1;     
assign cam_rstn = (ResetDelay == 20'h80000) ? 1'b1 : 1'b0;
// SCCB signals
wire sccb_clk      ;
wire sccb_clk_en   ;
wire sccb_data_out ;
wire sccb_data_in  ;
wire sccb_data_en  ;
assign SCCB_CLK  = (sccb_clk_en) ? sccb_clk : 1'b1;
assign SCCB_DATA = (~sccb_data_en) ? sccb_data_out : 1'bz;
assign sccb_data_in = SCCB_DATA;

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

wire ila_clk;

SCCB_MB_BD SCCB_MB_BD_inst
(
.reset(reset),		//input  reset
.sys_clock(sys_clock),        //input  sys_clock

.APB_M_0_paddr(APB_M_0_paddr),		//output [31:0] APB_M_0_paddr
.APB_M_0_penable(APB_M_0_penable),        //output  APB_M_0_penable
.APB_M_0_prdata(APB_M_0_prdata),        //input [31:0] APB_M_0_prdata
.APB_M_0_pready(APB_M_0_pready),        //input [0:0] APB_M_0_pready
.APB_M_0_psel(APB_M_0_psel),        //output [0:0] APB_M_0_psel
.APB_M_0_pslverr(APB_M_0_pslverr),        //input [0:0] APB_M_0_pslverr
.APB_M_0_pwdata(APB_M_0_pwdata),        //output [31:0] APB_M_0_pwdata
.APB_M_0_pwrite(APB_M_0_pwrite),        //output  APB_M_0_pwrite
.clk(clk),		//output  clk
.rstn(rstn),        //output [0:0] rstn

.cam_clk(cam_clk),
.ila_clk(ila_clk),

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

reg [18:0] writeAdd;
//wire [11:0] writeData;
//wire writeEN = rstn;

//reg TakePic;
//reg PicTaken;
reg [9:0] LineCount;

reg [1:0] DevHsync;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) DevHsync <= 2'b00;
     else DevHsync <= {DevHsync[0],cam_href};
wire SyncCamHsyncUP = (DevHsync == 2'b01) ? 1'b1 :1'b0;
wire SyncCamHsyncDO = (DevHsync == 2'b10) ? 1'b1 :1'b0;

reg [1:0] DevCamVsync;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) DevCamVsync <= 2'b00;
     else DevCamVsync <= {DevCamVsync[0],cam_vsynk};
wire SyncCamVsync = (DevCamVsync == 2'b01) ? 1'b1 :1'b0;
     
//always @(posedge cam_clk or negedge rstn)
//    if (!rstn) TakePic <= 1'b0;
//     else if (Ubun) TakePic <= 1'b1;
//     else if (Rbun) TakePic <= 1'b0;

//always @(posedge cam_clk or negedge rstn)
//    if (!rstn) PicTaken <= 1'b0;
//     else if (!TakePic) PicTaken <= 1'b0;
//     else if (cam_vsynk && (LineCount == 10'h000)) PicTaken <= 1'b1;
//     else if (cam_vsynk) PicTaken <= 1'b0;
     
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) LineCount <= 10'h000;
//     else if (!TakePic) LineCount <= 10'h000;
//    else if (PicTaken && (SyncCamHsyncUP)) LineCount <= LineCount + 1;
     else if (cam_vsynk) LineCount <= 10'h000;
     else if (SyncCamHsyncUP) LineCount <= LineCount + 1;
     
reg writeEN;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) writeEN <= 1'b0;
     else if (!cam_href) writeEN <= 1'b0;
     else writeEN <= ~writeEN;

reg [3:0] Reg_RED;
always @(posedge cam_in_clk or negedge rstn)
    if  (!rstn) Reg_RED <= 4'h0;
     else Reg_RED <= cam_data[3:0];   
     
//always @(posedge cam_in_clk or negedge rstn)
//    if (!rstn) writeAdd <= 19'h00000;
//     else if (cam_vsynk) writeAdd <= 19'h00000;
//     else if (writeEN) writeAdd <= writeAdd + 1;
//assign writeData = writeAdd[18:9];

wire ReadMem;
reg [19:0] ROMadd;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) ROMadd <= 20'h00000;
     else if (!VSYNC) ROMadd <= 20'h00000;
     else if (ReadMem) ROMadd <= ROMadd + 1;

//wire [11:0] StaticData = 
//                         (writeAdd == 19'd00000) ? 12'hfff :
////                         (writeAdd == 19'd00001) ? 12'hfff :
////                         (writeAdd == 19'd00002) ? 12'hfff :
////                         (writeAdd == 19'd00003) ? 12'hfff :
//                         (writeAdd == 19'd00639) ? 12'hfff :
////                         (writeAdd == 19'd00638) ? 12'hfff :
////                         (writeAdd == 19'd00637) ? 12'hfff :
////                         (writeAdd == 19'd00636) ? 12'hfff :
////                         (writeAdd == 19'd01279) ? 12'hfff :
////                         (writeAdd == 19'd01280) ? 12'hfff :
////                         (writeAdd == 19'd01919) ? 12'hfff :
////                         (writeAdd == 19'd01910) ? 12'hfff :
////                         (writeAdd == 19'd304639) ? 12'hfff :
////                         (writeAdd == 19'd304640) ? 12'hfff :
////                         (writeAdd == 19'd305279) ? 12'hfff :
////                         (writeAdd == 19'd305280) ? 12'hfff :
////                         (writeAdd == 19'd305919) ? 12'hfff :
////                         (writeAdd == 19'd305920) ? 12'hfff :
////                         (writeAdd == 19'd306559) ? 12'hfff :                         
//                         (writeAdd == 19'd306560) ? 12'hfff :
////                         (writeAdd == 19'd306561) ? 12'hfff :
////                         (writeAdd == 19'd306562) ? 12'hfff :
////                         (writeAdd == 19'd306563) ? 12'hfff :                         
////                         (writeAdd == 19'd307196) ? 12'hfff :
////                         (writeAdd == 19'd307197) ? 12'hfff :
////                         (writeAdd == 19'd307198) ? 12'hfff :
//                         (writeAdd == 19'd307199) ? 12'hfff : 12'h00f;

reg [18:0] StaticAdd;
always @(posedge cam_in_clk or negedge rstn) 
    if (!rstn) StaticAdd <= 19'h00000;
     else if (StaticAdd == 307199) StaticAdd <= 19'h00000;
     else StaticAdd <= StaticAdd + 1;  

wire [11:0] Data2RAM = {cam_data[3:0],cam_data[7:4],Reg_RED};
reg bCamData;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) bCamData <= 1'b0;
     else if (SyncCamVsync) bCamData <= ~bCamData;
     else if (SyncCamHsyncDO) bCamData <= ~bCamData;
     else if (writeEN) bCamData <= ~bCamData;

wire WriteAfterBlock = writeEN && bCamData;

always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) writeAdd <= 19'h00000;
     else if (cam_vsynk) writeAdd <= 19'h00000;
     else if (WriteAfterBlock) writeAdd <= writeAdd + 1;

//reg [11:0] mem [0:307199];
reg [11:0] mem [0:153599];
//wire [18:0] ROMadd;
reg [11:0] ROWdata;
//wire ReadRAMadd = ROMadd[20:1]
always @(posedge cam_in_clk) 
    if (WriteAfterBlock) mem[writeAdd] <= Data2RAM;
//always @(posedge cam_in_clk) 
//    if (rstn) mem[StaticAdd] <= StaticAdd[11:0];
always @(posedge cam_in_clk)
        ROWdata <= mem[ROMadd[19:1]];

reg [1:0] DevVSYNC;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) DevVSYNC <= 2'b00;
     else DevVSYNC <= {DevVSYNC[0],VSYNC};

wire SyncVGAVSYNC = (DevVSYNC == 2'b01) ? 1'b1 :1'b0;

reg SendVGA;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) SendVGA <= 1'b0;
     else SendVGA <= ReadMem;
reg bVGA;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) bVGA <= 1'b0;
     else if (SyncVGAVSYNC) bVGA <= ~bVGA;
     else if (!SendVGA && ReadMem) bVGA <= ~bVGA;
     else if (SendVGA) bVGA <= ~bVGA; 
wire [11:0] VGAdata = (SendVGA && !bVGA) ? ROWdata : 12'h000;

     
VGA VGA_inst(
.clk  (cam_in_clk  ),
.rstn (rstn ),

.SyncVsync(SyncCamVsync),
.ROWdata(VGAdata),
.ReadMem(ReadMem),

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
     
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
     ila_0 Cam_ila (
         .clk(ila_clk), // input wire clk
 
 	     .probe0(cam_vsynk), // input wire [0:0]  probe0  
         .probe1(cam_href ), // input wire [0:0]  probe1 
         .probe2(writeAdd), // input wire [19:0]  probe2 
         .probe3(VSYNC), // input wire [0:0]  probe3 
         .probe4(HSYNC), // input wire [0:0]  probe4 
         .probe5(ROMadd) // input wire [19:0]  probe5
     );
     
/*
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ila_0 Cam_ila (
	.clk(ila_clk), // input wire clk

	.probe0 (cam_vsynk ), // input wire [0:0]  probe0  
	.probe1 (cam_href  ), // input wire [0:0]  probe1 
	.probe2 (cam_data  ), // input wire [7:0]  probe2 
	.probe3 (TakePic   ), // input wire [0:0]  probe3 
	.probe4 (PicTaken  ), // input wire [0:0]  probe4 
	.probe5 (LineCount ), // input wire [9:0]  probe5 
	.probe6 (writeEN   ), // input wire [0:0]  probe6 
	.probe7 (Reg_RED   ), // input wire [3:0]  probe7 
	.probe8 (writeAdd[17:0]), // input wire [19:0]  probe8 
	.probe9 (ROMadd[17:0]  ), // input wire [18:0]  probe9 
	.probe10({BLU,GRN,RED}   ), // input wire [11:0]  probe10 
	.probe11(HSYNC     ), // input wire [0:0]  probe11 
	.probe12(VSYNC     ), // input wire [0:0]  probe12
	.probe13(ReadMem   ) // input wire [0:0]  probe13
		
);

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
