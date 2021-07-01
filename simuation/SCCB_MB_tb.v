`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2021 21:27:31
// Design Name: 
// Module Name: SCCB_MB_tb
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


module SCCB_MB_tb();
reg clk;
reg rstn;
initial begin 
clk = 1'b0;
rstn = 1'b0;
#100;
rstn = 1'b1;
end
always #5 clk = ~clk;

initial begin 
@(posedge SCCB_MB_Top_inst.SCCB_inst.rstn);
force SCCB_MB_Top_inst.WDrstnCount = 20'hffff0;
release SCCB_MB_Top_inst.WDrstnCount;
end 
wire SCCB_CLK ;
wire SCCB_DATA;

reg SendData;
reg [7:0] checkData;
reg [3:0] SCCBcount;
reg [8:0] ReadData;
always @(posedge SCCB_CLK) checkData <= {checkData[8:0],SCCB_DATA};
always @(negedge SCCB_CLK) 
    if (checkData == 8'h79) SendData <= 1'b1;
     else if (SCCBcount == 4'h8) SendData <= 1'b0;
always @(negedge SCCB_CLK) 
    if (!SendData) SCCBcount <= 4'h0;
     else SCCBcount <= SCCBcount + 1;
always @(negedge SCCB_CLK)
    if (!SendData) ReadData <= 9'h055;
     else ReadData <= {ReadData[7:0],1'b0};

assign SCCB_DATA = (SendData) ? ReadData[8] : 1'bz;               
initial begin
SendData = 1'b0;
#40000;
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
//force SCCB_MB_Top_inst.SCCB_inst.Start = 1'b1;
//@(posedge clk);
//release SCCB_MB_Top_inst.SCCB_inst.Start;
end 
wire  usb_uart_rxd =1'b0;
wire  usb_uart_txd;


//PULLUP U0 (.O (SCCB_DATA));
SCCB_MB_Top SCCB_MB_Top_inst(
.reset       (rstn),
.sys_clock   (clk),

.SCCB_CLK    (SCCB_CLK) ,
.SCCB_DATA   (SCCB_DATA),

.usb_uart_rxd(usb_uart_rxd),
.usb_uart_txd(usb_uart_txd)
    );

endmodule
