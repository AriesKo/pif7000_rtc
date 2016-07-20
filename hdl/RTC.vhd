<<<<<<< HEAD
-- RTC.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity RTC IS
Port(
                RST                 : IN    STD_LOGIC;        
                PORn                : in    std_logic;                          -- 20131111 added by sunjae         
        		CLK                 : IN    STD_LOGIC;

                PPS                 : IN    STD_LOGIC;
                ADPLL_128HZ         : IN    STD_LOGIC;
				ADPLL_1MZ	        : IN    STD_LOGIC;		
                RTC_SET_CMD         : IN    STD_LOGIC; 
        	RTC_SECOND_CNT         : IN    STD_LOGIC_VECTOR(31 DOWNTO 0); --added by dhkim

                --SEC_IN_DATA         : IN    STD_LOGIC_VECTOR(31 DOWNTO 0); --removed by dhkim
                SEC_OUT_DATA        : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0); 
                SUB_SEC_OUT_DATA    : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
				USEC_OUT_DATA       : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0)

     );
end RTC; 

architecture Behavioral of RTC is
----------------------------------------------------------------------------------
--Signals Deceleration(Linking)---------------------------------------------------
----------------------------------------------------------------------------------
	SIGNAL  S_PPS_DFF           : STD_LOGIC; 
  -- SIGNAL  S_PPS_REDGE         : STD_LOGIC; 
	-- 2013.08.08 : Edge Detection Chagne(R->F)
	SIGNAL  S_PPS_FEDGE         : STD_LOGIC; 
	SIGNAL  S_ADPLL_128_DFF     : STD_LOGIC; 
    SIGNAL  S_ADPLL_1M_DFF     : STD_LOGIC;
		-- SIGNAL  S_ADPLL_128_REDGE   : STD_LOGIC; 
		-- 2013.08.08 : Edge Detection Chagne(R->F)
	SIGNAL  S_ADPLL_128_FEDGE   : STD_LOGIC; 
	SIGNAL	S_ADPLL_1M_FEDGE	: STD_LOGIC;
    SIGNAL  S_SUBSEC_CNT        : STD_LOGIC_VECTOR(31 DOWNTO 0); 
    SIGNAL  S_SEC_CNT           : STD_LOGIC_VECTOR(31 DOWNTO 0); 
    SIGNAL  S_USEC_CNT			: STD_LOGIC_VECTOR(31 DOWNTO 0); 			
    SIGNAL  S_SET_CMD           : STD_LOGIC; 
    SIGNAL  S_SET_CMD_DFF       : STD_LOGIC; 
     
----------------------------------------------------------------------------------
--Start of the Program------------------------------------------------------------
--------------------------------------------------------------------------------
BEGIN

-- DETECTION 1MHZ Falling EDGE 
-- 2015.07.14 (HSKim): Edge Detection Chagne(R->F)
    PROCESS(RST, CLK)
    BEGIN                  
        if(RST = '0') then                    -- 20131026 added by Sunjae 
          S_ADPLL_1M_DFF   <= '0';           -- 20131026 added by Sunjae 
          S_ADPLL_1M_FEDGE <= '0';           -- 20131026 added by Sunjae 
        elsIF CLK'EVENT AND CLK = '1' THEN 
            S_ADPLL_1M_DFF <= ADPLL_1MZ; 
			IF S_ADPLL_1M_DFF = '1' AND ADPLL_1MZ = '0' THEN 
               S_ADPLL_1M_FEDGE <= '1'; 
            ELSE 
               S_ADPLL_1M_FEDGE <= '0'; 
            END IF; 
        END IF; 
    END PROCESS; 
	
-- DETECTION 128HZ Falling EDGE 
-- 2013.08.08 : Edge Detection Chagne(R->F)
    PROCESS(RST, CLK)
    BEGIN                  
        if(RST = '0') then                    -- 20131026 added by Sunjae 
          S_ADPLL_128_DFF   <= '0';           -- 20131026 added by Sunjae 
          S_ADPLL_128_FEDGE <= '0';           -- 20131026 added by Sunjae 
        elsIF CLK'EVENT AND CLK = '1' THEN 
            S_ADPLL_128_DFF <= ADPLL_128HZ; 

            -- IF S_ADPLL_128_DFF = '0' AND ADPLL_128HZ = '1' THEN 
						-- 2013.08.08 : Edge Detection Chagne(R->F)
						IF S_ADPLL_128_DFF = '1' AND ADPLL_128HZ = '0' THEN 
                -- S_ADPLL_128_REDGE <= '1'; 
								S_ADPLL_128_FEDGE <= '1'; 
            ELSE 
                -- S_ADPLL_128_REDGE <= '0'; 
								S_ADPLL_128_FEDGE <= '0'; 
            END IF; 
        END IF; 
    END PROCESS;

	
-- USEC CNT 2015.07.14 (HSKim)    
	USEC_OUT_DATA <= S_USEC_CNT;

    PROCESS(RST, CLK)
    BEGIN
        if(RST = '0') then                    -- 20131026 added by Sunjae 
          S_USEC_CNT <= (others => '0');    -- 20131026 added by Sunjae 
        elsIF CLK'EVENT AND CLK = '1' THEN 
			IF S_PPS_FEDGE = '1' THEN 
                S_USEC_CNT <= (OTHERS => '0'); 
            ELSE
                IF S_ADPLL_1M_FEDGE = '1' THEN 
                    S_USEC_CNT <= S_USEC_CNT + '1'; 
                END IF; 
            END IF; 
        END IF; 
    END PROCESS; 
	
	
-- SUB CNT      
    SUB_SEC_OUT_DATA <= S_SUBSEC_CNT; 

    PROCESS(RST, CLK)
    BEGIN
        if(RST = '0') then                    -- 20131026 added by Sunjae 
          S_SUBSEC_CNT <= (others => '0');    -- 20131026 added by Sunjae 
        elsIF CLK'EVENT AND CLK = '1' THEN 
            -- IF S_PPS_REDGE = '1' THEN 
						-- 2013.08.08 : Edge Detection Chagne(R->F)
			IF S_PPS_FEDGE = '1' THEN 
                S_SUBSEC_CNT <= (OTHERS => '0'); 
            ELSE
						-- IF S_ADPLL_128_REDGE = '1' THEN 
						-- 2013.08.08 : Edge Detection Chagne(R->F)
                IF S_ADPLL_128_FEDGE = '1' THEN 
                    S_SUBSEC_CNT <= S_SUBSEC_CNT + '1'; 
                END IF; 
            END IF; 
        END IF; 
    END PROCESS; 


-- DETECTION PPS FALLING EDGE 
-- 2013.08.08 : Edge Detection Chagne(R->F)
    PROCESS(RST, CLK)
    BEGIN
        if(RST = '0') then                    -- 20131026 added by Sunjae 
          S_PPS_DFF   <= '0';                 -- 20131026 added by Sunjae 
          S_PPS_FEDGE <= '0';                 -- 20131026 added by Sunjae 
        elsIF CLK'EVENT AND CLK = '1' THEN 
            S_PPS_DFF <= PPS; 

            -- IF S_PPS_DFF = '0' AND PPS = '1' THEN 
						-- 2013.08.08 : Edge Detection Chagne(R->F)
			IF S_PPS_DFF = '1' AND PPS = '0' THEN 
                -- S_PPS_REDGE <= '1'; 
				S_PPS_FEDGE <= '1'; 
            ELSE 
                -- S_PPS_REDGE <= '0'; 
				S_PPS_FEDGE <= '0'; 
            END IF; 
        END IF; 
    END PROCESS; 



-- SECOND 
    SEC_OUT_DATA <= S_SEC_CNT; 

    -- PROCESS(RST, CLK) 
    PROCESS(PORn, CLK)                          -- 20131111 modified by sunjae 
    BEGIN 
        -- if(RST = '0') then                    -- 20131026 added by Sunjae 
        if(PORn = '0') then                     -- 20131111 modified by sunjae 
          S_SEC_CNT <= (others => '0');         -- 20131026 added by Sunjae 
        elsIF CLK'EVENT AND CLK = '1' THEN 
            
            IF S_SET_CMD = '1' THEN 
                S_SEC_CNT <=  RTC_SECOND_CNT; 
						-- ELSIF S_PPS_REDGE = '1' THEN 
						-- 2013.08.08 : Edge Detection Chagne(R->F)
			ELSIF S_PPS_FEDGE = '1' THEN 
                S_SEC_CNT <= S_SEC_CNT + '1'; 
            END IF; 
        END IF;            
    END PROCESS;

    PROCESS(RST, CLK) 
    BEGIN 
        IF RST = '0' THEN 
            S_SET_CMD_DFF <= '0' ; 
            S_SET_CMD <= '0'; 
        ELSIF CLK'EVENT AND CLK = '1' THEN 
            S_SET_CMD_DFF <= RTC_SET_CMD; 
            
            IF S_SET_CMD_DFF = '0' AND RTC_SET_CMD = '1' THEN 
                S_SET_CMD <= '1'; 
            ELSE
                S_SET_CMD <= '0'; 
            END IF; 
        END IF; 
    END PROCESS;  
	
	
=======
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
		GPIO17				: out std_logic;
		GPIO27				: out std_logic;
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
		PPS_P 	=> GPIO17,
		PPS_R 	=> GPIO27
	);
>>>>>>> 3741b3d1378fa28c78d0f8eb1486f6ae80cd353c
	
END Behavioral;
