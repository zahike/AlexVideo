/*
 * CamConfig.c
 *
 *  Created on: Jul 4, 2021
 *      Author: udi
 */

void Camera_config()
{
//             writeSCCB(0x420000);
//             writeSCCB(0x420180);
//             writeSCCB(0x420280);
             writeSCCB(0x420300);     // x00 // VREF for Window 320x240
//             writeSCCB(0x420400);
//             writeSCCB(0x420500);
//             writeSCCB(0x420600);
//             writeSCCB(0x420700);
//             writeSCCB(0x420800);
             writeSCCB(0x420900);      // Output Logic Current Driver "00" = 1x
//             writeSCCB(0x420A76);
//             writeSCCB(0x420B73);
//             writeSCCB(0x420C00);
//             writeSCCB(0x420D00);
//             writeSCCB(0x420E01);    // COM5 - reserved
//            writeSCCB(0x420F43);     // COM6 Reset all timing when format changes
//             writeSCCB(0x421040);
             writeSCCB(0x421181);      // CLKRC = x81 => CLKRC(5:0) = 1 => Prescaler = 1
             writeSCCB(0x421204);      // COM7 = x04 => Output Format RGB
//             writeSCCB(0x4213E7);      // COM8 = xE7 => AGC, AEC, AWB enabled
             writeSCCB(0x42140A);      // COM9 x0A => Maximum AGC Value = 2x
//             writeSCCB(0x421500);
//             writeSCCB(0x4216" => REGISTER_DATA_IN <= "ZZZZZZZZ);
             writeSCCB(0x421725);      // x25 // HSTART for Window 320x240
             writeSCCB(0x42184D);      // x4D // HSTOP for Window 320x240
             writeSCCB(0x421921);      // x21 // VSTART for Window 320x240
             writeSCCB(0x421A5D);      // x5D // VSTOP for Window 320x240
//             writeSCCB(0x421B00);
//             writeSCCB(0x421C" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x421D" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x421E01);
//             writeSCCB(0x421F00);
//             writeSCCB(0x422004);
//             writeSCCB(0x422102);
//             writeSCCB(0x422201);
//             writeSCCB(0x422300);
//             writeSCCB(0x422475);
//             writeSCCB(0x422563);
//             writeSCCB(0x4226D4);
//             writeSCCB(0x422780);
//             writeSCCB(0x422880);
//             writeSCCB(0x4229" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x422A00);
             writeSCCB(0x422B10);   // 16 = x10 Dummy Pixels 784 + 16 = 800
//             writeSCCB(0x422C80);
//             writeSCCB(0x422D00);
//             writeSCCB(0x422E00);
//             writeSCCB(0x422F00);
//             writeSCCB(0x423008);
//             writeSCCB(0x423130);
             writeSCCB(0x423280);    // x80 // HREF for Window 320x240
//             writeSCCB(0x423308);
//             writeSCCB(0x423411);
//             writeSCCB(0x4235" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x4236" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42373F);
//             writeSCCB(0x423801);
//             writeSCCB(0x423900);
//             writeSCCB(0x423A04);    // TCLB //04// YUV order is YUYV
//             writeSCCB(0x423B00);
//             writeSCCB(0x423C78);    // COM12
//             writeSCCB(0x423DC0);    //C0// COM13 Gamma enabled and UV auto adjustment enabled
//             writeSCCB(0x423E00);
             writeSCCB(0x423F00);             // Edge Enhancement  - x"00"  Without edging
             writeSCCB(0x4240D0);      // COM15 = D0 => COM15(4) = '1' => Enable RGB444 mode
//             writeSCCB(0x424108);
//             writeSCCB(0x424200);
//             writeSCCB(0x424314);
//             writeSCCB(0x4244F0);
//             writeSCCB(0x424545);
//             writeSCCB(0x424661);
//             writeSCCB(0x424751);
//             writeSCCB(0x424879);
//             writeSCCB(0x4249" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x424A" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x424B00);
//             writeSCCB(0x424C00);
             writeSCCB(0x424D00);       // x4D(7) = 0 => Dummy Row inserted before active row
//             writeSCCB(0x424E" => REGISTER_DATA_IN <= "ZZZZZZZZ);
             writeSCCB(0x424FB3);  // x"C0"
             writeSCCB(0x4250B3);  // x"C0"
             writeSCCB(0x425100);  // x"00"
             writeSCCB(0x42523D);  // x"33"
             writeSCCB(0x4253A7);  // x"8D"
             writeSCCB(0x4254E4);  // x"C0"
             writeSCCB(0x42500);
             writeSCCB(0x425640);
//             writeSCCB(0x425780);
             writeSCCB(0x42589E);  // x"DE"
//             writeSCCB(0x4259" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x425A" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x425B" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x425C" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x425D" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x425E" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x425F" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x4260" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x4261" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x426200);
//             writeSCCB(0x426300);
//             writeSCCB(0x426450);
//             writeSCCB(0x426530);
//             writeSCCB(0x426600);
//             writeSCCB(0x4267C0);      // Manual U value
//             writeSCCB(0x426880);
//             writeSCCB(0x426900);
//             writeSCCB(0x426A00);
             writeSCCB(0x426B3A);      // PLL BYPASS
//             writeSCCB(0x426C02);
//             writeSCCB(0x426D55);
//             writeSCCB(0x426EC0);
//             writeSCCB(0x426F9F);      // Simple AWB
//             writeSCCB(0x42703A);
//             writeSCCB(0x427135);
//             writeSCCB(0x427211);
//             writeSCCB(0x4273F0);      // Bypass Clock Divider
//             writeSCCB(0x427400);
//             writeSCCB(0x42750F);
//             writeSCCB(0x427601);
//             writeSCCB(0x427710);
//             writeSCCB(0x4278" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x4279" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x427A24);
//             writeSCCB(0x427B04);
//             writeSCCB(0x427C07);
//             writeSCCB(0x427D10);
//             writeSCCB(0x427E28);
//             writeSCCB(0x427F36);
//             writeSCCB(0x428044);
//             writeSCCB(0x428152);
//             writeSCCB(0x428260);
//             writeSCCB(0x42836C);
//             writeSCCB(0x428478);
//             writeSCCB(0x42858C);
//             writeSCCB(0x42869E);
//             writeSCCB(0x4287BB);
//             writeSCCB(0x4288D2);
//             writeSCCB(0x4289E5);
//             writeSCCB(0x428A" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x428B" => REGISTER_DATA_IN <= "ZZZZZZZZ);
             writeSCCB(0x428C02);          // RGB444 = 02 => RGB444 enabled and RGB word = xR GB
//             writeSCCB(0x428D" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x428E" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x428F" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x4290" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x4291" => REGISTER_DATA_IN <= "ZZZZZZZZ);
             writeSCCB(0x42920B);         // 11 = x0B Dummy Rows 510 + 11 = 521
//             writeSCCB(0x429300);
//             writeSCCB(0x429450);
//             writeSCCB(0x429550);
//             writeSCCB(0x4296" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x4297" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x4298" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x4299" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x429A" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x429B" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x429C" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x429D99);
//             writeSCCB(0x429E7F);
//             writeSCCB(0x429FC0);
//             writeSCCB(0x42A090);
//             writeSCCB(0x42A1" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42A202);
//             writeSCCB(0x42A3" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42A400);
//             writeSCCB(0x42A50F);
//             writeSCCB(0x42A6F0);
//             writeSCCB(0x42A7C1);
//             writeSCCB(0x42A8F0);
//             writeSCCB(0x42A9C1);
//             writeSCCB(0x42AA14);
//             writeSCCB(0x42AB0F);
//             writeSCCB(0x42AC00);
//             writeSCCB(0x42AD80);
//             writeSCCB(0x42AE80);
//             writeSCCB(0x42AF80);
//             writeSCCB(0x42B0" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42B100);
//             writeSCCB(0x42B2" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42B380);
//             writeSCCB(0x42B4" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42B504);
//             writeSCCB(0x42B6" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42B7" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42B8" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42B9" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42BA" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42BB" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42BC" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42BD" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42BE00);
//             writeSCCB(0x42BF00);
//             writeSCCB(0x42C000);
//             writeSCCB(0x42C100);
//             writeSCCB(0x42C2" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42C3" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42C4" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42C5" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42C6" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42C7" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42C8" => REGISTER_DATA_IN <= "ZZZZZZZZ);
//             writeSCCB(0x42C9C0);
};
