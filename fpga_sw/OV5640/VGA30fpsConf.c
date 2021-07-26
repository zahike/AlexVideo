/*
 * VGA30fpsConf.c
 *
 * This configuration is from:
 * doc  : OV5640 Auto Focus Camera Module Application Notes
 * page : 19
 *
 *  Created on: Jul 26, 2021
 *      Author: udi
 */

void VGA30fpsConf()
{

	writeSCCB(0x78310311); // system clock from pad, bit[1]
	writeSCCB(0x78300882); // software reset, bit[7]
	usleep(5000);
	writeSCCB(0x78300842); // software power down, bit[6]
	writeSCCB(0x78310303);// system clock from PLL, bit[1]
	writeSCCB(0x783017ff);// FREX, Vsync, HREF, PCLK, D[9:6] output enable
	writeSCCB(0x783018ff);// D[5:0], GPIO[1:0] output enable

	// YUV VGA 30fps, night mode 5fps
	// Input Clock = 24Mhz, PCLK = 56MHz
//	writeSCCB(0x78303511); // PLL
//	writeSCCB(0x78303646); // PLL
	writeSCCB(0x78303511); // PLL
	writeSCCB(0x78303646); // PLL
	writeSCCB(0x783c0708); // light meter 1 threshold [7:0]
	writeSCCB(0x78382041); // Sensor flip off, ISP flip on
	writeSCCB(0x78382107); // Sensor mirror on, ISP mirror on, H binning on
	writeSCCB(0x78381431); // X INC
	writeSCCB(0x78381531); // Y INC
	writeSCCB(0x78380000); // HS
	writeSCCB(0x78380100); // HS
	writeSCCB(0x78380200); // VS
	writeSCCB(0x78380304); // VS
	writeSCCB(0x7838040a); // HW (HE)
	writeSCCB(0x7838053f); // HW (HE)
	writeSCCB(0x78380607); // VH (VE)
	writeSCCB(0x7838079b); // VH (VE)
//	writeSCCB(0x78380802); // DVPHO
//	writeSCCB(0x78380980); // DVPHO
	writeSCCB(0x78380805); // DVPHO
	writeSCCB(0x78380900); // DVPHO
	writeSCCB(0x78380a01); // DVPVO
	writeSCCB(0x78380be0); // DVPVO
	writeSCCB(0x78380c07); // HTS
	writeSCCB(0x78380d68); // HTS
	writeSCCB(0x78380e03); // VTS
	writeSCCB(0x78380fd8); // VTS
	writeSCCB(0x78381306); // Timing Voffset
	writeSCCB(0x78361800);
	writeSCCB(0x78361229);
	writeSCCB(0x78370952);
	writeSCCB(0x78370c03);
	writeSCCB(0x783a0217); // 60Hz max exposure, night mode 5fps
	writeSCCB(0x783a0310); // 60Hz max exposure
	// banding filters are calculated automatically in camera driver
	//writeSCCB(0x783a0801); // B50 step
	//writeSCCB(0x783a0927); // B50 step
	//writeSCCB(0x783a0a00); // B60 step
	//writeSCCB(0x783a0bf6); // B60 step
	//writeSCCB(0x783a0e03); // 50Hz max band
	//writeSCCB(0x783a0d04); // 60Hz max band
	writeSCCB(0x783a1417); // 50Hz max exposure, night mode 5fps
	writeSCCB(0x783a1510); // 50Hz max exposure
	writeSCCB(0x78400402); // BLC 2 lines
	writeSCCB(0x7830021c); // reset JFIFO, SFIFO, JPEG
//	19 Company Confidential
//	OmniVision Confidential for BYD Only
//	OV5640 Auto FocusCamera Module Application Notes
	writeSCCB(0x783006c3); // disable clock of JPEG2x, JPEG
	writeSCCB(0x78471303); // JPEG mode 3
	writeSCCB(0x78440704); // Quantization scale
	writeSCCB(0x78460b35);
	writeSCCB(0x78460c22);
	writeSCCB(0x78483722); // DVP CLK divider
	writeSCCB(0x78382402); // DVP CLK divider
	writeSCCB(0x785001a3); // SDE on, scale on, UV average off, color matrix on, AWB on
	writeSCCB(0x78350300); // AEC/AGC on};

	writeSCCB(0x78300802); // wake up from standby, bit[6]

};

