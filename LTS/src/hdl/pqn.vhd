------------------------------------------------------
-- Author: Takuya Nanami
-- Model: PQN model
-- Mode: LTS
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
entity LTS is
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
end LTS;
architecture Behavioral of LTS is
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
    SIGNAL v_v_vS : std_logic_vector(17 downto 0);
    SIGNAL v_v_vS_0 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vS_1 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vS_2 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vS_3 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vS_4 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vS_5 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vS_6 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vS_7 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vS_8 : std_logic_vector(36 downto 0);
    SIGNAL v_v_vS_9 : std_logic_vector(36 downto 0);
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
    SIGNAL v_n : std_logic_vector(17 downto 0);
    SIGNAL v_n_0 : std_logic_vector(37 downto 0);
    SIGNAL v_n_1 : std_logic_vector(37 downto 0);
    SIGNAL v_n_2 : std_logic_vector(37 downto 0);
    SIGNAL v_n_3 : std_logic_vector(37 downto 0);
    SIGNAL v_n_4 : std_logic_vector(37 downto 0);
    SIGNAL v_n_5 : std_logic_vector(37 downto 0);
    SIGNAL v_n_6 : std_logic_vector(37 downto 0);
    SIGNAL v_n_7 : std_logic_vector(37 downto 0);
    SIGNAL v_q : std_logic_vector(17 downto 0);
    SIGNAL v_q_0 : std_logic_vector(37 downto 0);
    SIGNAL v_q_1 : std_logic_vector(37 downto 0);
    SIGNAL v_q_2 : std_logic_vector(37 downto 0);
    SIGNAL v_q_3 : std_logic_vector(37 downto 0);
    SIGNAL v_q_4 : std_logic_vector(37 downto 0);
    SIGNAL v_q_5 : std_logic_vector(37 downto 0);
    SIGNAL v_q_6 : std_logic_vector(37 downto 0);
    SIGNAL v_q_7 : std_logic_vector(37 downto 0);
    SIGNAL v_u : std_logic_vector(17 downto 0);
    SIGNAL v_u_0 : std_logic_vector(37 downto 0);
    SIGNAL v_u_1 : std_logic_vector(37 downto 0);
    SIGNAL v_u_2 : std_logic_vector(37 downto 0);
    SIGNAL v_u_3 : std_logic_vector(37 downto 0);
    SIGNAL v_u_4 : std_logic_vector(37 downto 0);
    SIGNAL v_u_5 : std_logic_vector(37 downto 0);
    SIGNAL v_u_6 : std_logic_vector(37 downto 0);
    SIGNAL v_u_7 : std_logic_vector(37 downto 0);
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
    SIGNAL v_Iin_11 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_12 : std_logic_vector(34 downto 0);
    SIGNAL n_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vS_0 : std_logic_vector(29 downto 0);
    SIGNAL n_vv_vS_1 : std_logic_vector(29 downto 0);
    SIGNAL n_vv_vS_2 : std_logic_vector(29 downto 0);
    SIGNAL n_vv_vS_3 : std_logic_vector(29 downto 0);
    SIGNAL n_vv_vS_4 : std_logic_vector(29 downto 0);
    SIGNAL n_vv_vS_5 : std_logic_vector(29 downto 0);
    SIGNAL n_vv_vS_6 : std_logic_vector(29 downto 0);
    SIGNAL n_vv_vS_7 : std_logic_vector(29 downto 0);
    SIGNAL n_vv_vS_8 : std_logic_vector(29 downto 0);
    SIGNAL n_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vL_0 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_1 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_2 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_3 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_4 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_5 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_6 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_7 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_8 : std_logic_vector(27 downto 0);
    SIGNAL n_v_vS : std_logic_vector(17 downto 0);
    SIGNAL n_v_vS_0 : std_logic_vector(36 downto 0);
    SIGNAL n_v_vS_1 : std_logic_vector(36 downto 0);
    SIGNAL n_v_vS_2 : std_logic_vector(36 downto 0);
    SIGNAL n_v_vS_3 : std_logic_vector(36 downto 0);
    SIGNAL n_v_vS_4 : std_logic_vector(36 downto 0);
    SIGNAL n_v_vS_5 : std_logic_vector(36 downto 0);
    SIGNAL n_v_vS_6 : std_logic_vector(36 downto 0);
    SIGNAL n_v_vS_7 : std_logic_vector(36 downto 0);
    SIGNAL n_v_vS_8 : std_logic_vector(36 downto 0);
    SIGNAL n_v_vS_9 : std_logic_vector(36 downto 0);
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
    SIGNAL n_v_vL_11 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_12 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_13 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_14 : std_logic_vector(37 downto 0);
    SIGNAL n_v_vL_15 : std_logic_vector(37 downto 0);
    SIGNAL n_n : std_logic_vector(17 downto 0);
    SIGNAL n_n_0 : std_logic_vector(37 downto 0);
    SIGNAL n_n_1 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vS_0 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_1 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_2 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS_3 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vL_0 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vL_1 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vL_2 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vL_3 : std_logic_vector(36 downto 0);
    SIGNAL q_vv_vL_4 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS : std_logic_vector(17 downto 0);
    SIGNAL q_v_vS_0 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_1 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_2 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_3 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_4 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vS_5 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vL : std_logic_vector(17 downto 0);
    SIGNAL q_v_vL_0 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vL_1 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vL_2 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vL_3 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vL_4 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vL_5 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vL_6 : std_logic_vector(36 downto 0);
    SIGNAL q_v_vL_7 : std_logic_vector(36 downto 0);
    SIGNAL q_q : std_logic_vector(17 downto 0);
    SIGNAL q_q_0 : std_logic_vector(37 downto 0);
    SIGNAL q_q_1 : std_logic_vector(37 downto 0);
    SIGNAL q_q_2 : std_logic_vector(37 downto 0);
    SIGNAL q_q_3 : std_logic_vector(37 downto 0);
    SIGNAL q_q_4 : std_logic_vector(37 downto 0);
    SIGNAL u_v : std_logic_vector(17 downto 0);
    SIGNAL u_v_0 : std_logic_vector(28 downto 0);
    SIGNAL u_v_1 : std_logic_vector(28 downto 0);
    SIGNAL u_v_2 : std_logic_vector(28 downto 0);
    SIGNAL u_u : std_logic_vector(17 downto 0);
    SIGNAL u_u_0 : std_logic_vector(37 downto 0);
    SIGNAL u_u_1 : std_logic_vector(37 downto 0);
    SIGNAL u_u_2 : std_logic_vector(37 downto 0);
    SIGNAL u_u_3 : std_logic_vector(37 downto 0);
    SIGNAL u_u_4 : std_logic_vector(37 downto 0);
    SIGNAL u_u_5 : std_logic_vector(37 downto 0);
    SIGNAL u_u_6 : std_logic_vector(37 downto 0);
    SIGNAL u_u_7 : std_logic_vector(37 downto 0);
    SIGNAL n_uS : std_logic_vector(17 downto 0);
    SIGNAL n_uS_0 : std_logic_vector(19 downto 0);
    SIGNAL n_uS_1 : std_logic_vector(19 downto 0);
    SIGNAL n_uS_2 : std_logic_vector(19 downto 0);
    SIGNAL n_uS_3 : std_logic_vector(19 downto 0);
    SIGNAL n_uS_4 : std_logic_vector(19 downto 0);
    SIGNAL n_uL : std_logic_vector(17 downto 0);
    SIGNAL s_S : std_logic_vector(17 downto 0);
    SIGNAL s_S_0 : std_logic_vector(37 downto 0);
    SIGNAL s_S_1 : std_logic_vector(37 downto 0);
    SIGNAL s_L : std_logic_vector(17 downto 0);
    SIGNAL s_L_0 : std_logic_vector(37 downto 0);
    SIGNAL s_L_1 : std_logic_vector(37 downto 0);
    SIGNAL v_c_vS : std_logic_vector(17 downto 0):="111111111110111111";-- -0.0634765625
    SIGNAL v_c_vL : std_logic_vector(17 downto 0):="111111111110111111";-- -0.0634765625
    SIGNAL n_c_vS : std_logic_vector(17 downto 0):="000000000000100001";-- 0.0322265625
    SIGNAL n_c_vL : std_logic_vector(17 downto 0):="000000000011110110";-- 0.240234375
    SIGNAL q_c_vS : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0
    SIGNAL q_c_vL : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0
    SIGNAL u_c : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0
    SIGNAL s_c_L : std_logic_vector(17 downto 0):="000000000000010000";-- 0.015625
    SIGNAL crf : std_logic_vector(17 downto 0):="000000000000000000";-- 0
    SIGNAL crg : std_logic_vector(17 downto 0):="000000001011111111";-- 0.7490234375
    SIGNAL crh : std_logic_vector(17 downto 0):="111111110110000110";-- -0.619140625
    SIGNAL vini : std_logic_vector(17 downto 0):="111110110010110011";-- -4.8251953125
    SIGNAL nini : std_logic_vector(17 downto 0):="000110101011000011";-- 26.6904296875
    SIGNAL qini : std_logic_vector(17 downto 0):="111110001010001100";-- -7.36328125
    SIGNAL vth : std_logic_vector(17 downto 0):="000000000000000000";-- 0
    SIGNAL uth : std_logic_vector(17 downto 0):="111110010111101101";-- -6.5185546875

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
    -- vv * 0.054200172424316406 : 00000000.00001101111000000001    29bit
    v_vv_vS_0 <= "00000" & vv(17 downto 0) & "000000" when vv(17)='0' else "11111" & vv(17 downto 0) & "000000";
    v_vv_vS_1 <= "000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111111" & vv(17 downto 0) & "00000";
    v_vv_vS_2 <= "00000000" & vv(17 downto 0) & "000" when vv(17)='0' else "11111111" & vv(17 downto 0) & "000";
    v_vv_vS_3 <= "000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "111111111" & vv(17 downto 0) & "00";
    v_vv_vS_4 <= "0000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "0";
    v_vv_vS_5 <= "00000000000" & vv(17 downto 0) & "" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "";
    v_vv_vS_6 <= "00000000000000000000" & vv(17 downto 9) & "" when vv(17)='0' else "11111111111111111111" & vv(17 downto 9) & "";
    v_vv_vS_7 <= v_vv_vS_0 + v_vv_vS_1 + v_vv_vS_2 + v_vv_vS_3 + v_vv_vS_4 + v_vv_vS_5 + v_vv_vS_6;
    v_vv_vS <= v_vv_vS_7(28 downto 11);

    -- vv * -0.00014591217041015625 : 00000000.00000000000010011001    38bit
    v_vv_vL_0 <= "0000000000000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "1111111111111" & vv(17 downto 0) & "0000000";
    v_vv_vL_1 <= "0000000000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "1111111111111111" & vv(17 downto 0) & "0000";
    v_vv_vL_2 <= "00000000000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "11111111111111111" & vv(17 downto 0) & "000";
    v_vv_vL_3 <= "00000000000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "11111111111111111111" & vv(17 downto 0) & "";
    v_vv_vL_4 <= not (v_vv_vL_0 + v_vv_vL_1 + v_vv_vL_2 + v_vv_vL_3) + 1;
    v_vv_vL <= v_vv_vL_4(37 downto 20);

    -- vin * 0.12777233123779297 : 00000000.00100000101101011011    37bit
    v_v_vS_0 <= "000" & vin(17 downto 0) & "0000000000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "0000000000000000";
    v_v_vS_1 <= "000000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "0000000000";
    v_v_vS_2 <= "00000000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "00000000";
    v_v_vS_3 <= "000000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "0000000";
    v_v_vS_4 <= "00000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "00000";
    v_v_vS_5 <= "0000000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "000";
    v_v_vS_6 <= "00000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "00";
    v_v_vS_7 <= "0000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 0) & "";
    v_v_vS_8 <= "00000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111111111" & vin(17 downto 1) & "";
    v_v_vS_9 <= v_v_vS_0 + v_v_vS_1 + v_v_vS_2 + v_v_vS_3 + v_v_vS_4 + v_v_vS_5 + v_v_vS_6 + v_v_vS_7 + v_v_vS_8;
    v_v_vS <= v_v_vS_9(36 downto 19);

    -- vin * 0.12777233123779297 : 00000000.00100000101101011011    37bit
    v_v_vL_0 <= "000" & vin(17 downto 0) & "0000000000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "0000000000000000";
    v_v_vL_1 <= "000000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "0000000000";
    v_v_vL_2 <= "00000000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "00000000";
    v_v_vL_3 <= "000000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "0000000";
    v_v_vL_4 <= "00000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "00000";
    v_v_vL_5 <= "0000000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "000";
    v_v_vL_6 <= "00000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "00";
    v_v_vL_7 <= "0000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 0) & "";
    v_v_vL_8 <= "00000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111111111" & vin(17 downto 1) & "";
    v_v_vL_9 <= v_v_vL_0 + v_v_vL_1 + v_v_vL_2 + v_v_vL_3 + v_v_vL_4 + v_v_vL_5 + v_v_vL_6 + v_v_vL_7 + v_v_vL_8;
    v_v_vL <= v_v_vL_9(36 downto 19);

    -- nin * -0.02996826171875 : 00000000.00000111101011000000    38bit
    v_n_0 <= "000000" & nin(17 downto 0) & "00000000000000" when nin(17)='0' else "111111" & nin(17 downto 0) & "00000000000000";
    v_n_1 <= "0000000" & nin(17 downto 0) & "0000000000000" when nin(17)='0' else "1111111" & nin(17 downto 0) & "0000000000000";
    v_n_2 <= "00000000" & nin(17 downto 0) & "000000000000" when nin(17)='0' else "11111111" & nin(17 downto 0) & "000000000000";
    v_n_3 <= "000000000" & nin(17 downto 0) & "00000000000" when nin(17)='0' else "111111111" & nin(17 downto 0) & "00000000000";
    v_n_4 <= "00000000000" & nin(17 downto 0) & "000000000" when nin(17)='0' else "11111111111" & nin(17 downto 0) & "000000000";
    v_n_5 <= "0000000000000" & nin(17 downto 0) & "0000000" when nin(17)='0' else "1111111111111" & nin(17 downto 0) & "0000000";
    v_n_6 <= "00000000000000" & nin(17 downto 0) & "000000" when nin(17)='0' else "11111111111111" & nin(17 downto 0) & "000000";
    v_n_7 <= not (v_n_0 + v_n_1 + v_n_2 + v_n_3 + v_n_4 + v_n_5 + v_n_6) + 1;
    v_n <= v_n_7(37 downto 20);

    -- qin * -0.02996826171875 : 00000000.00000111101011000000    38bit
    v_q_0 <= "000000" & qin(17 downto 0) & "00000000000000" when qin(17)='0' else "111111" & qin(17 downto 0) & "00000000000000";
    v_q_1 <= "0000000" & qin(17 downto 0) & "0000000000000" when qin(17)='0' else "1111111" & qin(17 downto 0) & "0000000000000";
    v_q_2 <= "00000000" & qin(17 downto 0) & "000000000000" when qin(17)='0' else "11111111" & qin(17 downto 0) & "000000000000";
    v_q_3 <= "000000000" & qin(17 downto 0) & "00000000000" when qin(17)='0' else "111111111" & qin(17 downto 0) & "00000000000";
    v_q_4 <= "00000000000" & qin(17 downto 0) & "000000000" when qin(17)='0' else "11111111111" & qin(17 downto 0) & "000000000";
    v_q_5 <= "0000000000000" & qin(17 downto 0) & "0000000" when qin(17)='0' else "1111111111111" & qin(17 downto 0) & "0000000";
    v_q_6 <= "00000000000000" & qin(17 downto 0) & "000000" when qin(17)='0' else "11111111111111" & qin(17 downto 0) & "000000";
    v_q_7 <= not (v_q_0 + v_q_1 + v_q_2 + v_q_3 + v_q_4 + v_q_5 + v_q_6) + 1;
    v_q <= v_q_7(37 downto 20);

    -- uin * -0.02996826171875 : 00000000.00000111101011000000    38bit
    v_u_0 <= "000000" & uin(17 downto 0) & "00000000000000" when uin(17)='0' else "111111" & uin(17 downto 0) & "00000000000000";
    v_u_1 <= "0000000" & uin(17 downto 0) & "0000000000000" when uin(17)='0' else "1111111" & uin(17 downto 0) & "0000000000000";
    v_u_2 <= "00000000" & uin(17 downto 0) & "000000000000" when uin(17)='0' else "11111111" & uin(17 downto 0) & "000000000000";
    v_u_3 <= "000000000" & uin(17 downto 0) & "00000000000" when uin(17)='0' else "111111111" & uin(17 downto 0) & "00000000000";
    v_u_4 <= "00000000000" & uin(17 downto 0) & "000000000" when uin(17)='0' else "11111111111" & uin(17 downto 0) & "000000000";
    v_u_5 <= "0000000000000" & uin(17 downto 0) & "0000000" when uin(17)='0' else "1111111111111" & uin(17 downto 0) & "0000000";
    v_u_6 <= "00000000000000" & uin(17 downto 0) & "000000" when uin(17)='0' else "11111111111111" & uin(17 downto 0) & "000000";
    v_u_7 <= not (v_u_0 + v_u_1 + v_u_2 + v_u_3 + v_u_4 + v_u_5 + v_u_6) + 1;
    v_u <= v_u_7(37 downto 20);

    -- Iin * 0.48177433013916016 : 00000000.01111011010101011001    35bit
    v_Iin_0 <= "00" & Iin(17 downto 0) & "000000000000000" when Iin(17)='0' else "11" & Iin(17 downto 0) & "000000000000000";
    v_Iin_1 <= "000" & Iin(17 downto 0) & "00000000000000" when Iin(17)='0' else "111" & Iin(17 downto 0) & "00000000000000";
    v_Iin_2 <= "0000" & Iin(17 downto 0) & "0000000000000" when Iin(17)='0' else "1111" & Iin(17 downto 0) & "0000000000000";
    v_Iin_3 <= "00000" & Iin(17 downto 0) & "000000000000" when Iin(17)='0' else "11111" & Iin(17 downto 0) & "000000000000";
    v_Iin_4 <= "0000000" & Iin(17 downto 0) & "0000000000" when Iin(17)='0' else "1111111" & Iin(17 downto 0) & "0000000000";
    v_Iin_5 <= "00000000" & Iin(17 downto 0) & "000000000" when Iin(17)='0' else "11111111" & Iin(17 downto 0) & "000000000";
    v_Iin_6 <= "0000000000" & Iin(17 downto 0) & "0000000" when Iin(17)='0' else "1111111111" & Iin(17 downto 0) & "0000000";
    v_Iin_7 <= "000000000000" & Iin(17 downto 0) & "00000" when Iin(17)='0' else "111111111111" & Iin(17 downto 0) & "00000";
    v_Iin_8 <= "00000000000000" & Iin(17 downto 0) & "000" when Iin(17)='0' else "11111111111111" & Iin(17 downto 0) & "000";
    v_Iin_9 <= "0000000000000000" & Iin(17 downto 0) & "0" when Iin(17)='0' else "1111111111111111" & Iin(17 downto 0) & "0";
    v_Iin_10 <= "00000000000000000" & Iin(17 downto 0) & "" when Iin(17)='0' else "11111111111111111" & Iin(17 downto 0) & "";
    v_Iin_11 <= "00000000000000000000" & Iin(17 downto 3) & "" when Iin(17)='0' else "11111111111111111111" & Iin(17 downto 3) & "";
    v_Iin_12 <= v_Iin_0 + v_Iin_1 + v_Iin_2 + v_Iin_3 + v_Iin_4 + v_Iin_5 + v_Iin_6 + v_Iin_7 + v_Iin_8 + v_Iin_9 + v_Iin_10 + v_Iin_11;
    v_Iin <= v_Iin_12(34 downto 17);

    -- vv * 0.0931396484375 : 00000000.00010111110110000000    30bit
    n_vv_vS_0 <= "0000" & vv(17 downto 0) & "00000000" when vv(17)='0' else "1111" & vv(17 downto 0) & "00000000";
    n_vv_vS_1 <= "000000" & vv(17 downto 0) & "000000" when vv(17)='0' else "111111" & vv(17 downto 0) & "000000";
    n_vv_vS_2 <= "0000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "1111111" & vv(17 downto 0) & "00000";
    n_vv_vS_3 <= "00000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "11111111" & vv(17 downto 0) & "0000";
    n_vv_vS_4 <= "000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "000";
    n_vv_vS_5 <= "0000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "00";
    n_vv_vS_6 <= "000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "111111111111" & vv(17 downto 0) & "";
    n_vv_vS_7 <= "0000000000000" & vv(17 downto 1) & "" when vv(17)='0' else "1111111111111" & vv(17 downto 1) & "";
    n_vv_vS_8 <= n_vv_vS_0 + n_vv_vS_1 + n_vv_vS_2 + n_vv_vS_3 + n_vv_vS_4 + n_vv_vS_5 + n_vv_vS_6 + n_vv_vS_7;
    n_vv_vS <= n_vv_vS_8(29 downto 12);

    -- vv * 0.46435546875 : 00000000.01110110111000000000    28bit
    n_vv_vL_0 <= "00" & vv(17 downto 0) & "00000000" when vv(17)='0' else "11" & vv(17 downto 0) & "00000000";
    n_vv_vL_1 <= "000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "111" & vv(17 downto 0) & "0000000";
    n_vv_vL_2 <= "0000" & vv(17 downto 0) & "000000" when vv(17)='0' else "1111" & vv(17 downto 0) & "000000";
    n_vv_vL_3 <= "000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "111111" & vv(17 downto 0) & "0000";
    n_vv_vL_4 <= "0000000" & vv(17 downto 0) & "000" when vv(17)='0' else "1111111" & vv(17 downto 0) & "000";
    n_vv_vL_5 <= "000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "111111111" & vv(17 downto 0) & "0";
    n_vv_vL_6 <= "0000000000" & vv(17 downto 0) & "" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "";
    n_vv_vL_7 <= "00000000000" & vv(17 downto 1) & "" when vv(17)='0' else "11111111111" & vv(17 downto 1) & "";
    n_vv_vL_8 <= n_vv_vL_0 + n_vv_vL_1 + n_vv_vL_2 + n_vv_vL_3 + n_vv_vL_4 + n_vv_vL_5 + n_vv_vL_6 + n_vv_vL_7;
    n_vv_vL <= n_vv_vL_8(27 downto 10);

    -- vin * 0.11005687713623047 : 00000000.00011100001011001011    37bit
    n_v_vS_0 <= "0000" & vin(17 downto 0) & "000000000000000" when vin(17)='0' else "1111" & vin(17 downto 0) & "000000000000000";
    n_v_vS_1 <= "00000" & vin(17 downto 0) & "00000000000000" when vin(17)='0' else "11111" & vin(17 downto 0) & "00000000000000";
    n_v_vS_2 <= "000000" & vin(17 downto 0) & "0000000000000" when vin(17)='0' else "111111" & vin(17 downto 0) & "0000000000000";
    n_v_vS_3 <= "00000000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "00000000";
    n_v_vS_4 <= "0000000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "000000";
    n_v_vS_5 <= "00000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "00000";
    n_v_vS_6 <= "00000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "00";
    n_v_vS_7 <= "0000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 0) & "";
    n_v_vS_8 <= "00000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111111111" & vin(17 downto 1) & "";
    n_v_vS_9 <= n_v_vS_0 + n_v_vS_1 + n_v_vS_2 + n_v_vS_3 + n_v_vS_4 + n_v_vS_5 + n_v_vS_6 + n_v_vS_7 + n_v_vS_8;
    n_v_vS <= n_v_vS_9(36 downto 19);

    -- vin * -0.4453096389770508 : 00000000.01110001111111111101    38bit
    n_v_vL_0 <= "00" & vin(17 downto 0) & "000000000000000000" when vin(17)='0' else "11" & vin(17 downto 0) & "000000000000000000";
    n_v_vL_1 <= "000" & vin(17 downto 0) & "00000000000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "00000000000000000";
    n_v_vL_2 <= "0000" & vin(17 downto 0) & "0000000000000000" when vin(17)='0' else "1111" & vin(17 downto 0) & "0000000000000000";
    n_v_vL_3 <= "00000000" & vin(17 downto 0) & "000000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "000000000000";
    n_v_vL_4 <= "000000000" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "00000000000";
    n_v_vL_5 <= "0000000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "0000000000";
    n_v_vL_6 <= "00000000000" & vin(17 downto 0) & "000000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "000000000";
    n_v_vL_7 <= "000000000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "00000000";
    n_v_vL_8 <= "0000000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "0000000";
    n_v_vL_9 <= "00000000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "000000";
    n_v_vL_10 <= "000000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "00000";
    n_v_vL_11 <= "0000000000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "0000";
    n_v_vL_12 <= "00000000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "000";
    n_v_vL_13 <= "000000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "111111111111111111" & vin(17 downto 0) & "00";
    n_v_vL_14 <= "00000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "11111111111111111111" & vin(17 downto 0) & "";
    n_v_vL_15 <= not (n_v_vL_0 + n_v_vL_1 + n_v_vL_2 + n_v_vL_3 + n_v_vL_4 + n_v_vL_5 + n_v_vL_6 + n_v_vL_7 + n_v_vL_8 + n_v_vL_9 + n_v_vL_10 + n_v_vL_11 + n_v_vL_12 + n_v_vL_13 + n_v_vL_14) + 1;
    n_v_vL <= n_v_vL_15(37 downto 20);

    -- nin * -0.0625 : 00000000.00010000000000000000    38bit
    n_n_0 <= "0000" & nin(17 downto 0) & "0000000000000000" when nin(17)='0' else "1111" & nin(17 downto 0) & "0000000000000000";
    n_n_1 <= not (n_n_0) + 1;
    n_n <= n_n_1(37 downto 20);

    -- vv * -4.1961669921875e-05 : 00000000.00000000000000101100    38bit
    q_vv_vS_0 <= "000000000000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "00000";
    q_vv_vS_1 <= "00000000000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "11111111111111111" & vv(17 downto 0) & "000";
    q_vv_vS_2 <= "000000000000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "111111111111111111" & vv(17 downto 0) & "00";
    q_vv_vS_3 <= not (q_vv_vS_0 + q_vv_vS_1 + q_vv_vS_2) + 1;
    q_vv_vS <= q_vv_vS_3(37 downto 20);

    -- vv * 4.100799560546875e-05 : 00000000.00000000000000101011    37bit
    q_vv_vL_0 <= "000000000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "0000";
    q_vv_vL_1 <= "00000000000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "11111111111111111" & vv(17 downto 0) & "00";
    q_vv_vL_2 <= "0000000000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "1111111111111111111" & vv(17 downto 0) & "";
    q_vv_vL_3 <= "00000000000000000000" & vv(17 downto 1) & "" when vv(17)='0' else "11111111111111111111" & vv(17 downto 1) & "";
    q_vv_vL_4 <= q_vv_vL_0 + q_vv_vL_1 + q_vv_vL_2 + q_vv_vL_3;
    q_vv_vL <= q_vv_vL_4(36 downto 19);

    -- vin * 0.00020122528076171875 : 00000000.00000000000011010011    37bit
    q_v_vS_0 <= "0000000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "000000";
    q_v_vS_1 <= "00000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "00000";
    q_v_vS_2 <= "0000000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "000";
    q_v_vS_3 <= "0000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 0) & "";
    q_v_vS_4 <= "00000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111111111" & vin(17 downto 1) & "";
    q_v_vS_5 <= q_v_vS_0 + q_v_vS_1 + q_v_vS_2 + q_v_vS_3 + q_v_vS_4;
    q_v_vS <= q_v_vS_5(36 downto 19);

    -- vin * 0.00030422210693359375 : 00000000.00000000000100111111    37bit
    q_v_vL_0 <= "000000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "111111111111" & vin(17 downto 0) & "0000000";
    q_v_vL_1 <= "000000000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "0000";
    q_v_vL_2 <= "0000000000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "000";
    q_v_vL_3 <= "00000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "00";
    q_v_vL_4 <= "000000000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "111111111111111111" & vin(17 downto 0) & "0";
    q_v_vL_5 <= "0000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 0) & "";
    q_v_vL_6 <= "00000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111111111" & vin(17 downto 1) & "";
    q_v_vL_7 <= q_v_vL_0 + q_v_vL_1 + q_v_vL_2 + q_v_vL_3 + q_v_vL_4 + q_v_vL_5 + q_v_vL_6;
    q_v_vL <= q_v_vL_7(36 downto 19);

    -- qin * -0.0004119873046875 : 00000000.00000000000110110000    38bit
    q_q_0 <= "000000000000" & qin(17 downto 0) & "00000000" when qin(17)='0' else "111111111111" & qin(17 downto 0) & "00000000";
    q_q_1 <= "0000000000000" & qin(17 downto 0) & "0000000" when qin(17)='0' else "1111111111111" & qin(17 downto 0) & "0000000";
    q_q_2 <= "000000000000000" & qin(17 downto 0) & "00000" when qin(17)='0' else "111111111111111" & qin(17 downto 0) & "00000";
    q_q_3 <= "0000000000000000" & qin(17 downto 0) & "0000" when qin(17)='0' else "1111111111111111" & qin(17 downto 0) & "0000";
    q_q_4 <= not (q_q_0 + q_q_1 + q_q_2 + q_q_3) + 1;
    q_q <= q_q_4(37 downto 20);

    -- vin * 0.0006103515625 : 00000000.00000000001010000000    29bit
    u_v_0 <= "00000000000" & vin(17 downto 0) & "" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "";
    u_v_1 <= "0000000000000" & vin(17 downto 2) & "" when vin(17)='0' else "1111111111111" & vin(17 downto 2) & "";
    u_v_2 <= u_v_0 + u_v_1;
    u_v <= u_v_2(28 downto 11);

    -- uin * -0.0005941390991210938 : 00000000.00000000001001101111    38bit
    u_u_0 <= "00000000000" & uin(17 downto 0) & "000000000" when uin(17)='0' else "11111111111" & uin(17 downto 0) & "000000000";
    u_u_1 <= "00000000000000" & uin(17 downto 0) & "000000" when uin(17)='0' else "11111111111111" & uin(17 downto 0) & "000000";
    u_u_2 <= "000000000000000" & uin(17 downto 0) & "00000" when uin(17)='0' else "111111111111111" & uin(17 downto 0) & "00000";
    u_u_3 <= "00000000000000000" & uin(17 downto 0) & "000" when uin(17)='0' else "11111111111111111" & uin(17 downto 0) & "000";
    u_u_4 <= "000000000000000000" & uin(17 downto 0) & "00" when uin(17)='0' else "111111111111111111" & uin(17 downto 0) & "00";
    u_u_5 <= "0000000000000000000" & uin(17 downto 0) & "0" when uin(17)='0' else "1111111111111111111" & uin(17 downto 0) & "0";
    u_u_6 <= "00000000000000000000" & uin(17 downto 0) & "" when uin(17)='0' else "11111111111111111111" & uin(17 downto 0) & "";
    u_u_7 <= not (u_u_0 + u_u_1 + u_u_2 + u_u_3 + u_u_4 + u_u_5 + u_u_6) + 1;
    u_u <= u_u_7(37 downto 20);

    -- n0_3rd * 1.7509765625 : 00000001.11000000010000000000    20bit
    n_uS_0 <= n0_3rd & "00";
    n_uS_1 <= "0" & n0_3rd(17 downto 0) & "0" when n0_3rd(17)='0' else "1" & n0_3rd(17 downto 0) & "0";
    n_uS_2 <= "00" & n0_3rd(17 downto 0) & "" when n0_3rd(17)='0' else "11" & n0_3rd(17 downto 0) & "";
    n_uS_3 <= "0000000000" & n0_3rd(17 downto 8) & "" when n0_3rd(17)='0' else "1111111111" & n0_3rd(17 downto 8) & "";
    n_uS_4 <= n_uS_0 + n_uS_1 + n_uS_2 + n_uS_3;
    n_uS <= n_uS_4(19 downto 2);

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
--tau= 0.0016
--afn= 1.80859375
--afp= -0.0048828125
--bfn= -1.1787109375
--bfp= 436.59375
--cfn= 0.0
--cfp= 933.2490234375
--agn= 1.490234375
--agp= 7.4296875
--bgn= -0.5908203125
--bgp= 0.4794921875
--cgn= 0.0
--cgp= 2.1376953125
--ahn= -0.103515625
--ahp= 0.099609375
--bhn= 2.361328125
--bhp= -3.7158203125
--chn= -0.048828125
--chp= -1.923828125
--rg= 0.7490234375
--rh= -0.619140625
--phi= 0.4794921875
--epsq= 0.006591796875
--epsu= 0.009765625
--I0= -4.6455078125
--Ix= 16.076171875
--nx= 1.7509765625
--uth= -6.5185546875
--alpu= 0.974609375
--v_vv_vS=0.054200172424316406
--v_vv_vL=-0.00014591217041015625
--v_v_vS=0.12777233123779297
--v_v_vL=0.12777233123779297
--v_n=-0.02996826171875
--v_q=-0.02996826171875
--v_u=-0.02996826171875
--v_Iin=0.48177433013916016
--n_vv_vS=0.0931396484375
--n_vv_vL=0.46435546875
--n_v_vS=0.11005687713623047
--n_v_vL=-0.4453096389770508
--n_n=-0.0625
--q_vv_vS=-4.1961669921875e-05
--q_vv_vL=4.100799560546875e-05
--q_v_vS=0.00020122528076171875
--q_v_vL=0.00030422210693359375
--q_q=-0.0004119873046875
--u_v=0.0006103515625
--u_u=-0.0005941390991210938
--n_uS=1.7509765625
--n_uL=1
--s_S=-0.00390625
--s_L=-0.015625
--v_c_vS=-0.0634765625
--v_c_vL=-0.0634765625
--n_c_vS=0.0322265625
--n_c_vL=0.240234375
--q_c_vS=0.0
--q_c_vL=0.0
--u_c=0.0
--s_c_L=0.015625
--crf=0
--crg=0.7490234375
--crh=-0.619140625
--vini=-4.8251953125
--nini=26.6904296875
--qini=-7.36328125
--vth=0
--uth=-6.5185546875