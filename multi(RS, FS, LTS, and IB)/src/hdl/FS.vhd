------------------------------------------------------
-- Author: Takuya Nanami
-- Model: PQN model
-- Mode: FS
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
entity FS is
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
end FS;
architecture Behavioral of FS is
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
    SIGNAL v_vv_vS_0 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_1 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_2 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_3 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_4 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_5 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_6 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_7 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vS_8 : std_logic_vector(31 downto 0);
    SIGNAL v_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL v_vv_vL_0 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_1 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_2 : std_logic_vector(37 downto 0);
    SIGNAL v_vv_vL_3 : std_logic_vector(37 downto 0);
    SIGNAL v_v_vS : std_logic_vector(17 downto 0);
    SIGNAL v_v_vS_0 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_1 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_2 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_3 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_4 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_5 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vS_6 : std_logic_vector(30 downto 0);
    SIGNAL v_v_vL : std_logic_vector(17 downto 0);
    SIGNAL v_v_vL_0 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vL_1 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vL_2 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vL_3 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vL_4 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vL_5 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vL_6 : std_logic_vector(32 downto 0);
    SIGNAL v_v_vL_7 : std_logic_vector(32 downto 0);
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
    SIGNAL v_Iin_0 : std_logic_vector(35 downto 0);
    SIGNAL v_Iin_1 : std_logic_vector(35 downto 0);
    SIGNAL v_Iin_2 : std_logic_vector(35 downto 0);
    SIGNAL v_Iin_3 : std_logic_vector(35 downto 0);
    SIGNAL v_Iin_4 : std_logic_vector(35 downto 0);
    SIGNAL v_Iin_5 : std_logic_vector(35 downto 0);
    SIGNAL v_Iin_6 : std_logic_vector(35 downto 0);
    SIGNAL v_Iin_7 : std_logic_vector(35 downto 0);
    SIGNAL v_Iin_8 : std_logic_vector(35 downto 0);
    SIGNAL v_Iin_9 : std_logic_vector(35 downto 0);
    SIGNAL v_Iin_10 : std_logic_vector(35 downto 0);
    SIGNAL n_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vS_0 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vS_1 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vS_2 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vS_3 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vS_4 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vS_5 : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL n_vv_vL_0 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vL_1 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vL_2 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vL_3 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vL_4 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vL_5 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vL_6 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vL_7 : std_logic_vector(28 downto 0);
    SIGNAL n_vv_vL_8 : std_logic_vector(28 downto 0);
    SIGNAL n_v_vS : std_logic_vector(17 downto 0);
    SIGNAL n_v_vS_0 : std_logic_vector(34 downto 0);
    SIGNAL n_v_vS_1 : std_logic_vector(34 downto 0);
    SIGNAL n_v_vS_2 : std_logic_vector(34 downto 0);
    SIGNAL n_v_vS_3 : std_logic_vector(34 downto 0);
    SIGNAL n_v_vS_4 : std_logic_vector(34 downto 0);
    SIGNAL n_v_vS_5 : std_logic_vector(34 downto 0);
    SIGNAL n_v_vS_6 : std_logic_vector(34 downto 0);
    SIGNAL n_v_vS_7 : std_logic_vector(34 downto 0);
    SIGNAL n_v_vS_8 : std_logic_vector(34 downto 0);
    SIGNAL n_v_vS_9 : std_logic_vector(34 downto 0);
    SIGNAL n_v_vL : std_logic_vector(17 downto 0);
    SIGNAL n_v_vL_0 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_1 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_2 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_3 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_4 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_5 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_6 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_7 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_8 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_9 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_10 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_11 : std_logic_vector(35 downto 0);
    SIGNAL n_v_vL_12 : std_logic_vector(35 downto 0);
    SIGNAL n_n : std_logic_vector(17 downto 0);
    SIGNAL n_n_0 : std_logic_vector(37 downto 0);
    SIGNAL n_n_1 : std_logic_vector(37 downto 0);
    SIGNAL q_vv_vS : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vL : std_logic_vector(17 downto 0);
    SIGNAL q_vv_vL_0 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_1 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_2 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_3 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_4 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_5 : std_logic_vector(32 downto 0);
    SIGNAL q_vv_vL_6 : std_logic_vector(32 downto 0);
    SIGNAL q_v_vS : std_logic_vector(17 downto 0);
    SIGNAL q_v_vL : std_logic_vector(17 downto 0);
    SIGNAL q_v_vL_0 : std_logic_vector(30 downto 0);
    SIGNAL q_v_vL_1 : std_logic_vector(30 downto 0);
    SIGNAL q_v_vL_2 : std_logic_vector(30 downto 0);
    SIGNAL q_v_vL_3 : std_logic_vector(30 downto 0);
    SIGNAL q_v_vL_4 : std_logic_vector(30 downto 0);
    SIGNAL q_v_vL_5 : std_logic_vector(30 downto 0);
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
    SIGNAL v_c_vS : std_logic_vector(17 downto 0):="000000000001101011";-- 0.1044921875
    SIGNAL v_c_vL : std_logic_vector(17 downto 0):="000000000001101011";-- 0.1044921875
    SIGNAL n_c_vS : std_logic_vector(17 downto 0):="000000000001000010";-- 0.064453125
    SIGNAL n_c_vL : std_logic_vector(17 downto 0):="000000001100100111";-- 0.7880859375
    SIGNAL q_c_vS : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0
    SIGNAL q_c_vL : std_logic_vector(17 downto 0):="000000000000101111";-- 0.0458984375
    SIGNAL s_c_L : std_logic_vector(17 downto 0):="000000000000010000";-- 0.015625
    SIGNAL crf : std_logic_vector(17 downto 0):="000000000000000000";-- 0
    SIGNAL crg : std_logic_vector(17 downto 0):="111111110001101100";-- -0.89453125
    SIGNAL crh : std_logic_vector(17 downto 0):="111111000101000000";-- -3.6875
    SIGNAL vini : std_logic_vector(17 downto 0):="111110101011010001";-- -5.2958984375
    SIGNAL nini : std_logic_vector(17 downto 0):="000101101111110000";-- 22.984375
    SIGNAL qini : std_logic_vector(17 downto 0):="000000000000000000";-- 0.0
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
    -- vv * 0.038787841796875 : 00000000.00001001111011100000    32bit
    v_vv_vS_0 <= "00000" & vv(17 downto 0) & "000000000" when vv(17)='0' else "11111" & vv(17 downto 0) & "000000000";
    v_vv_vS_1 <= "00000000" & vv(17 downto 0) & "000000" when vv(17)='0' else "11111111" & vv(17 downto 0) & "000000";
    v_vv_vS_2 <= "000000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "00000";
    v_vv_vS_3 <= "0000000000" & vv(17 downto 0) & "0000" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "0000";
    v_vv_vS_4 <= "00000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "000";
    v_vv_vS_5 <= "0000000000000" & vv(17 downto 0) & "0" when vv(17)='0' else "1111111111111" & vv(17 downto 0) & "0";
    v_vv_vS_6 <= "00000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "11111111111111" & vv(17 downto 0) & "";
    v_vv_vS_7 <= "000000000000000" & vv(17 downto 1) & "" when vv(17)='0' else "111111111111111" & vv(17 downto 1) & "";
    v_vv_vS_8 <= v_vv_vS_0 + v_vv_vS_1 + v_vv_vS_2 + v_vv_vS_3 + v_vv_vS_4 + v_vv_vS_5 + v_vv_vS_6 + v_vv_vS_7;
    v_vv_vS <= v_vv_vS_8(31 downto 14);

    -- vv * -0.02001953125 : 00000000.00000101001000000000    38bit
    v_vv_vL_0 <= "000000" & vv(17 downto 0) & "00000000000000" when vv(17)='0' else "111111" & vv(17 downto 0) & "00000000000000";
    v_vv_vL_1 <= "00000000" & vv(17 downto 0) & "000000000000" when vv(17)='0' else "11111111" & vv(17 downto 0) & "000000000000";
    v_vv_vL_2 <= "00000000000" & vv(17 downto 0) & "000000000" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "000000000";
    v_vv_vL_3 <= not (v_vv_vL_0 + v_vv_vL_1 + v_vv_vL_2) + 1;
    v_vv_vL <= v_vv_vL_3(37 downto 20);

    -- vin * 0.13787841796875 : 00000000.00100011010011000000    31bit
    v_v_vS_0 <= "000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "0000000000";
    v_v_vS_1 <= "0000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "000000";
    v_v_vS_2 <= "00000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "00000";
    v_v_vS_3 <= "0000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "000";
    v_v_vS_4 <= "0000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "";
    v_v_vS_5 <= "00000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "11111111111111" & vin(17 downto 1) & "";
    v_v_vS_6 <= v_v_vS_0 + v_v_vS_1 + v_v_vS_2 + v_v_vS_3 + v_v_vS_4 + v_v_vS_5;
    v_v_vS <= v_v_vS_6(30 downto 13);

    -- vin * 0.13779067993164062 : 00000000.00100011010001100100    33bit
    v_v_vL_0 <= "000" & vin(17 downto 0) & "000000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "000000000000";
    v_v_vL_1 <= "0000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "00000000";
    v_v_vL_2 <= "00000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "0000000";
    v_v_vL_3 <= "0000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "00000";
    v_v_vL_4 <= "00000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "0";
    v_v_vL_5 <= "000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "111111111111111" & vin(17 downto 0) & "";
    v_v_vL_6 <= "000000000000000000" & vin(17 downto 3) & "" when vin(17)='0' else "111111111111111111" & vin(17 downto 3) & "";
    v_v_vL_7 <= v_v_vL_0 + v_v_vL_1 + v_v_vL_2 + v_v_vL_3 + v_v_vL_4 + v_v_vL_5 + v_v_vL_6;
    v_v_vL <= v_v_vL_7(32 downto 15);

    -- nin * -0.02001953125 : 00000000.00000101001000000000    38bit
    v_n_0 <= "000000" & nin(17 downto 0) & "00000000000000" when nin(17)='0' else "111111" & nin(17 downto 0) & "00000000000000";
    v_n_1 <= "00000000" & nin(17 downto 0) & "000000000000" when nin(17)='0' else "11111111" & nin(17 downto 0) & "000000000000";
    v_n_2 <= "00000000000" & nin(17 downto 0) & "000000000" when nin(17)='0' else "11111111111" & nin(17 downto 0) & "000000000";
    v_n_3 <= not (v_n_0 + v_n_1 + v_n_2) + 1;
    v_n <= v_n_3(37 downto 20);

    -- qin * -0.02001953125 : 00000000.00000101001000000000    38bit
    v_q_0 <= "000000" & qin(17 downto 0) & "00000000000000" when qin(17)='0' else "111111" & qin(17 downto 0) & "00000000000000";
    v_q_1 <= "00000000" & qin(17 downto 0) & "000000000000" when qin(17)='0' else "11111111" & qin(17 downto 0) & "000000000000";
    v_q_2 <= "00000000000" & qin(17 downto 0) & "000000000" when qin(17)='0' else "11111111111" & qin(17 downto 0) & "000000000";
    v_q_3 <= not (v_q_0 + v_q_1 + v_q_2) + 1;
    v_q <= v_q_3(37 downto 20);

    -- Iin * 0.8817195892333984 : 00000000.11100001101110000110    36bit
    v_Iin_0 <= "0" & Iin(17 downto 0) & "00000000000000000" when Iin(17)='0' else "1" & Iin(17 downto 0) & "00000000000000000";
    v_Iin_1 <= "00" & Iin(17 downto 0) & "0000000000000000" when Iin(17)='0' else "11" & Iin(17 downto 0) & "0000000000000000";
    v_Iin_2 <= "000" & Iin(17 downto 0) & "000000000000000" when Iin(17)='0' else "111" & Iin(17 downto 0) & "000000000000000";
    v_Iin_3 <= "00000000" & Iin(17 downto 0) & "0000000000" when Iin(17)='0' else "11111111" & Iin(17 downto 0) & "0000000000";
    v_Iin_4 <= "000000000" & Iin(17 downto 0) & "000000000" when Iin(17)='0' else "111111111" & Iin(17 downto 0) & "000000000";
    v_Iin_5 <= "00000000000" & Iin(17 downto 0) & "0000000" when Iin(17)='0' else "11111111111" & Iin(17 downto 0) & "0000000";
    v_Iin_6 <= "000000000000" & Iin(17 downto 0) & "000000" when Iin(17)='0' else "111111111111" & Iin(17 downto 0) & "000000";
    v_Iin_7 <= "0000000000000" & Iin(17 downto 0) & "00000" when Iin(17)='0' else "1111111111111" & Iin(17 downto 0) & "00000";
    v_Iin_8 <= "000000000000000000" & Iin(17 downto 0) & "" when Iin(17)='0' else "111111111111111111" & Iin(17 downto 0) & "";
    v_Iin_9 <= "0000000000000000000" & Iin(17 downto 1) & "" when Iin(17)='0' else "1111111111111111111" & Iin(17 downto 1) & "";
    v_Iin_10 <= v_Iin_0 + v_Iin_1 + v_Iin_2 + v_Iin_3 + v_Iin_4 + v_Iin_5 + v_Iin_6 + v_Iin_7 + v_Iin_8 + v_Iin_9;
    v_Iin <= v_Iin_10(35 downto 18);

    -- vv * 0.075439453125 : 00000000.00010011010100000000    28bit
    n_vv_vS_0 <= "0000" & vv(17 downto 0) & "000000" when vv(17)='0' else "1111" & vv(17 downto 0) & "000000";
    n_vv_vS_1 <= "0000000" & vv(17 downto 0) & "000" when vv(17)='0' else "1111111" & vv(17 downto 0) & "000";
    n_vv_vS_2 <= "00000000" & vv(17 downto 0) & "00" when vv(17)='0' else "11111111" & vv(17 downto 0) & "00";
    n_vv_vS_3 <= "0000000000" & vv(17 downto 0) & "" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "";
    n_vv_vS_4 <= "000000000000" & vv(17 downto 2) & "" when vv(17)='0' else "111111111111" & vv(17 downto 2) & "";
    n_vv_vS_5 <= n_vv_vS_0 + n_vv_vS_1 + n_vv_vS_2 + n_vv_vS_3 + n_vv_vS_4;
    n_vv_vS <= n_vv_vS_5(27 downto 10);

    -- vv * 0.985107421875 : 00000000.11111100001100000000    29bit
    n_vv_vL_0 <= "0" & vv(17 downto 0) & "0000000000" when vv(17)='0' else "1" & vv(17 downto 0) & "0000000000";
    n_vv_vL_1 <= "00" & vv(17 downto 0) & "000000000" when vv(17)='0' else "11" & vv(17 downto 0) & "000000000";
    n_vv_vL_2 <= "000" & vv(17 downto 0) & "00000000" when vv(17)='0' else "111" & vv(17 downto 0) & "00000000";
    n_vv_vL_3 <= "0000" & vv(17 downto 0) & "0000000" when vv(17)='0' else "1111" & vv(17 downto 0) & "0000000";
    n_vv_vL_4 <= "00000" & vv(17 downto 0) & "000000" when vv(17)='0' else "11111" & vv(17 downto 0) & "000000";
    n_vv_vL_5 <= "000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "111111" & vv(17 downto 0) & "00000";
    n_vv_vL_6 <= "00000000000" & vv(17 downto 0) & "" when vv(17)='0' else "11111111111" & vv(17 downto 0) & "";
    n_vv_vL_7 <= "000000000000" & vv(17 downto 1) & "" when vv(17)='0' else "111111111111" & vv(17 downto 1) & "";
    n_vv_vL_8 <= n_vv_vL_0 + n_vv_vL_1 + n_vv_vL_2 + n_vv_vL_3 + n_vv_vL_4 + n_vv_vL_5 + n_vv_vL_6 + n_vv_vL_7;
    n_vv_vL <= n_vv_vL_8(28 downto 11);

    -- vin * 0.14027023315429688 : 00000000.00100011111010001100    35bit
    n_v_vS_0 <= "000" & vin(17 downto 0) & "00000000000000" when vin(17)='0' else "111" & vin(17 downto 0) & "00000000000000";
    n_v_vS_1 <= "0000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "0000000000";
    n_v_vS_2 <= "00000000" & vin(17 downto 0) & "000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "000000000";
    n_v_vS_3 <= "000000000" & vin(17 downto 0) & "00000000" when vin(17)='0' else "111111111" & vin(17 downto 0) & "00000000";
    n_v_vS_4 <= "0000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "0000000";
    n_v_vS_5 <= "00000000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "000000";
    n_v_vS_6 <= "0000000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "0000";
    n_v_vS_7 <= "00000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "";
    n_v_vS_8 <= "000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "111111111111111111" & vin(17 downto 1) & "";
    n_v_vS_9 <= n_v_vS_0 + n_v_vS_1 + n_v_vS_2 + n_v_vS_3 + n_v_vS_4 + n_v_vS_5 + n_v_vS_6 + n_v_vS_7 + n_v_vS_8;
    n_v_vS <= n_v_vS_9(34 downto 17);

    -- vin * 1.7624187469482422 : 00000001.11000011001011011110    36bit
    n_v_vL_0 <= vin & "000000000000000000";
    n_v_vL_1 <= "0" & vin(17 downto 0) & "00000000000000000" when vin(17)='0' else "1" & vin(17 downto 0) & "00000000000000000";
    n_v_vL_2 <= "00" & vin(17 downto 0) & "0000000000000000" when vin(17)='0' else "11" & vin(17 downto 0) & "0000000000000000";
    n_v_vL_3 <= "0000000" & vin(17 downto 0) & "00000000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "00000000000";
    n_v_vL_4 <= "00000000" & vin(17 downto 0) & "0000000000" when vin(17)='0' else "11111111" & vin(17 downto 0) & "0000000000";
    n_v_vL_5 <= "00000000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "11111111111" & vin(17 downto 0) & "0000000";
    n_v_vL_6 <= "0000000000000" & vin(17 downto 0) & "00000" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "00000";
    n_v_vL_7 <= "00000000000000" & vin(17 downto 0) & "0000" when vin(17)='0' else "11111111111111" & vin(17 downto 0) & "0000";
    n_v_vL_8 <= "0000000000000000" & vin(17 downto 0) & "00" when vin(17)='0' else "1111111111111111" & vin(17 downto 0) & "00";
    n_v_vL_9 <= "00000000000000000" & vin(17 downto 0) & "0" when vin(17)='0' else "11111111111111111" & vin(17 downto 0) & "0";
    n_v_vL_10 <= "000000000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "111111111111111111" & vin(17 downto 0) & "";
    n_v_vL_11 <= "0000000000000000000" & vin(17 downto 1) & "" when vin(17)='0' else "1111111111111111111" & vin(17 downto 1) & "";
    n_v_vL_12 <= n_v_vL_0 + n_v_vL_1 + n_v_vL_2 + n_v_vL_3 + n_v_vL_4 + n_v_vL_5 + n_v_vL_6 + n_v_vL_7 + n_v_vL_8 + n_v_vL_9 + n_v_vL_10 + n_v_vL_11;
    n_v_vL <= n_v_vL_12(35 downto 18);

    -- nin * -0.0625 : 00000000.00010000000000000000    38bit
    n_n_0 <= "0000" & nin(17 downto 0) & "0000000000000000" when nin(17)='0' else "1111" & nin(17 downto 0) & "0000000000000000";
    n_n_1 <= not (n_n_0) + 1;
    n_n <= n_n_1(37 downto 20);

    -- vv * 0.0 : 00000000.00000000000000000000    18bit
    q_vv_vS <= "000000000000000000";

    -- vv * 0.0033273696899414062 : 00000000.00000000110110100001    33bit
    q_vv_vL_0 <= "000000000" & vv(17 downto 0) & "000000" when vv(17)='0' else "111111111" & vv(17 downto 0) & "000000";
    q_vv_vL_1 <= "0000000000" & vv(17 downto 0) & "00000" when vv(17)='0' else "1111111111" & vv(17 downto 0) & "00000";
    q_vv_vL_2 <= "000000000000" & vv(17 downto 0) & "000" when vv(17)='0' else "111111111111" & vv(17 downto 0) & "000";
    q_vv_vL_3 <= "0000000000000" & vv(17 downto 0) & "00" when vv(17)='0' else "1111111111111" & vv(17 downto 0) & "00";
    q_vv_vL_4 <= "000000000000000" & vv(17 downto 0) & "" when vv(17)='0' else "111111111111111" & vv(17 downto 0) & "";
    q_vv_vL_5 <= "00000000000000000000" & vv(17 downto 5) & "" when vv(17)='0' else "11111111111111111111" & vv(17 downto 5) & "";
    q_vv_vL_6 <= q_vv_vL_0 + q_vv_vL_1 + q_vv_vL_2 + q_vv_vL_3 + q_vv_vL_4 + q_vv_vL_5;
    q_vv_vL <= q_vv_vL_6(32 downto 15);

    -- vin * 0.0 : 00000000.00000000000000000000    18bit
    q_v_vS <= "000000000000000000";

    -- vin * 0.02454376220703125 : 00000000.00000110010010001000    31bit
    q_v_vL_0 <= "000000" & vin(17 downto 0) & "0000000" when vin(17)='0' else "111111" & vin(17 downto 0) & "0000000";
    q_v_vL_1 <= "0000000" & vin(17 downto 0) & "000000" when vin(17)='0' else "1111111" & vin(17 downto 0) & "000000";
    q_v_vL_2 <= "0000000000" & vin(17 downto 0) & "000" when vin(17)='0' else "1111111111" & vin(17 downto 0) & "000";
    q_v_vL_3 <= "0000000000000" & vin(17 downto 0) & "" when vin(17)='0' else "1111111111111" & vin(17 downto 0) & "";
    q_v_vL_4 <= "00000000000000000" & vin(17 downto 4) & "" when vin(17)='0' else "11111111111111111" & vin(17 downto 4) & "";
    q_v_vL_5 <= q_v_vL_0 + q_v_vL_1 + q_v_vL_2 + q_v_vL_3 + q_v_vL_4;
    q_v_vL <= q_v_vL_5(30 downto 13);

    -- qin * -0.001007080078125 : 00000000.00000000010000100000    38bit
    q_q_0 <= "0000000000" & qin(17 downto 0) & "0000000000" when qin(17)='0' else "1111111111" & qin(17 downto 0) & "0000000000";
    q_q_1 <= "000000000000000" & qin(17 downto 0) & "00000" when qin(17)='0' else "111111111111111" & qin(17 downto 0) & "00000";
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
--tau= 0.0016
--afn= 1.9375
--afp= -1.0
--bfn= -1.77734375
--bfp= 3.44140625
--cfn= 0.0
--cfp= 17.9765625
--agn= 1.20703125
--agp= 15.76171875
--bgn= -0.9296875
--bgp= -0.89453125
--cgn= 0.0
--cgp= 0.0
--ahn= 0.0
--ahp= 3.3046875
--bhn= -10.94921875
--bhp= -3.6875
--chn= 0.74609375
--chp= 0.74609375
--rg= -0.89453125
--rh= -3.6875
--phi= 0.3203125
--epsq= 0.01611328125
--epsu= 0.0
--I0= -0.8984375
--Ix= 44.04296875
--nx= 1.0
--uth= 0.0
--alpu= 0.0
--v_vv_vS=0.038787841796875
--v_vv_vL=-0.02001953125
--v_v_vS=0.13787841796875
--v_v_vL=0.13779067993164062
--v_n=-0.02001953125
--v_q=-0.02001953125
--v_Iin=0.8817195892333984
--n_vv_vS=0.075439453125
--n_vv_vL=0.985107421875
--n_v_vS=0.14027023315429688
--n_v_vL=1.7624187469482422
--n_n=-0.0625
--q_vv_vS=0.0
--q_vv_vL=0.0033273696899414062
--q_v_vS=0.0
--q_v_vL=0.02454376220703125
--q_q=-0.001007080078125
--s_S=-0.00390625
--s_L=-0.015625
--v_c_vS=0.1044921875
--v_c_vL=0.1044921875
--n_c_vS=0.064453125
--n_c_vL=0.7880859375
--q_c_vS=0.0
--q_c_vL=0.0458984375
--s_c_L=0.015625
--crf=0
--crg=-0.89453125
--crh=-3.6875
--vini=-5.2958984375
--nini=22.984375
--qini=0.0
--vth=0