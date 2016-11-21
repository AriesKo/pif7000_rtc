----------------------------------------------------------------------------------
-- Company:         EIAST & Satrec Initiative
--
-- Engineer:        Jun-Yong Park (jypark@satreci.com)
--
--                  Ahmed Salem Belal (Ahmed.salem@eiast.ae)
--
--                  Sun-Jae Lee (sjlee@satreci.com) (ADPLL Core)
--
-- Project Name:    DubaiSat-2 C&DH OBC AUX FPGA Design
--
-- Target Device:   A3P250 FBGA144
--
-- Module Name:     ADPLL_CORE.vhd
--
-- Dependent Files:
--
----------------------------------------------------------------------------------
-- Description:
--
-- This is the ADPLL_CORE which is glue logic for the ADPLL_CORE File
--
-- Functions:
--
-- (1): Generate 128Hz on External interuppt for LEON3 syncronization
-- (2): Generate 1Hz on External interuppt for LEON3 syncronization
-- (3): Generate 1Hz on CDH CAN Network to syncronize all modules OBC_PPS
-- (4): Generate OBC_PPS even in the absense of the PPS
--
----------------------------------------------------------------------------------
-- Revision:
--
-- 13.October.2009: First File Created, Version 0.1
-- 22.October.2009: Change ADPLL_CORE code to run on 20MHZ clock (still not completed)
-- 28.October.2009: Change the ADPLL TOP to have Automatic Accuracy (M) Setting
-- 23.October.2013: Overall changes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


Entity ADPLL_RTC_CORE is
Port (
    -- General Signals
    RESET           :In STD_LOGIC;
	PORn			:IN STD_LOGIC;
    CLK_20M_REF     :In STD_LOGIC;

    --PPS input signals
    PPSIN1     		:In STD_LOGIC;
    PPSIN2     		:In STD_LOGIC;

    -- PPSIN_EN          :In STD_LOGIC;

    --ADPLL Register
    -- ADPLL_State_IN  :In STD_LOGIC_VECTOR(5 downto 0); --TMTC States Input only
    -- ADPLL_State_OUT :OUT STD_LOGIC_VECTOR(1 downto 0); --TMTC States OUTPUT Only
    -- PPS_CNT     	:OUT STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- PPS1_VALID      : out std_logic;
    -- PPS2_VALID      : out std_logic;

    -- SRC_SEL_EN      : in  std_logic;
    -- SRC_SEL         : in  std_logic;
    -- SRC_SEL_ST      : out std_logic;

    -- PPSIN_INVALID   : out std_logic;
    -- PPSIN_VALID     : out std_logic;
    -- PPS_UNLOCK      : out std_logic;
    -- PPS_LOCK        : out std_logic;
	
	
	-- Related to RTC --------

	RTC_SET_CMD         : IN    STD_LOGIC; 
	ADPLL_REG_WEN		: IN	STD_LOGIC; 
	RTC_CTRL_REG_WEN	: IN	STD_LOGIC;
	RTC_SECOND_CNT_WEN	: IN	STD_LOGIC;
	
    MEM_DATA	        : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);     
	SEC_OUT_DATA        : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0); 
    SUB_SEC_OUT_DATA    : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
	USEC_OUT_DATA      	: OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
	ADPLL_REG			: OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
	RTC_CTRL_REG		: OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
	
    --Interuppt
    EXT_INT_1HZ     	:OUT STD_LOGIC;
    EXT_INT_128HZ   	:OUT STD_LOGIC
	
  );
end ADPLL_RTC_CORE;

architecture Behavioral of ADPLL_RTC_CORE is

----------------------------------------------------------------------------------
--Initialize Components-----------------------------------------------------------
----------------------------------------------------------------------------------

--ADPLL Core Initialization----
Component ADPLL_CORE
Port(
    CLK               : in  STD_LOGIC;
    S_RESETn          : in  STD_LOGIC;
    PPSIN1            : in  STD_LOGIC;
    PPSIN2            : in  STD_LOGIC;
    M                 : in  STD_LOGIC_VECTOR (2 downto 0);
    DIS_FRST          : in  STD_LOGIC;
    EN_AUTO           : in  STD_LOGIC;
    CLK_OUT_1         : out STD_LOGIC;
    CLK_OUT_8         : out STD_LOGIC;
    CLK_OUT_128       : out STD_LOGIC;
	CLK_DCO_1M		  : out STD_LOGIC;	
    LOCKED            : out STD_LOGIC;
    PPS1_VALID        : out STD_LOGIC;
    PPS2_VALID        : out STD_LOGIC;
    PPS_VALID         : out std_logic;    -- Selected PPS valid

    PPSIN_EN          : in  std_logic;
    PPSIN_SEL         : in  std_logic;

    SRC_SEL_EN        : in  std_logic;    -- 0: Auto Selection by ADPLL IP, 1: Source selection by SRC_SEL bit
    SRC_SEL           : in  std_logic;    -- 0: clock, 1: PPS
    SRC_SEL_ST        : out std_logic;    -- 0: clock, 1: PPS

    PPSIN_INVALID     : out std_logic;
    PPSIN_VALID       : out std_logic;
    PPS_UNLOCK        : out std_logic;
    PPS_LOCK          : out std_logic
  );
END component;

COMPONENT RTC IS
PORT(
    RST                 : IN    STD_LOGIC;
    PORn                : in    std_logic;                          -- 20131111 added by sunjae
    CLK                 : IN    STD_LOGIC;

    PPS                 : IN    STD_LOGIC;
    ADPLL_128HZ         : IN    STD_LOGIC;
	ADPLL_1MZ	        : IN    STD_LOGIC;
	RTC_SET_CMD             : IN    STD_LOGIC;
        RTC_SECOND_CNT         : IN    STD_LOGIC_VECTOR(31 DOWNTO 0); --added by dhkim
    --SEC_IN_DATA         : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);	--removed by dhkim
    SEC_OUT_DATA        : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
    SUB_SEC_OUT_DATA    : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
	USEC_OUT_DATA       : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0)

     );
END COMPONENT;

----------------------------------------------------------------------------------
--Signals Deceleration(Linking)---------------------------------------------------
----------------------------------------------------------------------------------

                --Setting Signals for the ADPLL Core
                SIGNAL S_ACCR_M		    : STD_LOGIC_VECTOR (2 downto 0);
				SIGNAL S_RTC_CTRL_REG	: STD_LOGIC_VECTOR (31 downto 0);
                -- SIGNAL S_DIS_FRST           : STD_LOGIC;                     -- 20130124 deleted by Sunjae
                SIGNAL S_EN_AUTO        : STD_LOGIC;
                SIGNAL S_PPSIN_SEL      : STD_LOGIC;--_VECTOR(1 downto 0);
                SIGNAL S_PPS_LOCK       : STD_LOGIC;
                SIGNAL S_PPS_VAL        : STD_LOGIC;
                SIGNAL S_CLK_OUT_1      : STD_LOGIC;
                SIGNAL S_CLK_OUT_8      : STD_LOGIC;
                SIGNAL S_CLK_OUT_128    : STD_LOGIC;
				SIGNAL S_CLK_DCO_1M		: STD_LOGIC;
                SIGNAL S_PPS_CNT        : STD_LOGIC_VECTOR(7 downto 0);
                SIGNAL S_TMP_PPS        : STD_LOGIC;
                SIGNAL S_TMP_PPS_DFF    : STD_LOGIC;
				SIGNAL PPSIN_EN			: STD_LOGIC;
				SIGNAL SRC_SEL_EN       : STD_LOGIC;
				SIGNAL SRC_SEL          : STD_LOGIC;
				SIGNAL SRC_SEL_ST       : STD_LOGIC;
				SIGNAL PPS1_VALID       : STD_LOGIC;
				SIGNAL PPS2_VALID       : STD_LOGIC;

				-- added by dhkim
				SIGNAL S_RTC_SECOND_CNT_REG	: STD_LOGIC_VECTOR (31 downto 0);

----------------------------------------------------------------------------------
--Start of the Program------------------------------------------------------------
----------------------------------------------------------------------------------

Begin

RTC_CTRL_REG	<= S_RTC_CTRL_REG;
ADPLL_REG		<= PPSIN_EN & SRC_SEL_EN & SRC_SEL & SRC_SEL_ST 
				   & "00" & PPS1_VALID & PPS2_VALID & X"0000" 
				   & S_PPS_LOCK & S_PPS_VAL & S_ACCR_M 
				   & S_EN_AUTO & '0' & S_PPSIN_SEL;
				   
--Translation of the ADPLL STATE Register

Process(RESET, CLK_20M_REF)
Begin
	IF RESET = '0' THEN
		S_PPSIN_SEL <= '0';
		S_EN_AUTO 	<= '1';
		S_ACCR_M	<= "000";
		SRC_SEL		<= '0';
		SRC_SEL_EN	<= '0';
		PPSIN_EN 	<= '0';
	ELSIF CLK_20M_REF'EVENT AND CLK_20M_REF = '1' THEN
		IF ADPLL_REG_WEN = '0' THEN
			S_PPSIN_SEL <= MEM_DATA(0);
			S_EN_AUTO 	<= MEM_DATA(2);
			S_ACCR_M	<= MEM_DATA(5 DOWNTO 3);
			SRC_SEL		<= MEM_DATA(29);
			SRC_SEL_EN	<= MEM_DATA(30);
			PPSIN_EN	<= MEM_DATA(31);
			
		--ELSE
		--	S_PPSIN_SEL <=	S_PPSIN_SEL ;
		--	S_EN_AUTO 	<=  S_EN_AUTO 	;
		--	S_ACCR_M	<=  S_ACCR_M	;
		--	SRC_SEL		<=  SRC_SEL		;
		--	SRC_SEL_EN	<=  SRC_SEL_EN	;
		--	PPSIN_EN	<=  PPSIN_EN	;
		END IF;
	END IF;
END PROCESS;

Process(RESET, CLK_20M_REF)
Begin
	IF RESET = '0' THEN
		S_RTC_CTRL_REG <= X"00000000";
	ELSIF CLK_20M_REF'EVENT AND CLK_20M_REF = '1' THEN
		IF RTC_CTRL_REG_WEN = '0' THEN
			S_RTC_CTRL_REG <= MEM_DATA;
		--ELSE
		--	S_RTC_CTRL_REG <= S_RTC_CTRL_REG;
		END IF;
	END IF;
END PROCESS;

-- added by dhkim
Process(RESET, CLK_20M_REF)
Begin
	IF RESET = '0' THEN
		S_RTC_SECOND_CNT_REG <= X"00000000";
	ELSIF CLK_20M_REF'EVENT AND CLK_20M_REF = '1' THEN
		IF RTC_SECOND_CNT_WEN = '0' THEN
			S_RTC_SECOND_CNT_REG <= MEM_DATA;
		--ELSE
		--	S_RTC_SECOND_CNT_REG <= S_RTC_SECOND_CNT_REG;
		END IF;
	END IF;
END PROCESS;

--This process select Between the PPS SOURCE (Either PPS1 or PPS2)
Process(RESET, CLK_20M_REF)
Begin
	IF RESET = '0' THEN
		S_TMP_PPS <= '1';
	ELSIF CLK_20M_REF'EVENT AND CLK_20M_REF = '1' THEN

		--Selection of the PPS Source
		IF S_PPSIN_SEL = '0' Then
			S_TMP_PPS <= PPSIN1;
		ELSE
			S_TMP_PPS <= PPSIN2;
		END IF;
	END IF;
END PROCESS;

PROCESS(RESET, CLK_20M_REF)
BEGIN
	IF RESET = '0' THEN
		S_TMP_PPS_DFF <= '1';
		S_PPS_CNT <= (OTHERS => '0');

	ELSIF CLK_20M_REF'EVENT AND CLK_20M_REF = '1' THEN
		S_TMP_PPS_DFF <= S_TMP_PPS;

		IF S_TMP_PPS = '0' AND S_TMP_PPS_DFF = '1' THEN         --FALLING EDGE
			S_PPS_CNT <= S_PPS_CNT + '1' ;
		END IF;
	END IF;
END PROCESS;

--Send 128Hz and 1 Hz on External Signals
EXT_INT_1HZ     <= S_CLK_OUT_1;
EXT_INT_128HZ   <= S_CLK_OUT_128;


----------------------------------------------------------------------------------
--Port Mapping--------------------------------------------------------------------
----------------------------------------------------------------------------------

--Port mapping the ADPLL core
ADPLL_CORE_Label: ADPLL_CORE
Port map(
    CLK               => CLK_20M_REF,       -- Main Operatational Clock (20MHz)
    S_RESETn          => RESET,             -- Active low Reset
    PPSIN1            => PPSIN1,       		-- Clock Refferance/ PPS Primary
    PPSIN2            => PPSIN2,       		-- Clock Refferance/ PPS Redundant
    M                 => S_ACCR_M,          -- Accuracy Setting, Default is "000" Highest
    DIS_FRST          => '0',               -- Not Used (Falling Reset Enabled)
    EN_AUTO           => S_EN_AUTO,         -- Automatic Accuracy Option, always valid
    CLK_OUT_1         => S_CLK_OUT_1,       -- 1 Hz Synced Clock
    CLK_OUT_8         => S_CLK_OUT_8,       -- 8 Hz Synced Clock
    CLK_OUT_128       => S_CLK_OUT_128,     -- 128 Hz Synced Clock
	CLK_DCO_1M		  => S_CLK_DCO_1M,      -- 1 MHz Synced Clock		  
    LOCKED            => S_PPS_LOCK,        -- Indication of Syncronized output
    PPS1_VALID        => PPS1_VALID,
    PPS2_VALID        => PPS2_VALID,
    PPS_VALID         => S_PPS_VAL,         -- Indication for valid PPS Source

    PPSIN_EN          => PPSIN_EN,
    PPSIN_SEL         => S_PPSIN_SEL,

    SRC_SEL_EN        => SRC_SEL_EN,
    SRC_SEL           => SRC_SEL,
    SRC_SEL_ST        => SRC_SEL_ST,

    PPSIN_INVALID     => OPEN,--PPSIN_INVALID,
    PPSIN_VALID       => OPEN,--PPSIN_VALID,
    PPS_UNLOCK        => OPEN,--PPS_UNLOCK,
    PPS_LOCK          => OPEN--PPS_LOCK
);

RTC_FUN : RTC
        PORT MAP(
                RST                 => RESET,
                PORn                => PORn,                                   -- 20131111 added by Sunjae
                CLK                 => CLK_20M_REF,

                PPS                 => S_CLK_OUT_1,
                ADPLL_128HZ         => S_CLK_OUT_128,
				ADPLL_1MZ			=> S_CLK_DCO_1M,
                RTC_SET_CMD         => RTC_SET_CMD,
				RTC_SECOND_CNT	    => S_RTC_SECOND_CNT_REG,	--added by dhkim

                --SEC_IN_DATA         => MEM_DATA,	--removed by dhkim
                SEC_OUT_DATA        => SEC_OUT_DATA,
                SUB_SEC_OUT_DATA    => SUB_SEC_OUT_DATA,
				USEC_OUT_DATA		=> USEC_OUT_DATA
);

end Behavioral;
