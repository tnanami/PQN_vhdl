------------------------------------------------------
-- Author: Takuya Nanami
-- Model: PQN model
-- Mode: IB
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
entity IB is
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
end IB;
architecture Behavioral of IB is
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
    SIGNAL v_vv_vS_0 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vS_1 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vS_2 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vS_3 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vS_4 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vS_5 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vS_6 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vS_7 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vS_8 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vS_9 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vS_10 : std_logic_vector(34 downto 0);
    SIGNAL v_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL v_vv_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_4 : std_logic_vector(37 downto 0);
    SIGNAL v_v_vS : std_logic_vector(17 downto 0);
    SIGNAL v_v_vS_0 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vS_1 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vS_2 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vS_3 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vS_4 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vS_5 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vS_6 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vL : std_logic_vector(17 downto 0);
    SIGNAL v_v_vL_0 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vL_1 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vL_2 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vL_3 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vL_4 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vL_5 : std_logic_vector(27 downto 0);
    SIGNAL v_v_vL_6 : std_logic_vector(27 downto 0);
    SIGNAL v_n : std_logic_vector(17 downto 0);
    SIGNAL v_n_0 : std_logic_vector(37 downto 0);
    SIGNAL v_n_1 : std_logic_vector(37 downto 0);
    SIGNAL v_n_2 : std_logic_vector(37 downto 0);
    SIGNAL v_n_3 : std_logic_vector(37 downto 0);
    SIGNAL v_n_4 : std_logic_vector(37 downto 0);
    SIGNAL v_n_5 : std_logic_vector(37 downto 0);
    SIGNAL v_q : std_logic_vector(17 downto 0);
    SIGNAL v_q_0 : std_logic_vector(37 downto 0);
    SIGNAL v_q_1 : std_logic_vector(37 downto 0);
    SIGNAL v_q_2 : std_logic_vector(37 downto 0);
    SIGNAL v_q_3 : std_logic_vector(37 downto 0);
    SIGNAL v_q_4 : std_logic_vector(37 downto 0);
    SIGNAL v_q_5 : std_logic_vector(37 downto 0);
    SIGNAL v_u : std_logic_vector(17 downto 0);
    SIGNAL v_u_0 : std_logic_vector(37 downto 0);
    SIGNAL v_u_1 : std_logic_vector(37 downto 0);
    SIGNAL v_u_2 : std_logic_vector(37 downto 0);
    SIGNAL v_u_3 : std_logic_vector(37 downto 0);
    SIGNAL v_u_4 : std_logic_vector(37 downto 0);
    SIGNAL v_u_5 : std_logic_vector(37 downto 0);
    SIGNAL v_Iin : std_logic_vector(17 downto 0);
    SIGNAL v_Iin_0 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_1 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_2 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_3 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_4 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_5 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_6 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_7 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_8 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_9 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_10 : std_logic_vector(34 downto 0);
    SIGNAL n_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vS_0 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vS_1 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vS_2 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vS_3 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vS_4 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vS_5 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vS_6 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vS_7 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vL_0 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_1 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_2 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_3 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_4 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_5 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_6 : std_logic_vector(27 downto 0);
    SIGNAL n_v_vS : std_logic_vector(17 downto 0);
    SIGNAL n_v_vS_0 : std_logic_vector(30 downto 0);
    SIGNAL n_v_vS_1 : std_logic_vector(30 downto 0);
    SIGNAL n_v_vS_2 : std_logic_vector(30 downto 0);
    SIGNAL n_v_vS_3 : std_logic_vector(30 downto 0);
    SIGNAL n_v_vS_4 : std_logic_vector(30 downto 0);
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
    SIGNAL n_v_vL_9 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_10 : std_logic_vector(37 downto 0);
    SIGNAL n_n : std_logic_vector(17 downto 0);
    SIGNAL n_n_0 : std_logic_vector(37 downto 0);
    SIGNAL n_n_1 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vS_0 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_1 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_2 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_3 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vL_4 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vL_5 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vL_6 : std_logic_vector(37 downto 0);
    SIGNAL q_v_vS : std_logic_vector(17 downto 0);
    SIGNAL q_v_vS_0 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_1 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_2 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_3 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_4 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_5 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_6 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vL : std_logic_vector(17 downto 0);
    SIGNAL q_v_vL_0 : std_logic_vector(34 downto 0);
    SIGNAL q_v_vL_1 : std_logic_vector(34 downto 0);
    SIGNAL q_v_vL_2 : std_logic_vector(34 downto 0);
    SIGNAL q_v_vL_3 : std_logic_vector(34 downto 0);
    SIGNAL q_v_vL_4 : std_logic_vector(34 downto 0);
    SIGNAL q_q : std_logic_vector(17 downto 0);
    SIGNAL q_q_0 : std_logic_vector(37 downto 0);
    SIGNAL q_q_1 : std_logic_vector(37 downto 0);
    SIGNAL q_q_2 : std_logic_vector(37 downto 0);
    SIGNAL q_q_3 : std_logic_vector(37 downto 0);
    SIGNAL q_q_4 : std_logic_vector(37 downto 0);
    SIGNAL q_q_5 : std_logic_vector(37 downto 0);
    SIGNAL u_v : std_logic_vector(17 downto 0);
    SIGNAL u_v_0 : std_logic_vector(33 downto 0);
    SIGNAL u_v_1 : std_logic_vector(33 downto 0);
    SIGNAL u_v_2 : std_logic_vector(33 downto 0);
    SIGNAL u_v_3 : std_logic_vector(33 downto 0);
    SIGNAL u_v_4 : std_logic_vector(33 downto 0);
    SIGNAL u_v_5 : std_logic_vector(33 downto 0);
    SIGNAL u_u : std_logic_vector(17 downto 0);
    SIGNAL u_u_0 : std_logic_vector(37 downto 0);
    SIGNAL u_u_1 : std_logic_vector(37 downto 0);
    SIGNAL u_u_2 : std_logic_vector(37 downto 0);
    SIGNAL u_u_3 : std_logic_vector(37 downto 0);
    SIGNAL u_u_4 : std_logic_vector(37 downto 0);
    SIGNAL u_u_5 : std_logic_vector(37 downto 0);
    SIGNAL n_uS : std_logic_vector(17 downto 0);
    SIGNAL n_uS_0 : std_logic_vector(21 downto 0);
    SIGNAL n_uS_1 : std_logic_vector(21 downto 0);
    SIGNAL n_uS_2 : std_logic_vector(21 downto 0);
    SIGNAL n_uS_3 : std_logic_vector(21 downto 0);
    SIGNAL n_uS_4 : std_logic_vector(21 downto 0);
    SIGNAL n_uL : std_logic_vector(17 downto 0);
    SIGNAL s_S : std_logic_vector(17 downto 0);
    SIGNAL s_S_0 : std_logic_vector(37 downto 0);
    SIGNAL s_S_1 : std_logic_vector(37 downto 0);
    SIGNAL s_L : std_logic_vector(17 downto 0);
    SIGNAL s_L_0 : std_logic_vector(37 downto 0);
    SIGNAL s_L_1 : std_logic_vector(37 downto 0);
    SIGNAL v_c_vS : std_logic_vector(17 downto 0):="111111111011011111";-- -0.2822265625
    SIGNAL v_c_vL : std_logic_vector(17 downto 0):="111111111011011111";-- -0.2822265625
    SIGNAL n_c_vS : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0
    SIGNAL n_c_vL : std_logic_vector(17 downto 0):="111111111111010100";-- -0.04296875
    SIGNAL q_c_vS : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0
    SIGNAL q_c_vL : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0
    SIGNAL u_c : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0
    SIGNAL s_c_L : std_logic_vector(17 downto 0):="000000000000010000";-- 0.015625
    SIGNAL crf : std_logic_vector(17 downto 0):="000000000000000000";-- 0
    SIGNAL crg : std_logic_vector(17 downto 0):="111111101100110010";-- -1.201171875
    SIGNAL crh : std_logic_vector(17 downto 0):="111111110100111000";-- -0.6953125
    SIGNAL vini : std_logic_vector(17 downto 0):="111110111000101010";-- -4.458984375
    SIGNAL nini : std_logic_vector(17 downto 0):="000110111100100000";-- 27.78125
    SIGNAL qini : std_logic_vector(17 downto 0):="111101101110000110";-- -9.119140625
    SIGNAL vth : std_logic_vector(17 downto 0):="000000000000000000";-- 0
    SIGNAL uth : std_logic_vector(17 downto 0):="111000000101001111";-- -31.6728515625

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
            vout_3rd <= vin_2nd + v_vv_x_2nd + v_v_x_2nd + v_x_2nd + v_n_2nd + v_q_2nd + v_Iin_2nd;
            n0_3rd <= n_vv_x_2nd + n_v_x_2nd + n_x_2nd + n_n_2nd;
            qout_3rd <= qin_2nd + q_vv_x_2nd + q_v_x_2nd + q_x_2nd + q_q_2nd;
            uout_3rd <= uin_2nd + u_v_2nd + u_u_2nd + u_c;
            vin_3rd <= vin_2nd;
            nin_3rd <= nin_2nd;
            qin_3rd <= qin_2nd;
            uin_3rd <= uin_2nd;
            sin_3rd <= sin_2nd;
            --4th stage
            PORT_vout <= vout_3rd;
            IF uin_3rd<uth THEN
                PORT_nout <= nin_3rd + n_uS;
            ELSE
                PORT_nout <= nin_3rd + n_uL;
            END IF;
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
    -- vv * 0.10122108459472656 : 00000000.00011001111010011010    35bit
    v_vv_vS_0 <= "0000" & vv(17 downto 0) & "0000000000000" when vv(17)='0' else "1111" & vv(17 downto 0) & "0000000000000";
    v_vv_vS_1 <= "00000" & vv(17 downto 0) & "000000000000" when vv(17)='0' else "11111" & vv(17 downto 0) & "000000000000";
    v_vv_vS_2 <= "00000000" & vv(17 downto 0) & "000000000" when vv(17)='0' else "11111111" & vv(17 downto 0) & "000000000";
    v_vv_vS_3 <= "000000000" & vv(17 downto 0) & "00000000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "00000000";
    v_vv_vS_4 <= "0000000000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "0000000";
    v_vv_vS_5 <= "00000000000" & vv(17 downto 0) & "000000" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "000000";
    v_vv_vS_6 <= "0000000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "1111111111111" & vv(17 downto 0) & "0000";
    v_vv_vS_7 <= "0000000000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "1111111111111111" & vv(17 downto 0) & "0";
    v_vv_vS_8 <= "00000000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "11111111111111111" & vv(17 downto 0) & "";
    v_vv_vS_9 <= "0000000000000000000" & vv(17 downto 2) & "" when vv(17)='0' else "1111111111111111111" & vv(17 downto 2) & "";
    v_vv_vS_10 <= v_vv_vS_0 + v_vv_vS_1 + v_vv_vS_2 + v_vv_vS_3 + v_vv_vS_4 + v_vv_vS_5 + v_vv_vS_6 + v_vv_vS_7 + v_vv_vS_8 + v_vv_vS_9;
    v_vv_vS <= v_vv_vS_10(34 downto 17);

    -- vv * -0.000217437744140625 : 00000000.00000000000011100100    38bit
    v_vv_vL_0 <= "0000000000000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "1111111111111" & vv(17 downto 0) & "0000000";
    v_vv_vL_1 <= "00000000000000" & vv(17 downto 0) & "000000" when vv(17)='0' else "11111111111111" & vv(17 downto 0) & "000000";
    v_vv_vL_2 <= "000000000000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "00000";
    v_vv_vL_3 <= "000000000000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "111111111111111111" & vv(17 downto 0) & "00";
    v_vv_vL_4 <= not (v_vv_vL_0 + v_vv_vL_1 + v_vv_vL_2 + v_vv_vL_3) + 1;
    v_vv_vL <= v_vv_vL_4(37 downto 20);

    -- vin * 0.15380859375 : 00000000.00100111011000000000    28bit
    v_v_vS_0 <= "000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "111" & vin(17 downto 0) & "0000000";
    v_v_vS_1 <= "000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "111111" & vin(17 downto 0) & "0000";
    v_v_vS_2 <= "0000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "000";
    v_v_vS_3 <= "00000000" & vin(17 downto 0) & "00" when vin(17)='0' else "11111111" & vin(17 downto 0) & "00";
    v_v_vS_4 <= "0000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "";
    v_v_vS_5 <= "00000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111" & vin(17 downto 1) & "";
    v_v_vS_6 <= v_v_vS_0 + v_v_vS_1 + v_v_vS_2 + v_v_vS_3 + v_v_vS_4 + v_v_vS_5;
    v_v_vS <= v_v_vS_6(27 downto 10);

    -- vin * 0.15380859375 : 00000000.00100111011000000000    28bit
    v_v_vL_0 <= "000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "111" & vin(17 downto 0) & "0000000";
    v_v_vL_1 <= "000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "111111" & vin(17 downto 0) & "0000";
    v_v_vL_2 <= "0000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "000";
    v_v_vL_3 <= "00000000" & vin(17 downto 0) & "00" when vin(17)='0' else "11111111" & vin(17 downto 0) & "00";
    v_v_vL_4 <= "0000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "";
    v_v_vL_5 <= "00000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111" & vin(17 downto 1) & "";
    v_v_vL_6 <= v_v_vL_0 + v_v_vL_1 + v_v_vL_2 + v_v_vL_3 + v_v_vL_4 + v_v_vL_5;
    v_v_vL <= v_v_vL_6(27 downto 10);

    -- nin * -0.0557861328125 : 00000000.00001110010010000000    38bit
    v_n_0 <= "00000" & nin(17 downto 0) & "000000000000000" when nin(17)='0' else "11111" & nin(17 downto 0) & "000000000000000";
    v_n_1 <= "000000" & nin(17 downto 0) & "00000000000000" when nin(17)='0' else "111111" & nin(17 downto 0) & "00000000000000";
    v_n_2 <= "0000000" & nin(17 downto 0) & "0000000000000" when nin(17)='0' else "1111111" & nin(17 downto 0) & "0000000000000";
    v_n_3 <= "0000000000" & nin(17 downto 0) & "0000000000" when nin(17)='0' else "1111111111" & nin(17 downto 0) & "0000000000";
    v_n_4 <= "0000000000000" & nin(17 downto 0) & "0000000" when nin(17)='0' else "1111111111111" & nin(17 downto 0) & "0000000";
    v_n_5 <= not (v_n_0 + v_n_1 + v_n_2 + v_n_3 + v_n_4) + 1;
    v_n <= v_n_5(37 downto 20);

    -- qin * -0.0557861328125 : 00000000.00001110010010000000    38bit
    v_q_0 <= "00000" & qin(17 downto 0) & "000000000000000" when qin(17)='0' else "11111" & qin(17 downto 0) & "000000000000000";
    v_q_1 <= "000000" & qin(17 downto 0) & "00000000000000" when qin(17)='0' else "111111" & qin(17 downto 0) & "00000000000000";
    v_q_2 <= "0000000" & qin(17 downto 0) & "0000000000000" when qin(17)='0' else "1111111" & qin(17 downto 0) & "0000000000000";
    v_q_3 <= "0000000000" & qin(17 downto 0) & "0000000000" when qin(17)='0' else "1111111111" & qin(17 downto 0) & "0000000000";
    v_q_4 <= "0000000000000" & qin(17 downto 0) & "0000000" when qin(17)='0' else "1111111111111" & qin(17 downto 0) & "0000000";
    v_q_5 <= not (v_q_0 + v_q_1 + v_q_2 + v_q_3 + v_q_4) + 1;
    v_q <= v_q_5(37 downto 20);

    -- uin * -0.0557861328125 : 00000000.00001110010010000000    38bit
    v_u_0 <= "00000" & uin(17 downto 0) & "000000000000000" when uin(17)='0' else "11111" & uin(17 downto 0) & "000000000000000";
    v_u_1 <= "000000" & uin(17 downto 0) & "00000000000000" when uin(17)='0' else "111111" & uin(17 downto 0) & "00000000000000";
    v_u_2 <= "0000000" & uin(17 downto 0) & "0000000000000" when uin(17)='0' else "1111111" & uin(17 downto 0) & "0000000000000";
    v_u_3 <= "0000000000" & uin(17 downto 0) & "0000000000" when uin(17)='0' else "1111111111" & uin(17 downto 0) & "0000000000";
    v_u_4 <= "0000000000000" & uin(17 downto 0) & "0000000" when uin(17)='0' else "1111111111111" & uin(17 downto 0) & "0000000";
    v_u_5 <= not (v_u_0 + v_u_1 + v_u_2 + v_u_3 + v_u_4) + 1;
    v_u <= v_u_5(37 downto 20);

    -- Iin * 0.07561588287353516 : 00000000.00010011010110111001    35bit
    v_Iin_0 <= "0000" & Iin(17 downto 0) & "0000000000000" when Iin(17)='0' else "1111" & Iin(17 downto 0) & "0000000000000";
    v_Iin_1 <= "0000000" & Iin(17 downto 0) & "0000000000" when Iin(17)='0' else "1111111" & Iin(17 downto 0) & "0000000000";
    v_Iin_2 <= "00000000" & Iin(17 downto 0) & "000000000" when Iin(17)='0' else "11111111" & Iin(17 downto 0) & "000000000";
    v_Iin_3 <= "0000000000" & Iin(17 downto 0) & "0000000" when Iin(17)='0' else "1111111111" & Iin(17 downto 0) & "0000000";
    v_Iin_4 <= "000000000000" & Iin(17 downto 0) & "00000" when Iin(17)='0' else "111111111111" & Iin(17 downto 0) & "00000";
    v_Iin_5 <= "0000000000000" & Iin(17 downto 0) & "0000" when Iin(17)='0' else "1111111111111" & Iin(17 downto 0) & "0000";
    v_Iin_6 <= "000000000000000" & Iin(17 downto 0) & "00" when Iin(17)='0' else "111111111111111" & Iin(17 downto 0) & "00";
    v_Iin_7 <= "0000000000000000" & Iin(17 downto 0) & "0" when Iin(17)='0' else "1111111111111111" & Iin(17 downto 0) & "0";
    v_Iin_8 <= "00000000000000000" & Iin(17 downto 0) & "" when Iin(17)='0' else "11111111111111111" & Iin(17 downto 0) & "";
    v_Iin_9 <= "00000000000000000000" & Iin(17 downto 3) & "" when Iin(17)='0' else "11111111111111111111" & Iin(17 downto 3) & "";
    v_Iin_10 <= v_Iin_0 + v_Iin_1 + v_Iin_2 + v_Iin_3 + v_Iin_4 + v_Iin_5 + v_Iin_6 + v_Iin_7 + v_Iin_8 + v_Iin_9;
    v_Iin <= v_Iin_10(34 downto 17);

    -- vv * 0.178466796875 : 00000000.00101101101100000000    29bit
    n_vv_vS_0 <= "000" & vv(17 downto 0) & "00000000" when vv(17)='0' else "111" & vv(17 downto 0) & "00000000";
    n_vv_vS_1 <= "00000" & vv(17 downto 0) & "000000" when vv(17)='0' else "11111" & vv(17 downto 0) & "000000";
    n_vv_vS_2 <= "000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111111" & vv(17 downto 0) & "00000";
    n_vv_vS_3 <= "00000000" & vv(17 downto 0) & "000" when vv(17)='0' else "11111111" & vv(17 downto 0) & "000";
    n_vv_vS_4 <= "000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "111111111" & vv(17 downto 0) & "00";
    n_vv_vS_5 <= "00000000000" & vv(17 downto 0) & "" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "";
    n_vv_vS_6 <= "000000000000" & vv(17 downto 1) & "" when vv(17)='0' else "111111111111" & vv(17 downto 1) & "";
    n_vv_vS_7 <= n_vv_vS_0 + n_vv_vS_1 + n_vv_vS_2 + n_vv_vS_3 + n_vv_vS_4 + n_vv_vS_5 + n_vv_vS_6;
    n_vv_vS <= n_vv_vS_7(28 downto 11);

    -- vv * 0.14794921875 : 00000000.00100101111000000000    28bit
    n_vv_vL_0 <= "000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "111" & vv(17 downto 0) & "0000000";
    n_vv_vL_1 <= "000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "111111" & vv(17 downto 0) & "0000";
    n_vv_vL_2 <= "00000000" & vv(17 downto 0) & "00" when vv(17)='0' else "11111111" & vv(17 downto 0) & "00";
    n_vv_vL_3 <= "000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "111111111" & vv(17 downto 0) & "0";
    n_vv_vL_4 <= "0000000000" & vv(17 downto 0) & "" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "";
    n_vv_vL_5 <= "00000000000" & vv(17 downto 1) & "" when vv(17)='0' else "11111111111" & vv(17 downto 1) & "";
    n_vv_vL_6 <= n_vv_vL_0 + n_vv_vL_1 + n_vv_vL_2 + n_vv_vL_3 + n_vv_vL_4 + n_vv_vL_5;
    n_vv_vL <= n_vv_vL_6(27 downto 10);

    -- vin * 0.01673126220703125 : 00000000.00000100010010001000    31bit
    n_v_vS_0 <= "000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "111111" & vin(17 downto 0) & "0000000";
    n_v_vS_1 <= "0000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "000";
    n_v_vS_2 <= "0000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "";
    n_v_vS_3 <= "00000000000000000" & vin(17 downto 4) & "" when vin(17)='0' else "11111111111111111" & vin(17 downto 4) & "";
    n_v_vS_4 <= n_v_vS_0 + n_v_vS_1 + n_v_vS_2 + n_v_vS_3;
    n_v_vS <= n_v_vS_4(30 downto 13);

    -- vin * -0.05634784698486328 : 00000000.00001110011011001101    38bit
    n_v_vL_0 <= "00000" & vin(17 downto 0) & "000000000000000" when vin(17)='0' else "11111" & vin(17 downto 0) & "000000000000000";
    n_v_vL_1 <= "000000" & vin(17 downto 0) & "00000000000000" when vin(17)='0' else "111111" & vin(17 downto 0) & "00000000000000";
    n_v_vL_2 <= "0000000" & vin(17 downto 0) & "0000000000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "0000000000000";
    n_v_vL_3 <= "0000000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "0000000000";
    n_v_vL_4 <= "00000000000" & vin(17 downto 0) & "000000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "000000000";
    n_v_vL_5 <= "0000000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "0000000";
    n_v_vL_6 <= "00000000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "000000";
    n_v_vL_7 <= "00000000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "000";
    n_v_vL_8 <= "000000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "111111111111111111" & vin(17 downto 0) & "00";
    n_v_vL_9 <= "00000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "11111111111111111111" & vin(17 downto 0) & "";
    n_v_vL_10 <= not (n_v_vL_0 + n_v_vL_1 + n_v_vL_2 + n_v_vL_3 + n_v_vL_4 + n_v_vL_5 + n_v_vL_6 + n_v_vL_7 + n_v_vL_8 + n_v_vL_9) + 1;
    n_v_vL <= n_v_vL_10(37 downto 20);

    -- nin * -0.125 : 00000000.00100000000000000000    38bit
    n_n_0 <= "000" & nin(17 downto 0) & "00000000000000000" when nin(17)='0' else "111" & nin(17 downto 0) & "00000000000000000";
    n_n_1 <= not (n_n_0) + 1;
    n_n <= n_n_1(37 downto 20);

    -- vv * -9.34600830078125e-05 : 00000000.00000000000001100010    38bit
    q_vv_vS_0 <= "00000000000000" & vv(17 downto 0) & "000000" when vv(17)='0' else "11111111111111" & vv(17 downto 0) & "000000";
    q_vv_vS_1 <= "000000000000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "00000";
    q_vv_vS_2 <= "0000000000000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "1111111111111111111" & vv(17 downto 0) & "0";
    q_vv_vS_3 <= not (q_vv_vS_0 + q_vv_vS_1 + q_vv_vS_2) + 1;
    q_vv_vS <= q_vv_vS_3(37 downto 20);

    -- vv * -0.00020885467529296875 : 00000000.00000000000011011011    38bit
    q_vv_vL_0 <= "0000000000000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "1111111111111" & vv(17 downto 0) & "0000000";
    q_vv_vL_1 <= "00000000000000" & vv(17 downto 0) & "000000" when vv(17)='0' else "11111111111111" & vv(17 downto 0) & "000000";
    q_vv_vL_2 <= "0000000000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "1111111111111111" & vv(17 downto 0) & "0000";
    q_vv_vL_3 <= "00000000000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "11111111111111111" & vv(17 downto 0) & "000";
    q_vv_vL_4 <= "0000000000000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "1111111111111111111" & vv(17 downto 0) & "0";
    q_vv_vL_5 <= "00000000000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "11111111111111111111" & vv(17 downto 0) & "";
    q_vv_vL_6 <= not (q_vv_vL_0 + q_vv_vL_1 + q_vv_vL_2 + q_vv_vL_3 + q_vv_vL_4 + q_vv_vL_5) + 1;
    q_vv_vL <= q_vv_vL_6(37 downto 20);

    -- vin * 0.00035381317138671875 : 00000000.00000000000101110011    37bit
    q_v_vS_0 <= "000000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "0000000";
    q_v_vS_1 <= "00000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "00000";
    q_v_vS_2 <= "000000000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "0000";
    q_v_vS_3 <= "0000000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "000";
    q_v_vS_4 <= "0000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 0) & "";
    q_v_vS_5 <= "00000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111111111" & vin(17 downto 1) & "";
    q_v_vS_6 <= q_v_vS_0 + q_v_vS_1 + q_v_vS_2 + q_v_vS_3 + q_v_vS_4 + q_v_vS_5;
    q_v_vS <= q_v_vS_6(36 downto 19);

    -- vin * 0.0001926422119140625 : 00000000.00000000000011001010    35bit
    q_v_vL_0 <= "0000000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "0000";
    q_v_vL_1 <= "00000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "000";
    q_v_vL_2 <= "00000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "";
    q_v_vL_3 <= "0000000000000000000" & vin(17 downto 2) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 2) & "";
    q_v_vL_4 <= q_v_vL_0 + q_v_vL_1 + q_v_vL_2 + q_v_vL_3;
    q_v_vL <= q_v_vL_4(34 downto 17);

    -- qin * -0.00045013427734375 : 00000000.00000000000111011000    38bit
    q_q_0 <= "000000000000" & qin(17 downto 0) & "00000000" when qin(17)='0' else "111111111111" & qin(17 downto 0) & "00000000";
    q_q_1 <= "0000000000000" & qin(17 downto 0) & "0000000" when qin(17)='0' else "1111111111111" & qin(17 downto 0) & "0000000";
    q_q_2 <= "00000000000000" & qin(17 downto 0) & "000000" when qin(17)='0' else "11111111111111" & qin(17 downto 0) & "000000";
    q_q_3 <= "0000000000000000" & qin(17 downto 0) & "0000" when qin(17)='0' else "1111111111111111" & qin(17 downto 0) & "0000";
    q_q_4 <= "00000000000000000" & qin(17 downto 0) & "000" when qin(17)='0' else "11111111111111111" & qin(17 downto 0) & "000";
    q_q_5 <= not (q_q_0 + q_q_1 + q_q_2 + q_q_3 + q_q_4) + 1;
    q_q <= q_q_5(37 downto 20);

    -- vin * 0.00206756591796875 : 00000000.00000000100001111000    34bit
    u_v_0 <= "000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "0000000";
    u_v_1 <= "00000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "00";
    u_v_2 <= "000000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "0";
    u_v_3 <= "0000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "";
    u_v_4 <= "00000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111111" & vin(17 downto 1) & "";
    u_v_5 <= u_v_0 + u_v_1 + u_v_2 + u_v_3 + u_v_4;
    u_v <= u_v_5(33 downto 16);

    -- uin * -0.00025844573974609375 : 00000000.00000000000100001111    38bit
    u_u_0 <= "000000000000" & uin(17 downto 0) & "00000000" when uin(17)='0' else "111111111111" & uin(17 downto 0) & "00000000";
    u_u_1 <= "00000000000000000" & uin(17 downto 0) & "000" when uin(17)='0' else "11111111111111111" & uin(17 downto 0) & "000";
    u_u_2 <= "000000000000000000" & uin(17 downto 0) & "00" when uin(17)='0' else "111111111111111111" & uin(17 downto 0) & "00";
    u_u_3 <= "0000000000000000000" & uin(17 downto 0) & "0" when uin(17)='0' else "1111111111111111111" & uin(17 downto 0) & "0";
    u_u_4 <= "00000000000000000000" & uin(17 downto 0) & "" when uin(17)='0' else "11111111111111111111" & uin(17 downto 0) & "";
    u_u_5 <= not (u_u_0 + u_u_1 + u_u_2 + u_u_3 + u_u_4) + 1;
    u_u <= u_u_5(37 downto 20);

    -- n0_3rd * 1.328125 : 00000001.01010100000000000000    22bit
    n_uS_0 <= n0_3rd & "0000";
    n_uS_1 <= "00" & n0_3rd(17 downto 0) & "00" when n0_3rd(17)='0' else "11" & n0_3rd(17 downto 0) & "00";
    n_uS_2 <= "0000" & n0_3rd(17 downto 0) & "" when n0_3rd(17)='0' else "1111" & n0_3rd(17 downto 0) & "";
    n_uS_3 <= "000000" & n0_3rd(17 downto 2) & "" when n0_3rd(17)='0' else "111111" & n0_3rd(17 downto 2) & "";
    n_uS_4 <= n_uS_0 + n_uS_1 + n_uS_2 + n_uS_3;
    n_uS <= n_uS_4(21 downto 4);

    -- n0_3rd * 1 : 00000001.00000000000000000000    18bit
    n_uL <= n0_3rd;

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
--tau= 0.0008
--afn= 1.814453125
--afp= -0.00390625
--bfn= -0.759765625
--bfp= 352.9111328125
--cfn= 0.0
--cfp= 487.5556640625
--agn= 1.427734375
--agp= 1.18359375
--bgn= -0.046875
--bgp= 0.1904296875
--cgn= 0.0
--cgp= -0.3916015625
--ahn= -0.208984375
--ahp= -0.4658203125
--bhn= 1.8828125
--bhp= 0.4609375
--chn= 0.236328125
--chp= -0.529296875
--rg= -1.201171875
--rh= -0.6953125
--phi= 0.4462890625
--epsq= 0.00360107421875
--epsu= 0.01654052734375
--I0= -6.1103515625
--Ix= 1.35546875
--nx= 1.328125
--uth= -31.6728515625
--alpu= 0.125
--v_vv_vS=0.10122108459472656
--v_vv_vL=-0.000217437744140625
--v_v_vS=0.15380859375
--v_v_vL=0.15380859375
--v_n=-0.0557861328125
--v_q=-0.0557861328125
--v_u=-0.0557861328125
--v_Iin=0.07561588287353516
--n_vv_vS=0.178466796875
--n_vv_vL=0.14794921875
--n_v_vS=0.01673126220703125
--n_v_vL=-0.05634784698486328
--n_n=-0.125
--q_vv_vS=-9.34600830078125e-05
--q_vv_vL=-0.00020885467529296875
--q_v_vS=0.00035381317138671875
--q_v_vL=0.0001926422119140625
--q_q=-0.00045013427734375
--u_v=0.00206756591796875
--u_u=-0.00025844573974609375
--n_uS=1.328125
--n_uL=1
--s_S=-0.00390625
--s_L=-0.015625
--v_c_vS=-0.2822265625
--v_c_vL=-0.2822265625
--n_c_vS=0.0
--n_c_vL=-0.04296875
--q_c_vS=0.0
--q_c_vL=0.0
--u_c=0.0
--s_c_L=0.015625
--crf=0
--crg=-1.201171875
--crh=-0.6953125
--vini=-4.458984375
--nini=27.78125
--qini=-9.119140625
--vth=0
--uth=-31.6728515625