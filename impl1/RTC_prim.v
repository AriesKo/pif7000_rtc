// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.7.1.502
// Netlist written on Wed Jun 15 13:36:26 2016
//
// Verilog Description of module RTC
//

module RTC (GSRn, LEDR, LEDG, R0, R1, R4);   // e:/dev/rtc_lattice/hdl/rtc.vhd(32[8:11])
    input GSRn /* synthesis black_box_pad_pin=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(35[3:7])
    output LEDR /* synthesis black_box_pad_pin=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(36[3:7])
    output LEDG;   // e:/dev/rtc_lattice/hdl/rtc.vhd(37[3:7])
    output R0;   // e:/dev/rtc_lattice/hdl/rtc.vhd(38[3:5])
    output R1;   // e:/dev/rtc_lattice/hdl/rtc.vhd(39[3:5])
    output R4;   // e:/dev/rtc_lattice/hdl/rtc.vhd(40[3:5])
    
    wire R4_c /* synthesis SET_AS_NETWORK=R4_c, is_clock=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(40[3:5])
    wire GSRnX /* synthesis pullmode="UP" */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(80[8:13])
    
    wire R0_c, R1_c, red_flash, green_flash, GND_net, VCC_net;
    
    GSR GSR_INST (.GSR(GSRnX)) /* synthesis syn_black_box=true, syn_noprune=1, syn_instantiated=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(98[11:14])
    OB REDL (.I(red_flash), .O(LEDR)) /* synthesis syn_black_box=true, syn_instantiated=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(128[7:9])
    OB GRNL (.I(green_flash), .O(LEDG)) /* synthesis syn_black_box=true, syn_instantiated=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(129[7:9])
    IB IBgsr (.I(GSRn), .O(GSRnX)) /* synthesis syn_black_box=true, syn_instantiated=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(97[11:13])
    OB R4_pad (.I(R4_c), .O(R4));   // e:/dev/rtc_lattice/hdl/rtc.vhd(40[3:5])
    OB R1_pad (.I(R1_c), .O(R1));   // e:/dev/rtc_lattice/hdl/rtc.vhd(39[3:5])
    OB R0_pad (.I(R0_c), .O(R0));   // e:/dev/rtc_lattice/hdl/rtc.vhd(38[3:5])
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    VLO i1 (.Z(GND_net));
    TSALL TSALL_INST (.TSALL(GND_net));
    PIF_RTC comp_PIF_RTC (.R0_c(R0_c), .R4_c(R4_c), .R1_c(R1_c), .GND_net(GND_net));   // e:/dev/rtc_lattice/hdl/rtc.vhd(116[16:23])
    pif_flasher_U0 F (.GND_net(GND_net), .R4_c(R4_c), .red_flash(red_flash), 
            .green_flash(green_flash));   // e:/dev/rtc_lattice/hdl/rtc.vhd(105[5:16])
    VHI i179 (.Z(VCC_net));
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

//
// Verilog Description of module PIF_RTC
//

module PIF_RTC (R0_c, R4_c, R1_c, GND_net);
    output R0_c;
    input R4_c;
    output R1_c;
    input GND_net;
    
    wire R4_c /* synthesis SET_AS_NETWORK=R4_c, is_clock=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(40[3:5])
    wire [23:0]one_sec_cnt;   // e:/dev/rtc_lattice/hdl/pif_rtc.vhd(61[8:19])
    
    wire n17, PPS_P_N_131, PPS_R_N_132, n163;
    wire [23:0]n101;
    
    wire n208, n207, n206, n205, n204, n24, n203, n202, n201, 
        n200, n18, n199, n198, n197, n26, n22, n265, n15, 
        n16;
    
    LUT4 i7_4_lut (.A(one_sec_cnt[6]), .B(one_sec_cnt[20]), .C(one_sec_cnt[23]), 
         .D(one_sec_cnt[13]), .Z(n17)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i7_4_lut.init = 16'h8000;
    FD1S3AX pps_p_sig_19 (.D(PPS_P_N_131), .CK(R4_c), .Q(R0_c)) /* synthesis LSE_LINE_FILE_ID=22, LSE_LCOL=16, LSE_RCOL=23, LSE_LLINE=116, LSE_RLINE=116 */ ;   // e:/dev/rtc_lattice/hdl/pif_rtc.vhd(71[2] 82[9])
    defparam pps_p_sig_19.GSR = "ENABLED";
    FD1S3AX pps_r_sig_20 (.D(PPS_R_N_132), .CK(R4_c), .Q(R1_c)) /* synthesis LSE_LINE_FILE_ID=22, LSE_LCOL=16, LSE_RCOL=23, LSE_LLINE=116, LSE_RLINE=116 */ ;   // e:/dev/rtc_lattice/hdl/pif_rtc.vhd(71[2] 82[9])
    defparam pps_r_sig_20.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i0 (.D(n101[0]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[0])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i0.GSR = "ENABLED";
    CCU2D one_sec_cnt_15_add_4_25 (.A0(one_sec_cnt[23]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(GND_net), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n208), .S0(n101[23]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_25.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_25.INIT1 = 16'h0000;
    defparam one_sec_cnt_15_add_4_25.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_25.INJECT1_1 = "NO";
    CCU2D one_sec_cnt_15_add_4_23 (.A0(one_sec_cnt[21]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[22]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n207), .COUT(n208), .S0(n101[21]), .S1(n101[22]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_23.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_23.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_23.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_23.INJECT1_1 = "NO";
    CCU2D one_sec_cnt_15_add_4_21 (.A0(one_sec_cnt[19]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[20]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n206), .COUT(n207), .S0(n101[19]), .S1(n101[20]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_21.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_21.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_21.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_21.INJECT1_1 = "NO";
    CCU2D one_sec_cnt_15_add_4_19 (.A0(one_sec_cnt[17]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[18]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n205), .COUT(n206), .S0(n101[17]), .S1(n101[18]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_19.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_19.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_19.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_19.INJECT1_1 = "NO";
    CCU2D one_sec_cnt_15_add_4_17 (.A0(one_sec_cnt[15]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[16]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n204), .COUT(n205), .S0(n101[15]), .S1(n101[16]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_17.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_17.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_17.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_17.INJECT1_1 = "NO";
    LUT4 i10_4_lut (.A(one_sec_cnt[12]), .B(one_sec_cnt[8]), .C(one_sec_cnt[22]), 
         .D(one_sec_cnt[14]), .Z(n24)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // e:/dev/rtc_lattice/hdl/pif_rtc.vhd(77[7:47])
    defparam i10_4_lut.init = 16'hfffe;
    CCU2D one_sec_cnt_15_add_4_15 (.A0(one_sec_cnt[13]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[14]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n203), .COUT(n204), .S0(n101[13]), .S1(n101[14]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_15.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_15.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_15.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_15.INJECT1_1 = "NO";
    CCU2D one_sec_cnt_15_add_4_13 (.A0(one_sec_cnt[11]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[12]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n202), .COUT(n203), .S0(n101[11]), .S1(n101[12]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_13.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_13.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_13.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_13.INJECT1_1 = "NO";
    CCU2D one_sec_cnt_15_add_4_11 (.A0(one_sec_cnt[9]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[10]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n201), .COUT(n202), .S0(n101[9]), .S1(n101[10]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_11.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_11.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_11.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_11.INJECT1_1 = "NO";
    CCU2D one_sec_cnt_15_add_4_9 (.A0(one_sec_cnt[7]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[8]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n200), .COUT(n201), .S0(n101[7]), .S1(n101[8]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_9.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_9.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_9.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_9.INJECT1_1 = "NO";
    LUT4 i4_2_lut (.A(one_sec_cnt[15]), .B(one_sec_cnt[1]), .Z(n18)) /* synthesis lut_function=(A+(B)) */ ;   // e:/dev/rtc_lattice/hdl/pif_rtc.vhd(77[7:47])
    defparam i4_2_lut.init = 16'heeee;
    CCU2D one_sec_cnt_15_add_4_7 (.A0(one_sec_cnt[5]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[6]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n199), .COUT(n200), .S0(n101[5]), .S1(n101[6]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_7.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_7.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_7.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_7.INJECT1_1 = "NO";
    CCU2D one_sec_cnt_15_add_4_5 (.A0(one_sec_cnt[3]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[4]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n198), .COUT(n199), .S0(n101[3]), .S1(n101[4]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_5.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_5.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_5.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_5.INJECT1_1 = "NO";
    LUT4 i1_2_lut (.A(R1_c), .B(n163), .Z(PPS_R_N_132)) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;
    defparam i1_2_lut.init = 16'h6666;
    CCU2D one_sec_cnt_15_add_4_3 (.A0(one_sec_cnt[1]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[2]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n197), .COUT(n198), .S0(n101[1]), .S1(n101[2]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_3.INIT0 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_3.INIT1 = 16'hfaaa;
    defparam one_sec_cnt_15_add_4_3.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_3.INJECT1_1 = "NO";
    LUT4 i165_4_lut (.A(one_sec_cnt[7]), .B(n26), .C(n22), .D(one_sec_cnt[17]), 
         .Z(n265)) /* synthesis lut_function=(!(A+(B+(C+(D))))) */ ;   // e:/dev/rtc_lattice/hdl/pif_rtc.vhd(77[7:47])
    defparam i165_4_lut.init = 16'h0001;
    LUT4 i5_2_lut (.A(one_sec_cnt[18]), .B(one_sec_cnt[9]), .Z(n15)) /* synthesis lut_function=(A (B)) */ ;
    defparam i5_2_lut.init = 16'h8888;
    LUT4 i6_4_lut (.A(one_sec_cnt[19]), .B(one_sec_cnt[5]), .C(one_sec_cnt[11]), 
         .D(one_sec_cnt[16]), .Z(n16)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i6_4_lut.init = 16'h8000;
    LUT4 i12_4_lut (.A(one_sec_cnt[21]), .B(n24), .C(n18), .D(one_sec_cnt[2]), 
         .Z(n26)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // e:/dev/rtc_lattice/hdl/pif_rtc.vhd(77[7:47])
    defparam i12_4_lut.init = 16'hfffe;
    LUT4 i8_4_lut (.A(one_sec_cnt[4]), .B(one_sec_cnt[0]), .C(one_sec_cnt[3]), 
         .D(one_sec_cnt[10]), .Z(n22)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // e:/dev/rtc_lattice/hdl/pif_rtc.vhd(77[7:47])
    defparam i8_4_lut.init = 16'hfffe;
    LUT4 i1_2_lut_adj_9 (.A(R0_c), .B(n163), .Z(PPS_P_N_131)) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;
    defparam i1_2_lut_adj_9.init = 16'h6666;
    FD1S3IX one_sec_cnt_15__i23 (.D(n101[23]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[23])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i23.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i22 (.D(n101[22]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[22])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i22.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i21 (.D(n101[21]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[21])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i21.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i20 (.D(n101[20]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[20])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i20.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i19 (.D(n101[19]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[19])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i19.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i18 (.D(n101[18]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[18])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i18.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i17 (.D(n101[17]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[17])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i17.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i16 (.D(n101[16]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[16])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i16.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i15 (.D(n101[15]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[15])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i15.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i14 (.D(n101[14]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[14])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i14.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i13 (.D(n101[13]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[13])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i13.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i12 (.D(n101[12]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[12])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i12.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i11 (.D(n101[11]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[11])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i11.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i10 (.D(n101[10]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[10])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i10.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i9 (.D(n101[9]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[9])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i9.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i8 (.D(n101[8]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[8])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i8.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i7 (.D(n101[7]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[7])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i7.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i6 (.D(n101[6]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[6])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i6.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i5 (.D(n101[5]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[5])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i5.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i4 (.D(n101[4]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[4])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i4.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i3 (.D(n101[3]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[3])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i3.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i2 (.D(n101[2]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[2])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i2.GSR = "ENABLED";
    FD1S3IX one_sec_cnt_15__i1 (.D(n101[1]), .CK(R4_c), .CD(n163), .Q(one_sec_cnt[1])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15__i1.GSR = "ENABLED";
    LUT4 i166_4_lut (.A(n17), .B(n265), .C(n15), .D(n16), .Z(n163)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // e:/dev/rtc_lattice/hdl/pif_rtc.vhd(77[7:47])
    defparam i166_4_lut.init = 16'h8000;
    CCU2D one_sec_cnt_15_add_4_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(one_sec_cnt[0]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .COUT(n197), .S1(n101[0]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam one_sec_cnt_15_add_4_1.INIT0 = 16'hF000;
    defparam one_sec_cnt_15_add_4_1.INIT1 = 16'h0555;
    defparam one_sec_cnt_15_add_4_1.INJECT1_0 = "NO";
    defparam one_sec_cnt_15_add_4_1.INJECT1_1 = "NO";
    
endmodule
//
// Verilog Description of module pif_flasher_U0
//

module pif_flasher_U0 (GND_net, R4_c, red_flash, green_flash);
    input GND_net;
    output R4_c;
    output red_flash;
    output green_flash;
    
    wire R4_c /* synthesis SET_AS_NETWORK=R4_c, is_clock=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(40[3:5])
    wire [5:0]Accum;   // e:/dev/rtc_lattice/hdl/piffla.vhd(111[10:15])
    wire [6:0]DeltaReg;   // e:/dev/rtc_lattice/hdl/piffla.vhd(114[10:18])
    wire [5:0]Accum_5__N_21;
    
    wire LedOn, n261, n2, n287, n289, n288, Tick;
    wire [6:0]n33;
    wire [4:0]n26;
    
    wire Tick_N_41, n221, n220, n219;
    
    LUT4 i2_3_lut_4_lut (.A(Accum[0]), .B(DeltaReg[0]), .C(Accum[1]), 
         .D(DeltaReg[1]), .Z(Accum_5__N_21[1])) /* synthesis lut_function=(A (B (C (D)+!C !(D))+!B !(C (D)+!C !(D)))+!A !(C (D)+!C !(D))) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(182[18:21])
    defparam i2_3_lut_4_lut.init = 16'h8778;
    OSCH OSCInst0 (.STDBY(GND_net), .OSC(R4_c)) /* synthesis nom_freq="26.60", syn_instantiated=1, LSE_LINE_FILE_ID=22, LSE_LCOL=5, LSE_RCOL=16, LSE_LLINE=105, LSE_RLINE=105 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(105[5:16])
    defparam OSCInst0.NOM_FREQ = "26.60";
    FD1S3AX LedOn_36 (.D(Accum[5]), .CK(R4_c), .Q(LedOn)) /* synthesis LSE_LINE_FILE_ID=22, LSE_LCOL=5, LSE_RCOL=16, LSE_LLINE=105, LSE_RLINE=105 */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(176[5] 189[12])
    defparam LedOn_36.GSR = "DISABLED";
    FD1S3JX R_37 (.D(n261), .CK(R4_c), .PD(DeltaReg[6]), .Q(red_flash)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=22, LSE_LCOL=5, LSE_RCOL=16, LSE_LLINE=105, LSE_RLINE=105 */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(176[5] 189[12])
    defparam R_37.GSR = "DISABLED";
    FD1S3JX G_38 (.D(n261), .CK(R4_c), .PD(n2), .Q(green_flash)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=22, LSE_LCOL=5, LSE_RCOL=16, LSE_LLINE=105, LSE_RLINE=105 */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(176[5] 189[12])
    defparam G_38.GSR = "DISABLED";
    LUT4 i53_4_lut_3_lut (.A(DeltaReg[4]), .B(n287), .C(Accum[4]), .Z(Accum_5__N_21[5])) /* synthesis lut_function=(A (B+(C))+!A (B (C))) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(182[18:21])
    defparam i53_4_lut_3_lut.init = 16'he8e8;
    LUT4 i32_4_lut_3_lut_rep_3_4_lut (.A(Accum[0]), .B(DeltaReg[0]), .C(Accum[1]), 
         .D(DeltaReg[1]), .Z(n289)) /* synthesis lut_function=(A (B (C+(D))+!B (C (D)))+!A (C (D))) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(182[18:21])
    defparam i32_4_lut_3_lut_rep_3_4_lut.init = 16'hf880;
    LUT4 i46_4_lut_3_lut_rep_1 (.A(DeltaReg[3]), .B(n288), .C(Accum[3]), 
         .Z(n287)) /* synthesis lut_function=(A (B+(C))+!A (B (C))) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(182[18:21])
    defparam i46_4_lut_3_lut_rep_1.init = 16'he8e8;
    FD1P3AX DeltaReg_14__i0 (.D(n33[0]), .SP(Tick), .CK(R4_c), .Q(DeltaReg[0])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14__i0.GSR = "DISABLED";
    FD1P3AX DeltaReg_14__i6 (.D(n33[6]), .SP(Tick), .CK(R4_c), .Q(DeltaReg[6])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14__i6.GSR = "DISABLED";
    LUT4 i19_2_lut (.A(Accum[0]), .B(DeltaReg[0]), .Z(n26[0])) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(182[18:21])
    defparam i19_2_lut.init = 16'h6666;
    LUT4 i39_4_lut_3_lut_rep_2 (.A(DeltaReg[2]), .B(n289), .C(Accum[2]), 
         .Z(n288)) /* synthesis lut_function=(A (B+(C))+!A (B (C))) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(182[18:21])
    defparam i39_4_lut_3_lut_rep_2.init = 16'he8e8;
    LUT4 Tick_I_0_1_lut (.A(Tick), .Z(Tick_N_41)) /* synthesis lut_function=(!(A)) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(149[14:36])
    defparam Tick_I_0_1_lut.init = 16'h5555;
    FD1S3IX Accum__i0 (.D(n26[0]), .CK(R4_c), .CD(Tick), .Q(Accum[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=22, LSE_LCOL=5, LSE_RCOL=16, LSE_LLINE=105, LSE_RLINE=105 */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(176[5] 189[12])
    defparam Accum__i0.GSR = "DISABLED";
    LUT4 i54_1_lut (.A(DeltaReg[6]), .Z(n2)) /* synthesis lut_function=(!(A)) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(188[24:34])
    defparam i54_1_lut.init = 16'h5555;
    FD1P3AX DeltaReg_14__i5 (.D(n33[5]), .SP(Tick), .CK(R4_c), .Q(DeltaReg[5])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14__i5.GSR = "DISABLED";
    FD1P3AX DeltaReg_14__i4 (.D(n33[4]), .SP(Tick), .CK(R4_c), .Q(DeltaReg[4])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14__i4.GSR = "DISABLED";
    FD1P3AX DeltaReg_14__i3 (.D(n33[3]), .SP(Tick), .CK(R4_c), .Q(DeltaReg[3])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14__i3.GSR = "DISABLED";
    FD1P3AX DeltaReg_14__i2 (.D(n33[2]), .SP(Tick), .CK(R4_c), .Q(DeltaReg[2])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14__i2.GSR = "DISABLED";
    FD1P3AX DeltaReg_14__i1 (.D(n33[1]), .SP(Tick), .CK(R4_c), .Q(DeltaReg[1])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14__i1.GSR = "DISABLED";
    LUT4 i161_2_lut (.A(DeltaReg[5]), .B(LedOn), .Z(n261)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(187[22:78])
    defparam i161_2_lut.init = 16'h9999;
    FD1S3IX Accum__i5 (.D(Accum_5__N_21[5]), .CK(R4_c), .CD(Tick), .Q(Accum[5])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=22, LSE_LCOL=5, LSE_RCOL=16, LSE_LLINE=105, LSE_RLINE=105 */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(176[5] 189[12])
    defparam Accum__i5.GSR = "DISABLED";
    LUT4 i2_3_lut (.A(n289), .B(DeltaReg[2]), .C(Accum[2]), .Z(Accum_5__N_21[2])) /* synthesis lut_function=(A (B (C)+!B !(C))+!A !(B (C)+!B !(C))) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(182[18:21])
    defparam i2_3_lut.init = 16'h9696;
    \DownCounter(18)_c15  DownCounter_18__i205 (.Tick(Tick), .R4_c(R4_c), 
            .Tick_N_41(Tick_N_41));
    CCU2D DeltaReg_14_add_4_7 (.A0(DeltaReg[5]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(DeltaReg[6]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n221), .S0(n33[5]), .S1(n33[6]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14_add_4_7.INIT0 = 16'hfaaa;
    defparam DeltaReg_14_add_4_7.INIT1 = 16'hfaaa;
    defparam DeltaReg_14_add_4_7.INJECT1_0 = "NO";
    defparam DeltaReg_14_add_4_7.INJECT1_1 = "NO";
    CCU2D DeltaReg_14_add_4_5 (.A0(DeltaReg[3]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(DeltaReg[4]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n220), .COUT(n221), .S0(n33[3]), .S1(n33[4]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14_add_4_5.INIT0 = 16'hfaaa;
    defparam DeltaReg_14_add_4_5.INIT1 = 16'hfaaa;
    defparam DeltaReg_14_add_4_5.INJECT1_0 = "NO";
    defparam DeltaReg_14_add_4_5.INJECT1_1 = "NO";
    CCU2D DeltaReg_14_add_4_3 (.A0(DeltaReg[1]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(DeltaReg[2]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n219), .COUT(n220), .S0(n33[1]), .S1(n33[2]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14_add_4_3.INIT0 = 16'hfaaa;
    defparam DeltaReg_14_add_4_3.INIT1 = 16'hfaaa;
    defparam DeltaReg_14_add_4_3.INJECT1_0 = "NO";
    defparam DeltaReg_14_add_4_3.INJECT1_1 = "NO";
    CCU2D DeltaReg_14_add_4_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(DeltaReg[0]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .COUT(n219), .S1(n33[0]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1241[12:13])
    defparam DeltaReg_14_add_4_1.INIT0 = 16'hF000;
    defparam DeltaReg_14_add_4_1.INIT1 = 16'h0555;
    defparam DeltaReg_14_add_4_1.INJECT1_0 = "NO";
    defparam DeltaReg_14_add_4_1.INJECT1_1 = "NO";
    LUT4 i2_3_lut_adj_7 (.A(n288), .B(DeltaReg[3]), .C(Accum[3]), .Z(Accum_5__N_21[3])) /* synthesis lut_function=(A (B (C)+!B !(C))+!A !(B (C)+!B !(C))) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(182[18:21])
    defparam i2_3_lut_adj_7.init = 16'h9696;
    LUT4 i2_3_lut_adj_8 (.A(n287), .B(DeltaReg[4]), .C(Accum[4]), .Z(Accum_5__N_21[4])) /* synthesis lut_function=(A (B (C)+!B !(C))+!A !(B (C)+!B !(C))) */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(182[18:21])
    defparam i2_3_lut_adj_8.init = 16'h9696;
    FD1S3IX Accum__i4 (.D(Accum_5__N_21[4]), .CK(R4_c), .CD(Tick), .Q(Accum[4])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=22, LSE_LCOL=5, LSE_RCOL=16, LSE_LLINE=105, LSE_RLINE=105 */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(176[5] 189[12])
    defparam Accum__i4.GSR = "DISABLED";
    FD1S3IX Accum__i3 (.D(Accum_5__N_21[3]), .CK(R4_c), .CD(Tick), .Q(Accum[3])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=22, LSE_LCOL=5, LSE_RCOL=16, LSE_LLINE=105, LSE_RLINE=105 */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(176[5] 189[12])
    defparam Accum__i3.GSR = "DISABLED";
    FD1S3IX Accum__i2 (.D(Accum_5__N_21[2]), .CK(R4_c), .CD(Tick), .Q(Accum[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=22, LSE_LCOL=5, LSE_RCOL=16, LSE_LLINE=105, LSE_RLINE=105 */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(176[5] 189[12])
    defparam Accum__i2.GSR = "DISABLED";
    FD1S3IX Accum__i1 (.D(Accum_5__N_21[1]), .CK(R4_c), .CD(Tick), .Q(Accum[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=22, LSE_LCOL=5, LSE_RCOL=16, LSE_LLINE=105, LSE_RLINE=105 */ ;   // e:/dev/rtc_lattice/hdl/piffla.vhd(176[5] 189[12])
    defparam Accum__i1.GSR = "DISABLED";
    
endmodule
//
// Verilog Description of module \DownCounter(18)_c15 
//

module \DownCounter(18)_c15  (Tick, R4_c, Tick_N_41) /* synthesis syn_hier="hard" */ ;
    output Tick;
    input R4_c;
    input Tick_N_41;
    
    wire R4_c /* synthesis SET_AS_NETWORK=R4_c, is_clock=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(40[3:5])
    wire [18:0]n142;
    
    wire xclk_keep_2, n164;
    wire [18:0]n81;
    
    wire n217, GND_net, n216, n215, n214, n213, n212, n211, 
        n210, n209, VCC_net;
    
    FD1S3IX Ctr_17__i18 (.D(n81[18]), .CK(xclk_keep_2), .CD(n164), .Q(n142[18])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i18.GSR = "DISABLED";
    CCU2D Ctr_17_add_4_19 (.A0(n142[17]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(n142[18]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n217), .S0(n81[17]), .S1(n81[18]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17_add_4_19.INIT0 = 16'h0555;
    defparam Ctr_17_add_4_19.INIT1 = 16'h0555;
    defparam Ctr_17_add_4_19.INJECT1_0 = "NO";
    defparam Ctr_17_add_4_19.INJECT1_1 = "NO";
    CCU2D Ctr_17_add_4_17 (.A0(n142[15]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(n142[16]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n216), .COUT(n217), .S0(n81[15]), .S1(n81[16]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17_add_4_17.INIT0 = 16'h0555;
    defparam Ctr_17_add_4_17.INIT1 = 16'h0555;
    defparam Ctr_17_add_4_17.INJECT1_0 = "NO";
    defparam Ctr_17_add_4_17.INJECT1_1 = "NO";
    FD1S3JX Ctr_17__i17 (.D(n81[17]), .CK(xclk_keep_2), .PD(n164), .Q(n142[17])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i17.GSR = "DISABLED";
    CCU2D Ctr_17_add_4_15 (.A0(n142[13]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(n142[14]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n215), .COUT(n216), .S0(n81[13]), .S1(n81[14]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17_add_4_15.INIT0 = 16'h0555;
    defparam Ctr_17_add_4_15.INIT1 = 16'h0555;
    defparam Ctr_17_add_4_15.INJECT1_0 = "NO";
    defparam Ctr_17_add_4_15.INJECT1_1 = "NO";
    FD1S3JX Ctr_17__i15 (.D(n81[15]), .CK(xclk_keep_2), .PD(n164), .Q(n142[15])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i15.GSR = "DISABLED";
    FD1S3IX Ctr_17__i16 (.D(n81[16]), .CK(xclk_keep_2), .CD(n164), .Q(n142[16])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i16.GSR = "DISABLED";
    CCU2D Ctr_17_add_4_13 (.A0(n142[11]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(n142[12]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n214), .COUT(n215), .S0(n81[11]), .S1(n81[12]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17_add_4_13.INIT0 = 16'h0555;
    defparam Ctr_17_add_4_13.INIT1 = 16'h0555;
    defparam Ctr_17_add_4_13.INJECT1_0 = "NO";
    defparam Ctr_17_add_4_13.INJECT1_1 = "NO";
    FD1S3JX Ctr_17__i13 (.D(n81[13]), .CK(xclk_keep_2), .PD(n164), .Q(n142[13])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i13.GSR = "DISABLED";
    FD1S3IX Ctr_17__i14 (.D(n81[14]), .CK(xclk_keep_2), .CD(n164), .Q(n142[14])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i14.GSR = "DISABLED";
    CCU2D Ctr_17_add_4_11 (.A0(n142[9]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(n142[10]), .B1(GND_net), .C1(GND_net), .D1(GND_net), .CIN(n213), 
          .COUT(n214), .S0(n81[9]), .S1(n81[10]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17_add_4_11.INIT0 = 16'h0555;
    defparam Ctr_17_add_4_11.INIT1 = 16'h0555;
    defparam Ctr_17_add_4_11.INJECT1_0 = "NO";
    defparam Ctr_17_add_4_11.INJECT1_1 = "NO";
    FD1S3IX Ctr_17__i11 (.D(n81[11]), .CK(xclk_keep_2), .CD(n164), .Q(n142[11])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i11.GSR = "DISABLED";
    FD1S3JX Ctr_17__i12 (.D(n81[12]), .CK(xclk_keep_2), .PD(n164), .Q(n142[12])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i12.GSR = "DISABLED";
    CCU2D Ctr_17_add_4_9 (.A0(n142[7]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(n142[8]), .B1(GND_net), .C1(GND_net), .D1(GND_net), .CIN(n212), 
          .COUT(n213), .S0(n81[7]), .S1(n81[8]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17_add_4_9.INIT0 = 16'h0555;
    defparam Ctr_17_add_4_9.INIT1 = 16'h0555;
    defparam Ctr_17_add_4_9.INJECT1_0 = "NO";
    defparam Ctr_17_add_4_9.INJECT1_1 = "NO";
    FD1S3IX Ctr_17__i9 (.D(n81[9]), .CK(xclk_keep_2), .CD(n164), .Q(n142[9])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i9.GSR = "DISABLED";
    FD1S3JX Ctr_17__i10 (.D(n81[10]), .CK(xclk_keep_2), .PD(n164), .Q(n142[10])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i10.GSR = "DISABLED";
    CCU2D Ctr_17_add_4_7 (.A0(n142[5]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(n142[6]), .B1(GND_net), .C1(GND_net), .D1(GND_net), .CIN(n211), 
          .COUT(n212), .S0(n81[5]), .S1(n81[6]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17_add_4_7.INIT0 = 16'h0555;
    defparam Ctr_17_add_4_7.INIT1 = 16'h0555;
    defparam Ctr_17_add_4_7.INJECT1_0 = "NO";
    defparam Ctr_17_add_4_7.INJECT1_1 = "NO";
    FD1S3JX Ctr_17__i7 (.D(n81[7]), .CK(xclk_keep_2), .PD(n164), .Q(n142[7])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i7.GSR = "DISABLED";
    FD1S3IX Ctr_17__i8 (.D(n81[8]), .CK(xclk_keep_2), .CD(n164), .Q(n142[8])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i8.GSR = "DISABLED";
    CCU2D Ctr_17_add_4_5 (.A0(n142[3]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(n142[4]), .B1(GND_net), .C1(GND_net), .D1(GND_net), .CIN(n210), 
          .COUT(n211), .S0(n81[3]), .S1(n81[4]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17_add_4_5.INIT0 = 16'h0555;
    defparam Ctr_17_add_4_5.INIT1 = 16'h0555;
    defparam Ctr_17_add_4_5.INJECT1_0 = "NO";
    defparam Ctr_17_add_4_5.INJECT1_1 = "NO";
    FD1S3JX Ctr_17__i5 (.D(n81[5]), .CK(xclk_keep_2), .PD(n164), .Q(n142[5])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i5.GSR = "DISABLED";
    FD1S3IX Ctr_17__i6 (.D(n81[6]), .CK(xclk_keep_2), .CD(n164), .Q(n142[6])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i6.GSR = "DISABLED";
    CCU2D Ctr_17_add_4_3 (.A0(n142[1]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(n142[2]), .B1(GND_net), .C1(GND_net), .D1(GND_net), .CIN(n209), 
          .COUT(n210), .S0(n81[1]), .S1(n81[2]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17_add_4_3.INIT0 = 16'h0555;
    defparam Ctr_17_add_4_3.INIT1 = 16'h0555;
    defparam Ctr_17_add_4_3.INJECT1_0 = "NO";
    defparam Ctr_17_add_4_3.INJECT1_1 = "NO";
    FD1S3IX Ctr_17__i3 (.D(n81[3]), .CK(xclk_keep_2), .CD(n164), .Q(n142[3])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i3.GSR = "DISABLED";
    FD1S3JX Ctr_17__i4 (.D(n81[4]), .CK(xclk_keep_2), .PD(n164), .Q(n142[4])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i4.GSR = "DISABLED";
    CCU2D Ctr_17_add_4_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(n142[0]), .B1(GND_net), .C1(GND_net), .D1(GND_net), .COUT(n209), 
          .S1(n81[0]));   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17_add_4_1.INIT0 = 16'hF000;
    defparam Ctr_17_add_4_1.INIT1 = 16'h0555;
    defparam Ctr_17_add_4_1.INJECT1_0 = "NO";
    defparam Ctr_17_add_4_1.INJECT1_1 = "NO";
    FD1S3IX Ctr_17__i1 (.D(n81[1]), .CK(xclk_keep_2), .CD(n164), .Q(n142[1])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i1.GSR = "DISABLED";
    FD1S3JX Ctr_17__i2 (.D(n81[2]), .CK(xclk_keep_2), .PD(n164), .Q(n142[2])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i2.GSR = "DISABLED";
    FD1S3JX Ctr_17__i0 (.D(n81[0]), .CK(xclk_keep_2), .PD(n164), .Q(n142[0])) /* synthesis syn_use_carry_chain=1 */ ;   // C:/lscc/diamond/3.7_x64/ispfpga/vhdl_packages/numeric_std.vhd(1308[12:13])
    defparam Ctr_17__i0.GSR = "DISABLED";
    VLO HierGndInst_1 (.Z(GND_net));
    pif_flasher F (.Tick(Tick), .Tick_kb_in(n142[18]), .R4_c(R4_c), .xclk_keep_2(xclk_keep_2), 
            .n164(n164), .Tick_N_41(Tick_N_41));   // e:/dev/rtc_lattice/hdl/rtc.vhd(105[5:16])
    VHI HierPwrInst_1 (.Z(VCC_net));
    
endmodule
//
// Verilog Description of module pif_flasher
//

module pif_flasher (Tick, Tick_kb_in, R4_c, xclk_keep_2, n164, Tick_N_41);
    output Tick;
    input Tick_kb_in;
    input R4_c;
    output xclk_keep_2;
    output n164;
    input Tick_N_41;
    
    wire xclk_keep_2 /* synthesis SET_AS_NETWORK=R4_c, is_clock=1 */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(40[3:5])
    
    assign Tick = Tick_kb_in;
    assign xclk_keep_2 = R4_c;
    LUT4 i88_1_lut (.A(Tick_N_41), .Z(n164)) /* synthesis lut_function=(!(A)) */ ;   // e:/dev/rtc_lattice/hdl/rtc.vhd(105[5:16])
    defparam i88_1_lut.init = 16'h5555;
    
endmodule
