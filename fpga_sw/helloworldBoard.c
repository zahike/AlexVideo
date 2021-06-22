/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "SCCB.h"

u32 *APB = XPAR_APB_M_0_BASEADDR;
u32 *UART = XPAR_UARTLITE_0_BASEADDR;

int writeSCCB (int WriteData);
int write4readSCCB (int WriteData);
int readSCCB (int WriteData);

//int writeSCCB (int WriteData)
//{
//	int data;
//
//	APB[2] = WriteData;
//	APB[0] = 1;
//	data = 1;
//	while (data)
//	{
//		data = APB[1];
//	};
//};
//
//int write4readSCCB (int WriteData)
//{
//	int data;
//
//	APB[2] = WriteData;
//	APB[0] = 1;
//	data = 1;
//	while (data)
//	{
//		data = APB[1];
//	};
//};
//
//int readSCCB (int WriteData)
//{
//	int data;
//
//	APB[2] = WriteData;
//	APB[0] = 1;
//	data = 1;
//	while (data)
//	{
//		data = APB[1];
//	};
//	data = APB[3];
//	return data;
//};

int main()
{
	int i;
    char ch,ch1,ch2;
	int data,Rdata;
	int ChUart;
	int Uread;
	int freq;
    init_platform();

    xil_printf ("\n\rhello world\n\r");

    APB[4] = 0x100; // set SCCB clock to ~200Khz
    APB[5] = 0x0;  // delay from negedge to data

    while (1)
    {
    	int i;
    	ch = 0;
    	data = 0;
    	while (ch != 13)
    	{

    	Uread = 0;
    	while (!(Uread & 0x00000001)){
    		Uread = UART[2];
    	}
    	ch = UART[0];
    	xil_printf ("%c",ch);
    	if (ch == 13) xil_printf("\n\r");
    	 else if (ch == 127)  data = data/16;
    	 else if ((ch>47) && (ch<58))  data = (16*data)+ ch - 48;
    	 else if ((ch>96) && (ch<103)) data = (16*data)+ ch - 87;
    	};
    	if (data < 0x10){
    		APB[5] = 0x10*data;
    		xil_printf("delay %d nSec\r\n",160*data);
    	} else if (data < 0x1000) {
    		APB[4] = data;
    		freq = 1000000/(data*20);
    		xil_printf("frequency %d \n\r",freq);
    	} else if (data < 0x10000){
    		write4readSCCB(0x1000000 | (data << 8));
    		Rdata = readSCCB(0x2000000 | (data << 8));
    	    xil_printf ("\n\r read from %x data %x \n\r",data,Rdata);
    	} else if (data < 0x1000000){
    		 writeSCCB(data);
    	xil_printf ("\n\rwrite data %x\n\r",data);
    	};

    };

    cleanup_platform();
    return 0;
}
