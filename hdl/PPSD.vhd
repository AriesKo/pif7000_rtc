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
--   1. PPS Detector Module
--	 2. Range of Valid PPS period : 0.998605s ~ 1.001062s
--==============================================================================

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.STD_LOGIC_ARITH.ALL;
    use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------- entity ----------------------

entity PPSD is
	Port( 
		RESET 		      : in  STD_LOGIC;
		CLK 		        : in  STD_LOGIC;
		CLK_REF_FE 	    : in  STD_LOGIC;
		PPS_VALID 	    : out STD_LOGIC
	);
end PPSD;


architecture Behavioral of PPSD is
----------------------------------- signal -------------------------

	signal PPS_CNT	    : STD_LOGIC_VECTOR (25 downto 0);
  signal PPS_CNT_EN   : STD_LOGIC;

begin
----------------------------------- wire ---------------------------

----------------------------------- process ------------------------

PRO_PPS_CNT:
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then 
			PPS_CNT <= (others => '0');
		elsif(CLK_REF_FE = '1') then
      PPS_CNT <= (others => '0');
    elsif(PPS_CNT_EN = '1') then
			PPS_CNT <= PPS_CNT + '1';
		end if;
	end if;
end process;

PRO_PPS_VALID:
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then 
			PPS_VALID   <= '0';
      PPS_CNT_EN  <= '0';
		elsif(CLK_REF_FE = '1') then
      PPS_CNT_EN  <= '1';
			
--=========================== real code ========================================
     case PPS_CNT(24 downto 14) is
          when "10011000011"  => PPS_VALID <= '1';    -- 0.9986048s
          when "10011000100"  => PPS_VALID <= '1';
					when "10011000101"  => PPS_VALID <= '1';
          when others         => PPS_VALID <= '0';
     end case;
 elsif(PPS_CNT(24 downto 14) = "10011000110") then    -- 1.0010624s

--========================== for simulation ====================================
      -- case PPS_CNT(14 downto 3) is
        -- when "100111000001" => PPS_VALID <= '1';      -- 0.9988ms
        -- when "100111000010" => PPS_VALID <= '1';
        -- when "100111000011" => PPS_VALID <= '1';
        -- when "100111000100" => PPS_VALID <= '1';
        -- when "100111000101" => PPS_VALID <= '1';
        -- when "100111000110" => PPS_VALID <= '1';
        -- when others         => PPS_VALID <= '0';
      -- end case;
    -- elsif(PPS_CNT(14 downto 3) = "100111000111") then -- 1.0012ms
--==============================================================================
      PPS_VALID   <= '0';
      PPS_CNT_EN  <= '0';
		end if;
	end if;
end process;


end Behavioral;