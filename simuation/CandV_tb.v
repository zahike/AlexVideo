`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2021 12:50:05
// Design Name: 
// Module Name: CandV_tb
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


module CandV_tb();
reg clk;
reg rstn;
initial begin 
clk = 1'b0;
rstn = 1'b0;
#100;
rstn = 1'b1;
end
always #5 clk = ~clk;

wire SCCB_CLK ;
wire SCCB_DATA;

reg [1:0] DevSCCB_CLK;
always @(posedge clk or negedge rstn)
    if (!rstn) DevSCCB_CLK <= 2'b00;
     else DevSCCB_CLK <= {DevSCCB_CLK,SCCB_CLK};
wire SCCB_CLKpos = (DevSCCB_CLK == 2'b01) ? 1'b1 : 1'b0;      
wire SCCB_CLKneg = (DevSCCB_CLK == 2'b10) ? 1'b1 : 1'b0;  
reg [1:0] DevSCCB_DATA;
always @(posedge clk or negedge rstn)
    if (!rstn) DevSCCB_DATA <= 2'b00;
     else DevSCCB_DATA <= {DevSCCB_DATA,SCCB_DATA};
wire SCCB_DATApos = (DevSCCB_DATA == 2'b01) ? 1'b1 : 1'b0;      
wire SCCB_DATAneg = (DevSCCB_DATA == 2'b10) ? 1'b1 : 1'b0;  

reg StartBit;
reg [1:0]StopBit;    
reg SCCBon;
reg [7:0] checkData;
reg [5:0] SCCBcount;
reg [8:0] ReadData;
reg SendData;
always @(posedge SCCB_CLK) checkData <= {checkData[8:0],SCCB_DATA};
always @(posedge clk or negedge rstn)
    if (!rstn) StartBit <= 1'b0;
     else if (!SCCBon && SCCB_DATAneg) StartBit <= 1'b1;
     else if (SCCB_CLKneg) StartBit <= 1'b0; 
always @(posedge clk or negedge rstn)
    if (!rstn) StopBit <= 2'b00;
     else if (!SCCBon || SCCB_CLKneg) StopBit <= 2'b00; 
     else if (SCCB_CLKpos && !SCCB_DATA) StopBit <= 2'b01;
     else if ((StopBit == 2'b01) && SCCB_DATApos) StopBit <= 2'b10;
always @(posedge clk or negedge rstn)
         if (!rstn) SCCBon <= 1'b0;
          else if (StartBit && SCCB_CLKneg) SCCBon <= 1'b1;
          else if (StopBit == 2'b10) SCCBon <= 1'b0;
always @(negedge SCCB_CLK) 
    if (!SCCBon) SCCBcount <= 6'h00;
     else SCCBcount <= SCCBcount + 1;


always @(negedge SCCB_CLK) 
    if ((SCCBcount == 6'h07) && SCCB_DATA) SendData <= 1'b1;
     else if (SCCBcount == 6'h10) SendData <= 1'b0;
always @(negedge SCCB_CLK)
    if (!SendData) ReadData <= 9'h055;
     else ReadData <= {ReadData[7:0],1'b0};

assign SCCB_DATA = (SendData) ? ReadData[8] : 1'bz;               
initial begin
SendData = 1'b0;
//force CandV_Top_inst.cam_in_clk = CandV_Top_inst.ila_clk;
end

wire       cam_in_clk ;
wire        cam_vsynk  ;
wire        cam_href   ;
wire [7:0]  cam_data   ;

reg [1:0] DevClk;
always @(posedge clk or negedge rstn)
    if (!rstn) DevClk <= 2'b00;
     else DevClk <= DevClk + 1;
assign cam_in_clk =  DevClk[1];
reg [31:0] TimeCounter;
always @(posedge cam_in_clk or negedge rstn) 
    if (!rstn) TimeCounter <= 833570;
     else if (TimeCounter == 833599) TimeCounter <= 32'h00000000;
     else TimeCounter<= TimeCounter + 1;

reg RegCamVsync;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) RegCamVsync <= 1'b0;
     else if (TimeCounter == 833597) RegCamVsync <= 1'b1;
     else if (TimeCounter == 4797) RegCamVsync <= 1'b0;

reg RegCamDisp;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) RegCamDisp <= 1'b0;
     else if (TimeCounter == 49870) RegCamDisp <= 1'b1;
     else if (TimeCounter == 817870) RegCamDisp <= 1'b0;

reg [11:0] RegHsyncCount;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) RegHsyncCount <= 12'h000;
     else if (!RegCamDisp) RegHsyncCount <= 12'h000;
     else if (RegHsyncCount == 1599) RegHsyncCount <= 12'h000;
     else RegHsyncCount <= RegHsyncCount + 1;   

reg RegCamHsync;
always @(posedge cam_in_clk or negedge rstn)
    if (!rstn) RegCamHsync <= 1'b0;
     else if (!RegCamDisp) RegCamHsync <= 1'b0;
     else if (RegHsyncCount == 0) RegCamHsync <= 1'b1;      
     else if (RegHsyncCount == 1280) RegCamHsync <= 1'b0;      
            
assign cam_vsynk = RegCamVsync;
assign cam_href = RegCamHsync;
assign cam_data = (RegCamHsync) ? TimeCounter[7:0] : 8'h00;
     
initial begin
@(rstn);
#100;
 
end 
CandV_Top CandV_Top_inst(
.reset       (rstn),
.sys_clock   (clk),

.cam_in_clk (cam_in_clk),
.cam_vsynk  (cam_vsynk ),
.cam_href   (cam_href  ),
.cam_data   (cam_data  ),

.SCCB_CLK    (SCCB_CLK) ,
.SCCB_DATA   (SCCB_DATA)
);

endmodule
