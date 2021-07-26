`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2021 16:32:12
// Design Name: 
// Module Name: MemoryBlock
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


module MemoryBlock(
input  clk,
input Rclk,

input  WriteEn,
input  [18:0] WriteAdd,
input  [11:0] WriteData,

input  [18:0] ReadAdd,
output [11:0] ReadData
    );

//reg [11:0] mem [0:307199];
reg [11:0] mem [0:153599];
reg [11:0] Reg_Data;
always @(posedge clk) 
    if (WriteEn) mem[WriteAdd] <= WriteData;
always @(posedge Rclk)
        Reg_Data <= mem[ReadAdd];
        
assign ReadData = Reg_Data;    
endmodule
