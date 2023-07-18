------------------------------------------------------
-- Author: Takuya Nanami
-- Model: PQN model
-- Mode: RSexci
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
entity RSexci is
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
end RSexci;
architecture Behavioral of RSexci is
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
    SIGNAL v_vv_vS_0 : std_logic_vector(28 downto 0);
    SIGNAL v_vv_vS_1 : std_logic_vector(28 downto 0);
    SIGNAL v_vv_vS_2 : std_logic_vector(28 downto 0);
    SIGNAL v_vv_vS_3 : std_logic_vector(28 downto 0);
    SIGNAL v_vv_vS_4 : std_logic_vector(28 downto 0);
    SIGNAL v_vv_vS_5 : std_logic_vector(28 downto 0);
    SIGNAL v_vv_vS_6 : std_logic_vector(28 downto 0);
    SIGNAL v_vv_vS_7 : std_logic_vector(28 downto 0);
    SIGNAL v_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL v_vv_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_4 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_5 : std_logic_vector(37 downto 0);
    SIGNAL v_v_vS : std_logic_vector(17 downto 0);
    SIGNAL v_v_vS_0 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_1 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_2 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_3 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_4 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_5 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_6 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vL : std_logic_vector(17 downto 0);
    SIGNAL v_v_vL_0 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vL_1 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vL_2 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vL_3 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vL_4 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vL_5 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vL_6 : std_logic_vector(30 downto 0);
    SIGNAL v_n : std_logic_vector(17 downto 0);
    SIGNAL v_n_0 : std_logic_vector(37 downto 0);
    SIGNAL v_n_1 : std_logic_vector(37 downto 0);
    SIGNAL v_n_2 : std_logic_vector(37 downto 0);
    SIGNAL v_n_3 : std_logic_vector(37 downto 0);
    SIGNAL v_q : std_logic_vector(17 downto 0);
    SIGNAL v_q_0 : std_logic_vector(37 downto 0);
    SIGNAL v_q_1 : std_logic_vector(37 downto 0);
    SIGNAL v_q_2 : std_logic_vector(37 downto 0);
    SIGNAL v_q_3 : std_logic_vector(37 downto 0);
    SIGNAL v_Iin : std_logic_vector(17 downto 0);
    SIGNAL v_Iin_0 : std_logic_vector(27 downto 0);
    SIGNAL v_Iin_1 : std_logic_vector(27 downto 0);
    SIGNAL v_Iin_2 : std_logic_vector(27 downto 0);
    SIGNAL v_Iin_3 : std_logic_vector(27 downto 0);
    SIGNAL v_Iin_4 : std_logic_vector(27 downto 0);
    SIGNAL v_Iin_5 : std_logic_vector(27 downto 0);
    SIGNAL v_Iin_6 : std_logic_vector(27 downto 0);
    SIGNAL v_Iin_7 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vL_0 : std_logic_vector(25 downto 0);
    SIGNAL n_vv_vL_1 : std_logic_vector(25 downto 0);
    SIGNAL n_vv_vL_2 : std_logic_vector(25 downto 0);
    SIGNAL n_vv_vL_3 : std_logic_vector(25 downto 0);
    SIGNAL n_vv_vL_4 : std_logic_vector(25 downto 0);
    SIGNAL n_v_vS : std_logic_vector(17 downto 0);
    SIGNAL n_v_vS_0 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vS_1 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vS_2 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vS_3 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL : std_logic_vector(17 downto 0);
    SIGNAL n_v_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_4 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_5 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_6 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_7 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_8 : std_logic_vector(37 downto 0);
    SIGNAL n_n : std_logic_vector(17 downto 0);
    SIGNAL n_n_0 : std_logic_vector(37 downto 0);
    SIGNAL n_n_1 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vS_0 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vS_1 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vS_2 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vS_3 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vS_4 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vS_5 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vS_6 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vS_7 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vL_0 : std_logic_vector(35 downto 0);
    SIGNAL q_vv_vL_1 : std_logic_vector(35 downto 0);
    SIGNAL q_vv_vL_2 : std_logic_vector(35 downto 0);
    SIGNAL q_vv_vL_3 : std_logic_vector(35 downto 0);
    SIGNAL q_vv_vL_4 : std_logic_vector(35 downto 0);
    SIGNAL q_vv_vL_5 : std_logic_vector(35 downto 0);
    SIGNAL q_vv_vL_6 : std_logic_vector(35 downto 0);
    SIGNAL q_vv_vL_7 : std_logic_vector(35 downto 0);
    SIGNAL q_vv_vL_8 : std_logic_vector(35 downto 0);
    SIGNAL q_v_vS : std_logic_vector(17 downto 0);
    SIGNAL q_v_vS_0 : std_logic_vector(32 downto 0);
    SIGNAL q_v_vS_1 : std_logic_vector(32 downto 0);
    SIGNAL q_v_vS_2 : std_logic_vector(32 downto 0);
    SIGNAL q_v_vS_3 : std_logic_vector(32 downto 0);
    SIGNAL q_v_vS_4 : std_logic_vector(32 downto 0);
    SIGNAL q_v_vS_5 : std_logic_vector(32 downto 0);
    SIGNAL q_v_vS_6 : std_logic_vector(32 downto 0);
    SIGNAL q_v_vL : std_logic_vector(17 downto 0);
    SIGNAL q_v_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_4 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_5 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_6 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_7 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_8 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_9 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL_10 : std_logic_vector(37 downto 0);
    SIGNAL q_q : std_logic_vector(17 downto 0);
    SIGNAL q_q_0 : std_logic_vector(37 downto 0);
    SIGNAL q_q_1 : std_logic_vector(37 downto 0);
    SIGNAL q_q_2 : std_logic_vector(37 downto 0);
    SIGNAL q_q_3 : std_logic_vector(37 downto 0);
    SIGNAL q_q_4 : std_logic_vector(37 downto 0);
    SIGNAL s_S : std_logic_vector(17 downto 0);
    SIGNAL s_S_0 : std_logic_vector(37 downto 0);
    SIGNAL s_S_1 : std_logic_vector(37 downto 0);
    SIGNAL s_L : std_logic_vector(17 downto 0);
    SIGNAL s_L_0 : std_logic_vector(37 downto 0);
    SIGNAL s_L_1 : std_logic_vector(37 downto 0);
    SIGNAL v_c_vS : std_logic_vector(17 downto 0):="000000000101001010";-- 0.322265625
    SIGNAL v_c_vL : std_logic_vector(17 downto 0):="000000000101001010";-- 0.322265625
    SIGNAL n_c_vS : std_logic_vector(17 downto 0):="000000000000000010";-- 0.001953125
    SIGNAL n_c_vL : std_logic_vector(17 downto 0):="000000000000000010";-- 0.001953125
    SIGNAL q_c_vS : std_logic_vector(17 downto 0):="000000000000001100";-- 0.01171875
    SIGNAL q_c_vL : std_logic_vector(17 downto 0):="000000100110000001";-- 2.3759765625
    SIGNAL s_c_L : std_logic_vector(17 downto 0):="000000000000010000";-- 0.015625
    SIGNAL crf : std_logic_vector(17 downto 0):="000000000000000000";-- 0
    SIGNAL crg : std_logic_vector(17 downto 0):="000000000001000000";-- 0.0625
    SIGNAL crh : std_logic_vector(17 downto 0):="000011111011100000";-- 15.71875
    SIGNAL vini : std_logic_vector(17 downto 0):="111110110011010110";-- -4.791015625
    SIGNAL nini : std_logic_vector(17 downto 0):="000110101111000000";-- 26.9375
    SIGNAL qini : std_logic_vector(17 downto 0):="111111000110010100";-- -3.60546875
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
    -- vv * 0.115966796875 : 00000000.00011101101100000000    29bit
    v_vv_vS_0 <= "0000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "1111" & vv(17 downto 0) & "0000000";
    v_vv_vS_1 <= "00000" & vv(17 downto 0) & "000000" when vv(17)='0' else "11111" & vv(17 downto 0) & "000000";
    v_vv_vS_2 <= "000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111111" & vv(17 downto 0) & "00000";
    v_vv_vS_3 <= "00000000" & vv(17 downto 0) & "000" when vv(17)='0' else "11111111" & vv(17 downto 0) & "000";
    v_vv_vS_4 <= "000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "111111111" & vv(17 downto 0) & "00";
    v_vv_vS_5 <= "00000000000" & vv(17 downto 0) & "" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "";
    v_vv_vS_6 <= "000000000000" & vv(17 downto 1) & "" when vv(17)='0' else "111111111111" & vv(17 downto 1) & "";
    v_vv_vS_7 <= v_vv_vS_0 + v_vv_vS_1 + v_vv_vS_2 + v_vv_vS_3 + v_vv_vS_4 + v_vv_vS_5 + v_vv_vS_6;
    v_vv_vS <= v_vv_vS_7(28 downto 11);

    -- vv * -0.041748046875 : 00000000.00001010101100000000    38bit
    v_vv_vL_0 <= "00000" & vv(17 downto 0) & "000000000000000" when vv(17)='0' else "11111" & vv(17 downto 0) & "000000000000000";
    v_vv_vL_1 <= "0000000" & vv(17 downto 0) & "0000000000000" when vv(17)='0' else "1111111" & vv(17 downto 0) & "0000000000000";
    v_vv_vL_2 <= "000000000" & vv(17 downto 0) & "00000000000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "00000000000";
    v_vv_vL_3 <= "00000000000" & vv(17 downto 0) & "000000000" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "000000000";
    v_vv_vL_4 <= "000000000000" & vv(17 downto 0) & "00000000" when vv(17)='0' else "111111111111" & vv(17 downto 0) & "00000000";
    v_vv_vL_5 <= not (v_vv_vL_0 + v_vv_vL_1 + v_vv_vL_2 + v_vv_vL_3 + v_vv_vL_4) + 1;
    v_vv_vL <= v_vv_vL_5(37 downto 20);

    -- vin * 0.26092529296875 : 00000000.01000010110011000000    31bit
    v_v_vS_0 <= "00" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "11" & vin(17 downto 0) & "00000000000";
    v_v_vS_1 <= "0000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "000000";
    v_v_vS_2 <= "000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "0000";
    v_v_vS_3 <= "0000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "000";
    v_v_vS_4 <= "0000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "";
    v_v_vS_5 <= "00000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111" & vin(17 downto 1) & "";
    v_v_vS_6 <= v_v_vS_0 + v_v_vS_1 + v_v_vS_2 + v_v_vS_3 + v_v_vS_4 + v_v_vS_5;
    v_v_vS <= v_v_vS_6(30 downto 13);

    -- vin * 0.26092529296875 : 00000000.01000010110011000000    31bit
    v_v_vL_0 <= "00" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "11" & vin(17 downto 0) & "00000000000";
    v_v_vL_1 <= "0000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "000000";
    v_v_vL_2 <= "000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "0000";
    v_v_vL_3 <= "0000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "000";
    v_v_vL_4 <= "0000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "";
    v_v_vL_5 <= "00000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111" & vin(17 downto 1) & "";
    v_v_vL_6 <= v_v_vL_0 + v_v_vL_1 + v_v_vL_2 + v_v_vL_3 + v_v_vL_4 + v_v_vL_5;
    v_v_vL <= v_v_vL_6(30 downto 13);

    -- nin * -0.07421875 : 00000000.00010011000000000000    38bit
    v_n_0 <= "0000" & nin(17 downto 0) & "0000000000000000" when nin(17)='0' else "1111" & nin(17 downto 0) & "0000000000000000";
    v_n_1 <= "0000000" & nin(17 downto 0) & "0000000000000" when nin(17)='0' else "1111111" & nin(17 downto 0) & "0000000000000";
    v_n_2 <= "00000000" & nin(17 downto 0) & "000000000000" when nin(17)='0' else "11111111" & nin(17 downto 0) & "000000000000";
    v_n_3 <= not (v_n_0 + v_n_1 + v_n_2) + 1;
    v_n <= v_n_3(37 downto 20);

    -- qin * -0.07421875 : 00000000.00010011000000000000    38bit
    v_q_0 <= "0000" & qin(17 downto 0) & "0000000000000000" when qin(17)='0' else "1111" & qin(17 downto 0) & "0000000000000000";
    v_q_1 <= "0000000" & qin(17 downto 0) & "0000000000000" when qin(17)='0' else "1111111" & qin(17 downto 0) & "0000000000000";
    v_q_2 <= "00000000" & qin(17 downto 0) & "000000000000" when qin(17)='0' else "11111111" & qin(17 downto 0) & "000000000000";
    v_q_3 <= not (v_q_0 + v_q_1 + v_q_2) + 1;
    v_q <= v_q_3(37 downto 20);

    -- Iin * 2.704345703125 : 00000010.10110100010100000000    28bit
    v_Iin_0 <= Iin( 16 downto 0) & "00000000000";
    v_Iin_1 <= "0" & Iin(17 downto 0) & "000000000" when Iin(17)='0' else "1" & Iin(17 downto 0) & "000000000";
    v_Iin_2 <= "000" & Iin(17 downto 0) & "0000000" when Iin(17)='0' else "111" & Iin(17 downto 0) & "0000000";
    v_Iin_3 <= "0000" & Iin(17 downto 0) & "000000" when Iin(17)='0' else "1111" & Iin(17 downto 0) & "000000";
    v_Iin_4 <= "000000" & Iin(17 downto 0) & "0000" when Iin(17)='0' else "111111" & Iin(17 downto 0) & "0000";
    v_Iin_5 <= "0000000000" & Iin(17 downto 0) & "" when Iin(17)='0' else "1111111111" & Iin(17 downto 0) & "";
    v_Iin_6 <= "000000000000" & Iin(17 downto 2) & "" when Iin(17)='0' else "111111111111" & Iin(17 downto 2) & "";
    v_Iin_7 <= v_Iin_0 + v_Iin_1 + v_Iin_2 + v_Iin_3 + v_Iin_4 + v_Iin_5 + v_Iin_6;
    v_Iin <= v_Iin_7(27 downto 10);

    -- vv * 0.015625 : 00000000.00000100000000000000    18bit
    n_vv_vS <= "000000" & vv(17 downto 6) when vv(17)='0' else "111111" & vv(17 downto 6);

    -- vv * 0.16064453125 : 00000000.00101001001000000000    26bit
    n_vv_vL_0 <= "000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111" & vv(17 downto 0) & "00000";
    n_vv_vL_1 <= "00000" & vv(17 downto 0) & "000" when vv(17)='0' else "11111" & vv(17 downto 0) & "000";
    n_vv_vL_2 <= "00000000" & vv(17 downto 0) & "" when vv(17)='0' else "11111111" & vv(17 downto 0) & "";
    n_vv_vL_3 <= "00000000000" & vv(17 downto 3) & "" when vv(17)='0' else "11111111111" & vv(17 downto 3) & "";
    n_vv_vL_4 <= n_vv_vL_0 + n_vv_vL_1 + n_vv_vL_2 + n_vv_vL_3;
    n_vv_vL <= n_vv_vL_4(25 downto 8);

    -- vin * -0.0126953125 : 00000000.00000011010000000000    38bit
    n_v_vS_0 <= "0000000" & vin(17 downto 0) & "0000000000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "0000000000000";
    n_v_vS_1 <= "00000000" & vin(17 downto 0) & "000000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "000000000000";
    n_v_vS_2 <= "0000000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "0000000000";
    n_v_vS_3 <= not (n_v_vS_0 + n_v_vS_1 + n_v_vS_2) + 1;
    n_v_vS <= n_v_vS_3(37 downto 20);

    -- vin * -0.030120849609375 : 00000000.00000111101101100000    38bit
    n_v_vL_0 <= "000000" & vin(17 downto 0) & "00000000000000" when vin(17)='0' else "111111" & vin(17 downto 0) & "00000000000000";
    n_v_vL_1 <= "0000000" & vin(17 downto 0) & "0000000000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "0000000000000";
    n_v_vL_2 <= "00000000" & vin(17 downto 0) & "000000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "000000000000";
    n_v_vL_3 <= "000000000" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "00000000000";
    n_v_vL_4 <= "00000000000" & vin(17 downto 0) & "000000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "000000000";
    n_v_vL_5 <= "000000000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "00000000";
    n_v_vL_6 <= "00000000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "000000";
    n_v_vL_7 <= "000000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "00000";
    n_v_vL_8 <= not (n_v_vL_0 + n_v_vL_1 + n_v_vL_2 + n_v_vL_3 + n_v_vL_4 + n_v_vL_5 + n_v_vL_6 + n_v_vL_7) + 1;
    n_v_vL <= n_v_vL_8(37 downto 20);

    -- nin * -0.015625 : 00000000.00000100000000000000    38bit
    n_n_0 <= "000000" & nin(17 downto 0) & "00000000000000" when nin(17)='0' else "111111" & nin(17 downto 0) & "00000000000000";
    n_n_1 <= not (n_n_0) + 1;
    n_n <= n_n_1(37 downto 20);

    -- vv * 0.00030422210693359375 : 00000000.00000000000100111111    37bit
    q_vv_vS_0 <= "000000000000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "111111111111" & vv(17 downto 0) & "0000000";
    q_vv_vS_1 <= "000000000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "0000";
    q_vv_vS_2 <= "0000000000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "1111111111111111" & vv(17 downto 0) & "000";
    q_vv_vS_3 <= "00000000000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "11111111111111111" & vv(17 downto 0) & "00";
    q_vv_vS_4 <= "000000000000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "111111111111111111" & vv(17 downto 0) & "0";
    q_vv_vS_5 <= "0000000000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "1111111111111111111" & vv(17 downto 0) & "";
    q_vv_vS_6 <= "00000000000000000000" & vv(17 downto 1) & "" when vv(17)='0' else "11111111111111111111" & vv(17 downto 1) & "";
    q_vv_vS_7 <= q_vv_vS_0 + q_vv_vS_1 + q_vv_vS_2 + q_vv_vS_3 + q_vv_vS_4 + q_vv_vS_5 + q_vv_vS_6;
    q_vv_vS <= q_vv_vS_7(36 downto 19);

    -- vv * 0.009885787963867188 : 00000000.00000010100001111110    36bit
    q_vv_vL_0 <= "0000000" & vv(17 downto 0) & "00000000000" when vv(17)='0' else "1111111" & vv(17 downto 0) & "00000000000";
    q_vv_vL_1 <= "000000000" & vv(17 downto 0) & "000000000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "000000000";
    q_vv_vL_2 <= "00000000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "11111111111111" & vv(17 downto 0) & "0000";
    q_vv_vL_3 <= "000000000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "000";
    q_vv_vL_4 <= "0000000000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "1111111111111111" & vv(17 downto 0) & "00";
    q_vv_vL_5 <= "00000000000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "11111111111111111" & vv(17 downto 0) & "0";
    q_vv_vL_6 <= "000000000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "111111111111111111" & vv(17 downto 0) & "";
    q_vv_vL_7 <= "0000000000000000000" & vv(17 downto 1) & "" when vv(17)='0' else "1111111111111111111" & vv(17 downto 1) & "";
    q_vv_vL_8 <= q_vv_vL_0 + q_vv_vL_1 + q_vv_vL_2 + q_vv_vL_3 + q_vv_vL_4 + q_vv_vL_5 + q_vv_vL_6 + q_vv_vL_7;
    q_vv_vL <= q_vv_vL_8(35 downto 18);

    -- vin * 0.0043792724609375 : 00000000.00000001000111110000    33bit
    q_v_vS_0 <= "00000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "0000000";
    q_v_vS_1 <= "000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "000";
    q_v_vS_2 <= "0000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "00";
    q_v_vS_3 <= "00000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "0";
    q_v_vS_4 <= "000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "";
    q_v_vS_5 <= "0000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "1111111111111111" & vin(17 downto 1) & "";
    q_v_vS_6 <= q_v_vS_0 + q_v_vS_1 + q_v_vS_2 + q_v_vS_3 + q_v_vS_4 + q_v_vS_5;
    q_v_vS <= q_v_vS_6(32 downto 15);

    -- vin * -0.2965736389160156 : 00000000.01001011111011000100    38bit
    q_v_vL_0 <= "00" & vin(17 downto 0) & "000000000000000000" when vin(17)='0' else "11" & vin(17 downto 0) & "000000000000000000";
    q_v_vL_1 <= "00000" & vin(17 downto 0) & "000000000000000" when vin(17)='0' else "11111" & vin(17 downto 0) & "000000000000000";
    q_v_vL_2 <= "0000000" & vin(17 downto 0) & "0000000000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "0000000000000";
    q_v_vL_3 <= "00000000" & vin(17 downto 0) & "000000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "000000000000";
    q_v_vL_4 <= "000000000" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "00000000000";
    q_v_vL_5 <= "0000000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "0000000000";
    q_v_vL_6 <= "00000000000" & vin(17 downto 0) & "000000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "000000000";
    q_v_vL_7 <= "0000000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "0000000";
    q_v_vL_8 <= "00000000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "000000";
    q_v_vL_9 <= "000000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "111111111111111111" & vin(17 downto 0) & "00";
    q_v_vL_10 <= not (q_v_vL_0 + q_v_vL_1 + q_v_vL_2 + q_v_vL_3 + q_v_vL_4 + q_v_vL_5 + q_v_vL_6 + q_v_vL_7 + q_v_vL_8 + q_v_vL_9) + 1;
    q_v_vL <= q_v_vL_10(37 downto 20);

    -- qin * -0.0010833740234375 : 00000000.00000000010001110000    38bit
    q_q_0 <= "0000000000" & qin(17 downto 0) & "0000000000" when qin(17)='0' else "1111111111" & qin(17 downto 0) & "0000000000";
    q_q_1 <= "00000000000000" & qin(17 downto 0) & "000000" when qin(17)='0' else "11111111111111" & qin(17 downto 0) & "000000";
    q_q_2 <= "000000000000000" & qin(17 downto 0) & "00000" when qin(17)='0' else "111111111111111" & qin(17 downto 0) & "00000";
    q_q_3 <= "0000000000000000" & qin(17 downto 0) & "0000" when qin(17)='0' else "1111111111111111" & qin(17 downto 0) & "0000";
    q_q_4 <= not (q_q_0 + q_q_1 + q_q_2 + q_q_3) + 1;
    q_q <= q_q_4(37 downto 20);

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
--afn= 1.5625
--afp= -0.5625
--bfn= -1.125
--bfp= 3.125
--cfn= 0.0
--cfp= 7.46875
--agn= 1.0
--agp= 10.28125
--bgn= 0.40625
--bgp= 0.09375
--cgn= 0.0
--cgp= 0.09375
--ahn= 0.28125
--ahp= 9.125
--bhn= -7.1875
--bhp= 15.0
--chn= -2.8125
--chp= 140.1875
--rg= 0.0625
--rh= 15.71875
--phi= 4.75
--epsq= 0.0693359375
--epsu= 0.0
--I0= 2.375
--Ix= 36.4375
--nx= 1.0
--uth= 5.3125
--alpu= 0.25
--v_vv_vS=0.115966796875
--v_vv_vL=-0.041748046875
--v_v_vS=0.26092529296875
--v_v_vL=0.26092529296875
--v_n=-0.07421875
--v_q=-0.07421875
--v_Iin=2.704345703125
--n_vv_vS=0.015625
--n_vv_vL=0.16064453125
--n_v_vS=-0.0126953125
--n_v_vL=-0.030120849609375
--n_n=-0.015625
--q_vv_vS=0.00030422210693359375
--q_vv_vL=0.009885787963867188
--q_v_vS=0.0043792724609375
--q_v_vL=-0.2965736389160156
--q_q=-0.0010833740234375
--s_S=-0.00390625
--s_L=-0.015625
--v_c_vS=0.322265625
--v_c_vL=0.322265625
--n_c_vS=0.001953125
--n_c_vL=0.001953125
--q_c_vS=0.01171875
--q_c_vL=2.3759765625
--s_c_L=0.015625
--crf=0
--crg=0.0625
--crh=15.71875
--vini=-4.791015625
--nini=26.9375
--qini=-3.60546875
--vth=0