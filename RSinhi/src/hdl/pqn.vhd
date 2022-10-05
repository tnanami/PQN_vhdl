------------------------------------------------------
-- Author: Takuya Nanami
-- Model: PQN model
-- Mode: RSinhi
-- Port Descriptions:
--    clk: clock
--    PORT_Iin: Stimulus input
--    PORT_vin/out: Membrane potential
--    PORT_nin/out: Recovery variable
--    PORT_qin/out: Slow variable
--    PORT_spike_flag: This becomes 1 only when a spike occurs
------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.ALL;
entity RSinhi is
PORT(
    clk : IN STD_LOGIC;
    PORT_Iin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_vin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_nin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_qin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_sin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_vout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_nout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_qout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_sout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_spike_flag : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
);
end RSinhi;
architecture Behavioral of RSinhi is
    TYPE STATE_TYPE IS (READY);
    SIGNAL STATE : STATE_TYPE := READY;
    SIGNAL Iin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL qin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vv36 : STD_LOGIC_VECTOR(35 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vv : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vin_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nin_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL qin_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sin_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vin_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nin_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL qin_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sin_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vout_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nout_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL qout_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sout_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_vS_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_vL_2nd: STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_v_vS_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_v_vL_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_n_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_q_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_Iin_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_vv_vS_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_vv_vL_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_v_vS_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_v_vL_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_n_2nd: STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL q_vv_vS_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL q_vv_vL_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL q_v_vS_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL q_v_vL_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL q_q_2nd: STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_S_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_L_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_S_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_L_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_x_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_v_x_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_x_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_vv_x_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_v_x_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_x_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL q_vv_x_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL q_v_x_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL q_x_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL v_vv_vS_0 : std_logic_vector(29 downto 0);
    SIGNAL v_vv_vS_1 : std_logic_vector(29 downto 0);
    SIGNAL v_vv_vS_2 : std_logic_vector(29 downto 0);
    SIGNAL v_vv_vS_3 : std_logic_vector(29 downto 0);
    SIGNAL v_vv_vS_4 : std_logic_vector(29 downto 0);
    SIGNAL v_vv_vS_5 : std_logic_vector(29 downto 0);
    SIGNAL v_vv_vS_6 : std_logic_vector(29 downto 0);
    SIGNAL v_vv_vS_7 : std_logic_vector(29 downto 0);
    SIGNAL v_vv_vS_8 : std_logic_vector(29 downto 0);
    SIGNAL v_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL v_vv_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_4 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_5 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_6 : std_logic_vector(37 downto 0);
    SIGNAL v_v_vS : std_logic_vector(17 downto 0);
    SIGNAL v_v_vS_0 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vS_1 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vS_2 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vS_3 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vS_4 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vS_5 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vS_6 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vS_7 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vL : std_logic_vector(17 downto 0);
    SIGNAL v_v_vL_0 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_1 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_2 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_3 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_4 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_5 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_6 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_7 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_8 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_9 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_10 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vL_11 : std_logic_vector(36 downto 0);
    SIGNAL v_n : std_logic_vector(17 downto 0);
    SIGNAL v_n_0 : std_logic_vector(37 downto 0);
    SIGNAL v_n_1 : std_logic_vector(37 downto 0);
    SIGNAL v_n_2 : std_logic_vector(37 downto 0);
    SIGNAL v_n_3 : std_logic_vector(37 downto 0);
    SIGNAL v_n_4 : std_logic_vector(37 downto 0);
    SIGNAL v_n_5 : std_logic_vector(37 downto 0);
    SIGNAL v_n_6 : std_logic_vector(37 downto 0);
    SIGNAL v_q : std_logic_vector(17 downto 0);
    SIGNAL v_q_0 : std_logic_vector(37 downto 0);
    SIGNAL v_q_1 : std_logic_vector(37 downto 0);
    SIGNAL v_q_2 : std_logic_vector(37 downto 0);
    SIGNAL v_q_3 : std_logic_vector(37 downto 0);
    SIGNAL v_q_4 : std_logic_vector(37 downto 0);
    SIGNAL v_q_5 : std_logic_vector(37 downto 0);
    SIGNAL v_q_6 : std_logic_vector(37 downto 0);
    SIGNAL v_Iin : std_logic_vector(17 downto 0);
    SIGNAL v_Iin_0 : std_logic_vector(30 downto 0);
    SIGNAL v_Iin_1 : std_logic_vector(30 downto 0);
    SIGNAL v_Iin_2 : std_logic_vector(30 downto 0);
    SIGNAL v_Iin_3 : std_logic_vector(30 downto 0);
    SIGNAL v_Iin_4 : std_logic_vector(30 downto 0);
    SIGNAL v_Iin_5 : std_logic_vector(30 downto 0);
    SIGNAL v_Iin_6 : std_logic_vector(30 downto 0);
    SIGNAL v_Iin_7 : std_logic_vector(30 downto 0);
    SIGNAL v_Iin_8 : std_logic_vector(30 downto 0);
    SIGNAL v_Iin_9 : std_logic_vector(30 downto 0);
    SIGNAL v_Iin_10 : std_logic_vector(30 downto 0);
    SIGNAL n_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vS_0 : std_logic_vector(24 downto 0);
    SIGNAL n_vv_vS_1 : std_logic_vector(24 downto 0);
    SIGNAL n_vv_vS_2 : std_logic_vector(24 downto 0);
    SIGNAL n_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vL_0 : std_logic_vector(26 downto 0);
    SIGNAL n_vv_vL_1 : std_logic_vector(26 downto 0);
    SIGNAL n_vv_vL_2 : std_logic_vector(26 downto 0);
    SIGNAL n_vv_vL_3 : std_logic_vector(26 downto 0);
    SIGNAL n_vv_vL_4 : std_logic_vector(26 downto 0);
    SIGNAL n_vv_vL_5 : std_logic_vector(26 downto 0);
    SIGNAL n_v_vS : std_logic_vector(17 downto 0);
    SIGNAL n_v_vS_0 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vS_1 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vS_2 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vS_3 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vS_4 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL : std_logic_vector(17 downto 0);
    SIGNAL n_v_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_4 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_5 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_6 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_7 : std_logic_vector(37 downto 0);
    SIGNAL n_n : std_logic_vector(17 downto 0);
    SIGNAL n_n_0 : std_logic_vector(37 downto 0);
    SIGNAL n_n_1 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vS_0 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vS_1 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vS_2 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vL_0 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_1 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_2 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_3 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_4 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_5 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_6 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_7 : std_logic_vector(32 downto 0);
    SIGNAL q_v_vS : std_logic_vector(17 downto 0);
    SIGNAL q_v_vS_0 : std_logic_vector(35 downto 0);
    SIGNAL q_v_vS_1 : std_logic_vector(35 downto 0);
    SIGNAL q_v_vS_2 : std_logic_vector(35 downto 0);
    SIGNAL q_v_vS_3 : std_logic_vector(35 downto 0);
    SIGNAL q_v_vS_4 : std_logic_vector(35 downto 0);
    SIGNAL q_v_vS_5 : std_logic_vector(35 downto 0);
    SIGNAL q_v_vS_6 : std_logic_vector(35 downto 0);
    SIGNAL q_v_vL : std_logic_vector(17 downto 0);
    SIGNAL q_v_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_4 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_5 : std_logic_vector(37 downto 0);
    SIGNAL q_q : std_logic_vector(17 downto 0);
    SIGNAL q_q_0 : std_logic_vector(37 downto 0);
    SIGNAL q_q_1 : std_logic_vector(37 downto 0);
    SIGNAL q_q_2 : std_logic_vector(37 downto 0);
    SIGNAL s_S : std_logic_vector(17 downto 0);
    SIGNAL s_S_0 : std_logic_vector(37 downto 0);
    SIGNAL s_S_1 : std_logic_vector(37 downto 0);
    SIGNAL s_L : std_logic_vector(17 downto 0);
    SIGNAL s_L_0 : std_logic_vector(37 downto 0);
    SIGNAL s_L_1 : std_logic_vector(37 downto 0);
    SIGNAL v_c_vS : std_logic_vector(17 downto 0):="000000000010011000";-- 0.1484375
    SIGNAL v_c_vL : std_logic_vector(17 downto 0):="000000000010011100";-- 0.15234375
    SIGNAL n_c_vS : std_logic_vector(17 downto 0):="000000000000000100";-- 0.00390625
    SIGNAL n_c_vL : std_logic_vector(17 downto 0):="000000000011110011";-- 0.2373046875
    SIGNAL q_c_vS : std_logic_vector(17 downto 0):="000000000000000011";-- 0.0029296875
    SIGNAL q_c_vL : std_logic_vector(17 downto 0):="000000000000000100";-- 0.00390625
    SIGNAL s_c_L : std_logic_vector(17 downto 0):="000000000000010000";-- 0.015625
    SIGNAL crf : std_logic_vector(17 downto 0):="000000000000000000";-- 0
    SIGNAL crg : std_logic_vector(17 downto 0):="000000010001000000";-- 1.0625
    SIGNAL crh : std_logic_vector(17 downto 0):="000000000110100000";-- 0.40625
    SIGNAL vini : std_logic_vector(17 downto 0):="111110111001011101";-- -4.4091796875
    SIGNAL nini : std_logic_vector(17 downto 0):="000100101111000000";-- 18.9375
    SIGNAL qini : std_logic_vector(17 downto 0):="111111100011100011";-- -1.7783203125
    SIGNAL vth : std_logic_vector(17 downto 0):="000000000000000000";-- 0

BEGIN
    updater : PROCESS (CLK)
    BEGIN
        IF (rising_edge(CLK)) THEN
            -- 1st stage
            Iin <= PORT_Iin;
            vv36 <= PORT_vin * PORT_vin;
            vin <= PORT_vin;
            nin <= PORT_nin;
            qin <= PORT_qin;
            sin <= PORT_sin;
            -- 2nd stage
            v_vv_vS_2nd <= v_vv_vS;
            v_vv_vL_2nd <= v_vv_vL;
            v_v_vS_2nd <= v_v_vS;
            v_v_vL_2nd <= v_v_vL;
            v_n_2nd <= v_n;
            v_q_2nd <= v_q;
            v_Iin_2nd <= v_Iin;
            n_vv_vS_2nd <= n_vv_vS;
            n_vv_vL_2nd <= n_vv_vL;
            n_v_vS_2nd <= n_v_vS;
            n_v_vL_2nd <= n_v_vL;
            n_n_2nd <= n_n;
            q_vv_vS_2nd <= q_vv_vS;
            q_vv_vL_2nd <= q_vv_vL;
            q_v_vS_2nd <= q_v_vS;
            q_v_vL_2nd <= q_v_vL;
            q_q_2nd <= q_q;
            s_S_2nd <= s_S;
            s_L_2nd <= s_L;
            vin_2nd <= vin;
            nin_2nd <= nin;
            qin_2nd <= qin;
            sin_2nd <= sin;
            -- 3rd stage
            vout_3rd <= vin_2nd + v_vv_x_2nd + v_v_x_2nd + v_x_2nd + v_n_2nd + v_q_2nd + v_Iin_2nd;
            nout_3rd <= nin_2nd + n_vv_x_2nd + n_v_x_2nd + n_x_2nd + n_n_2nd;
            qout_3rd <= qin_2nd + q_vv_x_2nd + q_v_x_2nd + q_x_2nd + q_q_2nd;
            vin_3rd <= vin_2nd;
            nin_3rd <= nin_2nd;
            qin_3rd <= qin_2nd;
            sin_3rd <= sin_2nd;
            --4th stage
            PORT_vout <= vout_3rd;
            PORT_nout <= nout_3rd;
            PORT_qout <= qout_3rd;
            IF vout_3rd<0 THEN
                PORT_sout <= sin_3rd + s_S_3rd;
            ELSE
                PORT_sout <= sin_3rd + s_L_3rd + s_c_L;
            END IF;
            IF vin_3rd<vth and vout_3rd>=vth THEN
                PORT_spike_flag <= "1";
            ELSE
                PORT_spike_flag <= "0";
            END IF;
        END IF;
    END PROCESS;
    vv <= vv36(27 downto 10 );
    -- vv * 0.077911376953125 : 00000000.00010011111100100000    30bit
    v_vv_vS_0 <= "0000" & vv(17 downto 0) & "00000000" when vv(17)='0' else "1111" & vv(17 downto 0) & "00000000";
    v_vv_vS_1 <= "0000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "1111111" & vv(17 downto 0) & "00000";
    v_vv_vS_2 <= "00000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "11111111" & vv(17 downto 0) & "0000";
    v_vv_vS_3 <= "000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "000";
    v_vv_vS_4 <= "0000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "00";
    v_vv_vS_5 <= "00000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "0";
    v_vv_vS_6 <= "000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "111111111111" & vv(17 downto 0) & "";
    v_vv_vS_7 <= "000000000000000" & vv(17 downto 3) & "" when vv(17)='0' else "111111111111111" & vv(17 downto 3) & "";
    v_vv_vS_8 <= v_vv_vS_0 + v_vv_vS_1 + v_vv_vS_2 + v_vv_vS_3 + v_vv_vS_4 + v_vv_vS_5 + v_vv_vS_6 + v_vv_vS_7;
    v_vv_vS <= v_vv_vS_8(29 downto 12);

    -- vv * -0.0491180419921875 : 00000000.00001100100100110000    38bit
    v_vv_vL_0 <= "00000" & vv(17 downto 0) & "000000000000000" when vv(17)='0' else "11111" & vv(17 downto 0) & "000000000000000";
    v_vv_vL_1 <= "000000" & vv(17 downto 0) & "00000000000000" when vv(17)='0' else "111111" & vv(17 downto 0) & "00000000000000";
    v_vv_vL_2 <= "000000000" & vv(17 downto 0) & "00000000000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "00000000000";
    v_vv_vL_3 <= "000000000000" & vv(17 downto 0) & "00000000" when vv(17)='0' else "111111111111" & vv(17 downto 0) & "00000000";
    v_vv_vL_4 <= "000000000000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "00000";
    v_vv_vL_5 <= "0000000000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "1111111111111111" & vv(17 downto 0) & "0000";
    v_vv_vL_6 <= not (v_vv_vL_0 + v_vv_vL_1 + v_vv_vL_2 + v_vv_vL_3 + v_vv_vL_4 + v_vv_vL_5) + 1;
    v_vv_vL <= v_vv_vL_6(37 downto 20);

    -- vin * 0.16556167602539062 : 00000000.00101010011000100100    33bit
    v_v_vS_0 <= "000" & vin(17 downto 0) & "000000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "000000000000";
    v_v_vS_1 <= "00000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "11111" & vin(17 downto 0) & "0000000000";
    v_v_vS_2 <= "0000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "00000000";
    v_v_vS_3 <= "0000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "00000";
    v_v_vS_4 <= "00000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "0000";
    v_v_vS_5 <= "000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "";
    v_v_vS_6 <= "000000000000000000" & vin(17 downto 3) & "" when vin(17)='0' else "111111111111111111" & vin(17 downto 3) & "";
    v_v_vS_7 <= v_v_vS_0 + v_v_vS_1 + v_v_vS_2 + v_v_vS_3 + v_v_vS_4 + v_v_vS_5 + v_v_vS_6;
    v_v_vS <= v_v_vS_7(32 downto 15);

    -- vin * 0.1627035140991211 : 00000000.00101001101001101111    37bit
    v_v_vL_0 <= "000" & vin(17 downto 0) & "0000000000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "0000000000000000";
    v_v_vL_1 <= "00000" & vin(17 downto 0) & "00000000000000" when vin(17)='0' else "11111" & vin(17 downto 0) & "00000000000000";
    v_v_vL_2 <= "00000000" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "00000000000";
    v_v_vL_3 <= "000000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "0000000000";
    v_v_vL_4 <= "00000000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "00000000";
    v_v_vL_5 <= "00000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "00000";
    v_v_vL_6 <= "000000000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "0000";
    v_v_vL_7 <= "00000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "00";
    v_v_vL_8 <= "000000000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "111111111111111111" & vin(17 downto 0) & "0";
    v_v_vL_9 <= "0000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 0) & "";
    v_v_vL_10 <= "00000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111111111" & vin(17 downto 1) & "";
    v_v_vL_11 <= v_v_vL_0 + v_v_vL_1 + v_v_vL_2 + v_v_vL_3 + v_v_vL_4 + v_v_vL_5 + v_v_vL_6 + v_v_vL_7 + v_v_vL_8 + v_v_vL_9 + v_v_vL_10;
    v_v_vL <= v_v_vL_11(36 downto 19);

    -- nin * -0.05419921875 : 00000000.00001101111000000000    38bit
    v_n_0 <= "00000" & nin(17 downto 0) & "000000000000000" when nin(17)='0' else "11111" & nin(17 downto 0) & "000000000000000";
    v_n_1 <= "000000" & nin(17 downto 0) & "00000000000000" when nin(17)='0' else "111111" & nin(17 downto 0) & "00000000000000";
    v_n_2 <= "00000000" & nin(17 downto 0) & "000000000000" when nin(17)='0' else "11111111" & nin(17 downto 0) & "000000000000";
    v_n_3 <= "000000000" & nin(17 downto 0) & "00000000000" when nin(17)='0' else "111111111" & nin(17 downto 0) & "00000000000";
    v_n_4 <= "0000000000" & nin(17 downto 0) & "0000000000" when nin(17)='0' else "1111111111" & nin(17 downto 0) & "0000000000";
    v_n_5 <= "00000000000" & nin(17 downto 0) & "000000000" when nin(17)='0' else "11111111111" & nin(17 downto 0) & "000000000";
    v_n_6 <= not (v_n_0 + v_n_1 + v_n_2 + v_n_3 + v_n_4 + v_n_5) + 1;
    v_n <= v_n_6(37 downto 20);

    -- qin * -0.05419921875 : 00000000.00001101111000000000    38bit
    v_q_0 <= "00000" & qin(17 downto 0) & "000000000000000" when qin(17)='0' else "11111" & qin(17 downto 0) & "000000000000000";
    v_q_1 <= "000000" & qin(17 downto 0) & "00000000000000" when qin(17)='0' else "111111" & qin(17 downto 0) & "00000000000000";
    v_q_2 <= "00000000" & qin(17 downto 0) & "000000000000" when qin(17)='0' else "11111111" & qin(17 downto 0) & "000000000000";
    v_q_3 <= "000000000" & qin(17 downto 0) & "00000000000" when qin(17)='0' else "111111111" & qin(17 downto 0) & "00000000000";
    v_q_4 <= "0000000000" & qin(17 downto 0) & "0000000000" when qin(17)='0' else "1111111111" & qin(17 downto 0) & "0000000000";
    v_q_5 <= "00000000000" & qin(17 downto 0) & "000000000" when qin(17)='0' else "11111111111" & qin(17 downto 0) & "000000000";
    v_q_6 <= not (v_q_0 + v_q_1 + v_q_2 + v_q_3 + v_q_4 + v_q_5) + 1;
    v_q <= v_q_6(37 downto 20);

    -- Iin * 5.077789306640625 : 00000101.00010011111010100000    31bit
    v_Iin_0 <= Iin( 15 downto 0) & "000000000000000";
    v_Iin_1 <= Iin & "0000000000000";
    v_Iin_2 <= "0000" & Iin(17 downto 0) & "000000000" when Iin(17)='0' else "1111" & Iin(17 downto 0) & "000000000";
    v_Iin_3 <= "0000000" & Iin(17 downto 0) & "000000" when Iin(17)='0' else "1111111" & Iin(17 downto 0) & "000000";
    v_Iin_4 <= "00000000" & Iin(17 downto 0) & "00000" when Iin(17)='0' else "11111111" & Iin(17 downto 0) & "00000";
    v_Iin_5 <= "000000000" & Iin(17 downto 0) & "0000" when Iin(17)='0' else "111111111" & Iin(17 downto 0) & "0000";
    v_Iin_6 <= "0000000000" & Iin(17 downto 0) & "000" when Iin(17)='0' else "1111111111" & Iin(17 downto 0) & "000";
    v_Iin_7 <= "00000000000" & Iin(17 downto 0) & "00" when Iin(17)='0' else "11111111111" & Iin(17 downto 0) & "00";
    v_Iin_8 <= "0000000000000" & Iin(17 downto 0) & "" when Iin(17)='0' else "1111111111111" & Iin(17 downto 0) & "";
    v_Iin_9 <= "000000000000000" & Iin(17 downto 2) & "" when Iin(17)='0' else "111111111111111" & Iin(17 downto 2) & "";
    v_Iin_10 <= v_Iin_0 + v_Iin_1 + v_Iin_2 + v_Iin_3 + v_Iin_4 + v_Iin_5 + v_Iin_6 + v_Iin_7 + v_Iin_8 + v_Iin_9;
    v_Iin <= v_Iin_10(30 downto 13);

    -- vv * 0.01171875 : 00000000.00000011000000000000    25bit
    n_vv_vS_0 <= "0000000" & vv(17 downto 0) & "" when vv(17)='0' else "1111111" & vv(17 downto 0) & "";
    n_vv_vS_1 <= "00000000" & vv(17 downto 1) & "" when vv(17)='0' else "11111111" & vv(17 downto 1) & "";
    n_vv_vS_2 <= n_vv_vS_0 + n_vv_vS_1;
    n_vv_vS <= n_vv_vS_2(24 downto 7);

    -- vv * 0.2216796875 : 00000000.00111000110000000000    27bit
    n_vv_vL_0 <= "000" & vv(17 downto 0) & "000000" when vv(17)='0' else "111" & vv(17 downto 0) & "000000";
    n_vv_vL_1 <= "0000" & vv(17 downto 0) & "00000" when vv(17)='0' else "1111" & vv(17 downto 0) & "00000";
    n_vv_vL_2 <= "00000" & vv(17 downto 0) & "0000" when vv(17)='0' else "11111" & vv(17 downto 0) & "0000";
    n_vv_vL_3 <= "000000000" & vv(17 downto 0) & "" when vv(17)='0' else "111111111" & vv(17 downto 0) & "";
    n_vv_vL_4 <= "0000000000" & vv(17 downto 1) & "" when vv(17)='0' else "1111111111" & vv(17 downto 1) & "";
    n_vv_vL_5 <= n_vv_vL_0 + n_vv_vL_1 + n_vv_vL_2 + n_vv_vL_3 + n_vv_vL_4;
    n_vv_vL <= n_vv_vL_5(26 downto 9);

    -- vin * -0.0146484375 : 00000000.00000011110000000000    38bit
    n_v_vS_0 <= "0000000" & vin(17 downto 0) & "0000000000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "0000000000000";
    n_v_vS_1 <= "00000000" & vin(17 downto 0) & "000000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "000000000000";
    n_v_vS_2 <= "000000000" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "00000000000";
    n_v_vS_3 <= "0000000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "0000000000";
    n_v_vS_4 <= not (n_v_vS_0 + n_v_vS_1 + n_v_vS_2 + n_v_vS_3) + 1;
    n_v_vS <= n_v_vS_4(37 downto 20);

    -- vin * -0.45721435546875 : 00000000.01110101000011000000    38bit
    n_v_vL_0 <= "00" & vin(17 downto 0) & "000000000000000000" when vin(17)='0' else "11" & vin(17 downto 0) & "000000000000000000";
    n_v_vL_1 <= "000" & vin(17 downto 0) & "00000000000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "00000000000000000";
    n_v_vL_2 <= "0000" & vin(17 downto 0) & "0000000000000000" when vin(17)='0' else "1111" & vin(17 downto 0) & "0000000000000000";
    n_v_vL_3 <= "000000" & vin(17 downto 0) & "00000000000000" when vin(17)='0' else "111111" & vin(17 downto 0) & "00000000000000";
    n_v_vL_4 <= "00000000" & vin(17 downto 0) & "000000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "000000000000";
    n_v_vL_5 <= "0000000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "0000000";
    n_v_vL_6 <= "00000000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "000000";
    n_v_vL_7 <= not (n_v_vL_0 + n_v_vL_1 + n_v_vL_2 + n_v_vL_3 + n_v_vL_4 + n_v_vL_5 + n_v_vL_6) + 1;
    n_v_vL <= n_v_vL_7(37 downto 20);

    -- nin * -0.015625 : 00000000.00000100000000000000    38bit
    n_n_0 <= "000000" & nin(17 downto 0) & "00000000000000" when nin(17)='0' else "111111" & nin(17 downto 0) & "00000000000000";
    n_n_1 <= not (n_n_0) + 1;
    n_n <= n_n_1(37 downto 20);

    -- vv * 3.4332275390625e-05 : 00000000.00000000000000100100    33bit
    q_vv_vS_0 <= "000000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "";
    q_vv_vS_1 <= "000000000000000000" & vv(17 downto 3) & "" when vv(17)='0' else "111111111111111111" & vv(17 downto 3) & "";
    q_vv_vS_2 <= q_vv_vS_0 + q_vv_vS_1;
    q_vv_vS <= q_vv_vS_2(32 downto 15);

    -- vv * 0.007175445556640625 : 00000000.00000001110101100100    33bit
    q_vv_vL_0 <= "00000000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "11111111" & vv(17 downto 0) & "0000000";
    q_vv_vL_1 <= "000000000" & vv(17 downto 0) & "000000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "000000";
    q_vv_vL_2 <= "0000000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "00000";
    q_vv_vL_3 <= "000000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "111111111111" & vv(17 downto 0) & "000";
    q_vv_vL_4 <= "00000000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "11111111111111" & vv(17 downto 0) & "0";
    q_vv_vL_5 <= "000000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "";
    q_vv_vL_6 <= "000000000000000000" & vv(17 downto 3) & "" when vv(17)='0' else "111111111111111111" & vv(17 downto 3) & "";
    q_vv_vL_7 <= q_vv_vL_0 + q_vv_vL_1 + q_vv_vL_2 + q_vv_vL_3 + q_vv_vL_4 + q_vv_vL_5 + q_vv_vL_6;
    q_vv_vL <= q_vv_vL_7(32 downto 15);

    -- vin * 0.0007610321044921875 : 00000000.00000000001100011110    36bit
    q_v_vS_0 <= "00000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "0000000";
    q_v_vS_1 <= "000000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "000000";
    q_v_vS_2 <= "0000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "00";
    q_v_vS_3 <= "00000000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "0";
    q_v_vS_4 <= "000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "111111111111111111" & vin(17 downto 0) & "";
    q_v_vS_5 <= "0000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 1) & "";
    q_v_vS_6 <= q_v_vS_0 + q_v_vS_1 + q_v_vS_2 + q_v_vS_3 + q_v_vS_4 + q_v_vS_5;
    q_v_vS <= q_v_vS_6(35 downto 18);

    -- vin * -0.004932403564453125 : 00000000.00000001010000110100    38bit
    q_v_vL_0 <= "00000000" & vin(17 downto 0) & "000000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "000000000000";
    q_v_vL_1 <= "0000000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "0000000000";
    q_v_vL_2 <= "000000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "00000";
    q_v_vL_3 <= "0000000000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "0000";
    q_v_vL_4 <= "000000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "111111111111111111" & vin(17 downto 0) & "00";
    q_v_vL_5 <= not (q_v_vL_0 + q_v_vL_1 + q_v_vL_2 + q_v_vL_3 + q_v_vL_4) + 1;
    q_v_vL <= q_v_vL_5(37 downto 20);

    -- qin * -0.00054931640625 : 00000000.00000000001001000000    38bit
    q_q_0 <= "00000000000" & qin(17 downto 0) & "000000000" when qin(17)='0' else "11111111111" & qin(17 downto 0) & "000000000";
    q_q_1 <= "00000000000000" & qin(17 downto 0) & "000000" when qin(17)='0' else "11111111111111" & qin(17 downto 0) & "000000";
    q_q_2 <= not (q_q_0 + q_q_1) + 1;
    q_q <= q_q_2(37 downto 20);

    -- sin * -0.00390625 : 00000000.00000001000000000000    38bit
    s_S_0 <= "00000000" & sin(17 downto 0) & "000000000000" when sin(17)='0' else "11111111" & sin(17 downto 0) & "000000000000";
    s_S_1 <= not (s_S_0) + 1;
    s_S <= s_S_1(37 downto 20);

    -- sin * -0.015625 : 00000000.00000100000000000000    38bit
    s_L_0 <= "000000" & sin(17 downto 0) & "00000000000000" when sin(17)='0' else "111111" & sin(17 downto 0) & "00000000000000";
    s_L_1 <= not (s_L_0) + 1;
    s_L <= s_L_1(37 downto 20);

    v_vv_x_2nd <= v_vv_vL_2nd when vin_2nd>=crf else v_vv_vS_2nd;
    v_v_x_2nd <= v_v_vL_2nd when vin_2nd>=crf else v_v_vS_2nd;
    v_x_2nd <= v_c_vL when vin_2nd>=crf else v_c_vS;
    n_vv_x_2nd <= n_vv_vL_2nd when vin_2nd>=crg else n_vv_vS_2nd;
    n_v_x_2nd <= n_v_vL_2nd when vin_2nd>=crg else n_v_vS_2nd;
    n_x_2nd <= n_c_vL when vin_2nd>=crg else n_c_vS;
    q_vv_x_2nd <= q_vv_vL_2nd when vin_2nd>=crh else q_vv_vS_2nd;
    q_v_x_2nd <= q_v_vL_2nd when vin_2nd>=crh else q_v_vS_2nd;
    q_x_2nd <= q_c_vL when vin_2nd>=crh else q_c_vS;

END Behavioral;
--dt= 0.0001
--tau= 0.0064
--afn= 1.4375
--afp= -0.90625
--bfn= -1.0625
--bfp= 1.65625
--cfn= 0.0
--cfp= 4.1875
--agn= 0.75
--agp= 14.1875
--bgn= 0.625
--bgp= 1.03125
--cgn= 0.0
--cgp= 0.125
--ahn= 0.0625
--ahp= 13.0625
--bhn= -11.09375
--bhp= 0.34375
--chn= -1.65625
--chp= 6.5625
--rg= 1.0625
--rh= 0.40625
--phi= 3.46875
--epsq= 0.03515625
--epsu= 0.0
--I0= 1.125
--Ix= 93.6875
--nx= 1.0
--uth= 3.5625
--alpu= 0.0
--v_vv_vS=0.077911376953125
--v_vv_vL=-0.0491180419921875
--v_v_vS=0.16556167602539062
--v_v_vL=0.1627035140991211
--v_n=-0.05419921875
--v_q=-0.05419921875
--v_Iin=5.077789306640625
--n_vv_vS=0.01171875
--n_vv_vL=0.2216796875
--n_v_vS=-0.0146484375
--n_v_vL=-0.45721435546875
--n_n=-0.015625
--q_vv_vS=3.4332275390625e-05
--q_vv_vL=0.007175445556640625
--q_v_vS=0.0007610321044921875
--q_v_vL=-0.004932403564453125
--q_q=-0.00054931640625
--s_S=-0.00390625
--s_L=-0.015625
--v_c_vS=0.1484375
--v_c_vL=0.15234375
--n_c_vS=0.00390625
--n_c_vL=0.2373046875
--q_c_vS=0.0029296875
--q_c_vL=0.00390625
--s_c_L=0.015625
--crf=0
--crg=1.0625
--crh=0.40625
--vini=-4.4091796875
--nini=18.9375
--qini=-1.7783203125
--vth=0