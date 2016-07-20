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
--   1. ADPLL TOP Module
--==============================================================================

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  -- use IEEE.STD_LOGIC_ARITH.ALL;
  -- use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------- entity ----------------------

entity ADPLL_CORE is
  Port(
    CLK               : in  STD_LOGIC;
    S_RESETn          : in  STD_LOGIC;
    PPSIN1            : in  STD_LOGIC;
    PPSIN2            : in  STD_LOGIC;
    M                 : in  STD_LOGIC_VECTOR (2 downto 0);
    DIS_FRST          : in  STD_LOGIC;
    EN_AUTO           : in  STD_LOGIC;
    CLK_OUT_1         : out STD_LOGIC;
    CLK_OUT_8         : out STD_LOGIC;
    CLK_OUT_128       : out STD_LOGIC;
	CLK_DCO_1M 		  : out std_logic; 						-- add by HSKim
    LOCKED            : out STD_LOGIC;
    PPS1_VALID        : out STD_LOGIC;
    PPS2_VALID        : out STD_LOGIC;
    PPS_VALID         : out std_logic;    -- Selected PPS valid

    PPSIN_EN          : in  std_logic;
    PPSIN_SEL         : in  std_logic;

    SRC_SEL_EN        : in  std_logic;    -- 0: Auto Selection by ADPLL IP, 1: Source selection by SRC_SEL bit
    SRC_SEL           : in  std_logic;    -- 0: OBC clock, 1: GPS PPS
    SRC_SEL_ST        : out std_logic;    -- 0: OBC clock, 1: GPS PPS

    PPSIN_INVALID     : out std_logic;
    PPSIN_VALID       : out std_logic;
    PPS_UNLOCK        : out std_logic;
    PPS_LOCK          : out std_logic
  );
end ADPLL_CORE;


architecture Behavioral of ADPLL_CORE is
----------------------------------- signal -------------------------

  signal CLK_REF_FE1    : STD_LOGIC;
  signal CLK_REF_FE2    : STD_LOGIC;
  signal CLK_REF_FE     : STD_LOGIC;
  signal CLK_REF_FE_i   : STD_LOGIC;
  signal CLK_DCO        : STD_LOGIC;
  signal UPDN_i         : STD_LOGIC;
  signal N_i            : STD_LOGIC_VECTOR(25 downto 0);
  signal CNT_TV_i       : STD_LOGIC_VECTOR(25 downto 0);
  signal CNT_DCO_i      : STD_LOGIC_VECTOR(25 downto 0);
  signal FILT_CLK_REF1  : STD_LOGIC;
  signal FILT_CLK_REF2  : STD_LOGIC;
  signal FILT_CLK_REF   : std_logic;
  signal FILT_CLK_REF_i : std_logic;
  signal LOCKED_i       : STD_LOGIC;
  signal LOCKED_i_D1    : STD_LOGIC;
  signal DIS_FRST_i     : STD_LOGIC;

  signal M_i            : STD_LOGIC_VECTOR(2 downto 0);
  signal SUB_OUT_i      : STD_LOGIC_VECTOR(25 downto 0);

  signal SRC_SEL_i      : std_logic;
  signal PPS1_VALID_i   : std_logic;
  signal PPS2_VALID_i   : std_logic;
  signal PPS_VALID_i    : std_logic;
  signal PPS_VALID_D1   : std_logic;

----------------------------------- component ----------------------

  component PFD is
    Port(
      CLK         : in  STD_LOGIC;
      RESET       : in  STD_LOGIC;
      CLK_REF     : in  STD_LOGIC;
      CLK_DCO     : in  STD_LOGIC;
      UPDN        : out  STD_LOGIC
    );
  end component;

  component ED is
    Port (
      CLK         : in  std_logic;
      RESET       : in  std_logic;
      CLK_REF     : in  std_logic;
      CLK_REF_FE  : out std_logic;
      FILT_CLK_REF: out std_logic
    );
  end component;

  component UPDN_CNT is
    Port (
      CLK         : in  STD_LOGIC;
      RESET       : in  STD_LOGIC;
      CLK_REF_FE  : in  STD_LOGIC;
      CNT_TV      : in  std_logic_vector(25 downto 0);
      UPDN        : in  STD_LOGIC;
      M           : in  STD_LOGIC_VECTOR (2 downto 0);
      N           : out STD_LOGIC_VECTOR (25 downto 0)
    );
  end component;

  component DCO is
    Port(
      RESET       : in  STD_LOGIC;
      CLK         : in  STD_LOGIC;
      CLK_REF_FE  : in  STD_LOGIC;
      N           : in  STD_LOGIC_VECTOR (25 downto 0);
      M           : in  STD_LOGIC_VECTOR (2 downto 0);
      DIS_FRST    : in  STD_LOGIC;
      LOCKED      : in  STD_LOGIC;
      EN_LOCKED   : in  STD_LOGIC;
      SRC_SEL     : in  std_logic;
      CLK_DCO     : out STD_LOGIC;
      CLK_DCO_8   : out STD_LOGIC;
      CLK_DCO_128 : out STD_LOGIC;
	  CLK_DCO_1M  : out std_logic; 						-- add by HSKim
		
      CNT_DCO_OUT : out STD_LOGIC_VECTOR (25 downto 0);
      CNT_TV_OUT  : out STD_LOGIC_VECTOR (25 downto 0)
    );
  end component;

  component PPSD is
    Port(
      RESET           : in  STD_LOGIC;
      CLK             : in  STD_LOGIC;
      CLK_REF_FE      : in  STD_LOGIC;
      PPS_VALID       : out STD_LOGIC
    );
  end component;

  component LOCK is
    Port(
      CLK         : in  STD_LOGIC;
      RESET       : in  STD_LOGIC;
      CLK_REF_FE  : in  STD_LOGIC;
      UPDN        : in  STD_LOGIC;
      M           : in  STD_LOGIC_VECTOR (2 downto 0);
      CNT_TV      : in  STD_LOGIC_VECTOR (25 downto 0);
      CNT_DCO     : in  STD_LOGIC_VECTOR (25 downto 0);
      LOCKED      : out STD_LOGIC;
      DBG_SUB_OUT     : out STD_LOGIC_VECTOR (25 downto 0)
    );
  end component;

  component AUTO_CONT is
    Port(
      CLK         : in  STD_LOGIC;
      RESET       : in  STD_LOGIC;
      M_IN        : in  STD_LOGIC_VECTOR(2 downto 0);
      DIS_FRST_IN : in  STD_LOGIC;
      EN_AUTO     : in  STD_LOGIC;
      CLK_DCO     : in  STD_LOGIC;
      SUB_OUT     : in  STD_LOGIC_VECTOR(25 downto 0);
      -- LOCKED_SIG : in  STD_LOGIC;
      M_OUT       : out STD_LOGIC_VECTOR(2 downto 0);
      DIS_FRST_OUT: out STD_LOGIC
    );
  end component;


begin

CLK_OUT_1       <= CLK_DCO;
LOCKED          <= LOCKED_i;

FILT_CLK_REF    <=  FILT_CLK_REF1 when PPSIN_SEL = '0' else
                    FILT_CLK_REF2;

FILT_CLK_REF_i  <=  FILT_CLK_REF when PPSIN_EN = '1' else
                    '1';

CLK_REF_FE      <=  CLK_REF_FE1 when  PPSIN_SEL = '0' else
                    CLK_REF_FE2;

CLK_REF_FE_i    <=  CLK_REF_FE when PPSIN_EN = '1' else
                    '0';

PPS1_VALID      <=  PPS1_VALID_i;
PPS2_VALID      <=  PPS2_VALID_i;

PPS_VALID_i     <=  PPS1_VALID_i when PPSIN_SEL = '0' else
                    PPS2_VALID_i;
PPS_VALID       <=  PPS_VALID_i;

process(CLK)
begin
  if(CLK'event and CLK = '1') then
    if(SRC_SEL_EN = '1') then
      SRC_SEL_i       <= SRC_SEL; -- PPS in disable 상태에서도 GPS PPS source 강제 selection은 가능
                                  -- 하지만 PPS가 입력되지 않으므로 마지막 주기 유지.
    else
      SRC_SEL_i       <= PPS_VALID_i and PPSIN_EN;
    end if;
  end if;
end process;
SRC_SEL_ST      <= SRC_SEL_i;

process(CLK)
begin
  if(CLK'event and CLK = '1') then
    PPS_VALID_D1  <= PPS_VALID_i;
    if(PPS_VALID_D1 = '1' and PPS_VALID_i = '0') then
      PPSIN_INVALID   <= '1';
      PPSIN_VALID     <= '0';
    elsif(PPS_VALID_D1 = '0' and PPS_VALID_i = '1') then
      PPSIN_INVALID   <= '0';
      PPSIN_VALID     <= '1';
    else
      PPSIN_INVALID   <= '0';
      PPSIN_VALID     <= '0';
    end if;
  end if;
end process;

process(CLK)
begin
  if(CLK'event and CLK = '1') then
    LOCKED_i_D1   <= LOCKED_i;
    if(LOCKED_i_D1 = '1' and LOCKED_i = '0') then
      PPS_UNLOCK      <= '1';
      PPS_LOCK        <= '0';
    elsif(LOCKED_i_D1 = '0' and LOCKED_i = '1') then
      PPS_UNLOCK      <= '0';
      PPS_LOCK        <= '1';
    else
      PPS_UNLOCK      <= '0';
      PPS_LOCK        <= '0';
    end if;
  end if;
end process;

----------------------------------- port map -----------------------

u1 : PFD    port map(
              CLK       => CLK,
              RESET     => S_RESETn,
              CLK_REF   => FILT_CLK_REF_i,
              -- CLK_REF   => CLK_REF_FE,            -- 20131028 modified by sunjae
              CLK_DCO   => CLK_DCO,
              UPDN      => UPDN_i
            );

u2_1 : ED     port map(
              CLK         => CLK,
              RESET       => S_RESETn,
              CLK_REF     => PPSIN1,
              CLK_REF_FE  => CLK_REF_FE1,
              FILT_CLK_REF=> FILT_CLK_REF1
            );

u2_2 : ED     port map(
              CLK         => CLK,
              RESET       => S_RESETn,
              CLK_REF     => PPSIN2,
              CLK_REF_FE  => CLK_REF_FE2,
              FILT_CLK_REF=> FILT_CLK_REF2
            );

u3 : UPDN_CNT port map(
              CLK         => CLK,
              RESET       => S_RESETn,
              CLK_REF_FE  => CLK_REF_FE_i,
              CNT_TV      => CNT_TV_i,
              UPDN        => UPDN_i,
              M           => M_i,
              N           => N_i
            );

u4 : DCO    port map(
              RESET           => S_RESETn,
              CLK             => CLK,
              CLK_REF_FE      => CLK_REF_FE_i,
              N               => N_i,
              M               => M_i,
              DIS_FRST        => '0', -- DIS_FRST_i, 20131024 modified by Sunjae
              LOCKED          => LOCKED_i,
              EN_LOCKED       => '0',             -- DCO use M & LOCKED Signal?
              SRC_SEL         => SRC_SEL_i,
              CLK_DCO         => CLK_DCO,
              CLK_DCO_8       => CLK_OUT_8,
              CLK_DCO_128     => CLK_OUT_128,
              CNT_DCO_OUT     => CNT_DCO_i,
			  CLK_DCO_1M	  => CLK_DCO_1M,

              CNT_TV_OUT      => CNT_TV_i
            );

u6_1 : PPSD port map(
              RESET           => S_RESETn,
              CLK             => CLK,
              CLK_REF_FE      => CLK_REF_FE1,
              PPS_VALID       => PPS1_VALID_i
            );

u6_2 : PPSD port map(
              RESET           => S_RESETn,
              CLK             => CLK,
              CLK_REF_FE      => CLK_REF_FE2,
              PPS_VALID       => PPS2_VALID_i
            );

u7 : LOCK   port map(
              CLK             => CLK,
              RESET           => S_RESETn,
              CLK_REF_FE      => CLK_REF_FE_i,
              UPDN            => UPDN_i,
              M               => M_i,
              CNT_TV          => CNT_TV_i,
              LOCKED          => LOCKED_i,
              CNT_DCO         => CNT_DCO_i,

              DBG_SUB_OUT     => SUB_OUT_i
            );

u8 : AUTO_CONT  port map(
                  CLK           => CLK,
                  RESET         => S_RESETn,
                  M_IN          => M,
                  DIS_FRST_IN   => DIS_FRST,          -- not used, 20131024
                  EN_AUTO       => EN_AUTO,           -- Enable Auto Mode
                  CLK_DCO       => CLK_DCO,
                  SUB_OUT       => SUB_OUT_i,
                  M_OUT         => M_i,
                  DIS_FRST_OUT  => DIS_FRST_i
                );

end Behavioral;

