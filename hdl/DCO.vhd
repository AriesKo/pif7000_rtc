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
--   1. Digital-Controlled Oscillator Module
--	 2. The DCO generate phase-locked 1Hz, 8Hz and 128Hz from M, N and CLK_REF_FE.
--   3. if DIS_FRST = '1' and EN_LOCKED = '0',
--      DCO Counter will reset at PPD falling edge(CLK_REF_FE).
--   4. if DIS_FRST = '1' and EN_LOCKED = '1',
--      DCO Counter will reset at PPD falling edge(CLK_REF_FE) when M="000" and LOCKED='1'.
--==============================================================================

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------- entity ----------------------

entity DCO is
	Port(
		RESET 		  : in  STD_LOGIC;
		CLK 		    : in  STD_LOGIC;
		CLK_REF_FE	: in  STD_LOGIC;
		N 			    : in  STD_LOGIC_VECTOR (25 downto 0);
		M 			    : in  STD_LOGIC_VECTOR (2 downto 0);
    DIS_FRST    : in  STD_LOGIC;
		LOCKED			: in	STD_LOGIC;
		EN_LOCKED		:	in	STD_LOGIC;															-- '1': Locked and M="000" 일때만 DIS_FRST(Disable Falling edge Reset)가 동작함
		SRC_SEL     : in  std_logic;
    CLK_DCO 	  : out STD_LOGIC;
		CLK_DCO_8 	: out STD_LOGIC;
		CLK_DCO_128 : out STD_LOGIC;
		CLK_DCO_1M  : out std_logic; 						-- add by HSKim
		CNT_DCO_OUT : out STD_LOGIC_VECTOR (25 downto 0);
		CNT_TV_OUT	: out STD_LOGIC_VECTOR (25 downto 0)
	);
end DCO;


architecture Behavioral of DCO is
----------------------------------- signal -------------------------

	signal CNT_TV 			: STD_LOGIC_VECTOR (25 downto 0);
	signal CNT_DCO 			: STD_LOGIC_VECTOR (25 downto 0);
	signal CNT_TV_2 		: STD_LOGIC_VECTOR (25 downto 0);
  signal CNT_TV_8     : STD_LOGIC_VECTOR (29 downto 0);
  signal CNT_TV_128   : STD_LOGIC_VECTOR (33 downto 0);
  signal TMP_CLK_DCO  : STD_LOGIC;
  signal TMP_CLK_DCO_DFF  : STD_LOGIC;
  signal TMP_CLK_DCO_8    : STD_LOGIC;
  signal TMP_CLK_DCO_128  : STD_LOGIC;
  signal TMP_CLK_DCO_1M	  : STD_LOGIC;
	signal CLK_REF_FE_1 : STD_LOGIC;
	signal CLK_REF_FE_2 : STD_LOGIC;
	signal CLK_REF_FE_3 : STD_LOGIC;
	signal M_1 				  : STD_LOGIC_VECTOR (2 downto 0);
	signal M_2 				  : STD_LOGIC_VECTOR (2 downto 0);
	signal CNT_TV_D			: STD_LOGIC_VECTOR (25 downto 0);		-- CNT_TV가 1/2주기 정도 Delay된 Signal

	constant INIT_VAL		: STD_LOGIC_VECTOR (25 downto 0) := "01001100010010110011111111";	-- 19,999,999				CNT_DCO initial value
	-- constant INIT_VAL		: STD_LOGIC_VECTOR (25 downto 0) := "00000000000100111000011111";	-- 19,999							CNT_DCO initial value, for simulation

  constant FRST_VAL   : STD_LOGIC_VECTOR (25 downto 0) := "00000000000000000000000101";	-- 5	CNT_DCO initial value at CLK_REF_FE

  signal CNT16        : std_logic_vector(3 downto 0);                           -- 20131024 added by Sunjae
  signal CNT256       : std_logic_vector(7 downto 0);                           -- 20131024 added by Sunjae
  signal CNT_1US	  : std_logic_vector(4 downto 0);
  constant CNT_1US_MAX  : std_logic_vector(4 downto 0) :="10011" ;
  constant CNT_1US_HALF  : std_logic_vector(4 downto 0) :="01001" ;
  
  signal SRC_SEL_D1   : std_logic;                                              -- 20131024 added by Sunjae
  signal SRC_SEL_D2   : std_logic;                                              -- 20131024 added by Sunjae
  signal SRC_SEL_D3   : std_logic;                                              -- 20131024 added by Sunjae

begin
----------------------------------- wire ---------------------------

CLK_DCO_8   <= TMP_CLK_DCO_8;
CLK_DCO_128 <= TMP_CLK_DCO_128;
CLK_DCO_1M <= TMP_CLK_DCO_1M;

CNT_DCO_OUT <= CNT_DCO;
CNT_TV_OUT	<= CNT_TV;
CLK_DCO		<= TMP_CLK_DCO;
----------------------------------- process ------------------------
TMP_CLK_DCO_Delay:------------------------------------------------------------
process(CLK, RESET)
begin
	if(RESET = '0') then
		TMP_CLK_DCO_DFF <= '0';		
	elsif CLK'event and CLK = '1' then
		TMP_CLK_DCO_DFF <= TMP_CLK_DCO;
	end if;
end process;

SHIFTER:------------------------------------------------------------
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			CNT_TV      <= INIT_VAL;
			CNT_TV_2    <= '0'&INIT_VAL(25 downto 1);
		elsif(CLK_REF_FE_2 = '1') then
      if(SRC_SEL_D2 = '0') then                                                    -- 20131024 added by Sunjae
        CNT_TV      <= INIT_VAL;                                                -- 20131024 added by Sunjae
        CNT_TV_2    <= '0'&INIT_VAL(25 downto 1);                               -- 20131024 added by Sunjae
      else                                                                      -- 20131024 added by Sunjae
        case M_2 is												                        -- (M)  N이 바뀌는 조건과 동기를 맞추기 위해..
          when "001" => CNT_TV    <= N(24 downto 0) & '0';			  -- N*2
                        CNT_TV_2  <= N;								            -- N
          when "010" => CNT_TV    <= N(23 downto 0) & "00";			  -- N*4
                        CNT_TV_2  <= N(24 downto 0) & '0';			  -- N*2
          when "011" => CNT_TV    <= N(22 downto 0) & "000";			-- N*8
                        CNT_TV_2  <= N(23 downto 0) & "00";		    -- N*4
          when "100" => CNT_TV    <= N(21 downto 0) & "0000";		  -- N*16
                        CNT_TV_2  <= N(22 downto 0) & "000";			-- N*8
          when "101" => CNT_TV    <= N(20 downto 0) & "00000";		-- N*32
                        CNT_TV_2  <= N(21 downto 0) & "0000";		  -- N*16
          when "110" => CNT_TV    <= N(19 downto 0) & "000000";		-- N*64
                        CNT_TV_2  <= N(20 downto 0) & "00000";		-- N*32
          when "111" => CNT_TV    <= N(18 downto 0) & "0000000";  -- N*128
                        CNT_TV_2  <= N(19 downto 0) & "000000";		-- N*64
          when others => CNT_TV   <= N;								            -- N
                         CNT_TV_2 <= '0' & N(25 downto 1);			  -- N/2
        end case;
      end if;                                                                   -- 20131024 added by Sunjae
    else                                                                        -- 20131024 added by Sunjae
      if(SRC_SEL = '0' and CNT_DCO = CNT_TV_D) then                             -- 20131024 added by Sunjae
        CNT_TV      <= INIT_VAL;                                                -- 20131024 added by Sunjae
        CNT_TV_2    <= '0'&INIT_VAL(25 downto 1);                               -- 20131024 added by Sunjae
      else                                                                      -- 20131024 added by Sunjae
        CNT_TV      <= CNT_TV;                                                  -- 20131024 added by Sunjae
        CNT_TV_2    <= CNT_TV_2;                                                -- 20131024 added by Sunjae
      end if;                                                                   -- 20131024 added by Sunjae
		end if;                                                                     -- 20131024 added by Sunjae
	end if;
end process;

COUNTER:------------------------------------------------------------
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			CNT_DCO <= (others => '0');
		-- elsif(CLK_REF_FE = '1') then
		elsif(CLK_REF_FE = '1' and SRC_SEL = '1') then                              -- 20131024 modified by Sunjae
			if(DIS_FRST = '0') then
				CNT_DCO <= FRST_VAL;
			else
				if(EN_LOCKED = '1')	then									--	EN_LOCKED로
					if(LOCKED = '1' and M = "000") then			--	DIS_FRST가 1일때 무조건 Disable Falling edge Reset이냐
						if(CNT_DCO = CNT_TV_D) then						--	아니면
							CNT_DCO <= (others => '0');					--	DIS_FRST가 1이고 M="000" and LOCKED 상태를 만족해야 Disable Falling edge Reset이냐
						else																	--	를 선택
							CNT_DCO <= CNT_DCO + '1';						--
						end if;																--
					else																		--
						CNT_DCO <= FRST_VAL;									--
					end if;																	--
				else																			--
					if(CNT_DCO = CNT_TV_D) then
						CNT_DCO <= (others => '0');
					else
						CNT_DCO <= CNT_DCO + '1';
					end if;
				end if;																		--
	    end if;
		else
			if(CNT_DCO = CNT_TV_D) then
				CNT_DCO <= (others => '0');
			else
				CNT_DCO <= CNT_DCO + '1';
			end if;
		end if;
	end if;
end process;

--------------------- add by HSKim for 1Mhz Clock generation ------------------
PRO_CNT_1US : 
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			CNT_1US		<= (others=>'0');
		elsif (TMP_CLK_DCO = '0') and (TMP_CLK_DCO_DFF = '1') then
			CNT_1US	<= (others=>'0');
		elsif CNT_1US = CNT_1US_MAX then
			CNT_1US		<= (others=>'0');
		else
			CNT_1US <= CNT_1US + '1';
		end if;
	end if;
end process;
--------------------- add by HSKim for 1Mhz Clock generation ------------------

PULS_GEN:------------------------------------------------------------
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			TMP_CLK_DCO 	<= '0';
			CNT_TV_D 	<= INIT_VAL;
		elsif(CNT_DCO = CNT_TV_D) then
			TMP_CLK_DCO <= '0';
		else
			-- if(CLK_REF_FE = '1') then
			if(CLK_REF_FE = '1' and SRC_SEL = '1') then                               -- 20131024 modified by Sunjae
				if(DIS_FRST = '0') then										-- DIS_FRST 가 '0'이면 그냥 PPS falling edge Reset
					TMP_CLK_DCO <= '0';
				else																			-- DIS_FRST 가 '1'이면 EN_LOCKED에 따라 결정
					if(EN_LOCKED = '1') then
						if(LOCKED = '0' or M /= "000") then
							TMP_CLK_DCO <= '0';
						end if;
					end if;
				end if;
			else
				if(CNT_DCO = CNT_TV_2) then
					TMP_CLK_DCO 	<= '1';
					CNT_TV_D	<= CNT_TV;
				end if;
	    end if;
		end if;
	end if;
end process;


--------------------- add by HSKim for 1Mhz Clock generation ------------------
PRO_TMP_CLK_DCO_1M : 
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			TMP_CLK_DCO_1M  <= '0';
		elsif(CNT_1US = CNT_1US_MAX) then
			if (TMP_CLK_DCO = '0') and (TMP_CLK_DCO_DFF = '1') then
				TMP_CLK_DCO_1M  <= '1';
			else
				TMP_CLK_DCO_1M  <= '0';
			end if;
		elsif(CNT_1US = CNT_1US_HALF) then
			TMP_CLK_DCO_1M 	<= '1';
		else
			TMP_CLK_DCO_1M <= TMP_CLK_DCO_1M;
		end if;
	end if;
end process;

--------------------- add by HSKim for 1Mhz Clock generation ------------------


PRO_CNT_TV_8:
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			CNT_TV_8      <= "0000" & INIT_VAL;
      TMP_CLK_DCO_8 <= '0';
      CNT16         <= (others => '0');                                         -- 20131024 added by Sunjae
		elsif(CNT_DCO = CNT_TV_D) then                        -- PPS가 없을 경우 초기화 시점.
			TMP_CLK_DCO_8 <= '0';
			CNT_TV_8      <= "0000" & CNT_TV;
      CNT16         <= (others => '0');                                         -- 20131024 added by Sunjae
		else
			-- if(CLK_REF_FE = '1') then 													-- PPS가 있을 경우 CLK 초기화 시점.
			if(CLK_REF_FE = '1' and SRC_SEL = '1') then                               -- 20131024 modified by Sunjae
				if(DIS_FRST = '0') then
					TMP_CLK_DCO_8 <= '0';
          CNT16         <= (others => '0');                                     -- 20131024 added by Sunjae
				else
					if(EN_LOCKED = '1') then
						if(LOCKED = '0' or M /= "000") then
							TMP_CLK_DCO_8 <= '0';
              CNT16         <= (others => '0');                                 -- 20131024 added by Sunjae
						else
							if(CNT_DCO = CNT_TV_8(29 downto 4)) then		-- DIS_FRST상태이면서 CLK_REF_FE와 동시에 CNT_DCO = CNT_TV_8(29 downto 4) 인경우
                -- TMP_CLK_DCO_8 <= not TMP_CLK_DCO_8;
                -- CNT_TV_8      <= CNT_TV_8 + ("0000" & CNT_TV);
                if(CNT16 = "1111") then                                         -- 20131024 modified by Sunjae
                  TMP_CLK_DCO_8 <= TMP_CLK_DCO_8;
                  CNT_TV_8      <= CNT_TV_8;
                  CNT16         <= CNT16;
                else
                  TMP_CLK_DCO_8 <= not TMP_CLK_DCO_8;
                  CNT_TV_8      <= CNT_TV_8 + ("0000" & CNT_TV);
                  CNT16         <= CNT16 + '1';
                end if;
							end if;
						end if;
					else
						if(CNT_DCO = CNT_TV_8(29 downto 4)) then			-- DIS_FRST상태이면서 CLK_REF_FE와 동시에 CNT_DCO = CNT_TV_8(29 downto 4) 인경우
              -- TMP_CLK_DCO_8 <= not TMP_CLK_DCO_8;
              -- CNT_TV_8      <= CNT_TV_8 + ("0000" & CNT_TV);
              if(CNT16 = "1111") then                                           -- 20131024 modified by Sunjae
                TMP_CLK_DCO_8 <= TMP_CLK_DCO_8;
                CNT_TV_8      <= CNT_TV_8;
                CNT16         <= CNT16;
              else
                TMP_CLK_DCO_8 <= not TMP_CLK_DCO_8;
                CNT_TV_8      <= CNT_TV_8 + ("0000" & CNT_TV);
                CNT16         <= CNT16 + '1';
              end if;
						end if;
					end if;
				end if;
			else
				-- if(CLK_REF_FE_3 = '1') then                      	-- PPS가 있을 경우 CNT 초기화 시점.
				if(CLK_REF_FE_3 = '1' and SRC_SEL_D3 = '1') then                           -- 20131024 modified by Sunjae
					if(DIS_FRST = '0') then
						CNT_TV_8	<= "0000" & CNT_TV;
					else
						if(EN_LOCKED = '1') then
							if(LOCKED = '0' or M /= "000") then
								CNT_TV_8	<= "0000" & CNT_TV;
							else
								if(CNT_DCO = CNT_TV_8(29 downto 4)) then	-- DIS_FRST상태이면서 CLK_REF_FE_3와 동시에 CNT_DCO = CNT_TV_8(29 downto 4) 인경우
                  -- TMP_CLK_DCO_8 <= not TMP_CLK_DCO_8;
                  -- CNT_TV_8      <= CNT_TV_8 + ("0000" & CNT_TV);
                  if(CNT16 = "1111") then                                       -- 20131024 modified by Sunjae
                    TMP_CLK_DCO_8 <= TMP_CLK_DCO_8;
                    CNT_TV_8      <= CNT_TV_8;
                    CNT16         <= CNT16;
                  else
                    TMP_CLK_DCO_8 <= not TMP_CLK_DCO_8;
                    CNT_TV_8      <= CNT_TV_8 + ("0000" & CNT_TV);
                    CNT16         <= CNT16 + '1';
                  end if;
								elsif(CNT_DCO(25 downto 16) = "00000000000") then					-- actual code
								-- elsif(CNT_DCO(25 downto 6) = "000000000000000000000") then		-- for simulation
									CNT_TV_8	<= "0000" & CNT_TV;
								end if;
							end if;
						else
							if(CNT_DCO = CNT_TV_8(29 downto 4)) then		-- DIS_FRST상태이면서 CLK_REF_FE_3와 동시에 CNT_DCO = CNT_TV_8(29 downto 4) 인경우 
                -- TMP_CLK_DCO_8 <= not TMP_CLK_DCO_8;
                -- CNT_TV_8      <= CNT_TV_8 + ("0000" & CNT_TV);
                if(CNT16 = "1111") then                                         -- 20131024 modified by Sunjae
                  TMP_CLK_DCO_8 <= TMP_CLK_DCO_8;
                  CNT_TV_8      <= CNT_TV_8;
                  CNT16         <= CNT16;
                else
                  TMP_CLK_DCO_8 <= not TMP_CLK_DCO_8;
                  CNT_TV_8      <= CNT_TV_8 + ("0000" & CNT_TV);
                  CNT16         <= CNT16 + '1';
                end if;
							elsif(CNT_DCO(25 downto 16) = "00000000000") then					-- actual code
							-- elsif(CNT_DCO(25 downto 6) = "000000000000000000000") then		-- for simulation
								CNT_TV_8	<= "0000" & CNT_TV;
							end if;
						end if;
					end if;
				else
					if(CNT_DCO = CNT_TV_8(29 downto 4)) then
            -- TMP_CLK_DCO_8 <= not TMP_CLK_DCO_8;
            -- CNT_TV_8      <= CNT_TV_8 + ("0000" & CNT_TV);
            if(CNT16 = "1111") then                                             -- 20131024 modified by Sunjae
              TMP_CLK_DCO_8 <= TMP_CLK_DCO_8;
              CNT_TV_8      <= CNT_TV_8;
              CNT16         <= CNT16;
            else
              TMP_CLK_DCO_8 <= not TMP_CLK_DCO_8;
              CNT_TV_8      <= CNT_TV_8 + ("0000" & CNT_TV);
              CNT16         <= CNT16 + '1';
            end if;
          end if;
				end if;
			end if;
		end if;
	end if;
end process;

PRO_CNT_TV_128:
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if(RESET = '0') then
			CNT_TV_128      <= "00000000" & INIT_VAL;
      TMP_CLK_DCO_128 <= '0';
      CNT256          <= (others => '0');                                       -- 20131024 added by Sunjae
		elsif(CNT_DCO = CNT_TV_D) then
			TMP_CLK_DCO_128 <= '0';
			CNT_TV_128      <= "00000000" & CNT_TV;
      CNT256          <= (others => '0');                                       -- 20131024 added by Sunjae
		else
			-- if(CLK_REF_FE = '1') then
			if(CLK_REF_FE = '1' and SRC_SEL = '1') then                               -- 20131024 modified by Sunjae
				if(DIS_FRST = '0') then
					TMP_CLK_DCO_128 <= '0';
          CNT256          <= (others => '0');                                   -- 20131024 added by Sunjae
				else
					if(EN_LOCKED = '1') then
						if(LOCKED = '0' or M /= "000") then
							TMP_CLK_DCO_128 <= '0';
              CNT256          <= (others => '0');                               -- 20131024 added by Sunjae
						else
							if(CNT_DCO = CNT_TV_128(33 downto 8)) then
								-- TMP_CLK_DCO_128 <= not TMP_CLK_DCO_128;
								-- CNT_TV_128      <= CNT_TV_128 + ("00000000" & CNT_TV);
                if(CNT256 = "11111111") then                                    -- 20131024 modified by Sunjae
                  TMP_CLK_DCO_128 <= TMP_CLK_DCO_128;
                  CNT_TV_128      <= CNT_TV_128;
                  CNT256          <= CNT256;
                else
                  TMP_CLK_DCO_128 <= not TMP_CLK_DCO_128;
                  CNT_TV_128      <= CNT_TV_128 + ("00000000" & CNT_TV);
                  CNT256          <= CNT256 + '1';
                end if;
							end if;
						end if;
					else
						if(CNT_DCO = CNT_TV_128(33 downto 8)) then
							-- TMP_CLK_DCO_128 <= not TMP_CLK_DCO_128;
							-- CNT_TV_128      <= CNT_TV_128 + ("00000000" & CNT_TV);
              if(CNT256 = "11111111") then                                      -- 20131024 modified by Sunjae
                TMP_CLK_DCO_128 <= TMP_CLK_DCO_128;
                CNT_TV_128      <= CNT_TV_128;
                CNT256          <= CNT256;
              else
                TMP_CLK_DCO_128 <= not TMP_CLK_DCO_128;
                CNT_TV_128      <= CNT_TV_128 + ("00000000" & CNT_TV);
                CNT256          <= CNT256 + '1';
              end if;
						end if;
					end if;
				end if;
			else
				-- if(CLK_REF_FE_3 = '1') then
				if(CLK_REF_FE_3 = '1' and SRC_SEL_D3 = '1') then                           -- 20131024 modified by Sunjae
					if(DIS_FRST = '0') then
						CNT_TV_128      <= "00000000" & CNT_TV;
					else
						if(EN_LOCKED = '1') then
							if(LOCKED = '0' or M /= "000") then
								CNT_TV_128      <= "00000000" & CNT_TV;
							else
								if(CNT_DCO = CNT_TV_128(33 downto 8)) then
									-- TMP_CLK_DCO_128 <= not TMP_CLK_DCO_128;
									-- CNT_TV_128      <= CNT_TV_128 + ("00000000" & CNT_TV);
                  if(CNT256 = "11111111") then                                  -- 20131024 modified by Sunjae
                    TMP_CLK_DCO_128 <= TMP_CLK_DCO_128;
                    CNT_TV_128      <= CNT_TV_128;
                    CNT256          <= CNT256;
                  else
                    TMP_CLK_DCO_128 <= not TMP_CLK_DCO_128;
                    CNT_TV_128      <= CNT_TV_128 + ("00000000" & CNT_TV);
                    CNT256          <= CNT256 + '1';
                  end if;
								elsif(CNT_DCO(25 downto 16) = "00000000000") then					-- actual code
								-- elsif(CNT_DCO(25 downto 6) = "000000000000000000000") then		-- for simulation
									CNT_TV_128      <= "00000000" & CNT_TV;
								end if;
							end if;
						else
							if(CNT_DCO = CNT_TV_128(33 downto 8)) then
								-- TMP_CLK_DCO_128 <= not TMP_CLK_DCO_128;
								-- CNT_TV_128      <= CNT_TV_128 + ("00000000" & CNT_TV);
                if(CNT256 = "11111111") then                                    -- 20131024 modified by Sunjae
                  TMP_CLK_DCO_128 <= TMP_CLK_DCO_128;
                  CNT_TV_128      <= CNT_TV_128;
                  CNT256          <= CNT256;
                else
                  TMP_CLK_DCO_128 <= not TMP_CLK_DCO_128;
                  CNT_TV_128      <= CNT_TV_128 + ("00000000" & CNT_TV);
                  CNT256          <= CNT256 + '1';
                end if;
							elsif(CNT_DCO(25 downto 16) = "00000000000") then					-- actual code
							-- elsif(CNT_DCO(25 downto 6) = "000000000000000000000") then		-- for simulation
								CNT_TV_128      <= "00000000" & CNT_TV;
							end if;
						end if;
					end if;
				else
			    if(CNT_DCO = CNT_TV_128(33 downto 8)) then
						-- TMP_CLK_DCO_128 <= not TMP_CLK_DCO_128;
						-- CNT_TV_128      <= CNT_TV_128 + ("00000000" & CNT_TV);
            if(CNT256 = "11111111") then                                        -- 20131024 modified by Sunjae
              TMP_CLK_DCO_128 <= TMP_CLK_DCO_128;
              CNT_TV_128      <= CNT_TV_128;
              CNT256          <= CNT256;
            else
              TMP_CLK_DCO_128 <= not TMP_CLK_DCO_128;
              CNT_TV_128      <= CNT_TV_128 + ("00000000" & CNT_TV);
              CNT256          <= CNT256 + '1';
            end if;
					end if;
				end if;
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
			CLK_REF_FE_3  <= '0';
      SRC_SEL_D1    <= '0';                                                     -- 20131024 added by Sunjae
      SRC_SEL_D2    <= '0';                                                     -- 20131024 added by Sunjae
      SRC_SEL_D3    <= '0';                                                     -- 20131024 added by Sunjae
			M_1           <= "000";
			M_2           <= "000";
		else
			CLK_REF_FE_1  <= CLK_REF_FE;
			CLK_REF_FE_2  <= CLK_REF_FE_1;
			CLK_REF_FE_3  <= CLK_REF_FE_2;
      SRC_SEL_D1    <= SRC_SEL;                                                 -- 20131024 added by Sunjae
      SRC_SEL_D2    <= SRC_SEL_D1;                                              -- 20131024 added by Sunjae
      SRC_SEL_D3    <= SRC_SEL_D2;                                              -- 20131024 added by Sunjae
			M_1           <= M;
			M_2           <= M_1;
		end if;
	end if;
end process;


end Behavioral;