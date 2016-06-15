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
entity RTC is
	port 
	(	
		GSRn				: in std_logic;
		LEDR				: out std_logic;
		LEDG				: out std_logic;
		R0					: out std_logic;
		R1					: out std_logic;
		R4					: out std_logic
	);
end RTC;

----------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
architecture rtl of RTC is

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
component PIF_RTC is
	port 
	(	
		RST					: in std_logic;
		CLOCK				: in std_logic; -- 20.60MHz, 48.54ns
		PPS_P				: out std_logic;
		PPS_R				: out std_logic
	);
end component PIF_RTC;

----------------------------------------------------------------------------------------------------
-- signal
----------------------------------------------------------------------------------------------------
signal osc      			: std_logic;
signal red_flash			: std_logic;
signal green_flash  		: std_logic;
signal GSRnX        		: std_logic;

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

R4 <= osc;

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
comp_PIF_RTC : PIF_RTC
	port map
	(	
		RST		=> GSRnX,
		CLOCK 	=> osc,
		PPS_P 	=> R0,
		PPS_R 	=> R1
	);
	
----------------------------------------------------------------------------------------------------
-- drive the LEDs
----------------------------------------------------------------------------------------------------
REDL: OB port map ( I=>red_flash  , O => LEDR );
GRNL: OB port map ( I=>green_flash, O => LEDG );

----------------------------------------------------------------------------------------------------
end rtl;
----------------------------------------------------------------------------------------------------