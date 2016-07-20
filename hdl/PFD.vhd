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
--   1. Phase and Frequency Detector Module
--	 2. PFD output the UPDN Signal using the CLK_REF and CLK_DCO
--==============================================================================

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.STD_LOGIC_ARITH.ALL;
    use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------- entity ----------------------

entity PFD is
	Port( 
		CLK     : in  STD_LOGIC;
		RESET   : in  STD_LOGIC;
		CLK_REF : in  STD_LOGIC;
		CLK_DCO : in  STD_LOGIC;
		UPDN    : out STD_LOGIC
	);
end PFD;


architecture Behavioral of PFD is

  signal CLK_DCO_1  : STD_LOGIC; 
  signal CLK_DCO_2  : STD_LOGIC;
  signal CLK_DCO_3  : STD_LOGIC;      -- 20131028 added by sunjae
  signal CLK_REF_D1 : STD_LOGIC;      -- 20131028 added by sunjae
  signal UPDN_i     : STD_LOGIC;      -- 20131028 added by sunjae

----------------------------------- component -------------------

	-- component JK_FF is               -- 20131028 Removed by sunjae
		-- Port ( 
			-- CLK     : in  STD_LOGIC;
			-- RESET   : in  STD_LOGIC;
			-- J       : in  STD_LOGIC;
			-- K       : in  STD_LOGIC;
			-- Q       : out STD_LOGIC
		-- );
	-- end component;


begin
----------------------------------- port map ---------------------

-- U1 : JK_FF 	port map(             -- 20131028 Removed by sunjae
				-- CLK     => CLK,
				-- RESET   => RESET,
				-- J       => CLK_REF,
				-- K       => CLK_DCO_2,
				-- Q       => UPDN
			-- );

----------------------------------- process ---------------------

process(CLK)            -- 20131028 added by sunjae
begin
  if(CLK'event and CLK = '1') then
    if(RESET = '0') then
      UPDN_i  <= '0';
    else
      if(CLK_REF_D1 = '1' and CLK_REF = '0') then
        if(CLK_DCO_3 = '0') then
          UPDN_i  <= '1';
        else
          UPDN_i  <= '0';
        end if;
      else
        UPDN_i  <= UPDN_i;
      end if;
    end if;
  end if;
end process;
UPDN    <= UPDN_i;      -- 20131028 added by sunjae

DELAY:------------------------------------------------------------
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
      CLK_REF_D1  <= '1';
			CLK_DCO_1   <= '0';
			CLK_DCO_2   <= '0';
			CLK_DCO_3   <= '0';      -- 20131028 added by sunjae
		else
      CLK_REF_D1  <= CLK_REF;
			CLK_DCO_1   <= CLK_DCO;
			CLK_DCO_2   <= CLK_DCO_1;
			CLK_DCO_3   <= CLK_DCO_2;      -- 20131028 added by sunjae
		end if;
	end if;
end process;


end Behavioral;