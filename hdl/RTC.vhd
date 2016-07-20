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
	
	
	
END Behavioral;
