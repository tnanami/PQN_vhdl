------------------------------------------------------
-- Author: Takuya Nanami
-- Model: PQN model
-- Mode: PB
-- Port Descriptions:
--    clk: clock
--    PORT_Iin: Stimulus input
--    PORT_vin/out: Membrane potential
--    PORT_nin/out: Recovery variable
--    PORT_qin/out: Slow variable
--    PORT_uin/out: Slow variable (only used for LTS, IB, and PB classes)
--    PORT_spike_flag: This becomes 1 only when a spike occurs
------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.ALL;
entity PB is
PORT(
    clk : IN STD_LOGIC;
    PORT_Iin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_vin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_nin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_qin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_uin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_sin : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_vout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_nout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_qout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_uout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_sout : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    PORT_spike_flag : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
);
end PB;
architecture Behavioral of PB is
    TYPE STATE_TYPE IS (READY);
    SIGNAL STATE : STATE_TYPE := READY;
    SIGNAL Iin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL qin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL uin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sin : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vv36 : STD_LOGIC_VECTOR(35 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vv : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vin_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nin_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL qin_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL uin_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sin_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vin_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nin_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL qin_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL uin_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sin_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vout_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nout_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL qout_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL uout_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sout_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_vS_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_vL_2nd: STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_v_vS_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_v_vL_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_n_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_q_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_u_2nd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
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
    SIGNAL u_v_2nd: STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL u_u_2nd: STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
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
    SIGNAL n0_3rd : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL v_vv_vS_0 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_1 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_2 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_3 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_4 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_5 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_6 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_7 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL v_vv_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_4 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_5 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_6 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_7 : std_logic_vector(37 downto 0);
    SIGNAL v_v_vS : std_logic_vector(17 downto 0);
    SIGNAL v_v_vS_0 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_1 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_2 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_3 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_4 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_5 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_6 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_7 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_8 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_9 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_10 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_11 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vL : std_logic_vector(17 downto 0);
    SIGNAL v_v_vL_0 : std_logic_vector(35 downto 0);
    SIGNAL v_v_vL_1 : std_logic_vector(35 downto 0);
    SIGNAL v_v_vL_2 : std_logic_vector(35 downto 0);
    SIGNAL v_v_vL_3 : std_logic_vector(35 downto 0);
    SIGNAL v_v_vL_4 : std_logic_vector(35 downto 0);
    SIGNAL v_v_vL_5 : std_logic_vector(35 downto 0);
    SIGNAL v_v_vL_6 : std_logic_vector(35 downto 0);
    SIGNAL v_v_vL_7 : std_logic_vector(35 downto 0);
    SIGNAL v_v_vL_8 : std_logic_vector(35 downto 0);
    SIGNAL v_v_vL_9 : std_logic_vector(35 downto 0);
    SIGNAL v_v_vL_10 : std_logic_vector(35 downto 0);
    SIGNAL v_n : std_logic_vector(17 downto 0);
    SIGNAL v_n_0 : std_logic_vector(37 downto 0);
    SIGNAL v_n_1 : std_logic_vector(37 downto 0);
    SIGNAL v_n_2 : std_logic_vector(37 downto 0);
    SIGNAL v_n_3 : std_logic_vector(37 downto 0);
    SIGNAL v_n_4 : std_logic_vector(37 downto 0);
    SIGNAL v_q : std_logic_vector(17 downto 0);
    SIGNAL v_q_0 : std_logic_vector(37 downto 0);
    SIGNAL v_q_1 : std_logic_vector(37 downto 0);
    SIGNAL v_q_2 : std_logic_vector(37 downto 0);
    SIGNAL v_q_3 : std_logic_vector(37 downto 0);
    SIGNAL v_q_4 : std_logic_vector(37 downto 0);
    SIGNAL v_u : std_logic_vector(17 downto 0);
    SIGNAL v_u_0 : std_logic_vector(37 downto 0);
    SIGNAL v_u_1 : std_logic_vector(37 downto 0);
    SIGNAL v_u_2 : std_logic_vector(37 downto 0);
    SIGNAL v_u_3 : std_logic_vector(37 downto 0);
    SIGNAL v_u_4 : std_logic_vector(37 downto 0);
    SIGNAL v_Iin : std_logic_vector(17 downto 0);
    SIGNAL v_Iin_0 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_1 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_2 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_3 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_4 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_5 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_6 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_7 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_8 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_9 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_10 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_11 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_12 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_13 : std_logic_vector(36 downto 0);
    SIGNAL v_Iin_14 : std_logic_vector(36 downto 0);
    SIGNAL n_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vS_0 : std_logic_vector(23 downto 0);
    SIGNAL n_vv_vS_1 : std_logic_vector(23 downto 0);
    SIGNAL n_vv_vS_2 : std_logic_vector(23 downto 0);
    SIGNAL n_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL n_v_vS : std_logic_vector(17 downto 0);
    SIGNAL n_v_vS_0 : std_logic_vector(27 downto 0);
    SIGNAL n_v_vS_1 : std_logic_vector(27 downto 0);
    SIGNAL n_v_vS_2 : std_logic_vector(27 downto 0);
    SIGNAL n_v_vS_3 : std_logic_vector(27 downto 0);
    SIGNAL n_v_vL : std_logic_vector(17 downto 0);
    SIGNAL n_v_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL n_n : std_logic_vector(17 downto 0);
    SIGNAL n_n_0 : std_logic_vector(37 downto 0);
    SIGNAL n_n_1 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vS_0 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_1 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_2 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_3 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_4 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_5 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vL_0 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vL_1 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vL_2 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vL_3 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vL_4 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vL_5 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS : std_logic_vector(17 downto 0);
    SIGNAL q_v_vS_0 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vS_1 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vS_2 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vS_3 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vS_4 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vS_5 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vS_6 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vS_7 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vS_8 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vL : std_logic_vector(17 downto 0);
    SIGNAL q_v_vL_0 : std_logic_vector(31 downto 0);
    SIGNAL q_v_vL_1 : std_logic_vector(31 downto 0);
    SIGNAL q_v_vL_2 : std_logic_vector(31 downto 0);
    SIGNAL q_v_vL_3 : std_logic_vector(31 downto 0);
    SIGNAL q_v_vL_4 : std_logic_vector(31 downto 0);
    SIGNAL q_q : std_logic_vector(17 downto 0);
    SIGNAL q_q_0 : std_logic_vector(37 downto 0);
    SIGNAL q_q_1 : std_logic_vector(37 downto 0);
    SIGNAL q_q_2 : std_logic_vector(37 downto 0);
    SIGNAL q_q_3 : std_logic_vector(37 downto 0);
    SIGNAL u_v : std_logic_vector(17 downto 0);
    SIGNAL u_v_0 : std_logic_vector(34 downto 0);
    SIGNAL u_v_1 : std_logic_vector(34 downto 0);
    SIGNAL u_v_2 : std_logic_vector(34 downto 0);
    SIGNAL u_v_3 : std_logic_vector(34 downto 0);
    SIGNAL u_v_4 : std_logic_vector(34 downto 0);
    SIGNAL u_v_5 : std_logic_vector(34 downto 0);
    SIGNAL u_v_6 : std_logic_vector(34 downto 0);
    SIGNAL u_v_7 : std_logic_vector(34 downto 0);
    SIGNAL u_v_8 : std_logic_vector(34 downto 0);
    SIGNAL u_u : std_logic_vector(17 downto 0);
    SIGNAL u_u_0 : std_logic_vector(37 downto 0);
    SIGNAL u_u_1 : std_logic_vector(37 downto 0);
    SIGNAL u_u_2 : std_logic_vector(37 downto 0);
    SIGNAL u_u_3 : std_logic_vector(37 downto 0);
    SIGNAL u_u_4 : std_logic_vector(37 downto 0);
    SIGNAL u_u_5 : std_logic_vector(37 downto 0);
    SIGNAL u_u_6 : std_logic_vector(37 downto 0);
    SIGNAL u_u_7 : std_logic_vector(37 downto 0);
    SIGNAL u_u_8 : std_logic_vector(37 downto 0);
    SIGNAL s_S : std_logic_vector(17 downto 0);
    SIGNAL s_S_0 : std_logic_vector(37 downto 0);
    SIGNAL s_S_1 : std_logic_vector(37 downto 0);
    SIGNAL s_S_2 : std_logic_vector(37 downto 0);
    SIGNAL s_L : std_logic_vector(17 downto 0);
    SIGNAL s_L_0 : std_logic_vector(37 downto 0);
    SIGNAL s_L_1 : std_logic_vector(37 downto 0);
    SIGNAL s_L_2 : std_logic_vector(37 downto 0);
    SIGNAL v_c_vS : std_logic_vector(17 downto 0):="000000000000111100";-- 0.05859375
    SIGNAL v_c_vL : std_logic_vector(17 downto 0):="000000000000111100";-- 0.05859375
    SIGNAL n_c_vS : std_logic_vector(17 downto 0):="000000000000000001";-- 0.0009765625
    SIGNAL n_c_vL : std_logic_vector(17 downto 0):="000000010001110010";-- 1.111328125
    SIGNAL q_c_vS : std_logic_vector(17 downto 0):="111111111111111110";-- -0.001953125
    SIGNAL q_c_vL : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0
    SIGNAL u_c : std_logic_vector(17 downto 0):="111111111111111100";-- -0.00390625
    SIGNAL s_c_L : std_logic_vector(17 downto 0):="000000000010100000";-- 0.15625
    SIGNAL crf : std_logic_vector(17 downto 0):="000000000000000000";-- 0
    SIGNAL crg : std_logic_vector(17 downto 0):="000000100011001000";-- 2.1953125
    SIGNAL crh : std_logic_vector(17 downto 0):="111111110000111010";-- -0.943359375
    SIGNAL vini : std_logic_vector(17 downto 0):="111110110011000111";-- -4.8056640625
    SIGNAL nini : std_logic_vector(17 downto 0):="000110100110101111";-- 26.4208984375
    SIGNAL qini : std_logic_vector(17 downto 0):="111001101101110001";-- -25.1396484375
    SIGNAL vth : std_logic_vector(17 downto 0):="000000000000000000";-- 0
    SIGNAL uth : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0

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
            uin <= PORT_uin;
            sin <= PORT_sin;
            -- 2nd stage
            v_vv_vS_2nd <= v_vv_vS;
            v_vv_vL_2nd <= v_vv_vL;
            v_v_vS_2nd <= v_v_vS;
            v_v_vL_2nd <= v_v_vL;
            v_n_2nd <= v_n;
            v_q_2nd <= v_q;
            v_u_2nd <= v_u;
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
            u_v_2nd <= u_v;
            u_u_2nd <= u_u;
            s_S_2nd <= s_S;
            s_L_2nd <= s_L;
            vin_2nd <= vin;
            nin_2nd <= nin;
            qin_2nd <= qin;
            uin_2nd <= uin;
            sin_2nd <= sin;
            -- 3rd stage
            vout_3rd <= vin_2nd + v_vv_x_2nd + v_v_x_2nd + v_x_2nd + v_n_2nd + v_q_2nd - v_u_2nd + v_Iin_2nd;
            nout_3rd <= nin_2nd + n_vv_x_2nd + n_v_x_2nd + n_x_2nd + n_n_2nd;
            qout_3rd <= qin_2nd + q_vv_x_2nd + q_v_x_2nd + q_x_2nd + q_q_2nd;
            uout_3rd <= uin_2nd + u_v_2nd + u_u_2nd + u_c;
            vin_3rd <= vin_2nd;
            nin_3rd <= nin_2nd;
            qin_3rd <= qin_2nd;
            uin_3rd <= uin_2nd;
            sin_3rd <= sin_2nd;
            --4th stage
            PORT_vout <= vout_3rd;
            PORT_nout <= nout_3rd;
            PORT_qout <= qout_3rd;
            PORT_uout <= uout_3rd;
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
    -- vv * 0.09687042236328125 : 00000000.00011000110011001000    32bit
    v_vv_vS_0 <= "0000" & vv(17 downto 0) & "0000000000" when vv(17)='0' else "1111" & vv(17 downto 0) & "0000000000";
    v_vv_vS_1 <= "00000" & vv(17 downto 0) & "000000000" when vv(17)='0' else "11111" & vv(17 downto 0) & "000000000";
    v_vv_vS_2 <= "000000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "00000";
    v_vv_vS_3 <= "0000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "0000";
    v_vv_vS_4 <= "0000000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "1111111111111" & vv(17 downto 0) & "0";
    v_vv_vS_5 <= "00000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "11111111111111" & vv(17 downto 0) & "";
    v_vv_vS_6 <= "00000000000000000" & vv(17 downto 3) & "" when vv(17)='0' else "11111111111111111" & vv(17 downto 3) & "";
    v_vv_vS_7 <= v_vv_vS_0 + v_vv_vS_1 + v_vv_vS_2 + v_vv_vS_3 + v_vv_vS_4 + v_vv_vS_5 + v_vv_vS_6;
    v_vv_vS <= v_vv_vS_7(31 downto 14);

    -- vv * -0.022104263305664062 : 00000000.00000101101010001010    38bit
    v_vv_vL_0 <= "000000" & vv(17 downto 0) & "00000000000000" when vv(17)='0' else "111111" & vv(17 downto 0) & "00000000000000";
    v_vv_vL_1 <= "00000000" & vv(17 downto 0) & "000000000000" when vv(17)='0' else "11111111" & vv(17 downto 0) & "000000000000";
    v_vv_vL_2 <= "000000000" & vv(17 downto 0) & "00000000000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "00000000000";
    v_vv_vL_3 <= "00000000000" & vv(17 downto 0) & "000000000" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "000000000";
    v_vv_vL_4 <= "0000000000000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "1111111111111" & vv(17 downto 0) & "0000000";
    v_vv_vL_5 <= "00000000000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "11111111111111111" & vv(17 downto 0) & "000";
    v_vv_vL_6 <= "0000000000000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "1111111111111111111" & vv(17 downto 0) & "0";
    v_vv_vL_7 <= not (v_vv_vL_0 + v_vv_vL_1 + v_vv_vL_2 + v_vv_vL_3 + v_vv_vL_4 + v_vv_vL_5 + v_vv_vL_6) + 1;
    v_vv_vL <= v_vv_vL_7(37 downto 20);

    -- vin * 0.1776599884033203 : 00000000.00101101011110110010    34bit
    v_v_vS_0 <= "000" & vin(17 downto 0) & "0000000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "0000000000000";
    v_v_vS_1 <= "00000" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "11111" & vin(17 downto 0) & "00000000000";
    v_v_vS_2 <= "000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "111111" & vin(17 downto 0) & "0000000000";
    v_v_vS_3 <= "00000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "00000000";
    v_v_vS_4 <= "0000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "000000";
    v_v_vS_5 <= "00000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "00000";
    v_v_vS_6 <= "000000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "0000";
    v_v_vS_7 <= "0000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "000";
    v_v_vS_8 <= "000000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "0";
    v_v_vS_9 <= "0000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "";
    v_v_vS_10 <= "0000000000000000000" & vin(17 downto 3) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 3) & "";
    v_v_vS_11 <= v_v_vS_0 + v_v_vS_1 + v_v_vS_2 + v_v_vS_3 + v_v_vS_4 + v_v_vS_5 + v_v_vS_6 + v_v_vS_7 + v_v_vS_8 + v_v_vS_9 + v_v_vS_10;
    v_v_vS <= v_v_vS_11(33 downto 16);

    -- vin * 0.17761802673339844 : 00000000.00101101011110000110    36bit
    v_v_vL_0 <= "000" & vin(17 downto 0) & "000000000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "000000000000000";
    v_v_vL_1 <= "00000" & vin(17 downto 0) & "0000000000000" when vin(17)='0' else "11111" & vin(17 downto 0) & "0000000000000";
    v_v_vL_2 <= "000000" & vin(17 downto 0) & "000000000000" when vin(17)='0' else "111111" & vin(17 downto 0) & "000000000000";
    v_v_vL_3 <= "00000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "0000000000";
    v_v_vL_4 <= "0000000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "00000000";
    v_v_vL_5 <= "00000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "0000000";
    v_v_vL_6 <= "000000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "000000";
    v_v_vL_7 <= "0000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "00000";
    v_v_vL_8 <= "000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "111111111111111111" & vin(17 downto 0) & "";
    v_v_vL_9 <= "0000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 1) & "";
    v_v_vL_10 <= v_v_vL_0 + v_v_vL_1 + v_v_vL_2 + v_v_vL_3 + v_v_vL_4 + v_v_vL_5 + v_v_vL_6 + v_v_vL_7 + v_v_vL_8 + v_v_vL_9;
    v_v_vL <= v_v_vL_10(35 downto 18);

    -- nin * -0.04888916015625 : 00000000.00001100100001000000    38bit
    v_n_0 <= "00000" & nin(17 downto 0) & "000000000000000" when nin(17)='0' else "11111" & nin(17 downto 0) & "000000000000000";
    v_n_1 <= "000000" & nin(17 downto 0) & "00000000000000" when nin(17)='0' else "111111" & nin(17 downto 0) & "00000000000000";
    v_n_2 <= "000000000" & nin(17 downto 0) & "00000000000" when nin(17)='0' else "111111111" & nin(17 downto 0) & "00000000000";
    v_n_3 <= "00000000000000" & nin(17 downto 0) & "000000" when nin(17)='0' else "11111111111111" & nin(17 downto 0) & "000000";
    v_n_4 <= not (v_n_0 + v_n_1 + v_n_2 + v_n_3) + 1;
    v_n <= v_n_4(37 downto 20);

    -- qin * -0.04888916015625 : 00000000.00001100100001000000    38bit
    v_q_0 <= "00000" & qin(17 downto 0) & "000000000000000" when qin(17)='0' else "11111" & qin(17 downto 0) & "000000000000000";
    v_q_1 <= "000000" & qin(17 downto 0) & "00000000000000" when qin(17)='0' else "111111" & qin(17 downto 0) & "00000000000000";
    v_q_2 <= "000000000" & qin(17 downto 0) & "00000000000" when qin(17)='0' else "111111111" & qin(17 downto 0) & "00000000000";
    v_q_3 <= "00000000000000" & qin(17 downto 0) & "000000" when qin(17)='0' else "11111111111111" & qin(17 downto 0) & "000000";
    v_q_4 <= not (v_q_0 + v_q_1 + v_q_2 + v_q_3) + 1;
    v_q <= v_q_4(37 downto 20);

    -- uin * -0.04888916015625 : 00000000.00001100100001000000    38bit
    v_u_0 <= "00000" & uin(17 downto 0) & "000000000000000" when uin(17)='0' else "11111" & uin(17 downto 0) & "000000000000000";
    v_u_1 <= "000000" & uin(17 downto 0) & "00000000000000" when uin(17)='0' else "111111" & uin(17 downto 0) & "00000000000000";
    v_u_2 <= "000000000" & uin(17 downto 0) & "00000000000" when uin(17)='0' else "111111111" & uin(17 downto 0) & "00000000000";
    v_u_3 <= "00000000000000" & uin(17 downto 0) & "000000" when uin(17)='0' else "11111111111111" & uin(17 downto 0) & "000000";
    v_u_4 <= not (v_u_0 + v_u_1 + v_u_2 + v_u_3) + 1;
    v_u <= v_u_4(37 downto 20);

    -- Iin * 1.466578483581543 : 00000001.01110111011100011011    37bit
    v_Iin_0 <= Iin & "0000000000000000000";
    v_Iin_1 <= "00" & Iin(17 downto 0) & "00000000000000000" when Iin(17)='0' else "11" & Iin(17 downto 0) & "00000000000000000";
    v_Iin_2 <= "000" & Iin(17 downto 0) & "0000000000000000" when Iin(17)='0' else "111" & Iin(17 downto 0) & "0000000000000000";
    v_Iin_3 <= "0000" & Iin(17 downto 0) & "000000000000000" when Iin(17)='0' else "1111" & Iin(17 downto 0) & "000000000000000";
    v_Iin_4 <= "000000" & Iin(17 downto 0) & "0000000000000" when Iin(17)='0' else "111111" & Iin(17 downto 0) & "0000000000000";
    v_Iin_5 <= "0000000" & Iin(17 downto 0) & "000000000000" when Iin(17)='0' else "1111111" & Iin(17 downto 0) & "000000000000";
    v_Iin_6 <= "00000000" & Iin(17 downto 0) & "00000000000" when Iin(17)='0' else "11111111" & Iin(17 downto 0) & "00000000000";
    v_Iin_7 <= "0000000000" & Iin(17 downto 0) & "000000000" when Iin(17)='0' else "1111111111" & Iin(17 downto 0) & "000000000";
    v_Iin_8 <= "00000000000" & Iin(17 downto 0) & "00000000" when Iin(17)='0' else "11111111111" & Iin(17 downto 0) & "00000000";
    v_Iin_9 <= "000000000000" & Iin(17 downto 0) & "0000000" when Iin(17)='0' else "111111111111" & Iin(17 downto 0) & "0000000";
    v_Iin_10 <= "0000000000000000" & Iin(17 downto 0) & "000" when Iin(17)='0' else "1111111111111111" & Iin(17 downto 0) & "000";
    v_Iin_11 <= "00000000000000000" & Iin(17 downto 0) & "00" when Iin(17)='0' else "11111111111111111" & Iin(17 downto 0) & "00";
    v_Iin_12 <= "0000000000000000000" & Iin(17 downto 0) & "" when Iin(17)='0' else "1111111111111111111" & Iin(17 downto 0) & "";
    v_Iin_13 <= "00000000000000000000" & Iin(17 downto 1) & "" when Iin(17)='0' else "11111111111111111111" & Iin(17 downto 1) & "";
    v_Iin_14 <= v_Iin_0 + v_Iin_1 + v_Iin_2 + v_Iin_3 + v_Iin_4 + v_Iin_5 + v_Iin_6 + v_Iin_7 + v_Iin_8 + v_Iin_9 + v_Iin_10 + v_Iin_11 + v_Iin_12 + v_Iin_13;
    v_Iin <= v_Iin_14(36 downto 19);

    -- vv * 0.01953125 : 00000000.00000101000000000000    24bit
    n_vv_vS_0 <= "000000" & vv(17 downto 0) & "" when vv(17)='0' else "111111" & vv(17 downto 0) & "";
    n_vv_vS_1 <= "00000000" & vv(17 downto 2) & "" when vv(17)='0' else "11111111" & vv(17 downto 2) & "";
    n_vv_vS_2 <= n_vv_vS_0 + n_vv_vS_1;
    n_vv_vS <= n_vv_vS_2(23 downto 6);

    -- vv * 0.25 : 00000000.01000000000000000000    18bit
    n_vv_vL <= "00" & vv(17 downto 2) when vv(17)='0' else "11" & vv(17 downto 2);

    -- vin * 0.00885009765625 : 00000000.00000010010001000000    28bit
    n_v_vS_0 <= "0000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "000";
    n_v_vS_1 <= "0000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "";
    n_v_vS_2 <= "00000000000000" & vin(17 downto 4) & "" when vin(17)='0' else "11111111111111" & vin(17 downto 4) & "";
    n_v_vS_3 <= n_v_vS_0 + n_v_vS_1 + n_v_vS_2;
    n_v_vS <= n_v_vS_3(27 downto 10);

    -- vin * -1.0029296875 : 00000001.00000000110000000000    38bit
    n_v_vL_0 <= vin & "00000000000000000000";
    n_v_vL_1 <= "000000000" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "00000000000";
    n_v_vL_2 <= "0000000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "0000000000";
    n_v_vL_3 <= not (n_v_vL_0 + n_v_vL_1 + n_v_vL_2) + 1;
    n_v_vL <= n_v_vL_3(37 downto 20);

    -- nin * -0.015625 : 00000000.00000100000000000000    38bit
    n_n_0 <= "000000" & nin(17 downto 0) & "00000000000000" when nin(17)='0' else "111111" & nin(17 downto 0) & "00000000000000";
    n_n_1 <= not (n_n_0) + 1;
    n_n <= n_n_1(37 downto 20);

    -- vv * -0.000637054443359375 : 00000000.00000000001010011100    38bit
    q_vv_vS_0 <= "00000000000" & vv(17 downto 0) & "000000000" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "000000000";
    q_vv_vS_1 <= "0000000000000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "1111111111111" & vv(17 downto 0) & "0000000";
    q_vv_vS_2 <= "0000000000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "1111111111111111" & vv(17 downto 0) & "0000";
    q_vv_vS_3 <= "00000000000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "11111111111111111" & vv(17 downto 0) & "000";
    q_vv_vS_4 <= "000000000000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "111111111111111111" & vv(17 downto 0) & "00";
    q_vv_vS_5 <= not (q_vv_vS_0 + q_vv_vS_1 + q_vv_vS_2 + q_vv_vS_3 + q_vv_vS_4) + 1;
    q_vv_vS <= q_vv_vS_5(37 downto 20);

    -- vv * 0.0011320114135742188 : 00000000.00000000010010100011    37bit
    q_vv_vL_0 <= "0000000000" & vv(17 downto 0) & "000000000" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "000000000";
    q_vv_vL_1 <= "0000000000000" & vv(17 downto 0) & "000000" when vv(17)='0' else "1111111111111" & vv(17 downto 0) & "000000";
    q_vv_vL_2 <= "000000000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "0000";
    q_vv_vL_3 <= "0000000000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "1111111111111111111" & vv(17 downto 0) & "";
    q_vv_vL_4 <= "00000000000000000000" & vv(17 downto 1) & "" when vv(17)='0' else "11111111111111111111" & vv(17 downto 1) & "";
    q_vv_vL_5 <= q_vv_vL_0 + q_vv_vL_1 + q_vv_vL_2 + q_vv_vL_3 + q_vv_vL_4;
    q_vv_vL <= q_vv_vL_5(36 downto 19);

    -- vin * -0.0028791427612304688 : 00000000.00000000101111001011    38bit
    q_v_vS_0 <= "000000000" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "00000000000";
    q_v_vS_1 <= "00000000000" & vin(17 downto 0) & "000000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "000000000";
    q_v_vS_2 <= "000000000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "00000000";
    q_v_vS_3 <= "0000000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "0000000";
    q_v_vS_4 <= "00000000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "000000";
    q_v_vS_5 <= "00000000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "000";
    q_v_vS_6 <= "0000000000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "1111111111111111111" & vin(17 downto 0) & "0";
    q_v_vS_7 <= "00000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "11111111111111111111" & vin(17 downto 0) & "";
    q_v_vS_8 <= not (q_v_vS_0 + q_v_vS_1 + q_v_vS_2 + q_v_vS_3 + q_v_vS_4 + q_v_vS_5 + q_v_vS_6 + q_v_vS_7) + 1;
    q_v_vS <= q_v_vS_8(37 downto 20);

    -- vin * 0.000457763671875 : 00000000.00000000000111100000    32bit
    q_v_vL_0 <= "000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "00";
    q_v_vL_1 <= "0000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "0";
    q_v_vL_2 <= "00000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "";
    q_v_vL_3 <= "000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "111111111111111" & vin(17 downto 1) & "";
    q_v_vL_4 <= q_v_vL_0 + q_v_vL_1 + q_v_vL_2 + q_v_vL_3;
    q_v_vL <= q_v_vL_4(31 downto 14);

    -- qin * -7.724761962890625e-05 : 00000000.00000000000001010001    38bit
    q_q_0 <= "00000000000000" & qin(17 downto 0) & "000000" when qin(17)='0' else "11111111111111" & qin(17 downto 0) & "000000";
    q_q_1 <= "0000000000000000" & qin(17 downto 0) & "0000" when qin(17)='0' else "1111111111111111" & qin(17 downto 0) & "0000";
    q_q_2 <= "00000000000000000000" & qin(17 downto 0) & "" when qin(17)='0' else "11111111111111111111" & qin(17 downto 0) & "";
    q_q_3 <= not (q_q_0 + q_q_1 + q_q_2) + 1;
    q_q <= q_q_3(37 downto 20);

    -- vin * 0.0047550201416015625 : 00000000.00000001001101111010    35bit
    u_v_0 <= "00000000" & vin(17 downto 0) & "000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "000000000";
    u_v_1 <= "00000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "000000";
    u_v_2 <= "000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "00000";
    u_v_3 <= "00000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "000";
    u_v_4 <= "000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "00";
    u_v_5 <= "0000000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "0";
    u_v_6 <= "00000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "";
    u_v_7 <= "0000000000000000000" & vin(17 downto 2) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 2) & "";
    u_v_8 <= u_v_0 + u_v_1 + u_v_2 + u_v_3 + u_v_4 + u_v_5 + u_v_6 + u_v_7;
    u_v <= u_v_8(34 downto 17);

    -- uin * -0.0009565353393554688 : 00000000.00000000001111101011    38bit
    u_u_0 <= "00000000000" & uin(17 downto 0) & "000000000" when uin(17)='0' else "11111111111" & uin(17 downto 0) & "000000000";
    u_u_1 <= "000000000000" & uin(17 downto 0) & "00000000" when uin(17)='0' else "111111111111" & uin(17 downto 0) & "00000000";
    u_u_2 <= "0000000000000" & uin(17 downto 0) & "0000000" when uin(17)='0' else "1111111111111" & uin(17 downto 0) & "0000000";
    u_u_3 <= "00000000000000" & uin(17 downto 0) & "000000" when uin(17)='0' else "11111111111111" & uin(17 downto 0) & "000000";
    u_u_4 <= "000000000000000" & uin(17 downto 0) & "00000" when uin(17)='0' else "111111111111111" & uin(17 downto 0) & "00000";
    u_u_5 <= "00000000000000000" & uin(17 downto 0) & "000" when uin(17)='0' else "11111111111111111" & uin(17 downto 0) & "000";
    u_u_6 <= "0000000000000000000" & uin(17 downto 0) & "0" when uin(17)='0' else "1111111111111111111" & uin(17 downto 0) & "0";
    u_u_7 <= "00000000000000000000" & uin(17 downto 0) & "" when uin(17)='0' else "11111111111111111111" & uin(17 downto 0) & "";
    u_u_8 <= not (u_u_0 + u_u_1 + u_u_2 + u_u_3 + u_u_4 + u_u_5 + u_u_6 + u_u_7) + 1;
    u_u <= u_u_8(37 downto 20);

    -- sin * -0.0390625 : 00000000.00001010000000000000    38bit
    s_S_0 <= "00000" & sin(17 downto 0) & "000000000000000" when sin(17)='0' else "11111" & sin(17 downto 0) & "000000000000000";
    s_S_1 <= "0000000" & sin(17 downto 0) & "0000000000000" when sin(17)='0' else "1111111" & sin(17 downto 0) & "0000000000000";
    s_S_2 <= not (s_S_0 + s_S_1) + 1;
    s_S <= s_S_2(37 downto 20);

    -- sin * -0.15625 : 00000000.00101000000000000000    38bit
    s_L_0 <= "000" & sin(17 downto 0) & "00000000000000000" when sin(17)='0' else "111" & sin(17 downto 0) & "00000000000000000";
    s_L_1 <= "00000" & sin(17 downto 0) & "000000000000000" when sin(17)='0' else "11111" & sin(17 downto 0) & "000000000000000";
    s_L_2 <= not (s_L_0 + s_L_1) + 1;
    s_L <= s_L_2(37 downto 20);

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
--dt= 0.001
--tau= 0.064
--afn= 1.9814453125
--afp= -0.4521484375
--bfn= -0.9169921875
--bfp= 4.017578125
--cfn= 0.0
--cfp= 8.966796875
--agn= 1.25
--agp= 16.0
--bgn= -0.2265625
--bgp= 2.005859375
--cgn= 0.0
--cgp= 6.7587890625
--ahn= -8.248046875
--ahp= 14.658203125
--bhn= -2.259765625
--bhp= -0.2021484375
--chn= 15.8720703125
--chp= -6.4638671875
--rg= 2.1953125
--rh= -0.943359375
--phi= 3.12890625
--epsq= 0.00494384765625
--epsu= 0.3043212890625
--I0= -0.4609375
--Ix= 29.998046875
--nx= 1.0
--uth= 0.0
--alpu= 0.201171875
--v_vv_vS=0.09687042236328125
--v_vv_vL=-0.022104263305664062
--v_v_vS=0.1776599884033203
--v_v_vL=0.17761802673339844
--v_n=-0.04888916015625
--v_q=-0.04888916015625
--v_u=-0.04888916015625
--v_Iin=1.466578483581543
--n_vv_vS=0.01953125
--n_vv_vL=0.25
--n_v_vS=0.00885009765625
--n_v_vL=-1.0029296875
--n_n=-0.015625
--q_vv_vS=-0.000637054443359375
--q_vv_vL=0.0011320114135742188
--q_v_vS=-0.0028791427612304688
--q_v_vL=0.000457763671875
--q_q=-7.724761962890625e-05
--u_v=0.0047550201416015625
--u_u=-0.0009565353393554688
--s_S=-0.0390625
--s_L=-0.15625
--v_c_vS=0.05859375
--v_c_vL=0.05859375
--n_c_vS=0.0009765625
--n_c_vL=1.111328125
--q_c_vS=-0.001953125
--q_c_vL=0.0
--u_c=-0.00390625
--s_c_L=0.15625
--crf=0
--crg=2.1953125
--crh=-0.943359375
--vini=-4.8056640625
--nini=26.4208984375
--qini=-25.1396484375
--vth=0
--uth=0.0