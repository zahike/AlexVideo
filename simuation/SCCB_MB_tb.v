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
wire  usb_uart_rxd =1'b0;
wire  usb_uart_txd;

wire SCCB_DATA;
//PULLUP U0 (.O (SCCB_DATA));
SCCB_MB_Top SCCB_MB_Top_inst(
.reset       (rstn),
.sys_clock   (clk),

.SCCB_DATA   (SCCB_DATA),

.usb_uart_rxd(usb_uart_rxd),
.usb_uart_txd(usb_uart_txd)
    );

endmodule
