------------------------------------------------------
-- Author: Takuya Nanami
-- Model: PQN model
-- Mode: Class2
-- Port Descriptions:
--    clk: clock
--    PORT_Iin: Stimulus input
--    PORT_vin/out: Membrane potential
--    PORT_nin/out: Recovery variable
--    PORT_spike_flag: This becomes 1 only when a spike occurs
------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.ALL;
entity Class2 is
PORT(
    clk : IN STD_LOGIC;
    PORT_Iin : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    PORT_vin : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    PORT_nin : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    PORT_sin : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    PORT_vout : OUT STD_LOGIC_VECTOR(27 DOWNTO 0);
    PORT_nout : OUT STD_LOGIC_VECTOR(27 DOWNTO 0);
    PORT_sout : OUT STD_LOGIC_VECTOR(27 DOWNTO 0);
    PORT_spike_flag : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
);
end Class2;
architecture Behavioral of Class2 is
    TYPE STATE_TYPE IS (READY);
    SIGNAL STATE : STATE_TYPE := READY;
    SIGNAL Iin : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vin : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nin : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sin : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vv36 : STD_LOGIC_VECTOR(55 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vv : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vin_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nin_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sin_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vin_3rd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nin_3rd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sin_3rd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL vout_3rd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nout_3rd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sout_3rd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_vS_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_vL_2nd: STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_v_vS_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_v_vL_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_n_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_q_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_u_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_Iin_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_vv_vS_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_vv_vL_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_v_vS_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_v_vL_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_n_2nd: STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_S_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_L_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_S_3rd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_L_3rd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_x_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_v_x_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_x_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_vv_x_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_v_x_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL n_x_2nd : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
    SIGNAL v_vv_vS : std_logic_vector(27 downto 0);
    SIGNAL v_vv_vS_0 : std_logic_vector(35 downto 0);
    SIGNAL v_vv_vS_1 : std_logic_vector(35 downto 0);
    SIGNAL v_vv_vS_2 : std_logic_vector(35 downto 0);
    SIGNAL v_vv_vL : std_logic_vector(27 downto 0);
    SIGNAL v_vv_vL_0 : std_logic_vector(47 downto 0);
    SIGNAL v_vv_vL_1 : std_logic_vector(47 downto 0);
    SIGNAL v_vv_vL_2 : std_logic_vector(47 downto 0);
    SIGNAL v_v_vS : std_logic_vector(27 downto 0);
    SIGNAL v_v_vS_0 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_1 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vS_2 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vL : std_logic_vector(27 downto 0);
    SIGNAL v_v_vL_0 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vL_1 : std_logic_vector(33 downto 0);
    SIGNAL v_v_vL_2 : std_logic_vector(33 downto 0);
    SIGNAL v_n : std_logic_vector(27 downto 0);
    SIGNAL v_n_0 : std_logic_vector(47 downto 0);
    SIGNAL v_n_1 : std_logic_vector(47 downto 0);
    SIGNAL v_n_2 : std_logic_vector(47 downto 0);
    SIGNAL v_Iin : std_logic_vector(27 downto 0);
    SIGNAL v_Iin_0 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_1 : std_logic_vector(34 downto 0);
    SIGNAL v_Iin_2 : std_logic_vector(34 downto 0);
    SIGNAL n_vv_vS : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vS_0 : std_logic_vector(47 downto 0);
    SIGNAL n_vv_vS_1 : std_logic_vector(47 downto 0);
    SIGNAL n_vv_vS_2 : std_logic_vector(47 downto 0);
    SIGNAL n_vv_vL : std_logic_vector(27 downto 0);
    SIGNAL n_vv_vL_0 : std_logic_vector(32 downto 0);
    SIGNAL n_vv_vL_1 : std_logic_vector(32 downto 0);
    SIGNAL n_vv_vL_2 : std_logic_vector(32 downto 0);
    SIGNAL n_v_vS : std_logic_vector(27 downto 0);
    SIGNAL n_v_vS_0 : std_logic_vector(47 downto 0);
    SIGNAL n_v_vS_1 : std_logic_vector(47 downto 0);
    SIGNAL n_v_vS_2 : std_logic_vector(47 downto 0);
    SIGNAL n_v_vL : std_logic_vector(27 downto 0);
    SIGNAL n_v_vL_0 : std_logic_vector(29 downto 0);
    SIGNAL n_v_vL_1 : std_logic_vector(29 downto 0);
    SIGNAL n_v_vL_2 : std_logic_vector(29 downto 0);
    SIGNAL n_n : std_logic_vector(27 downto 0);
    SIGNAL n_n_0 : std_logic_vector(47 downto 0);
    SIGNAL n_n_1 : std_logic_vector(47 downto 0);
    SIGNAL s_S : std_logic_vector(27 downto 0);
    SIGNAL s_S_0 : std_logic_vector(47 downto 0);
    SIGNAL s_S_1 : std_logic_vector(47 downto 0);
    SIGNAL s_S_2 : std_logic_vector(47 downto 0);
    SIGNAL s_L : std_logic_vector(27 downto 0);
    SIGNAL s_L_0 : std_logic_vector(47 downto 0);
    SIGNAL s_L_1 : std_logic_vector(47 downto 0);
    SIGNAL s_L_2 : std_logic_vector(47 downto 0);
    SIGNAL v_c_vS : std_logic_vector(27 downto 0):="0000000000000000000000000000";-- 0.0
    SIGNAL v_c_vL : std_logic_vector(27 downto 0):="0000000000000000000000000000";-- 0.0
    SIGNAL n_c_vS : std_logic_vector(27 downto 0):="1111111110010000000000000000";-- -0.4375
    SIGNAL n_c_vL : std_logic_vector(27 downto 0):="0000000001101000000000000000";-- 0.40625
    SIGNAL s_c_L : std_logic_vector(27 downto 0):="0000000000010100000000000000";-- 0.078125
    SIGNAL crf : std_logic_vector(27 downto 0):="0000000000000000000000000000";-- 0
    SIGNAL crg : std_logic_vector(27 downto 0):="1111110100000000000000000000";-- -3
    SIGNAL vini : std_logic_vector(27 downto 0):="1111111011100110101000011001";-- -1.0990972518920898
    SIGNAL nini : std_logic_vector(27 downto 0):="0000001100111110111001000000";-- 3.24566650390625
    SIGNAL vth : std_logic_vector(27 downto 0):="0000000000000000000000000000";-- 0

BEGIN
    updater : PROCESS (CLK)
    BEGIN
        IF (rising_edge(CLK)) THEN
            -- 1st stage
            Iin <= PORT_Iin;
            vv36 <= PORT_vin * PORT_vin;
            vin <= PORT_vin;
            nin <= PORT_nin;
            sin <= PORT_sin;
            -- 2nd stage
            v_vv_vS_2nd <= v_vv_vS;
            v_vv_vL_2nd <= v_vv_vL;
            v_v_vS_2nd <= v_v_vS;
            v_v_vL_2nd <= v_v_vL;
            v_n_2nd <= v_n;
            v_Iin_2nd <= v_Iin;
            n_vv_vS_2nd <= n_vv_vS;
            n_vv_vL_2nd <= n_vv_vL;
            n_v_vS_2nd <= n_v_vS;
            n_v_vL_2nd <= n_v_vL;
            n_n_2nd <= n_n;
            s_S_2nd <= s_S;
            s_L_2nd <= s_L;
            vin_2nd <= vin;
            nin_2nd <= nin;
            sin_2nd <= sin;
            -- 3rd stage
            vout_3rd <= vin_2nd + v_vv_x_2nd + v_v_x_2nd + v_x_2nd + v_n_2nd + v_Iin_2nd;
            nout_3rd <= nin_2nd + n_vv_x_2nd + n_v_x_2nd + n_x_2nd + n_n_2nd;
            vin_3rd <= vin_2nd;
            nin_3rd <= nin_2nd;
            sin_3rd <= sin_2nd;
            --4th stage
            PORT_vout <= vout_3rd;
            PORT_nout <= nout_3rd;
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
    vv <= vv36(47 downto 20 );
    -- vv * 0.005859375 : 00000000.00000001100000000000    36bit
    v_vv_vS_0 <= "00000000" & vv(27 downto 0) & "" when vv(27)='0' else "11111111" & vv(27 downto 0) & "";
    v_vv_vS_1 <= "000000000" & vv(27 downto 1) & "" when vv(27)='0' else "111111111" & vv(27 downto 1) & "";
    v_vv_vS_2 <= v_vv_vS_0 + v_vv_vS_1;
    v_vv_vS <= v_vv_vS_2(35 downto 8);

    -- vv * -0.005859375 : 00000000.00000001100000000000    48bit
    v_vv_vL_0 <= "00000000" & vv(27 downto 0) & "000000000000" when vv(27)='0' else "11111111" & vv(27 downto 0) & "000000000000";
    v_vv_vL_1 <= "000000000" & vv(27 downto 0) & "00000000000" when vv(27)='0' else "111111111" & vv(27 downto 0) & "00000000000";
    v_vv_vL_2 <= not (v_vv_vL_0 + v_vv_vL_1) + 1;
    v_vv_vL <= v_vv_vL_2(47 downto 20);

    -- vin * 0.0234375 : 00000000.00000110000000000000    34bit
    v_v_vS_0 <= "000000" & vin(27 downto 0) & "" when vin(27)='0' else "111111" & vin(27 downto 0) & "";
    v_v_vS_1 <= "0000000" & vin(27 downto 1) & "" when vin(27)='0' else "1111111" & vin(27 downto 1) & "";
    v_v_vS_2 <= v_v_vS_0 + v_v_vS_1;
    v_v_vS <= v_v_vS_2(33 downto 6);

    -- vin * 0.0234375 : 00000000.00000110000000000000    34bit
    v_v_vL_0 <= "000000" & vin(27 downto 0) & "" when vin(27)='0' else "111111" & vin(27 downto 0) & "";
    v_v_vL_1 <= "0000000" & vin(27 downto 1) & "" when vin(27)='0' else "1111111" & vin(27 downto 1) & "";
    v_v_vL_2 <= v_v_vL_0 + v_v_vL_1;
    v_v_vL <= v_v_vL_2(33 downto 6);

    -- nin * -0.00146484375 : 00000000.00000000011000000000    48bit
    v_n_0 <= "0000000000" & nin(27 downto 0) & "0000000000" when nin(27)='0' else "1111111111" & nin(27 downto 0) & "0000000000";
    v_n_1 <= "00000000000" & nin(27 downto 0) & "000000000" when nin(27)='0' else "11111111111" & nin(27 downto 0) & "000000000";
    v_n_2 <= not (v_n_0 + v_n_1) + 1;
    v_n <= v_n_2(47 downto 20);

    -- Iin * 0.01171875 : 00000000.00000011000000000000    35bit
    v_Iin_0 <= "0000000" & Iin(27 downto 0) & "" when Iin(27)='0' else "1111111" & Iin(27 downto 0) & "";
    v_Iin_1 <= "00000000" & Iin(27 downto 1) & "" when Iin(27)='0' else "11111111" & Iin(27 downto 1) & "";
    v_Iin_2 <= v_Iin_0 + v_Iin_1;
    v_Iin <= v_Iin_2(34 downto 7);

    -- vv * -0.046875 : 00000000.00001100000000000000    48bit
    n_vv_vS_0 <= "00000" & vv(27 downto 0) & "000000000000000" when vv(27)='0' else "11111" & vv(27 downto 0) & "000000000000000";
    n_vv_vS_1 <= "000000" & vv(27 downto 0) & "00000000000000" when vv(27)='0' else "111111" & vv(27 downto 0) & "00000000000000";
    n_vv_vS_2 <= not (n_vv_vS_0 + n_vv_vS_1) + 1;
    n_vv_vS <= n_vv_vS_2(47 downto 20);

    -- vv * 0.046875 : 00000000.00001100000000000000    33bit
    n_vv_vL_0 <= "00000" & vv(27 downto 0) & "" when vv(27)='0' else "11111" & vv(27 downto 0) & "";
    n_vv_vL_1 <= "000000" & vv(27 downto 1) & "" when vv(27)='0' else "111111" & vv(27 downto 1) & "";
    n_vv_vL_2 <= n_vv_vL_0 + n_vv_vL_1;
    n_vv_vL <= n_vv_vL_2(32 downto 5);

    -- vin * -0.1875 : 00000000.00110000000000000000    48bit
    n_v_vS_0 <= "000" & vin(27 downto 0) & "00000000000000000" when vin(27)='0' else "111" & vin(27 downto 0) & "00000000000000000";
    n_v_vS_1 <= "0000" & vin(27 downto 0) & "0000000000000000" when vin(27)='0' else "1111" & vin(27 downto 0) & "0000000000000000";
    n_v_vS_2 <= not (n_v_vS_0 + n_v_vS_1) + 1;
    n_v_vS <= n_v_vS_2(47 downto 20);

    -- vin * 0.375 : 00000000.01100000000000000000    30bit
    n_v_vL_0 <= "00" & vin(27 downto 0) & "" when vin(27)='0' else "11" & vin(27 downto 0) & "";
    n_v_vL_1 <= "000" & vin(27 downto 1) & "" when vin(27)='0' else "111" & vin(27 downto 1) & "";
    n_v_vL_2 <= n_v_vL_0 + n_v_vL_1;
    n_v_vL <= n_v_vL_2(29 downto 2);

    -- nin * -0.015625 : 00000000.00000100000000000000    48bit
    n_n_0 <= "000000" & nin(27 downto 0) & "00000000000000" when nin(27)='0' else "111111" & nin(27 downto 0) & "00000000000000";
    n_n_1 <= not (n_n_0) + 1;
    n_n <= n_n_1(47 downto 20);

    -- sin * -0.01953125 : 00000000.00000101000000000000    48bit
    s_S_0 <= "000000" & sin(27 downto 0) & "00000000000000" when sin(27)='0' else "111111" & sin(27 downto 0) & "00000000000000";
    s_S_1 <= "00000000" & sin(27 downto 0) & "000000000000" when sin(27)='0' else "11111111" & sin(27 downto 0) & "000000000000";
    s_S_2 <= not (s_S_0 + s_S_1) + 1;
    s_S <= s_S_2(47 downto 20);

    -- sin * -0.078125 : 00000000.00010100000000000000    48bit
    s_L_0 <= "0000" & sin(27 downto 0) & "0000000000000000" when sin(27)='0' else "1111" & sin(27 downto 0) & "0000000000000000";
    s_L_1 <= "000000" & sin(27 downto 0) & "00000000000000" when sin(27)='0' else "111111" & sin(27 downto 0) & "00000000000000";
    s_L_2 <= not (s_L_0 + s_L_1) + 1;
    s_L <= s_L_2(47 downto 20);

    v_vv_x_2nd <= v_vv_vL_2nd when vin_2nd>=crf else v_vv_vS_2nd;
    v_v_x_2nd <= v_v_vL_2nd when vin_2nd>=crf else v_v_vS_2nd;
    v_x_2nd <= v_c_vL when vin_2nd>=crf else v_c_vS;
    n_vv_x_2nd <= n_vv_vL_2nd when vin_2nd>=crg else n_vv_vS_2nd;
    n_v_x_2nd <= n_v_vL_2nd when vin_2nd>=crg else n_v_vS_2nd;
    n_x_2nd <= n_c_vL when vin_2nd>=crg else n_c_vS;

END Behavioral;
--dt= 0.0005
--tau= 0.032
--afn= 4
--afp= -4
--bfn= -2
--bfp= 2.0
--cfn= 0
--cfp= 32.0
--agn= -3
--agp= 3
--bgn= -2
--bgp= -4.0
--cgn= -16
--cgp= -22.0
--rg= -3
--phi= 0.09375
--I0= 0
--Ix= 8
--v_vv_vS=0.005859375
--v_vv_vL=-0.005859375
--v_v_vS=0.0234375
--v_v_vL=0.0234375
--v_n=-0.00146484375
--v_Iin=0.01171875
--n_vv_vS=-0.046875
--n_vv_vL=0.046875
--n_v_vS=-0.1875
--n_v_vL=0.375
--n_n=-0.015625
--s_S=-0.01953125
--s_L=-0.078125
--v_c_vS=0.0234375
--v_c_vL=0.0234375
--n_c_vS=-0.4375
--n_c_vL=0.40625
--s_c_L=0.078125
--crf=0
--crg=-3
--vini=-1.0990972518920898
--nini=3.24566650390625
--vth=0