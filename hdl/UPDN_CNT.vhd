--==============================================================================
-- Design Units: Architecture
--------------------------------------------------------------------------------
-- [Designer Information]
--   Author    : Sunjae Lee
--   Company   : Satrec Initiative (www.satreci.com)
--   Division  : Space Program Division Digital H/W Team (Space 2 team)
--   E-mail    : sjlee@satreci.com
--------------------------------------------------------------------------------
-- [Tool Information]
--   Project Manage  : ACTEL LIBERO
--   Synthesis       : Synplify
--   Simulation      : ModelSim ACTEL
--------------------------------------------------------------------------------
-- [SIM generic value definition] (if exist)
--  SIM = 0 : code configuration for actual operation
--  SIM = 1 : code configuration for for simulation
--  SIM = 2 : code configuration for for H/W test
--------------------------------------------------------------------------------
-- [Revision List]
--  Version  | Revisor      | Date        | Changes
--  1.0        Sunjae Lee     2013.10.23
--------------------------------------------------------------------------------
-- [Description]
--   1. Up-Down Counter Module
--	 2. The UPDN_CNT calculate the N value.
--==============================================================================

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------- entity ----------------------

entity UPDN_CNT is
	Port ( 
		CLK 		    : in  STD_LOGIC;
		RESET 		  : in  STD_LOGIC;
		CLK_REF_FE 	: in  STD_LOGIC;
    CNT_TV      : in  std_logic_vector(25 downto 0);
		UPDN 		    : in  STD_LOGIC;
		M   			  : in  STD_LOGIC_VECTOR (2 downto 0);
		N 			    : out STD_LOGIC_VECTOR (25 downto 0)
	);
end UPDN_CNT;


architecture Behavioral of UPDN_CNT is
----------------------------------- signal -------------------------

	signal CNT 	    : STD_LOGIC_VECTOR (25 downto 0);
	signal OLD_M		: STD_LOGIC_VECTOR (2 downto 0);
	signal DIF_M		: STD_LOGIC_VECTOR (2 downto 0);
	signal CLK_REF_FE_1	: STD_LOGIC;
	signal OLD_M_1	: STD_LOGIC_VECTOR (2 downto 0); 

	constant INIT_VAL : STD_LOGIC_VECTOR (25 downto 0) := "01001100010010110011111111"; --"01001100010010110011111111"	-- 19,999,999
	-- constant INIT_VAL : STD_LOGIC_VECTOR (25 downto 0) := "00000000000100111000011111"; --"00000000000100111000011111"      -- 19,999 (Test Bench)
	
begin
----------------------------------- wire ---------------------------

N 			    <= CNT;

----------------------------------- process ------------------------

PRO_CNT:------------------------------------------------------------ DIF_M 만큼 Shift
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			CNT <= INIT_VAL;
		elsif(CLK_REF_FE_1 = '1') then
			if(M > OLD_M_1) then
				case DIF_M is
					when "001" => CNT <= '0' & CNT(25 downto 1);
					when "010" => CNT <= "00" & CNT(25 downto 2);
					when "011" => CNT <= "000" & CNT(25 downto 3);
					when "100" => CNT <= "0000" & CNT(25 downto 4);
					when "101" => CNT <= "00000" & CNT(25 downto 5);
					when "110" => CNT <= "000000" & CNT(25 downto 6);
					when "111" => CNT <= "0000000" & CNT(25 downto 7);
					when others => CNT <= CNT;
				end case;
			elsif(M < OLD_M_1) then
				case DIF_M is
					when "001" => CNT <= CNT(24 downto 0) & '0';
					when "010" => CNT <= CNT(23 downto 0) & "00";
					when "011" => CNT <= CNT(22 downto 0) & "000";
					when "100" => CNT <= CNT(21 downto 0) & "0000";
					when "101" => CNT <= CNT(20 downto 0) & "00000";
					when "110" => CNT <= CNT(19 downto 0) & "000000";
					when "111" => CNT <= CNT(18 downto 0) & "0000000";
					when others => CNT <= CNT;
				end case;
			elsif(UPDN = '0') then
        if(CNT_TV(24 downto 14) = "10011000010") then       -- Min period = 0.9986048s
          CNT <= CNT;
        else
          CNT <= CNT - '1';
        end if;
			elsif(UPDN = '1') then
        if(CNT_TV(24 downto 14) = "10011000110") then     -- Max period = 1.0010624s
          CNT <= CNT;
        else
          CNT <= CNT + '1';
        end if;
      else
        CNT <= CNT;
			end if;
		end if;
	end if;
end process;

PRO_M:------------------------------------------------------------ DIF_M 계산
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			OLD_M <= "000";
			DIF_M <= "000";
		elsif(CLK_REF_FE = '1') then
			OLD_M <= M;
			if(M > OLD_M) then
				DIF_M <= M - OLD_M;
			else
				DIF_M <= OLD_M - M;
			end if;
		end if;
	end if;
end process;

DELAY:------------------------------------------------------------
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			CLK_REF_FE_1 	<= '0';
			OLD_M_1				<= "000";
		else
			CLK_REF_FE_1 	<= CLK_REF_FE;
			OLD_M_1				<= OLD_M;
		end if;
	end if;
end process;


end Behavioral;

