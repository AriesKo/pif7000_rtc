----------------------------------------------------------------------------------------------------
-- PIF_RTC.vhd    pif real time clock
--
-- Initial entry: 16.06.13 sangil
--
-- Copyright (c) 2015 to 2016
--
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
library work;           
use work.defs.all;

----------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
library machxo2;        
use machxo2.components.all;

----------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
entity TOP_ADPLL is
	port 
	(	
		GSRn				: in std_logic;
		RA5 				: in std_logic;
		LEDR				: out std_logic;
		LEDG				: out std_logic;
		GPIO17				: out std_logic;
		GPIO27				: out std_logic
	);
end TOP_ADPLL;

----------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
architecture rtl of TOP_ADPLL is

----------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
component pif_flasher is 
	port 
	( 
		red					: out std_logic;
		green 				: out std_logic;
		xclk				: out std_logic
	);
end component pif_flasher;

----------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
component ADPLL_RTC_CORE is
	port 
	(
	    -- General Signals
	    RESET           		:in std_logic;
		PORn					:in STD_LOGIC;
	    CLK_20M_REF     		:in STD_LOGIC;

	    --PPS input signals
	    PPSIN1     				:in std_logic;
	    PPSIN2     				:in std_logic;
		
		-- Related to RTC --------

		RTC_SET_CMD         	: in std_logic; 
		ADPLL_REG_WEN			: in std_logic; 
		RTC_CTRL_REG_WEN		: in std_logic;
		RTC_SECOND_CNT_WEN		: in std_logic;
		
	    MEM_DATA	        	: in std_logic_vector(31 DOWNTO 0);     
		SEC_OUT_DATA        	: out std_logic_vector(31 DOWNTO 0); 
	    SUB_SEC_OUT_DATA    	: out std_logic_vector(31 DOWNTO 0);
		USEC_OUT_DATA      		: out std_logic_vector(31 DOWNTO 0);
		ADPLL_REG				: out std_logic_vector(31 DOWNTO 0);
		RTC_CTRL_REG			: out std_logic_vector(31 DOWNTO 0);
		
	    --Interuppt
	    EXT_INT_1HZ     		:out STD_LOGIC;
	    EXT_INT_128HZ   		:out STD_LOGIC
  	);
end component ADPLL_RTC_CORE;

----------------------------------------------------------------------------------------------------
-- signal
----------------------------------------------------------------------------------------------------
signal osc      			: std_logic;
signal red_flash			: std_logic;
signal green_flash  		: std_logic;
signal GSRnX        		: std_logic;
signal s_PPS_P				: std_logic;
signal s_PPS_R				: std_logic;

----------------------------------------------------------------------------------------------------
-- attribute
----------------------------------------------------------------------------------------------------
attribute pullmode  : string;
attribute pullmode of GSRnX: signal is "UP";  -- else floats

----------------------------------------------------------------------------------------------------
-- constant
----------------------------------------------------------------------------------------------------
constant OSC_STR  			: string := "7";

----------------------------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------------------------
-- global reset
IBgsr   : IB  port map ( I=>GSRn, O=>GSRnX );
GSR_GSR : GSR port map ( GSR=>GSRnX );

----------------------------------------------------------------------------------------------------
-- LED flasher
----------------------------------------------------------------------------------------------------
F : pif_flasher 
	port map 
	( 
		red 	=> red_flash,
		green 	=> green_flash,
		xclk 	=> osc
	);

----------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------
comp_ADPLL_RTC_CORE : ADPLL_RTC_CORE
	port map
	(
	    -- General Signals
	    RESET => GSRnX,
		PORn => GSRnX,
	    CLK_20M_REF => RA5,

	    --PPS input signals
	    PPSIN1 => '0',
	    PPSIN2 => '0',
		
		-- Related to RTC --------

		RTC_SET_CMD => '0',
		ADPLL_REG_WEN => '1',
		RTC_CTRL_REG_WEN => '1',
		RTC_SECOND_CNT_WEN => '1',
		
	    MEM_DATA 			=> (others => '0'),
		SEC_OUT_DATA 		=> open,
	    SUB_SEC_OUT_DATA 	=> open,
		USEC_OUT_DATA 		=> open,
		ADPLL_REG 			=> open,
		RTC_CTRL_REG 		=> open,
		
	    --Interuppt
	    EXT_INT_1HZ 		=> GPIO17,
	    EXT_INT_128HZ 		=> GPIO27
  	);
	
----------------------------------------------------------------------------------------------------
-- drive the LEDs
----------------------------------------------------------------------------------------------------
REDL: OB port map ( I=>red_flash  , O => LEDR );
GRNL: OB port map ( I=>green_flash, O => LEDG );

----------------------------------------------------------------------------------------------------
end rtl;
----------------------------------------------------------------------------------------------------