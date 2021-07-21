/*
 * CamConfig.c
 *
 *  Created on: Jul 4, 2021
 *      Author: udi
 */

void Camera_config()
{

	//15fps VGA YUV output
	// 24MHz input clock, 24MHz PCLK
writeSCCB(0x78310311); // system clock from pad, bit[1]
writeSCCB(0x78300882); // software reset, bit[7]
usleep(5000);
	// delay 5ms
writeSCCB(0x78300842); // software power down, bit[6]
//writeSCCB(0x78310303); // system clock from PLL, bit[1]
writeSCCB(0x78310301); // system clock from pin, bit[1]
writeSCCB(0x783017ff); // FREX, Vsync, HREF, PCLK, D[9:6] output enable
writeSCCB(0x783018ff); // D[5:0], GPIO[1:0] output enable
writeSCCB(0x7830341a); // MIPI 10-bit
writeSCCB(0x78303713); // PLL root divider, bit[4], PLL pre-divider, bit[3:0]
writeSCCB(0x78310801); // PCLK root divider, bit[5:4], SCLK2x root divider, bit[3:2]

//writeSCCB(0x78460c22); // PCLK root divider, bit[5:4], SCLK2x root divider, bit[3:2]
//writeSCCB(0x78382408); // PCLK root divider, bit[5:4], SCLK2x root divider, bit[3:2]
////writeSCCB(0x78460c20); // PCLK root divider, bit[5:4], SCLK2x root divider, bit[3:2]

	             // SCLK root divider, bit[1:0]
writeSCCB(0x78363036);
writeSCCB(0x7836310e);
writeSCCB(0x783632e2);
writeSCCB(0x78363312);
writeSCCB(0x783621e0);
writeSCCB(0x783704a0);
writeSCCB(0x7837035a);
writeSCCB(0x78371578);
writeSCCB(0x78371701);
writeSCCB(0x78370b60);
writeSCCB(0x7837051a);
writeSCCB(0x78390502);
writeSCCB(0x78390610);
writeSCCB(0x7839010a);
writeSCCB(0x78373112);
writeSCCB(0x78360008); // VCM control
writeSCCB(0x78360133); // VCM control
writeSCCB(0x78302d60); // system control
writeSCCB(0x78362052);
writeSCCB(0x78371b20);
writeSCCB(0x78471c50);
writeSCCB(0x783a1343); // pre-gain = 1.047x
writeSCCB(0x783a1800); // gain ceiling
writeSCCB(0x783a19f8); // gain ceiling = 15.5x
writeSCCB(0x78363513);
writeSCCB(0x78363603);
writeSCCB(0x78363440);
writeSCCB(0x78362201);
//	             14 Company Confidential
//	             OmniVision Confidential for BYD Only
//	             OV5640 Auto FocusCamera Module Application Notes
	             // 50/60Hz detection
writeSCCB(0x783c0134); // Band auto, bit[7]
writeSCCB(0x783c0428); // threshold low sum
writeSCCB(0x783c0598); // threshold high sum
writeSCCB(0x783c0600); // light meter 1 threshold[15:8]
writeSCCB(0x783c0708); // light meter 1 threshold[7:0]
writeSCCB(0x783c0800); // light meter 2 threshold[15:8]
writeSCCB(0x783c091c); // light meter 2 threshold[7:0]
writeSCCB(0x783c0a9c); // sample number[15:8]
writeSCCB(0x783c0b40); // sample number[7:0]
writeSCCB(0x78381000); // Timing Hoffset[11:8]
writeSCCB(0x78381110); // Timing Hoffset[7:0]
writeSCCB(0x78381200); // Timing Voffset[10:8]
writeSCCB(0x78370864);
writeSCCB(0x78400102); // BLC start from line 2
writeSCCB(0x7840051a); // BLC always update
writeSCCB(0x78300000); // enable blocks
writeSCCB(0x783004ff); // enable clocks
writeSCCB(0x78300e58); // MIPI power down, DVP enable
writeSCCB(0x78302e00);
writeSCCB(0x78430030); // YUV 422, YUYV
writeSCCB(0x78501f00); // YUV 422
writeSCCB(0x78440e00);
writeSCCB(0x785000a7); // Lenc on, raw gamma on, BPC on, WPC on, CIP on
	             // AEC target
writeSCCB(0x783a0f30); // stable range in high
writeSCCB(0x783a1028); // stable range in low
writeSCCB(0x783a1b30); // stable range out high
writeSCCB(0x783a1e26); // stable range out low
writeSCCB(0x783a1160); // fast zone high
writeSCCB(0x783a1f14); // fast zone low
	             // Lens correction for ?
writeSCCB(0x78580023);
writeSCCB(0x78580114);
writeSCCB(0x7858020f);
writeSCCB(0x7858030f);
writeSCCB(0x78580412);
writeSCCB(0x78580526);
writeSCCB(0x7858060c);
writeSCCB(0x78580708);
writeSCCB(0x78580805);
writeSCCB(0x78580905);
writeSCCB(0x78580a08);
writeSCCB(0x78580b0d);
//	             15 Company Confidential
//	             OmniVision Confidential for BYD Only
//	             OV5640 Auto FocusCamera Module Application Notes
writeSCCB(0x78580c08);
writeSCCB(0x78580d03);
writeSCCB(0x78580e00);
writeSCCB(0x78580f00);
writeSCCB(0x78581003);
writeSCCB(0x78581109);
writeSCCB(0x78581207);
writeSCCB(0x78581303);
writeSCCB(0x78581400);
writeSCCB(0x78581501);
writeSCCB(0x78581603);
writeSCCB(0x78581708);
writeSCCB(0x7858180d);
writeSCCB(0x78581908);
writeSCCB(0x78581a05);
writeSCCB(0x78581b06);
writeSCCB(0x78581c08);
writeSCCB(0x78581d0e);
writeSCCB(0x78581e29);
writeSCCB(0x78581f17);
writeSCCB(0x78582011);
writeSCCB(0x78582111);
writeSCCB(0x78582215);
writeSCCB(0x78582328);
writeSCCB(0x78582446);
writeSCCB(0x78582526);
writeSCCB(0x78582608);
writeSCCB(0x78582726);
writeSCCB(0x78582864);
writeSCCB(0x78582926);
writeSCCB(0x78582a24);
writeSCCB(0x78582b22);
writeSCCB(0x78582c24);
writeSCCB(0x78582d24);
writeSCCB(0x78582e06);
writeSCCB(0x78582f22);
writeSCCB(0x78583040);
writeSCCB(0x78583142);
writeSCCB(0x78583224);
writeSCCB(0x78583326);
writeSCCB(0x78583424);
writeSCCB(0x78583522);
writeSCCB(0x78583622);
writeSCCB(0x78583726);
writeSCCB(0x78583844);
writeSCCB(0x78583924);
writeSCCB(0x78583a26);
writeSCCB(0x78583b28);
//	             16 Company Confidential
//	             OmniVision Confidential for BYD Only
//	             OV5640 Auto FocusCamera Module Application Notes
writeSCCB(0x78583c42);
writeSCCB(0x78583dce); // lenc BR offset
	             // AWB
writeSCCB(0x785180ff); // AWB B block
writeSCCB(0x785181f2); // AWB control
writeSCCB(0x78518200); // [7:4] max local counter, [3:0] max fast counter
writeSCCB(0x78518314); // AWB advanced
writeSCCB(0x78518425);
writeSCCB(0x78518524);
writeSCCB(0x78518609);
writeSCCB(0x78518709);
writeSCCB(0x78518809);
writeSCCB(0x78518975);
writeSCCB(0x78518a54);
writeSCCB(0x78518be0);
writeSCCB(0x78518cb2);
writeSCCB(0x78518d42);
writeSCCB(0x78518e3d);
writeSCCB(0x78518f56);
writeSCCB(0x78519046);
writeSCCB(0x785191f8); // AWB top limit
writeSCCB(0x78519204); // AWB bottom limit
writeSCCB(0x78519370); // red limit
writeSCCB(0x785194f0); // green limit
writeSCCB(0x785195f0); // blue limit
writeSCCB(0x78519603); // AWB control
writeSCCB(0x78519701); // local limit
writeSCCB(0x78519804);
writeSCCB(0x78519912);
writeSCCB(0x78519a04);
writeSCCB(0x78519b00);
writeSCCB(0x78519c06);
writeSCCB(0x78519d82);
writeSCCB(0x78519e38); // AWB control
	             // Gamma
writeSCCB(0x78548001); // Gamma bias plus on, bit[0]
writeSCCB(0x78548108);
writeSCCB(0x78548214);
writeSCCB(0x78548328);
writeSCCB(0x78548451);
writeSCCB(0x78548565);
writeSCCB(0x78548671);
writeSCCB(0x7854877d);
writeSCCB(0x78548887);
writeSCCB(0x78548991);
writeSCCB(0x78548a9a);
//	             17 Company Confidential
//	             OmniVision Confidential for BYD Only
//	             OV5640 Auto FocusCamera Module Application Notes
writeSCCB(0x78548baa);
writeSCCB(0x78548cb8);
writeSCCB(0x78548dcd);
writeSCCB(0x78548edd);
writeSCCB(0x78548fea);
writeSCCB(0x7854901d);
	             // color matrix
writeSCCB(0x7853811e); // CMX1 for Y
writeSCCB(0x7853825b); // CMX2 for Y
writeSCCB(0x78538308); // CMX3 for Y
writeSCCB(0x7853840a); // CMX4 for U
writeSCCB(0x7853857e); // CMX5 for U
writeSCCB(0x78538688); // CMX6 for U
writeSCCB(0x7853877c); // CMX7 for V
writeSCCB(0x7853886c); // CMX8 for V
writeSCCB(0x78538910); // CMX9 for V
writeSCCB(0x78538a01); // sign[9]
writeSCCB(0x78538b98); // sign[8:1]
	             // UV adjsut
writeSCCB(0x78558006); // saturation on, bit[1]
writeSCCB(0x78558340);
writeSCCB(0x78558410);
writeSCCB(0x78558910);
writeSCCB(0x78558a00);
writeSCCB(0x78558bf8);
writeSCCB(0x78501d40); // enable manual offset of contrast
	             // CIP
writeSCCB(0x78530008); // CIP sharpen MT threshold 1
writeSCCB(0x78530130); // CIP sharpen MT threshold 2
writeSCCB(0x78530210); // CIP sharpen MT offset 1
writeSCCB(0x78530300); // CIP sharpen MT offset 2
writeSCCB(0x78530408); // CIP DNS threshold 1
writeSCCB(0x78530530); // CIP DNS threshold 2
writeSCCB(0x78530608); // CIP DNS offset 1
writeSCCB(0x78530716); // CIP DNS offset 2
writeSCCB(0x78530908); // CIP sharpen TH threshold 1
writeSCCB(0x78530a30); // CIP sharpen TH threshold 2
writeSCCB(0x78530b04); // CIP sharpen TH offset 1
writeSCCB(0x78530c06); // CIP sharpen TH offset 2
writeSCCB(0x78502500);
writeSCCB(0x78300802); // wake up from standby, bit[6]
//	             18 Company Confidential
//	             OmniVision Confidential

//	////////////////////////////////////////////////////////////
//	//////////////YUV VGA 30fps, night mode 5fps////////////////
//	////////////////////////////////////////////////////////////
//	// YUV VGA 30fps, night mode 5fps
//	// Input Clock = 24Mhz, PCLK = 56MHz
//
//writeSCCB(0x78303511); // PLL
//writeSCCB(0x78303646); // PLL
//writeSCCB(0x783c0708); // light meter 1 threshold [7:0]
//writeSCCB(0x78382041); // Sensor flip off, ISP flip on
//writeSCCB(0x78382107); // Sensor mirror on, ISP mirror on, H binning on
//writeSCCB(0x78381431); // X INC
//writeSCCB(0x78381531); // Y INC
//writeSCCB(0x78380000); // HS
//writeSCCB(0x78380100); // HS
//writeSCCB(0x78380200); // VS
//writeSCCB(0x78380304); // VS
//writeSCCB(0x7838040a); // HW (HE)
//writeSCCB(0x7838053f); // HW (HE)
//writeSCCB(0x78380607); // VH (VE)
//writeSCCB(0x7838079b); // VH (VE)
//writeSCCB(0x78380802); // DVPHO
//writeSCCB(0x78380980); // DVPHO
//writeSCCB(0x78380a01); // DVPVO
//writeSCCB(0x78380be0); // DVPVO
//writeSCCB(0x78380c07); // HTS
//writeSCCB(0x78380d68); // HTS
//writeSCCB(0x78380e03); // VTS
//writeSCCB(0x78380fd8); // VTS
//writeSCCB(0x78381306); // Timing Voffset
//writeSCCB(0x78361800);
//writeSCCB(0x78361229);
//writeSCCB(0x78370952);
//writeSCCB(0x78370c03);
//writeSCCB(0x783a0217); // 60Hz max exposure, night mode 5fps
//writeSCCB(0x783a0310); // 60Hz max exposure
//	// banding filters are calculated automatically in camera driver
//	//             writeSCCB(0x783a0801); // B50 step
//	//             writeSCCB(0x783a0927); // B50 step
//	//             writeSCCB(0x783a0a00); // B60 step
//	//             writeSCCB(0x783a0bf6); // B60 step
//	//             writeSCCB(0x783a0e03); // 50Hz max band
//	//             writeSCCB(0x783a0d04); // 60Hz max band
//writeSCCB(0x783a1417); // 50Hz max exposure, night mode 5fps
//writeSCCB(0x783a1510); // 50Hz max exposure
//writeSCCB(0x78400402); // BLC 2 lines
//writeSCCB(0x7830021c); // reset JFIFO, SFIFO, JPEG
////	19 Company Confidential
////	OmniVision Confidential for BYD Only
////	OV5640 Auto FocusCamera Module Application Notes
//writeSCCB(0x783006c3); // disable clock of JPEG2x, JPEG
//writeSCCB(0x78471303); // JPEG mode 3
//writeSCCB(0x78440704); // Quantization scale
//writeSCCB(0x78460b35);
//writeSCCB(0x78460c22);
//writeSCCB(0x78483722); // DVP CLK divider
//writeSCCB(0x78382402); // DVP CLK divider
//writeSCCB(0x785001a3); // SDE on, scale on, UV average off, color matrix on, AWB on
//writeSCCB(0x78350300); // AEC/AGC on
////	VGA 15fps
//	// YUV VGA 15fps, night mode 5fps
//	// Input Clock = 24Mhz, PCLK = 28MHz
//	//same settings as VGA 30fps, except the following settings
//writeSCCB(0x78303521); // PLL
//writeSCCB(0x783a020b); // 60Hz max exposure, night mode 5fps
//writeSCCB(0x783a0388); // 60Hz max exposure
//writeSCCB(0x783a140b); // 50Hz max exposure, night mode 5fps
//writeSCCB(0x783a1588); // 50Hz max exposure};


};
