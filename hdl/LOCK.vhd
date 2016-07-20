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
--   1. Locked Module
--	 2. The LOCKED output high when the ADPLL is continuously locked more then 3 times.
--   3. The SUB_OUT mean Phase Error in CLK number of times.
--==============================================================================

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------- entity ----------------------

entity LOCK is
	Port( 
		CLK 			  : in  STD_LOGIC;
		RESET 		  : in  STD_LOGIC;
		CLK_REF_FE 	: in  STD_LOGIC;
		UPDN 			  : in  STD_LOGIC;
		M 				  : in  STD_LOGIC_VECTOR (2 downto 0);
		CNT_TV 		  : in  STD_LOGIC_VECTOR (25 downto 0);
		CNT_DCO 		: in  STD_LOGIC_VECTOR (25 downto 0);
		LOCKED 		  : out STD_LOGIC;
		DBG_SUB_OUT : out STD_LOGIC_VECTOR (25 downto 0)
	);
end LOCK;


architecture Behavioral of LOCK is
----------------------------------- signal -------------------------

	signal SUB_OUT 	      : std_logic_vector(25 downto 0);
  signal CNT_LOCKED     : std_logic_vector(1 downto 0);
  signal CLK_REF_FE_1	  : std_logic;
	signal CLK_REF_FE_2	  : std_logic;
  signal CNT_DCO_D1     : std_logic_vector (25 downto 0);
  signal CNT_DCO_D2     : std_logic_vector (25 downto 0);
  signal CNT_DCO_D3     : std_logic_vector (25 downto 0);
  signal CNT_DCO_D4     : std_logic_vector (25 downto 0);                    -- 20131027 deleted by Sunjae
  signal CONST_SUB_OUT  : std_logic_vector (25 downto 0);

  constant ZERO         : std_logic_vector(25 downto 0) := (others => '0');
  
  constant INIT_CNT_VAL : STD_LOGIC_VECTOR(25 downto 0) := "00000000000000000000000110";  -- 20131024 added by Sunjae
  constant ERR_P25US6   : std_logic_vector(25 downto 0) := "00" & X"000200";    -- 20131024 added by Sunjae
  constant ERR_P12US8   : std_logic_vector(25 downto 0) := "00" & X"000100";    -- 20131024 added by Sunjae
  constant ERR_P6US4    : std_logic_vector(25 downto 0) := "00" & X"000080";    -- 20131024 added by Sunjae
  constant ERR_P3US2    : std_logic_vector(25 downto 0) := "00" & X"000040";    -- 20131024 added by Sunjae
  
  signal POS_ERR_VAL    : std_logic_vector(25 downto 0);                        -- 20131024 added by Sunjae
  signal CNT_CLK        : std_logic_vector(25 downto 0);                        -- 20131024 added by Sunjae
  signal POS_ERR        : std_logic;
  
  signal CLK_REF_FE_D1  : std_logic;                                            -- 20131024 added by Sunjae
  signal CLK_REF_FE_D2  : std_logic;                                            -- 20131024 added by Sunjae
  signal CLK_REF_FE_D3  : std_logic;                                            -- 20131024 added by Sunjae

begin
----------------------------------- wire ---------------------------

DBG_SUB_OUT <= CONST_SUB_OUT;

---------------------------------- process -------------------------

PRO_SUB_OUT:
process(CLK)
begin
  if CLK'event and CLK = '1' then
    if(RESET = '0') then
      SUB_OUT 			<= (others => '0');
			CONST_SUB_OUT	<= (others => '0');
    elsif(CLK_REF_FE = '1') then
      if(UPDN = '0') then
        SUB_OUT       <= CNT_TV - CNT_DCO_D4;
        CONST_SUB_OUT <= CNT_TV - CNT_DCO_D4;
        -- SUB_OUT       <= CNT_TV - CNT_DCO_D3;                                   -- 20131027 modified by Sunjae
        -- CONST_SUB_OUT <= CNT_TV - CNT_DCO_D3;                                   -- 20131027 modified by Sunjae
      else
        SUB_OUT       <= CNT_DCO_D4;
        CONST_SUB_OUT <= CNT_DCO_D4;
        -- SUB_OUT       <= CNT_DCO_D3;                                            -- 20131027 modified by Sunjae
        -- CONST_SUB_OUT <= CNT_DCO_D3;                                            -- 20131027 modified by Sunjae
      end if;
    elsif(CLK_REF_FE_1 = '1') then
      case M is
        --------------------- for real operation -------------------------------
        when "111"  => SUB_OUT <= "000000000" & SUB_OUT(25 downto 9);   -- 25.6 us
        when "110"  => SUB_OUT <= "00000000" & SUB_OUT(25 downto 8);    -- 12.8 us
        when others => SUB_OUT <= "0000000" & SUB_OUT(25 downto 7);     -- 6.4 us
        
        --------------------- for simulation -----------------------------------
        -- when "111"  => SUB_OUT <= "00000000" & SUB_OUT(25 downto 8);  -- 12.8 us
        -- when "110"  => SUB_OUT <= "0000000" & SUB_OUT(25 downto 7);   -- 6.4 us
        -- when others => SUB_OUT <= "000000" & SUB_OUT(25 downto 6);    -- 3.2 us
      end case;
    end if;
  end if;
end process;

process(CLK)                                                                    -- 20131024 added by Sunjae
begin
  if CLK'event and CLK = '1' then
    if(RESET = '0') then
      POS_ERR_VAL <= CNT_TV + ERR_P6US4;
    elsif(CLK_REF_FE_D3 = '1') then
      case M is
        --------------------- for real operation -------------------------------
        when "111"  => POS_ERR_VAL <= CNT_TV + ERR_P25US6;   -- 25.6 us
        when "110"  => POS_ERR_VAL <= CNT_TV + ERR_P12US8;   -- 12.8 us
        when others => POS_ERR_VAL <= CNT_TV + ERR_P6US4;    -- 6.4 us
        
        --------------------- for simulation -----------------------------------
        -- when "111"  => POS_ERR_VAL <= CNT_TV + ERR_P12US8;  -- 12.8 us
        -- when "110"  => POS_ERR_VAL <= CNT_TV + ERR_P6US4;   -- 6.4 us
        -- when others => POS_ERR_VAL <= CNT_TV + ERR_P3US2;   -- 3.2 us
      end case;
    end if;
  end if;
end process;

process(CLK)                                                                    -- 20131024 added by Sunjae
begin
  if CLK'event and CLK = '1' then
    if(RESET = '0' or CLK_REF_FE = '1') then
      CNT_CLK <= INIT_CNT_VAL;
      POS_ERR <= '0';
    elsif(CNT_CLK = POS_ERR_VAL) then
      CNT_CLK <= CNT_CLK;
      POS_ERR <= '1';
    else
      CNT_CLK <= CNT_CLK + '1';
      POS_ERR <= POS_ERR;
    end if;
  end if;
end process;

PRO_LOCKED:
process(CLK)
begin
  if CLK'event and CLK = '1' then
    if(RESET = '0') then
      LOCKED <= '0';
      CNT_LOCKED <= "00";
    elsif(POS_ERR = '1') then                                                   -- 20131024 added by Sunjae
      CNT_LOCKED  <= "00";
      LOCKED      <= '0';
    elsif(CLK_REF_FE_2 = '1') then
      if(SUB_OUT = ZERO) then
        if(CNT_LOCKED = "11") then
          LOCKED      <= '1';
        else
          CNT_LOCKED <= CNT_LOCKED + '1';
        end if;
      else
        CNT_LOCKED  <= "00";
        LOCKED      <= '0';
      end if;
    end if;
  end if;
end process;

DELAY:------------------------------------------------------------
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			CLK_REF_FE_1  <= '0';
			CLK_REF_FE_2  <= '0';
  
      CNT_DCO_D1    <= (others => '0');
      CNT_DCO_D2    <= (others => '0');
      CNT_DCO_D3    <= (others => '0');
      CNT_DCO_D4    <= (others => '0');                                      -- 20131027 deleted by Sunjae
      
      CLK_REF_FE_D1 <= '0';
      CLK_REF_FE_D2 <= '0';
      CLK_REF_FE_D3 <= '0';
		else
			CLK_REF_FE_1  <= CLK_REF_FE;
			CLK_REF_FE_2  <= CLK_REF_FE_1;
  
      CNT_DCO_D1    <= CNT_DCO;
      CNT_DCO_D2    <= CNT_DCO_D1;
      CNT_DCO_D3    <= CNT_DCO_D2;
      CNT_DCO_D4    <= CNT_DCO_D3;                                           -- 20131027 deleted by Sunjae
      
      CLK_REF_FE_D1 <= CLK_REF_FE;
      CLK_REF_FE_D2 <= CLK_REF_FE_D1;
      CLK_REF_FE_D3 <= CLK_REF_FE_D2;
		end if;
	end if;
end process;


end Behavioral;

