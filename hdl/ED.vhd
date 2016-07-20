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
--  1.0        Sunjae Lee     2013.10.18
--------------------------------------------------------------------------------
-- [Description]
--   1. Edge Detector Module
--   2. The ED output filtered CLK_REF(FILT_CLK_REF) and PPS falling edge pulse(CLK_REF_FE).
--==============================================================================


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.STD_LOGIC_ARITH.ALL;
    use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------- entity ------------------------

entity ED is
  Port (
    CLK         : in  std_logic;
    RESET       : in  std_logic;
    CLK_REF     : in  std_logic;
    CLK_REF_FE  : out std_logic;
    FILT_CLK_REF: out std_logic
  );
end ED;


architecture Behavioral of ED is
----------------------------------- signal -------------------------

  signal CLK_REF_D1     : std_logic;
  signal CLK_REF_D2     : std_logic;
  signal CLK_REF_FILT   : std_logic;
  signal CLK_REF_FILT_D1: std_logic;

begin

process(CLK)
begin
  if CLK'event and CLK = '1' then
    if(RESET = '0') then
      CLK_REF_D1      <= '1';
      CLK_REF_D2      <= '1';
    else
      CLK_REF_D1      <= CLK_REF;
      CLK_REF_D2      <= CLK_REF_D1;
    end if;
  end if;
end process;

process(CLK)
begin
  if CLK'event and CLK = '1' then
    if(RESET = '0') then
      CLK_REF_FILT    <= '1';
    elsif(CLK_REF_D2 = '1' and CLK_REF_D1 = '1') then
      CLK_REF_FILT    <= '1';
    elsif(CLK_REF_D2 = '0' and CLK_REF_D1 = '0') then
      CLK_REF_FILT    <= '0';
    else
      CLK_REF_FILT    <= CLK_REF_FILT;
    end if;
  end if;
end process;

process(CLK)
begin
  if CLK'event and CLK = '1' then
    if(RESET = '0') then
      CLK_REF_FILT_D1 <= '1';
    else
      CLK_REF_FILT_D1 <= CLK_REF_FILT;
    end if;
  end if;
end process;

process(CLK)
begin
  if CLK'event and CLK = '1' then
    if(CLK_REF_FILT_D1 = '1' and CLK_REF_FILT = '0') then
      CLK_REF_FE <= '1';
    else
      CLK_REF_FE <= '0';
    end if;
  end if;
end process;

FILT_CLK_REF  <=  CLK_REF_FILT;

end Behavioral;