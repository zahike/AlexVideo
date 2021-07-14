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
force CandV_Top_inst.VGA_inst.clk = CandV_Top_inst.ila_clk;
end
CandV_Top CandV_Top_inst(
.reset       (rstn),
.sys_clock   (clk),

.SCCB_CLK    (SCCB_CLK) ,
.SCCB_DATA   (SCCB_DATA)
);

endmodule
