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
--   1. ADPLL Auto Controller
--==============================================================================

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------- entity ----------------------

entity AUTO_CONT is
	Port( 
		CLK 			  : in  STD_LOGIC;
		RESET 			: in  STD_LOGIC;
		M_IN				: in  STD_LOGIC_VECTOR(2 downto 0);
		DIS_FRST_IN	: in 	STD_LOGIC;
		EN_AUTO			:	in	STD_LOGIC;
		CLK_DCO			: in  STD_LOGIC;
		SUB_OUT			:	in	STD_LOGIC_VECTOR(25 downto 0);
		M_OUT				: out STD_LOGIC_VECTOR(2 downto 0);
		DIS_FRST_OUT: out	STD_LOGIC
	);
end AUTO_CONT;


architecture Behavioral of AUTO_CONT is
----------------------------------- signal -------------------------

	signal	CLK_DCO_RE		: STD_LOGIC;
	signal	CLK_DCO_RE_1	: STD_LOGIC;
	signal	CLK_DCO_RE_2	: STD_LOGIC;
	signal	TMP_CLK_DCO		:	STD_LOGIC;
	signal 	LOCKED				: STD_LOGIC;
	signal	CNT_LOCKED		:	STD_LOGIC_VECTOR(1 downto 0);
	signal	M							:	STD_LOGIC_VECTOR(2 downto 0);
	signal	DIS_FRST			: STD_LOGIC;
	signal	TMP_SUB_OUT		:	STD_LOGIC_VECTOR(23 downto 0);
	
	constant ZERO					: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	
begin
----------------------------------- wire ---------------------------

M_OUT					<= M;
DIS_FRST_OUT	<= DIS_FRST;

----------------------------------- process ------------------------

process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			M						<= "000";
			DIS_FRST		<= '0';
			LOCKED			<= '0';
			CNT_LOCKED	<= (others => '0');
		else
			if(EN_AUTO = '0') then
				M							<= M_IN;
				DIS_FRST			<= DIS_FRST_IN; 
				LOCKED				<= '0';
				CNT_LOCKED		<= (others => '0');
			else
				if(CLK_DCO_RE_1 = '1') then
					if(TMP_SUB_OUT = ZERO) then
						if(CNT_LOCKED = "01") then
							LOCKED			<= '1';
							CNT_LOCKED	<= CNT_LOCKED;
						else
							LOCKED			<= '0';
							CNT_LOCKED	<= CNT_LOCKED + '1';
						end if;
					else
						LOCKED			<= '0';
						CNT_LOCKED	<= (others => '0');
					end if;
					DIS_FRST	<= DIS_FRST;
				elsif(CLK_DCO_RE_2 = '1') then
					if(LOCKED	='1') then
						if(M = "000") then
							DIS_FRST	<= '1';
							M	<= M;
						else
							DIS_FRST	<= '0';
							M	<= M - '1';
						end if;
					else
						DIS_FRST	<= '0';
						if(TMP_SUB_OUT(23 downto 2) = "0000000000000000000000") then
							M	<= M;
						else
              if(M = "111") then
                M	<= M;
              else
                M	<= M + '1';
              end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end process;

process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			TMP_SUB_OUT	<= (others => '0');
		elsif(CLK_DCO_RE = '1') then
			case M is
				when "111"	=> TMP_SUB_OUT	<= "0000000" & SUB_OUT(25 downto 9);   -- 25.6 us
				when "110"	=> TMP_SUB_OUT	<= "000000" & SUB_OUT(25 downto 8);   --  12.8 us
				when "101"	=> TMP_SUB_OUT	<= "00000" & SUB_OUT(25 downto 7);   --  6.4 us
				when "100"	=> TMP_SUB_OUT	<= "0000" & SUB_OUT(25 downto 6);   --  3.2 us
				when "011"	=> TMP_SUB_OUT	<= "000" & SUB_OUT(25 downto 5);   --  1.6 us
				when "010"	=> TMP_SUB_OUT	<= "00" & SUB_OUT(25 downto 4);   --  0.8 us
				when "001"	=> TMP_SUB_OUT	<= '0' & SUB_OUT(25 downto 3);   --  0.4 us
				when others => TMP_SUB_OUT	<= SUB_OUT(25 downto 2);   --  0.2 us
			end case;
		end if;
	end if;
end process;

DELAY:
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			TMP_CLK_DCO		<= '0';
			CLK_DCO_RE_1	<= '0';
			CLK_DCO_RE_2	<= '0';
		else
			TMP_CLK_DCO		<= CLK_DCO;
			CLK_DCO_RE_1	<= CLK_DCO_RE;
			CLK_DCO_RE_2	<= CLK_DCO_RE_1;
		end if;
	end if;
end process;

process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			CLK_DCO_RE	<= '0';
		elsif(CLK_DCO = '1' and TMP_CLK_DCO = '0') then
			CLK_DCO_RE	<= '1';
		else
			CLK_DCO_RE	<= '0';
		end if;
	end if;
end process;
			
end Behavioral;

