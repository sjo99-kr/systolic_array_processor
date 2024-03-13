`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2023 09:25:46 PM
// Design Name: 
// Module Name: Multiply_Unit
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


module MMU(clk,rst, gemm_valid, state,
row_in1, row_in2,row_in3,row_in4, row_in5,row_in6,row_in7,row_in8, row_in9 ,row_in10 ,row_in11, row_in12, row_in13, row_in14, row_in15,row_in16,
sync_reset
,col_in1,col_in2, col_in3, col_in4, col_in5, col_in6, col_in7, col_in8, col_in9, col_in10, col_in11,col_in12, col_in13, col_in14, col_in15 ,col_in16 
,flag
,weight11,weight12,weight13,weight14,weight15,weight16,weight17,weight18,weight19,weight110, weight111, weight112, weight113, weight114, weight115, weight116,

out_acc1, out_acc2, out_acc3, out_acc4, out_acc5, out_acc6, out_acc7, out_acc8, out_acc9, out_acc10, out_acc11, out_acc12, out_acc13, out_acc14, out_acc15, out_acc16,

act_outsig_1,act_outsig_2,act_outsig_3,act_outsig_4,act_outsig_5,act_outsig_6, act_outsig_7, act_outsig_8, act_outsig_9, act_outsig_10,
act_outsig_11,act_outsig_12,act_outsig_13,act_outsig_14,act_outsig_15,act_outsig_16,
act_push);

//valid == out_signal (from buffer)
parameter n =4;

input clk,rst, sync_reset;
input [1:0] state;
input [1:0] flag;
// row input 8bits (16 pics) for data 
input signed [7:0] row_in1, row_in2, row_in3, row_in4, row_in5, row_in6, row_in7, row_in8;
input signed [7:0] row_in9, row_in10, row_in11, row_in12, row_in13, row_in14, row_in15, row_in16;

// col input 8 or more bits (16 pics) for data or pixel 
input signed [19:0] col_in1, col_in2,col_in3,col_in4,col_in5,col_in6,col_in7, col_in8;
input signed [19:0] col_in9, col_in10, col_in11, col_in12, col_in13, col_in14, col_in15, col_in16;

// gemm valid  signal
input gemm_valid;

input signed [7:0] weight11, weight12, weight13, weight14, weight15, weight16, weight17, weight18;
input signed [7:0] weight19, weight110, weight111, weight112, weight113, weight114, weight115, weight116;
output reg act_push;

// out_acc out signal 
wire act_outsig1,act_outsig2,act_outsig3,act_outsig4,act_outsig5,act_outsig6, act_outsig7, act_outsig8, act_outsig9, act_outsig10,
act_outsig11,act_outsig12,act_outsig13,act_outsig14,act_outsig15,act_outsig16;

output act_outsig_1;
// out_acc out signal 
output act_outsig_2,act_outsig_3,act_outsig_4,act_outsig_5,act_outsig_6, act_outsig_7, act_outsig_8, act_outsig_9, act_outsig_10,
act_outsig_11,act_outsig_12,act_outsig_13,act_outsig_14,act_outsig_15,act_outsig_16;

// out data setting
output signed [19:0] out_acc1, out_acc2, out_acc3, out_acc4, out_acc5, out_acc6, out_acc7, out_acc8;
output signed [19:0] out_acc9, out_acc10, out_acc11, out_acc12, out_acc13, out_acc14, out_acc15, out_acc16;

// PE valid out sig
// row all
wire out_valid12_13, out_valid13_14, out_valid14_15, out_valid15_16, out_valid16_17, out_valid17_18, out_valid18_19,
out_valid19_110, out_valid110_111, out_valid111_112, out_valid112_113, out_valid113_114, out_valid114_115, out_valid115_116;
//col 1
wire out_valid11_21, out_valid21_31, out_valid31_41,out_valid41_51, out_valid51_61, out_valid61_71,
out_valid71_81,out_valid81_91, out_valid91_101, out_valid101_111,out_valid111_121,out_valid121_131,out_valid131_141, out_valid141_151,
out_valid151_161;
// col2 
wire out_valid12_22, out_valid22_32, out_valid32_42,out_valid42_52, out_valid52_62, out_valid62_72,
out_valid72_82,out_valid82_92, out_valid92_102, out_valid102_112,out_valid112_122,out_valid122_132,out_valid132_142, out_valid142_152,
out_valid152_162;
//col3
wire  out_valid23_33, out_valid33_43,out_valid43_53, out_valid53_63, out_valid63_73,
out_valid73_83,out_valid83_93, out_valid93_103, out_valid103_113,out_valid113_123,out_valid123_133,out_valid133_143, out_valid143_153,
out_valid153_163;
//col4
wire out_valid24_34, out_valid34_44,out_valid44_54, out_valid54_64, out_valid64_74,
out_valid74_84,out_valid84_94, out_valid94_104, out_valid104_114,out_valid114_124,out_valid124_134,out_valid134_144, out_valid144_154,
out_valid154_164;
//col5
wire out_valid25_35, out_valid35_45,out_valid45_55, out_valid55_65, out_valid65_75,
out_valid75_85,out_valid85_95, out_valid95_105, out_valid105_115,out_valid115_125,out_valid125_135,out_valid135_145, out_valid145_155,
out_valid155_165;
//col6
wire out_valid26_36, out_valid36_46,out_valid46_56, out_valid56_66, out_valid66_76,
out_valid76_86,out_valid86_96, out_valid96_106, out_valid106_116,out_valid116_126,out_valid126_136,out_valid136_146, out_valid146_156,
out_valid156_166;
//col7
wire out_valid27_37, out_valid37_47,out_valid47_57, out_valid57_67, out_valid67_77,
out_valid77_87,out_valid87_97, out_valid97_107, out_valid107_117,out_valid117_127,out_valid127_137,out_valid137_147, out_valid147_157,
out_valid157_167;
//col8
wire out_valid28_38, out_valid38_48,out_valid48_58, out_valid58_68, out_valid68_78,
out_valid78_88,out_valid88_98, out_valid98_108, out_valid108_118,out_valid118_128,out_valid128_138,out_valid138_148, out_valid148_158,
out_valid158_168;
//col9
wire out_valid29_39, out_valid39_49,out_valid49_59, out_valid59_69, out_valid69_79,
out_valid79_89,out_valid89_99, out_valid99_109, out_valid109_119,out_valid119_129,out_valid129_139,out_valid139_149, out_valid149_159,
out_valid159_169;
//col10
wire out_valid210_310, out_valid310_410,out_valid410_510, out_valid510_610, out_valid610_710,
out_valid710_810,out_valid810_910, out_valid910_1010, out_valid1010_1110,out_valid1110_1210,out_valid1210_1310,out_valid1310_1410, out_valid1410_1510,
out_valid1510_1610;
//col11
wire out_valid211_311, out_valid311_411,out_valid411_511, out_valid511_611, out_valid611_711,
out_valid711_811,out_valid811_911, out_valid911_1011, out_valid1011_1111,out_valid1111_1211,out_valid1211_1311,out_valid1311_1411, out_valid1411_1511,
out_valid1511_1611;
//col12
wire out_valid212_312, out_valid312_412,out_valid412_512, out_valid512_612, out_valid612_712,
out_valid712_812,out_valid812_912, out_valid912_1012, out_valid1012_1112,out_valid1112_1212,out_valid1212_1312,out_valid1312_1412, out_valid1412_1512,
out_valid1512_1612;
//col13
wire out_valid213_313, out_valid313_413,out_valid413_513, out_valid513_613, out_valid613_713,
out_valid713_813,out_valid813_913, out_valid913_1013, out_valid1013_1113,out_valid1113_1213,out_valid1213_1313,out_valid1313_1413, out_valid1413_1513,
out_valid1513_1613;
//col14
wire out_valid214_314, out_valid314_414,out_valid414_514, out_valid514_614, out_valid614_714,
out_valid714_814,out_valid814_914, out_valid914_1014, out_valid1014_1114,out_valid1114_1214,out_valid1214_1314,out_valid1314_1414, out_valid1414_1514,
out_valid1514_1614;
//col15
wire out_valid215_315, out_valid315_415,out_valid415_515, out_valid515_615, out_valid615_715,
out_valid715_815,out_valid815_915, out_valid915_1015, out_valid1015_1115,out_valid1115_1215,out_valid1215_1315,out_valid1315_1415, out_valid1415_1515,
out_valid1515_1615;
//col16
wire out_valid116_216, out_valid216_316, out_valid316_416,out_valid416_516, out_valid516_616, out_valid616_716,
out_valid716_816,out_valid816_916, out_valid916_1016, out_valid1016_1116, out_valid1116_1216,out_valid1216_1316,out_valid1316_1416, out_valid1416_1516,
out_valid1516_1616;


// wire setting (row)
wire signed [7:0] line11_12, line12_13, line13_14, line14_15, line15_16, line16_17, line17_18, line18_19, line19_110;
wire signed [7:0] line0110_0111, line0111_0112, line0112_0113, line0113_0114, line0114_0115, line0115_0116;

wire signed [7:0] line21_22, line22_23, line23_24, line24_25, line25_26, line26_27, line27_28, line28_29, line29_210;
wire signed [7:0] line210_211, line211_212, line212_213, line213_214, line214_215, line215_216;

wire signed [7:0] line31_32, line32_33, line33_34, line34_35, line35_36, line36_37, line37_38, line38_39, line39_310;
wire signed [7:0] line310_311, line311_312, line312_313, line313_314, line314_315, line315_316;

wire signed [7:0] line41_42, line42_43, line43_44, line44_45, line45_46, line46_47, line47_48, line48_49, line49_410;
wire signed [7:0] line410_411, line411_412, line412_413, line413_414, line414_415, line415_416;

wire signed [7:0] line51_52, line52_53, line53_54, line54_55, line55_56, line56_57, line57_58, line58_59, line59_510;
wire signed [7:0] line510_511, line511_512, line512_513, line513_514, line514_515, line515_516;

wire signed [7:0] line61_62, line62_63, line63_64, line64_65, line65_66, line66_67, line67_68, line68_69, line69_610;
wire signed [7:0] line610_611, line611_612, line612_613, line613_614, line614_615, line615_616;

wire signed [7:0] line71_72, line72_73, line73_74, line74_75, line75_76, line76_77, line77_78, line78_79, line79_710;
wire signed [7:0] line710_711, line711_712, line712_713, line713_714, line714_715, line715_716;

wire signed [7:0] line81_82, line82_83, line83_84, line84_85, line85_86, line86_87, line87_88, line88_89, line89_810;
wire signed [7:0] line810_811, line811_812, line812_813, line813_814, line814_815, line815_816;

wire signed [7:0] line91_92, line92_93, line93_94, line94_95, line95_96, line96_97, line97_98, line98_99, line99_910;
wire signed [7:0] line910_911, line911_912, line912_913, line913_914, line914_915, line915_916;

wire signed [7:0] line101_102, line102_103, line103_104, line104_105, line105_106, line106_107, line107_108, line108_109, line109_1010;
wire signed [7:0] line1010_1011, line1011_1012, line1012_1013, line1013_1014, line1014_1015, line1015_1016;

wire signed [7:0] line111_112, line112_113, line113_114, line114_115, line115_116, line116_117, line117_118, line118_119, line119_1110;
wire signed [7:0] line1110_1111, line1111_1112, line1112_1113, line1113_1114, line1114_1115, line1115_1116;

wire signed [7:0] line121_122, line122_123, line123_124, line124_125, line125_126, line126_127, line127_128, line128_129, line129_1210;
wire signed [7:0] line1210_1211, line1211_1212, line1212_1213, line1213_1214, line1214_1215, line1215_1216;

wire signed [7:0] line131_132, line132_133, line133_134, line134_135, line135_136, line136_137, line137_138, line138_139, line139_1310;
wire signed [7:0] line1310_1311, line1311_1312, line1312_1313, line1313_1314, line1314_1315, line1315_1316;

wire signed [7:0] line141_142, line142_143, line143_144, line144_145, line145_146, line146_147, line147_148, line148_149, line149_1410;
wire signed [7:0] line1410_1411, line1411_1412, line1412_1413, line1413_1414, line1414_1415, line1415_1416;

wire signed [7:0] line151_152, line152_153, line153_154, line154_155, line155_156, line156_157, line157_158, line158_159, line159_1510;
wire signed [7:0] line1510_1511, line1511_1512, line1512_1513, line1513_1514, line1514_1515, line1515_1516;

wire signed [7:0] line161_162, line162_163, line163_164, line164_165, line165_166, line166_167, line167_168, line168_169, line169_1610;
wire signed [7:0] line1610_1611, line1611_1612, line1612_1613, line1613_1614, line1614_1615, line1615_1616;

// wire setting (col)
wire signed [19:0] line11_21, line12_22, line13_23, line14_24, line15_25, line16_26, line17_27, line18_28;
wire signed [19:0] line19_29, line110_210, line111_211, line112_212, line113_213, line114_214, line115_215, line116_216;
wire signed [19:0] line21_31, line22_32, line23_33, line24_34, line25_35, line26_36, line27_37, line28_38;
wire signed [19:0] line29_39, line210_310, line211_311, line212_312, line213_313, line214_314, line215_315, line216_316;
wire signed [19:0] line31_41, line32_42, line33_43, line34_44, line35_45, line36_46, line37_47, line38_48;
wire signed [19:0] line39_49, line310_410, line311_411, line312_412, line313_413, line314_414, line315_415, line316_416;
wire signed [19:0] line41_51, line42_52, line43_53, line44_54, line45_55, line46_56, line47_57, line48_58;
wire signed [19:0] line49_59, line410_510, line411_511, line412_512, line413_513, line414_514, line415_515, line416_516;
wire signed [19:0] line51_61, line52_62, line53_63, line54_64, line55_65, line56_66, line57_67, line58_68;
wire signed [19:0] line59_69, line510_610, line511_611, line512_612, line513_613, line514_614, line515_615, line516_616;
wire signed [19:0] line61_71, line62_72, line63_73, line64_74, line65_75, line66_76, line67_77, line68_78;
wire signed [19:0] line69_79, line610_710, line611_711, line612_712, line613_713, line614_714, line615_715, line616_716;
wire signed [19:0] line71_81, line72_82, line73_83, line74_84, line75_85, line76_86, line77_87, line78_88;
wire signed [19:0] line79_89, line710_810, line711_811, line712_812, line713_813, line714_814, line715_815, line716_816;
wire signed [19:0] line81_91, line82_92, line83_93, line84_94, line85_95, line86_96, line87_97, line88_98;
wire signed [19:0] line89_99, line810_910, line811_911, line812_912, line813_913, line814_914, line815_915, line816_916;
wire signed [19:0] line91_101, line92_102, line93_103, line94_104, line95_105, line96_106, line97_107, line98_108;
wire signed [19:0] line99_109, line910_1010, line911_1011, line912_1012, line913_1013, line914_1014, line915_1015, line916_1016;
wire signed [19:0] line101_111, line102_112, line103_113, line104_114, line105_115, line106_116, line107_117, line108_118;
wire signed [19:0] line109_119, line1010_1110, line1011_1111, line1012_1112, line1013_1113, line1014_1114, line1015_1115, line1016_1116;
wire signed [19:0] line111_121, line112_122, line113_123, line114_124, line115_125, line116_126, line117_127, line118_128;
wire signed [19:0] line119_129, line1110_1210, line1111_1211, line1112_1212, line1113_1213, line1114_1214, line1115_1215, line1116_1216;
wire signed [19:0] line121_131, line122_132, line123_133, line124_134, line125_135, line126_136, line127_137, line128_138;
wire signed [19:0] line129_139, line1210_1310, line1211_1311, line1212_1312, line1213_1313, line1214_1314, line1215_1315, line1216_1316;
wire signed [19:0] line131_141, line132_142, line133_143, line134_144, line135_145, line136_146, line137_147, line138_148;
wire signed [19:0] line139_149, line1310_1410, line1311_1411, line1312_1412, line1313_1413, line1314_1414, line1315_1415, line1316_1416;
wire signed [19:0] line141_151, line142_152, line143_153, line144_154, line145_155, line146_156, line147_157, line148_158;
wire signed [19:0] line149_159, line1410_1510, line1411_1511, line1412_1512, line1413_1513, line1414_1514, line1415_1515, line1416_1516;
wire signed [19:0] line151_161, line152_162, line153_163, line154_164, line155_165, line156_166, line157_167, line158_168;
wire signed [19:0] line159_169, line1510_1610, line1511_1611, line1512_1612, line1513_1613, line1514_1614, line1515_1615, line1516_1616;

// wire 16 ->> acc  (col)
wire signed [19:0] line161_acc1, line162_acc2, line163_acc3, line164_acc4, line165_acc5, line166_acc6, line167_acc7, line168_acc8;
wire signed [19:0] line169_acc9, line1610_acc10, line1611_acc11, line1612_acc12, line1613_acc13, line1614_acc14; 
wire signed [19:0] line1615_acc15, line1616_acc16;


//reg sign




// Systolic array  row 1 (16 pics)
pe pe11(clk, rst, state, row_in1, col_in1, weight11, line11_12, line11_21 ,flag, gemm_valid, sync_reset, out_valid11_21);
pe pe12(clk, rst, state, line11_12, col_in2, weight12, line12_13, line12_22 ,flag, out_valid11_21,sync_reset, out_valid12_13);
pe pe13(clk, rst, state, line12_13, col_in3, weight13, line13_14, line13_23 ,flag, out_valid12_13,sync_reset,out_valid13_14);
pe pe14(clk, rst, state, line13_14, col_in4, weight14, line14_15, line14_24 ,flag, out_valid13_14,sync_reset, out_valid14_15);

pe pe15(clk, rst, state, line14_15, col_in5, weight15, line15_16, line15_25 ,flag, out_valid14_15 ,sync_reset,out_valid15_16);

pe pe16(clk, rst, state, line15_16, col_in6, weight16, line16_17, line16_26 ,flag, out_valid15_16,sync_reset, out_valid16_17);
pe pe17(clk, rst, state, line16_17, col_in7, weight17, line17_18, line17_27, flag, out_valid16_17,sync_reset, out_valid17_18);
pe pe18(clk, rst, state, line17_18, col_in8, weight18, line18_19, line18_28 ,flag, out_valid17_18,sync_reset, out_valid18_19);
pe pe19(clk, rst, state, line18_19, col_in9, weight19, line19_110, line19_29 ,flag, out_valid18_19,sync_reset, out_valid19_110);
pe pe0110(clk, rst, state,line19_110 ,col_in10, weight110, line0110_0111, line110_210 ,flag, out_valid19_110, sync_reset, out_valid110_111);
pe pe0111(clk, rst, state,line0110_0111 ,col_in11, weight111, line0111_0112, line111_211 ,flag, out_valid110_111, sync_reset, out_valid111_112);
pe pe0112(clk, rst, state,line0111_0112 ,col_in12, weight112, line0112_0113, line112_212 ,flag, out_valid111_112, sync_reset, out_valid112_113);
pe pe0113(clk, rst, state,line0112_0113 ,col_in13, weight113, line0113_0114, line113_213 ,flag, out_valid112_113, sync_reset, out_valid113_114);
pe pe0114(clk, rst, state,line0113_0114 ,col_in14, weight114, line0114_0115, line114_214 ,flag, out_valid113_114, sync_reset, out_valid114_115);
pe pe0115(clk, rst, state,line0114_0115 ,col_in15, weight115, line0115_0116, line115_215 ,flag, out_valid114_115, sync_reset, out_valid115_116);
pe_last pe0116(clk, rst, state, line0115_0116 , col_in16, weight116, line116_216 ,flag, out_valid115_116, sync_reset,out_valid116_216);

// Systolic array row 2 (16 pics)
pe pe21(clk, rst, state, row_in2, line11_21, weight14, line21_22, line21_31 ,flag, out_valid11_21,sync_reset,out_valid21_31);
pe pe22(clk, rst, state, line21_22, line12_22, weight15, line22_23, line22_32 ,flag, out_valid12_13,sync_reset, out_valid22_32);
pe pe23(clk, rst, state, line22_23, line13_23, weight16, line23_24, line23_33 ,flag, out_valid13_14,sync_reset,out_valid23_33);
pe pe24(clk, rst, state, line23_24, line14_24, weight17, line24_25, line24_34 ,flag, out_valid14_15,sync_reset, out_valid24_34);
pe pe25(clk, rst, state, line24_25, line15_25, weight15, line25_26, line25_35 ,flag, out_valid15_16,sync_reset, out_valid25_35);
pe pe26(clk, rst, state, line25_26, line16_26, weight16, line26_27, line26_36 ,flag, out_valid16_17,sync_reset, out_valid26_36);
pe pe27(clk, rst, state, line26_27, line17_27, weight17, line27_28, line27_37, flag, out_valid17_18,sync_reset, out_valid27_37);
pe pe28(clk, rst, state, line27_28, line18_28, weight18, line28_29, line28_38 ,flag, out_valid18_19,sync_reset, out_valid28_38);
pe pe29(clk, rst, state, line28_29, line19_29, weight19, line29_210, line29_39 ,flag, out_valid19_110,sync_reset, out_valid29_39);
pe pe210(clk, rst, state,line29_210 ,line110_210, weight110, line210_211, line210_310 ,flag, out_valid110_111,sync_reset, out_valid210_310);
pe pe211(clk, rst, state,line210_211 ,line111_211, weight111, line211_212, line211_311 ,flag, out_valid111_112,sync_reset, out_valid211_311);
pe pe212(clk, rst, state,line211_212 ,line112_212, weight112, line212_213, line212_312 ,flag, out_valid112_113,sync_reset, out_valid212_312);
pe pe213(clk, rst, state,line212_213 ,line113_213, weight113, line213_214, line213_313 ,flag, out_valid113_114,sync_reset, out_valid213_313);
pe pe214(clk, rst, state,line213_214 ,line114_214, weight114, line214_215, line214_314 ,flag, out_valid114_115,sync_reset, out_valid214_314);
pe pe215(clk, rst, state,line214_215 , line115_215, weight115, line215_216, line215_315 ,flag, out_valid115_116,sync_reset, out_valid215_315);
pe_last pe216(clk, rst, state, line215_216 ,line116_216, weight116, line216_316 ,flag, out_valid116_216,sync_reset, out_valid216_316);

// Systolic array row 3 (16 pics)
pe pe31(clk, rst, state, row_in3, line21_31, weight17, line31_32, line31_41 ,flag, out_valid21_31,sync_reset, out_valid31_41);
pe pe32(clk, rst, state, line31_32, line22_32, weight18, line32_33, line32_42 ,flag, out_valid22_32,sync_reset,out_valid32_42);
pe pe33(clk, rst, state, line32_33, line23_33, weight19, line33_34, line33_43 ,flag, out_valid23_33,sync_reset,out_valid33_43);
pe pe34(clk, rst, state, line33_34, line24_34, weight14, line34_35, line34_44 ,flag, out_valid24_34,sync_reset,out_valid34_44);
pe pe35(clk, rst, state, line34_35, line25_35, weight15, line35_36, line35_45 ,flag, out_valid25_35,sync_reset, out_valid35_45);
pe pe36(clk, rst, state, line35_36, line26_36, weight16, line36_37, line36_46 ,flag, out_valid26_36,sync_reset, out_valid36_46);
pe pe37(clk, rst, state, line36_37, line27_37, weight17, line37_38, line37_47, flag, out_valid27_37,sync_reset, out_valid37_47);
pe pe38(clk, rst, state, line37_38, line28_38, weight18, line38_39, line38_48 ,flag, out_valid28_38,sync_reset, out_valid38_48);
pe pe39(clk, rst, state, line38_39, line29_39, weight19, line39_310, line39_49 ,flag, out_valid29_39,sync_reset, out_valid39_49);
pe pe310(clk, rst, state,line39_310 ,line210_310, weight110, line310_311, line310_410 ,flag, out_valid210_310,sync_reset, out_valid310_410);
pe pe311(clk, rst, state,line310_311 ,line211_311, weight111, line311_312, line311_411 ,flag, out_valid211_311,sync_reset, out_valid311_411);
pe pe312(clk, rst, state,line311_312 ,line212_312, weight112, line312_313, line312_412 ,flag, out_valid212_312,sync_reset, out_valid312_412);
pe pe313(clk, rst, state,line312_313 ,line213_313, weight113, line313_314, line313_413 ,flag, out_valid213_313,sync_reset, out_valid313_413);
pe pe314(clk, rst, state,line313_314 ,line214_314, weight114, line314_315, line314_414 ,flag, out_valid214_314,sync_reset, out_valid314_414);
pe pe315(clk, rst, state,line314_315 , line215_315, weight115, line315_316, line315_415 ,flag, out_valid215_315,sync_reset, out_valid315_415);
pe_last pe316(clk, rst, state, line315_316 ,line216_316, weight116, line316_416 ,flag, out_valid216_316,sync_reset, out_valid316_416);

// Systolic array row 4 (16 pics)
pe pe41(clk, rst, state, row_in4, line31_41, weight110, line41_42, line41_51 ,flag, out_valid31_41,sync_reset, out_valid41_51);
pe pe42(clk, rst, state, line41_42, line32_42, weight111, line42_43, line42_52 ,flag, out_valid32_42,sync_reset,out_valid42_52);
pe pe43(clk, rst, state, line42_43, line33_43, weight112, line43_44, line43_53 ,flag, out_valid33_43,sync_reset, out_valid43_53);
pe pe44(clk, rst, state, line43_44, line34_44, weight14, line44_45, line44_54 ,flag, out_valid34_44,sync_reset, out_valid44_54);
pe pe45(clk, rst, state, line44_45, line35_45, weight15, line45_46, line45_55 ,flag, out_valid35_45,sync_reset, out_valid45_55);
pe pe46(clk, rst, state, line45_46, line36_46, weight16, line46_47, line46_56 ,flag, out_valid36_46,sync_reset, out_valid46_56);
pe pe47(clk, rst, state, line46_47, line37_47, weight17, line47_48, line47_57, flag, out_valid37_47,sync_reset, out_valid47_57);
pe pe48(clk, rst, state, line47_48, line38_48, weight18, line48_49, line48_58 ,flag, out_valid38_48,sync_reset, out_valid48_58);
pe pe49(clk, rst, state, line48_49, line39_49, weight19, line49_410, line49_59 ,flag, out_valid39_49,sync_reset, out_valid49_59);
pe pe410(clk, rst, state,line49_410 ,line310_410, weight110, line410_411, line410_510 ,flag, out_valid310_410,sync_reset, out_valid410_510);
pe pe411(clk, rst, state,line410_411 ,line311_411, weight111, line411_412, line411_511 ,flag, out_valid311_411,sync_reset, out_valid411_511);
pe pe412(clk, rst, state,line411_412 ,line312_412, weight112, line412_413, line412_512 ,flag, out_valid312_412,sync_reset, out_valid412_512);
pe pe413(clk, rst, state,line412_413 ,line313_413, weight113, line413_414, line413_513 ,flag, out_valid313_413,sync_reset, out_valid413_513);
pe pe414(clk, rst, state,line413_414 ,line314_414, weight114, line414_415, line414_514 ,flag, out_valid314_414,sync_reset, out_valid414_514);
pe pe415(clk, rst, state,line414_415 , line315_415, weight115, line415_416, line415_515 ,flag, out_valid315_415,sync_reset, out_valid415_515);
pe_last pe416(clk, rst, state, line415_416 ,line316_416, weight116, line416_516 ,flag, out_valid316_416,sync_reset, out_valid416_516);

// Systolic array row 5 (16 pics)
pe pe51(clk, rst, state, row_in5, line41_51, weight15, line51_52, line51_61 ,flag, out_valid41_51, sync_reset,out_valid51_61);
pe pe52(clk, rst, state, line51_52, line42_52, weight110, line52_53, line52_62 ,flag, out_valid42_52,sync_reset,out_valid52_62);
pe pe53(clk, rst, state, line52_53, line43_53, weight13, line53_54, line53_63 ,flag, out_valid43_53,sync_reset,out_valid53_63);
pe pe54(clk, rst, state, line53_54, line44_54, weight14, line54_55, line54_64 ,flag, out_valid44_54,sync_reset, out_valid54_64);
pe pe55(clk, rst, state, line54_55, line45_55, weight15, line55_56, line55_65 ,flag, out_valid45_55,sync_reset, out_valid55_65);
pe pe56(clk, rst, state, line55_56, line46_56, weight16, line56_57, line56_66 ,flag, out_valid46_56,sync_reset, out_valid56_66);
pe pe57(clk, rst, state, line56_57, line47_57, weight17, line57_58, line57_67, flag, out_valid47_57,sync_reset, out_valid57_67);
pe pe58(clk, rst, state, line57_58, line48_58, weight18, line58_59, line58_68 ,flag, out_valid48_58,sync_reset, out_valid58_68);
pe pe59(clk, rst, state, line58_59, line49_59, weight19, line59_510, line59_69 ,flag, out_valid49_59,sync_reset, out_valid59_69);
pe pe510(clk, rst, state,line59_510 ,line410_510, weight110, line510_511, line510_610 ,flag, out_valid410_510,sync_reset, out_valid510_610);
pe pe511(clk, rst, state,line510_511 ,line411_511, weight111, line511_512, line511_611 ,flag, out_valid411_511,sync_reset, out_valid511_611);
pe pe512(clk, rst, state,line511_512 ,line412_512, weight112, line512_513, line512_612 ,flag, out_valid412_512,sync_reset, out_valid512_612);
pe pe513(clk, rst, state,line512_513 ,line413_513, weight113, line513_514, line513_613 ,flag, out_valid413_513,sync_reset, out_valid513_613);
pe pe514(clk, rst, state,line513_514 ,line414_514, weight114, line514_515, line514_614 ,flag, out_valid414_514,sync_reset, out_valid514_614);
pe pe515(clk, rst, state,line514_515 , line415_515, weight115, line515_516, line515_615 ,flag, out_valid415_515,sync_reset, out_valid515_615);
pe_last pe516(clk, rst, state, line515_516 ,line416_516, weight116, line516_616 ,flag, out_valid416_516,sync_reset, out_valid516_616);

// Systolic array row 6 (16 pics)

pe pe61(clk, rst, state, row_in6, line51_61, weight11, line61_62, line61_71 ,flag, out_valid51_61,sync_reset, out_valid61_71);
pe pe62(clk, rst, state, line61_62, line52_62, weight12, line62_63, line62_72 ,flag, out_valid52_62,sync_reset,out_valid62_72);
pe pe63(clk, rst, state, line62_63, line53_63, weight13, line63_64, line63_73 ,flag, out_valid53_63,sync_reset,out_valid63_73);
pe pe64(clk, rst, state, line63_64, line54_64, weight14, line64_65, line64_74 ,flag, out_valid54_64,sync_reset, out_valid64_74);

pe pe65(clk, rst, state, line64_65, line55_65, weight15, line65_66, line65_75 ,flag, out_valid55_65,sync_reset, out_valid65_75);

pe pe66(clk, rst, state, line65_66, line56_66, weight16, line66_67, line66_76 ,flag, out_valid56_66,sync_reset, out_valid66_76);
pe pe67(clk, rst, state, line66_67, line57_67, weight17, line67_68, line67_77, flag, out_valid57_67,sync_reset, out_valid67_77);
pe pe68(clk, rst, state, line67_68, line58_68, weight18, line68_69, line68_78 ,flag, out_valid58_68,sync_reset, out_valid68_78);
pe pe69(clk, rst, state, line68_69, line59_69, weight19, line69_610, line69_79 ,flag, out_valid59_69,sync_reset, out_valid69_79);
pe pe610(clk, rst, state,line69_610 ,line510_610, weight110, line610_611, line610_710 ,flag, out_valid510_610,sync_reset, out_valid610_710);
pe pe611(clk, rst, state,line610_611 ,line511_611, weight111, line611_612, line611_711 ,flag, out_valid511_611,sync_reset, out_valid611_711);
pe pe612(clk, rst, state,line611_612 ,line512_612, weight112, line612_613, line612_712 ,flag, out_valid512_612,sync_reset, out_valid612_712);
pe pe613(clk, rst, state,line612_613 ,line513_613, weight113, line613_614, line613_713 ,flag, out_valid513_613,sync_reset, out_valid613_713);
pe pe614(clk, rst, state,line613_614 ,line514_614, weight114, line614_615, line614_714 ,flag, out_valid514_614,sync_reset, out_valid614_714);
pe pe615(clk, rst, state,line614_615 , line515_615, weight115, line615_616, line615_715 ,flag, out_valid515_615,sync_reset, out_valid615_715);
pe_last pe616(clk, rst, state, line615_616 ,line516_616, weight116, line616_716 ,flag, out_valid516_616,sync_reset, out_valid616_716);

// Systolic array row 7 (16 pics)

pe pe71(clk, rst, state, row_in7, line61_71, weight11, line71_72, line71_81 ,flag, out_valid61_71,sync_reset,out_valid71_81);
pe pe72(clk, rst, state, line71_72, line62_72, weight12, line72_73, line72_82 ,flag, out_valid62_72,sync_reset,out_valid72_82);
pe pe73(clk, rst, state, line72_73, line63_73, weight13, line73_74, line73_83 ,flag, out_valid63_73,sync_reset,out_valid73_83);
pe pe74(clk, rst, state, line73_74, line64_74, weight14, line74_75, line74_84 ,flag, out_valid64_74,sync_reset, out_valid74_84);
pe pe75(clk, rst, state, line74_75, line65_75, weight15, line75_76, line75_85 ,flag, out_valid65_75,sync_reset, out_valid75_85);
pe pe76(clk, rst, state, line75_76, line66_76, weight16, line76_77, line76_86 ,flag, out_valid66_76,sync_reset, out_valid76_86);
pe pe77(clk, rst, state, line76_77, line67_77, weight17, line77_78, line77_87, flag, out_valid67_77,sync_reset, out_valid77_87);
pe pe78(clk, rst, state, line77_78, line68_78, weight18, line78_79, line78_88 ,flag, out_valid68_78,sync_reset, out_valid78_88);
pe pe79(clk, rst, state, line78_79, line69_79, weight19, line79_710, line79_89 ,flag, out_valid69_79,sync_reset, out_valid79_89);
pe pe710(clk, rst, state,line79_710 ,line610_710, weight110, line710_711, line710_810 ,flag, out_valid610_710,sync_reset, out_valid710_810);
pe pe711(clk, rst, state,line710_711 ,line611_711, weight111, line711_712, line711_811 ,flag, out_valid611_711,sync_reset, out_valid711_811);
pe pe712(clk, rst, state,line711_712 ,line612_712, weight112, line712_713, line712_812 ,flag, out_valid612_712,sync_reset, out_valid712_812);
pe pe713(clk, rst, state,line712_713 ,line613_713, weight113, line713_714, line713_813 ,flag, out_valid613_713,sync_reset, out_valid713_813);
pe pe714(clk, rst, state,line713_714 ,line614_714, weight114, line714_715, line714_814 ,flag, out_valid614_714,sync_reset, out_valid714_814);
pe pe715(clk, rst, state,line714_715 , line615_715, weight115, line715_716, line715_815 ,flag, out_valid615_715,sync_reset, out_valid715_815);
pe_last pe716(clk, rst, state, line715_716 ,line616_716, weight116, line716_816 ,flag, out_valid616_716,sync_reset, out_valid716_816);

// Systolic array row 8 (16 pics)

pe pe81(clk, rst, state, row_in8, line71_81, weight11, line81_82, line81_91 ,flag, out_valid71_81,sync_reset,out_valid81_91);
pe pe82(clk, rst, state, line81_82, line72_82, weight12, line82_83, line82_92 ,flag, out_valid72_82,sync_reset,out_valid82_92);
pe pe83(clk, rst, state, line82_83, line73_83, weight13, line83_84, line83_93 ,flag, out_valid73_83,sync_reset, out_valid83_93);

pe pe84(clk, rst, state, line83_84, line74_84, weight14, line84_85, line84_94 ,flag, out_valid74_84,sync_reset, out_valid84_94);
pe pe85(clk, rst, state, line84_85, line75_85, weight15, line85_86, line85_95 ,flag, out_valid75_85,sync_reset, out_valid85_95);
pe pe86(clk, rst, state, line85_86, line76_86, weight16, line86_87, line86_96 ,flag, out_valid76_86,sync_reset, out_valid86_96);
pe pe87(clk, rst, state, line86_87, line77_87, weight17, line87_88, line87_97, flag, out_valid77_87,sync_reset, out_valid87_97);
pe pe88(clk, rst, state, line87_88, line78_88, weight18, line88_89, line88_98 ,flag, out_valid78_88,sync_reset, out_valid88_98);
pe pe89(clk, rst, state, line88_89, line79_89, weight19, line89_810, line89_99 ,flag, out_valid79_89,sync_reset, out_valid89_99);
pe pe810(clk, rst, state,line89_810 ,line710_810, weight110, line810_811, line810_910 ,flag, out_valid710_810,sync_reset, out_valid810_910);
pe pe811(clk, rst, state,line810_811 ,line711_811, weight111, line811_812, line811_911 ,flag, out_valid711_811,sync_reset, out_valid811_911);
pe pe812(clk, rst, state,line811_812 ,line712_812, weight112, line812_813, line812_912 ,flag, out_valid712_812,sync_reset,out_valid812_912);
pe pe813(clk, rst, state,line812_813 ,line713_813, weight113, line813_814, line813_913 ,flag, out_valid713_813,sync_reset, out_valid813_913);
pe pe814(clk, rst, state,line813_814 ,line714_814, weight114, line814_815, line814_914 ,flag, out_valid714_814,sync_reset, out_valid814_914);
pe pe815(clk, rst, state,line814_815 , line715_815, weight115, line815_816, line815_915 ,flag, out_valid715_815,sync_reset, out_valid815_915);
pe_last pe816(clk, rst, state, line815_816 ,line716_816, weight116, line816_916 ,flag, out_valid716_816 ,sync_reset, out_valid816_916);

// Systolic array row 9 (16 pics)

pe pe91(clk, rst, state, row_in9, line81_91, weight11, line91_92, line91_101 ,flag, out_valid81_91,sync_reset, out_valid91_101);
pe pe92(clk, rst, state, line91_92, line82_92, weight12, line92_93, line92_102 ,flag, out_valid82_92,sync_reset,out_valid92_102);
pe pe93(clk, rst, state, line92_93, line83_93, weight13, line93_94, line93_103 ,flag, out_valid83_93,sync_reset, out_valid93_103);

pe pe94(clk, rst, state, line93_94, line84_94, weight14, line94_95, line94_104 ,flag, out_valid84_94,sync_reset, out_valid94_104);
pe pe95(clk, rst, state, line94_95, line85_95, weight15, line95_96, line95_105 ,flag, out_valid85_95,sync_reset, out_valid95_105);
pe pe96(clk, rst, state, line95_96, line86_96, weight16, line96_97, line96_106 ,flag, out_valid86_96,sync_reset, out_valid96_106);
pe pe97(clk, rst, state, line96_97, line87_97, weight17, line97_98, line97_107, flag, out_valid87_97,sync_reset, out_valid97_107);
pe pe98(clk, rst, state, line97_98, line88_98, weight18, line98_99, line98_108 ,flag, out_valid88_98,sync_reset, out_valid98_108);
pe pe99(clk, rst, state, line98_99, line89_99, weight19, line99_910, line99_109 ,flag, out_valid89_99,sync_reset, out_valid99_109);
pe pe910(clk, rst, state,line99_910 ,line810_910, weight110, line910_911, line910_1010 ,flag, out_valid810_910,sync_reset, out_valid910_1010);
pe pe911(clk, rst, state,line910_911 ,line811_911, weight111, line911_912, line911_1011 ,flag, out_valid811_911,sync_reset, out_valid911_1011);
pe pe912(clk, rst, state,line911_912 ,line812_912, weight112, line912_913, line912_1012 ,flag, out_valid812_912,sync_reset, out_valid912_1012);
pe pe913(clk, rst, state,line912_913 ,line813_913, weight113, line913_914, line913_1013 ,flag, out_valid813_913,sync_reset, out_valid913_1013);
pe pe914(clk, rst, state,line913_914 ,line814_914, weight114, line914_915, line914_1014 ,flag, out_valid814_914,sync_reset, out_valid914_1014);
pe pe915(clk, rst, state,line914_915 , line815_915, weight115, line915_916, line915_1015 ,flag, out_valid815_915,sync_reset, out_valid915_1015);
pe_last pe916(clk, rst, state, line915_916 ,line816_916, weight116, line916_1016 ,flag, out_valid816_916,sync_reset, out_valid916_1016);

// Systolic array row 10 (16 pics)

pe pe101(clk, rst, state, row_in10, line91_101, weight11, line101_102, line101_111 ,flag, out_valid91_101,sync_reset, out_valid101_111);
pe pe102(clk, rst, state, line101_102, line92_102, weight12, line102_103, line102_112 ,flag, out_valid92_102,sync_reset,out_valid102_112);
pe pe103(clk, rst, state, line102_103, line93_103, weight13, line103_104, line103_113 ,flag, out_valid93_103,sync_reset, out_valid103_113);
pe pe104(clk, rst, state, line103_104, line94_104, weight14, line104_105, line104_114 ,flag, out_valid94_104,sync_reset, out_valid104_114);
pe pe105(clk, rst, state, line104_105, line95_105, weight15, line105_106, line105_115 ,flag, out_valid95_105,sync_reset,out_valid105_115);
pe pe106(clk, rst, state, line105_106, line96_106, weight16, line106_107, line106_116 ,flag, out_valid96_106,sync_reset,out_valid106_116);
pe pe107(clk, rst, state, line106_107, line97_107, weight17, line107_108, line107_117, flag, out_valid97_107,sync_reset, out_valid107_117);
pe pe108(clk, rst, state, line107_108, line98_108, weight18, line108_109, line108_118 ,flag, out_valid98_108,sync_reset, out_valid108_118);

pe pe109(clk, rst, state, line108_109, line99_109, weight19, line109_1010, line109_119 ,flag, out_valid99_109,sync_reset, out_valid109_119);

pe pe1010(clk, rst, state,line109_1010 ,line910_1010, weight110, line1010_1011, line1010_1110 ,flag, out_valid910_1010,sync_reset, out_valid1010_1110);
pe pe1011(clk, rst, state,line1010_1011 ,line911_1011, weight111, line1011_1012, line1011_1111 ,flag, out_valid911_1011,sync_reset, out_valid1011_1111);
pe pe1012(clk, rst, state,line1011_1012 ,line912_1012, weight112, line1012_1013, line1012_1112 ,flag,  out_valid912_1012,sync_reset, out_valid1012_1112);
pe pe1013(clk, rst, state,line1012_1013 ,line913_1013, weight113, line1013_1014, line1013_1113 ,flag, out_valid913_1013,sync_reset, out_valid1013_1113);
pe pe1014(clk, rst, state,line1013_1014 ,line914_1014, weight114, line1014_1015, line1014_1114 ,flag, out_valid914_1014,sync_reset, out_valid1014_1114);
pe pe1015(clk, rst, state,line1014_1015 , line915_1015, weight115, line1015_1016, line1015_1115 ,flag, out_valid915_1015,sync_reset, out_valid1015_1115);
pe_last pe1016(clk, rst, state, line1015_1016 ,line916_1016, weight116, line1016_1116 ,flag, out_valid916_1016,sync_reset, out_valid1016_1116);

// Systolic array row 11 (16 pics)

pe pe111(clk, rst, state, row_in11, line101_111, weight11, line111_112, line111_121 ,flag, out_valid101_111,sync_reset, out_valid111_121);
pe pe112(clk, rst, state, line111_112, line102_112, weight12, line112_113, line112_122 ,flag, out_valid102_112,sync_reset,out_valid112_122);
pe pe113(clk, rst, state, line112_113, line103_113, weight13, line113_114, line113_123 ,flag, out_valid103_113,sync_reset, out_valid113_123);

pe pe114(clk, rst, state, line113_114, line104_114, weight14, line114_115, line114_124 ,flag, out_valid104_114,sync_reset, out_valid114_124);
pe pe115(clk, rst, state, line114_115, line105_115, weight15, line115_116, line115_125 ,flag, out_valid105_115,sync_reset, out_valid115_125);
pe pe116(clk, rst, state, line115_116, line106_116, weight16, line116_117, line116_126 ,flag, out_valid106_116,sync_reset, out_valid116_126);
pe pe117(clk, rst, state, line116_117, line107_117, weight17, line117_118, line117_127, flag, out_valid107_117,sync_reset, out_valid117_127);
pe pe118(clk, rst, state, line117_118, line108_118, weight18, line118_119, line118_128 ,flag,out_valid108_118,sync_reset, out_valid118_128);
pe pe119(clk, rst, state, line118_119, line109_119, weight19, line119_1110, line119_129 ,flag, out_valid109_119,sync_reset, out_valid119_129);
pe pe1110(clk, rst, state,line119_1110 ,line1010_1110, weight110, line1110_1111, line1110_1210 ,flag, out_valid1010_1110,sync_reset, out_valid1110_1210);
pe pe1111(clk, rst, state,line1110_1111 ,line1011_1111, weight111, line1111_1112, line1111_1211 ,flag, out_valid1011_1111,sync_reset, out_valid1111_1211);
pe pe1112(clk, rst, state,line1111_1112 ,line1012_1112, weight112, line1112_1113, line1112_1212 ,flag, out_valid1012_1112,sync_reset, out_valid1112_1212);
pe pe1113(clk, rst, state,line1112_1113 ,line1013_1113, weight113, line1113_1114, line1113_1213 ,flag, out_valid1013_1113,sync_reset, out_valid1113_1213);
pe pe1114(clk, rst, state,line1113_1114 ,line1014_1114, weight114, line1114_1115, line1114_1214 ,flag, out_valid1014_1114,sync_reset, out_valid1114_1214);
pe pe1115(clk, rst, state,line1114_1115 , line1015_1115, weight115, line1115_1116, line1115_1215 ,flag, out_valid1015_1115,sync_reset, out_valid1115_1215);
pe_last pe1116(clk, rst, state, line1115_1116 ,line1016_1116, weight116, line1116_1216 ,flag, out_valid1016_1116,sync_reset, out_valid1116_1216);

// Systolic array row 12 (16 pics)
pe pe121(clk, rst, state, row_in12, line111_121, weight11, line121_122, line121_131 ,flag, out_valid111_121,sync_reset,out_valid121_131);
pe pe122(clk, rst, state, line121_122, line112_122, weight12, line122_123, line122_132 ,flag, out_valid112_122,sync_reset,out_valid122_132);
pe pe123(clk, rst, state, line122_123, line113_123, weight13, line123_124, line123_133 ,flag, out_valid113_123,sync_reset, out_valid123_133);

pe pe124(clk, rst, state, line123_124, line114_124, weight14, line124_125, line124_134 ,flag, out_valid114_124,sync_reset, out_valid124_134);
pe pe125(clk, rst, state, line124_125, line115_125, weight15, line125_126, line125_135 ,flag, out_valid115_125,sync_reset, out_valid125_135);
pe pe126(clk, rst, state, line125_126, line116_126, weight16, line126_127, line126_136 ,flag, out_valid116_126,sync_reset, out_valid126_136);
pe pe127(clk, rst, state, line126_127, line117_127, weight17, line127_128, line127_137, flag, out_valid117_127,sync_reset, out_valid127_137);
pe pe128(clk, rst, state, line127_128, line118_128, weight18, line128_129, line128_138 ,flag, out_valid118_128,sync_reset, out_valid128_138);
pe pe129(clk, rst, state, line128_129, line119_129, weight19, line129_1210, line129_139 ,flag, out_valid119_129,sync_reset, out_valid129_139);
pe pe1210(clk, rst, state,line129_1210 ,line1110_1210, weight110, line1210_1211, line1210_1310 ,flag, out_valid1110_1210,sync_reset, out_valid1210_1310);
pe pe1211(clk, rst, state,line1210_1211 ,line1111_1211, weight111, line1211_1212, line1211_1311 ,flag, out_valid1111_1211,sync_reset, out_valid1211_1311);
pe pe1212(clk, rst, state,line1211_1212 ,line1112_1212, weight112, line1212_1213, line1212_1312 ,flag, out_valid1112_1212,sync_reset, out_valid1212_1312);
pe pe1213(clk, rst, state,line1212_1213 ,line1113_1213, weight113, line1213_1214, line1213_1313 ,flag, out_valid1113_1213,sync_reset, out_valid1213_1313);
pe pe1214(clk, rst, state,line1213_1214 ,line1114_1214, weight114, line1214_1215, line1214_1314 ,flag, out_valid1114_1214,sync_reset, out_valid1214_1314);
pe pe1215(clk, rst, state,line1214_1215 , line1115_1215, weight115, line1215_1216, line1215_1315 ,flag, out_valid1115_1215,sync_reset, out_valid1215_1315);
pe_last pe1216(clk, rst, state, line1215_1216 ,line1116_1216, weight116, line1216_1316 ,flag, out_valid1116_1216,sync_reset, out_valid1216_1316);

// Systolic array row 13 (16 pics)

pe pe131(clk, rst, state, row_in13, line121_131, weight11, line131_132, line131_141 ,flag, out_valid121_131,sync_reset,out_valid131_141);
pe pe132(clk, rst, state, line131_132, line122_132, weight12, line132_133, line132_142 ,flag, out_valid122_132,sync_reset,out_valid132_142);
pe pe133(clk, rst, state, line132_133, line123_133, weight13, line133_134, line133_143 ,flag, out_valid123_133,sync_reset, out_valid133_143	);
pe pe134(clk, rst, state, line133_134, line124_134, weight14, line134_135, line134_144 ,flag, out_valid124_134,sync_reset, out_valid134_144);
pe pe135(clk, rst, state, line134_135, line125_135, weight15, line135_136, line135_145 ,flag, out_valid125_135,sync_reset, out_valid135_145);
pe pe136(clk, rst, state, line135_136, line126_136, weight16, line136_137, line136_146 ,flag, out_valid126_136,sync_reset, out_valid136_146);
pe pe137(clk, rst, state, line136_137, line127_137, weight17, line137_138, line137_147, flag, out_valid127_137,sync_reset, out_valid137_147);
pe pe138(clk, rst, state, line137_138, line128_138, weight18, line138_139, line138_148 ,flag, out_valid128_138,sync_reset, out_valid138_148);
pe pe139(clk, rst, state, line138_139, line129_139, weight19, line139_1310, line139_149 ,flag, out_valid129_139,sync_reset, out_valid139_149);
pe pe1310(clk, rst, state,line139_1310 ,line1210_1310, weight110, line1310_1311, line1310_1410 ,flag, out_valid1210_1310,sync_reset, out_valid1310_1410);
pe pe1311(clk, rst, state,line1310_1311 ,line1211_1311, weight111, line1311_1312, line1311_1411 ,flag, out_valid1211_1311,sync_reset, out_valid1311_1411);
pe pe1312(clk, rst, state,line1311_1312 ,line1212_1312, weight112, line1312_1313, line1312_1412 ,flag, out_valid1212_1312,sync_reset, out_valid1312_1412);
pe pe1313(clk, rst, state,line1312_1313 ,line1213_1313, weight113, line1313_1314, line1313_1413 ,flag, out_valid1213_1313,sync_reset, out_valid1313_1413);
pe pe1314(clk, rst, state,line1313_1314 ,line1214_1314, weight114, line1314_1315, line1314_1414 ,flag, out_valid1214_1314,sync_reset, out_valid1314_1414);
pe pe1315(clk, rst, state,line1314_1315 , line1215_1315, weight115, line1315_1316, line1315_1415 ,flag, out_valid1215_1315,sync_reset, out_valid1315_1415);
pe_last pe1316(clk, rst, state, line1315_1316 ,line1216_1316, weight116, line1316_1416 ,flag, out_valid1216_1316,sync_reset, out_valid1316_1416);

// Systolic array row 14 (16 pics)

pe pe141(clk, rst, state, row_in14, line131_141, weight11, line141_142, line141_151 ,flag, out_valid131_141,sync_reset,out_valid141_151);
pe pe142(clk, rst, state, line141_142, line132_142, weight12, line142_143, line142_152 ,flag, out_valid132_142,sync_reset,out_valid142_152);
pe pe143(clk, rst, state, line142_143, line133_143, weight13, line143_144, line143_153 ,flag, out_valid133_143,sync_reset, out_valid143_153);
pe pe144(clk, rst, state, line143_144, line134_144, weight14, line144_145, line144_154 ,flag, out_valid134_144,sync_reset, out_valid144_154);
pe pe145(clk, rst, state, line144_145, line135_145, weight15, line145_146, line145_155 ,flag, out_valid135_145,sync_reset, out_valid145_155);
pe pe146(clk, rst, state, line145_146, line136_146, weight16, line146_147, line146_156 ,flag, out_valid136_146,sync_reset, out_valid146_156);
pe pe147(clk, rst, state, line146_147, line137_147, weight17, line147_148, line147_157, flag, out_valid137_147,sync_reset, out_valid147_157);
pe pe148(clk, rst, state, line147_148, line138_148, weight18, line148_149, line148_158 ,flag, out_valid138_148,sync_reset, out_valid148_158);
pe pe149(clk, rst, state, line148_149, line139_149, weight19, line149_1410, line149_159 ,flag, out_valid139_149,sync_reset, out_valid149_159);
pe pe1410(clk, rst, state,line149_1410 ,line1310_1410, weight110, line1410_1411, line1410_1510 ,flag, out_valid1310_1410,sync_reset, out_valid1410_1510);
pe pe1411(clk, rst, state,line1410_1411 ,line1311_1411, weight111, line1411_1412, line1411_1511 ,flag, out_valid1311_1411,sync_reset, out_valid1411_1511);
pe pe1412(clk, rst, state,line1411_1412 ,line1312_1412, weight112, line1412_1413, line1412_1512 ,flag,  out_valid1312_1412,sync_reset, out_valid1412_1512);
pe pe1413(clk, rst, state,line1412_1413 ,line1313_1413, weight113, line1413_1414, line1413_1513 ,flag, out_valid1313_1413,sync_reset, out_valid1413_1513);
pe pe1414(clk, rst, state,line1413_1414 ,line1314_1414, weight114, line1414_1415, line1414_1514 ,flag, out_valid1314_1414,sync_reset, out_valid1414_1514);
pe pe1415(clk, rst, state,line1414_1415 , line1315_1415, weight115, line1415_1416, line1415_1515 ,flag, out_valid1315_1415,sync_reset, out_valid1415_1515);
pe_last pe1416(clk, rst, state, line1415_1416 ,line1316_1416, weight116, line1416_1516 ,flag, out_valid1316_1416,sync_reset, out_valid1416_1516);

// Systolic array row 15 (16 pics)

pe pe151(clk, rst, state, row_in15, line141_151, weight11, line151_152, line151_161 ,flag, out_valid141_151,sync_reset,out_valid151_161);
pe pe152(clk, rst, state, line151_152, line142_152, weight12, line152_153, line152_162 ,flag, out_valid142_152,sync_reset,out_valid152_162);
pe pe153(clk, rst, state, line152_153, line143_153, weight13, line153_154, line153_163 ,flag, out_valid143_153,sync_reset, out_valid153_163);
pe pe154(clk, rst, state, line153_154, line144_154, weight14, line154_155, line154_164 ,flag, out_valid144_154,sync_reset, out_valid154_164);
pe pe155(clk, rst, state, line154_155, line145_155, weight15, line155_156, line155_165 ,flag, out_valid145_155,sync_reset, out_valid155_165);
pe pe156(clk, rst, state, line155_156, line146_156, weight16, line156_157, line156_166 ,flag, out_valid146_156,sync_reset, out_valid156_166);
pe pe157(clk, rst, state, line156_157, line147_157, weight17, line157_158, line157_167, flag, out_valid147_157 ,sync_reset, out_valid157_167);
pe pe158(clk, rst, state, line157_158, line148_158, weight18, line158_159, line158_168 ,flag, out_valid148_158 ,sync_reset, out_valid158_168);
pe pe159(clk, rst, state, line158_159, line149_159, weight19, line159_1510, line159_169 ,flag, out_valid149_159,sync_reset, out_valid159_169);
pe pe1510(clk, rst, state,line159_1510 ,line1410_1510, weight110, line1510_1511, line1510_1610 ,flag, out_valid1410_1510 ,sync_reset, out_valid1510_1610);
pe pe1511(clk, rst, state,line1510_1511 ,line1411_1511, weight111, line1511_1512, line1511_1611 ,flag, out_valid1411_1511 ,sync_reset, out_valid1511_1611);
pe pe1512(clk, rst, state,line1511_1512 ,line1412_1512, weight112, line1512_1513, line1512_1612 ,flag, out_valid1412_1512 ,sync_reset, out_valid1512_1612);
pe pe1513(clk, rst, state,line1512_1513 ,line1413_1513, weight113, line1513_1514, line1513_1613 ,flag, out_valid1413_1513,sync_reset, out_valid1513_1613);
pe pe1514(clk, rst, state,line1513_1514 ,line1414_1514, weight114, line1514_1515, line1514_1614 ,flag, out_valid1414_1514,sync_reset, out_valid1514_1614);
pe pe1515(clk, rst, state,line1514_1515 , line1415_1515, weight115, line1515_1516, line1515_1615 ,flag, out_valid1415_1515,sync_reset, out_valid1515_1615);
pe_last pe1516(clk, rst, state, line1515_1516 ,line1416_1516, weight116, line1516_1616 ,flag, out_valid1416_1516,sync_reset, out_valid1516_1616);

// Systolic array row 16 (16 pics)

pe_last_row pe161(clk, rst, state, row_in16, line151_161, weight11, line161_162, line161_acc1 ,flag, out_valid151_161 ,sync_reset, act_outsig1);
pe_last_row pe162(clk, rst, state, line161_162, line152_162, weight12, line162_163, line162_acc2 ,flag, out_valid152_162 ,sync_reset,act_outsig2);
pe_last_row pe163(clk, rst, state, line162_163, line153_163, weight13, line163_164, line163_acc3 ,flag, out_valid153_163 ,sync_reset, act_outsig3);

pe_last_row pe164(clk, rst, state, line163_164, line154_164, weight14, line164_165, line164_acc4 ,flag, out_valid154_164 ,sync_reset, act_outsig4);
pe_last_row pe165(clk, rst, state, line164_165, line155_165, weight15, line165_166, line165_acc5 ,flag, out_valid155_165 ,sync_reset, act_outsig5);
pe_last_row pe166(clk, rst, state, line165_166, line156_166, weight16, line166_167, line166_acc6 ,flag, out_valid156_166,sync_reset, act_outsig6);
pe_last_row pe167(clk, rst, state, line166_167, line157_167, weight17, line167_168, line167_acc7, flag, out_valid157_167,sync_reset, act_outsig7);
pe_last_row pe168(clk, rst, state, line167_168, line158_168, weight18, line168_169, line168_acc8 ,flag, out_valid158_168,sync_reset, act_outsig8);
pe_last_row pe169(clk, rst, state, line168_169, line159_169, weight19, line169_1610, line169_acc9 ,flag, out_valid159_169,sync_reset, act_outsig9);
pe_last_row pe1610(clk, rst, state,line169_1610 ,line1510_1610, weight110, line1610_1611, line1610_acc10 ,flag, out_valid1510_1610,sync_reset, act_outsig10);
pe_last_row pe1611(clk, rst, state,line1610_1611 ,line1511_1611, weight111, line1611_1612, line1611_acc11 ,flag, out_valid1511_1611,sync_reset , act_outsig11);
pe_last_row pe1612(clk, rst, state,line1611_1612 ,line1512_1612, weight112, line1612_1613, line1612_acc12 ,flag, out_valid1512_1612,sync_reset, act_outsig12);
pe_last_row pe1613(clk, rst, state,line1612_1613 ,line1513_1613, weight113, line1613_1614, line1613_acc13 ,flag, out_valid1513_1613,sync_reset, act_outsig13);
pe_last_row pe1614(clk, rst, state,line1613_1614 ,line1514_1614, weight114, line1614_1615, line1614_acc14 ,flag, out_valid1514_1614,sync_reset, act_outsig14);
pe_last_row pe1615(clk, rst, state,line1614_1615 , line1515_1615, weight115, line1615_1616, line1615_acc15 ,flag, out_valid1515_1615,sync_reset, act_outsig15);
pe_last_row_last pe1616(clk, rst, state, line1615_1616 ,line1516_1616, weight116, line1616_acc16 ,flag, out_valid1516_1616,sync_reset, act_outsig16);




assign out_acc1 = line161_acc1;
assign out_acc2 = line162_acc2; 
assign out_acc3 = line163_acc3; 
assign out_acc4 =  line164_acc4; 
assign out_acc5 = line165_acc5; 
assign out_acc6 =  line166_acc6; 
assign out_acc7 =  line167_acc7; 
assign out_acc8 =  line168_acc8; 
assign out_acc9 = line169_acc9; 
assign out_acc10 =  line1610_acc10; 
assign out_acc11 =  line1611_acc11; 
assign out_acc12 =  line1612_acc12; 
assign out_acc13 =  line1613_acc13; 
assign out_acc14 =  line1614_acc14; 
assign out_acc15 =  line1615_acc15; 
assign out_acc16 =  line1616_acc16; 

assign act_outsig_1 = act_outsig1;
assign act_outsig_2 = act_outsig2;
assign act_outsig_3 = act_outsig3;
assign act_outsig_4 = act_outsig4;
assign act_outsig_5 = act_outsig5;
assign act_outsig_6 = act_outsig6;
assign act_outsig_7 = act_outsig7;
assign act_outsig_8 = act_outsig8;
assign act_outsig_9 = act_outsig9;
assign act_outsig_10 = act_outsig10;
assign act_outsig_11 = act_outsig11;
assign act_outsig_12 = act_outsig12;
assign act_outsig_13 = act_outsig13;
assign act_outsig_14 = act_outsig14;
assign act_outsig_15 = act_outsig15;
assign act_outsig_16 = act_outsig16;


endmodule

