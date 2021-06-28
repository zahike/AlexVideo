`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2021 18:06:06
// Design Name: 
// Module Name: SCCB_MB_Top
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


module SCCB_MB_Top(
input  reset,
input  sys_clock,

output wire SCCB_CLK,
inout  wire SCCB_DATA,

input       Dbun       ,
output      cam_clk    ,
input       cam_in_clk ,
input       cam_vsynk  ,
input       cam_href   ,
input [7:0] cam_data   ,
output      cam_rstn   ,
output      cam_pwdn   ,

input  usb_uart_rxd,
output  usb_uart_txd

    );


wire clk;		//output  clk;
wire [0:0] rstn;		//output [0:0] rstn;
//wire SCCB_DATAin = SCCB_DATA;
wire sccb_clk      ;
wire sccb_clk_en   ;
wire sccb_data_out ;
wire sccb_data_in  ;
wire sccb_data_en  ;

assign SCCB_CLK  = (sccb_clk_en) ? sccb_clk : 1'b1;
assign SCCB_DATA = (~sccb_data_en) ? sccb_data_out : 1'bz;

assign sccb_data_in = SCCB_DATA;

assign cam_pwdn = (Dbun) ? 1'b1 : 1'b0;
reg [19:0] ResetDelay;
always @(posedge clk or negedge rstn)
    if (!rstn) ResetDelay <= 20'h00000;
     else if (Dbun == 1'b1) ResetDelay <= 20'h00000;
     else if (ResetDelay == 20'h80000) ResetDelay <= 20'h80000;
     else ResetDelay <= ResetDelay + 1;
     
//assign cam_rstn = (!Dbun) ? 1'b1 : 1'b0;
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
.ClockDiv(ClockDiv), //output [15:0] ClockDiv
.NegDel  (NegDel  )  //output [15:0] NegDel

);

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ila_1 APB_ila (
	.clk(clk), // input wire clk

	.probe0(APB_M_0_paddr  ), // input wire [31:0]  probe0  
	.probe1(APB_M_0_penable), // input wire [0:0]  probe1 
	.probe2(APB_M_0_prdata ), // input wire [31:0]  probe2 
	.probe3(APB_M_0_pready ), // input wire [0:0]  probe3 
	.probe4(APB_M_0_psel   ), // input wire [0:0]  probe4 
	.probe5(APB_M_0_pslverr), // input wire [0:0]  probe5 
	.probe6(APB_M_0_pwdata ), // input wire [31:0]  probe6 
	.probe7(APB_M_0_pwrite ), // input wire [0:0]  probe7 
	.probe8(Start), // input wire [0:0]  probe8
	.probe9(Busy) // input wire [0:0]  probe9
	);

wire [7:0] ReadData;
//wire       SCCB_CLK ;
//wire       SCCB_DATA;

SCCB SCCB_inst(
.clk (clk ),
.rstn(rstn),

.ClkDiv(ClockDiv),
.NegDel(NegDel  ),

.Start(Start),
.DataIn(DataOut[25:0]),
.Busy(Busy),
.ReadData(ReadData),

.sccb_clk     (sccb_clk     ),
.sccb_clk_en  (sccb_clk_en  ),
.sccb_data_out(sccb_data_out),
.sccb_data_in (sccb_data_in ),
.sccb_data_en (sccb_data_en )

//.SCCB_CLK (SCCB_CLK ),
//.SCCB_DATA(SCCB_DATA)

    );
reg[19:0] WDrstnCount;
always @(posedge clk or negedge rstn)
    if (!rstn) WDrstnCount <= 20'h00000;
     else if (!SCCB_CLK || !sccb_data_in )WDrstnCount <= 20'h00000;
     else if (WDrstnCount == 20'hfffff) WDrstnCount <= 20'hfffff;
     else WDrstnCount <= WDrstnCount + 1;

wire WDrstn = (WDrstnCount == 20'hfffff) ? 1'b0 : 1'b1;
reg [7:0] BitCount;
always @(negedge SCCB_CLK or negedge WDrstn)
    if (!WDrstn) BitCount <= 8'h00;
     else BitCount <= BitCount + 1;
     
reg [11:0] GetData;
always @(posedge SCCB_CLK or negedge WDrstn)
    if (!WDrstn) GetData <= 12'h000;
     else GetData <= {GetData[10:0],sccb_data_in};

ila_0 your_instance_name (
	.clk(ila_clk), // input wire clk

//	.probe0(WDrstn), // input wire [0:0]  probe0  
//	.probe0(cam_rstn), // input wire [0:0]  probe0  
	.probe0(sccb_data_en), // input wire [0:0]  probe0  
	.probe1(SCCB_CLK), // input wire [0:0]  probe1 
	.probe2(sccb_data_in), // input wire [0:0]  probe2 
	.probe3(BitCount), // input wire [7:0]  probe3 
	.probe4(GetData[9:2]) // input wire [7:0]  probe4
);

assign DataIn = {24'h000000,ReadData};

endmodule
