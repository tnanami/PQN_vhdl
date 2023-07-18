LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY pqn_unit IS
	GENERIC (PQN_BIT_WIDTH : NATURAL := 18);
	PORT (
		CLK : IN STD_LOGIC;
		TRIGER : IN STD_LOGIC;
		UART_RXD_I0 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_RXD_I1 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_RXD_I2 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_RXD_I3 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_TXD_V0 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_TXD_V1 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_TXD_V2 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_TXD_V3 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0)
	);
END pqn_unit;

ARCHITECTURE Behavioral OF pqn_unit IS

	-- Components FS, RS, IB and LTS
	-- These calculate the values of state variables at the next time
	-- step from the current values of the state variables
	COMPONENT FS IS
		PORT (
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
	END COMPONENT;

	COMPONENT RSexci IS
		PORT (
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
	END COMPONENT;

	COMPONENT LTS IS
		PORT (
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
	END COMPONENT;

	COMPONENT IB IS
		PORT (
			clk : IN STD_LOGIC;
			PORT_Iin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_vin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_nin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_qin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_uin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_sin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_vout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_nout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_qout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_uout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_sout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			PORT_spike_flag : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT blk_ram1 IS
		PORT (
			addra : IN std_logic_vector(6 DOWNTO 0);
			clka : IN std_logic;
			dina : IN std_logic_vector(17 DOWNTO 0);
			douta : OUT std_logic_vector(17 DOWNTO 0);
			wea : IN std_logic;
			-- -- -- -- -- --
			addrb : IN std_logic_vector(6 DOWNTO 0);
			clkb : IN std_logic;
			dinb : IN std_logic_vector(17 DOWNTO 0);
			doutb : OUT std_logic_vector(17 DOWNTO 0);
			web : IN std_logic
		);
	END COMPONENT;
	
	CONSTANT transmitted_neuron : INTEGER := 1;
	
	CONSTANT N0 : INTEGER := 100;
	SIGNAL counter_r : INTEGER := 0;
	SIGNAL counter_w : INTEGER := 0;

	-- pqn signals
	SIGNAL iin_lts : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0'); -- -0.2
	SIGNAL vin_lts : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL sin_lts : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL nin_lts : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL qin_lts : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL uin_lts : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL vout_lts : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL sout_lts : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL nout_lts : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL qout_lts : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL uout_lts : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL spike_flag_lts : STD_LOGIC_VECTOR(0 DOWNTO 0);

	SIGNAL iin_ib : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0'); -- 0.7
	SIGNAL vin_ib : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL sin_ib : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL nin_ib : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL qin_ib : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL uin_ib : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL vout_ib : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL sout_ib : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL nout_ib : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL qout_ib : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL uout_ib : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL spike_flag_ib : STD_LOGIC_VECTOR(0 DOWNTO 0);

	SIGNAL iin_rs : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0'); -- 0.09
	SIGNAL vin_rs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL sin_rs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL nin_rs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL qin_rs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL vout_rs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL sout_rs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL nout_rs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL qout_rs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL spike_flag_rs : STD_LOGIC_VECTOR(0 DOWNTO 0);

	SIGNAL iin_fs : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0'); -- 0.1
	SIGNAL vin_fs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL sin_fs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL nin_fs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL qin_fs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL vout_fs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL sout_fs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL nout_fs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL qout_fs : STD_LOGIC_VECTOR(17 DOWNTO 0);
	SIGNAL spike_flag_fs : STD_LOGIC_VECTOR(0 DOWNTO 0);

	-- ram signals
	SIGNAL addrw : std_logic_vector(6 DOWNTO 0);
	SIGNAL addrr : std_logic_vector(6 DOWNTO 0);

	SIGNAL ram_in_v_rs : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_in_n_rs : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_in_q_rs : std_logic_vector(17 DOWNTO 0);

	SIGNAL ram_in_v_fs : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_in_n_fs : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_in_q_fs : std_logic_vector(17 DOWNTO 0);

	SIGNAL ram_in_v_lts : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_in_n_lts : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_in_q_lts : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_in_u_lts : std_logic_vector(17 DOWNTO 0);

	SIGNAL ram_in_v_ib : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_in_n_ib : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_in_q_ib : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_in_u_ib : std_logic_vector(17 DOWNTO 0);

	SIGNAL wea : std_logic;
	SIGNAL web : std_logic := '0';

	SIGNAL ram_out_v_fs : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_n_fs : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_q_fs : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_u_fs : std_logic_vector(17 DOWNTO 0);

	SIGNAL ram_out_v_rs : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_n_rs : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_q_rs : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_u_rs : std_logic_vector(17 DOWNTO 0);

	SIGNAL ram_out_v_lts : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_n_lts : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_q_lts : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_u_lts : std_logic_vector(17 DOWNTO 0);

	SIGNAL ram_out_v_ib : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_n_ib : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_q_ib : std_logic_vector(17 DOWNTO 0);
	SIGNAL ram_out_u_ib : std_logic_vector(17 DOWNTO 0);

	TYPE STATE_TYPE IS (SET, READY);
	SIGNAL STATE : STATE_TYPE := SET;

BEGIN
	PROCESS (clk) IS BEGIN
	IF rising_edge(clk) THEN
		CASE STATE IS
			WHEN SET => 
				IF triger = '1' THEN
					state <= ready;
				END IF;

			WHEN READY => 
				IF counter_r < N0 THEN
					addrr <= std_logic_vector(to_unsigned(counter_r, addrr'length));
					counter_r <= counter_r + 1;
 
					Iin_ib <= UART_RXD_I0;
					Iin_lts <= UART_RXD_I1;
					Iin_rs <= UART_RXD_I2;
					Iin_fs <= UART_RXD_I3;
 
					vin_lts <= ram_out_v_lts;
					nin_lts <= ram_out_n_lts;
					qin_lts <= ram_out_q_lts;
					uin_lts <= ram_out_u_lts;

					vin_ib <= ram_out_v_ib;
					nin_ib <= ram_out_n_ib;
					qin_ib <= ram_out_q_ib;
					uin_ib <= ram_out_u_ib;

					vin_rs <= ram_out_v_rs;
					nin_rs <= ram_out_n_rs;
					qin_rs <= ram_out_q_rs;

					vin_fs <= ram_out_v_fs;
					nin_fs <= ram_out_n_fs;
					qin_fs <= ram_out_q_fs;

					IF counter_r = transmitted_neuron THEN 
					-- transmit only one voltage in address 
					-- 'transmitted_neuron' of each block ram
						UART_TXD_V0 <= ram_out_v_ib;
						UART_TXD_V1 <= ram_out_v_lts;
						UART_TXD_V2 <= ram_out_v_rs;
						UART_TXD_V3 <= ram_out_v_fs;
					END IF;

				ELSE
					counter_r <= counter_r + 1;
					IF counter_r = N0 + 7 THEN
						STATE <= SET;
						counter_r <= 0;
					END IF;
				END IF;
				
				-- after 7 clocks it starts to write updated values on ram
				IF counter_r > 7 THEN
					IF counter_w < N0 THEN
						counter_w <= counter_w + 1;
						ram_in_v_lts <= vout_lts;
						ram_in_n_lts <= nout_lts;
						ram_in_q_lts <= qout_lts;
						ram_in_u_lts <= uout_lts;

						ram_in_v_ib <= vout_ib;
						ram_in_n_ib <= nout_ib;
						ram_in_q_ib <= qout_ib;
						ram_in_u_ib <= uout_ib;

						ram_in_v_rs <= vout_rs;
						ram_in_n_rs <= nout_rs;
						ram_in_q_rs <= qout_rs;

						ram_in_v_fs <= vout_fs;
						ram_in_n_fs <= nout_fs;
						ram_in_q_fs <= qout_fs;
						wea <= '1';
						addrw <= std_logic_vector(to_unsigned(counter_w, addrw'length));
						IF counter_w = N0 - 1 THEN
							-- STATE <= SET;
							counter_w <= 0;
						END IF;
					END IF;
				END IF;

			WHEN OTHERS => STATE <= SET;
		END CASE;

	END IF;
END PROCESS;

FS_0 : FS
PORT MAP(
	clk => CLK, 
	PORT_Iin => Iin_fs, 
	PORT_vin => vin_fs, 
	PORT_nin => nin_fs, 
	PORT_qin => qin_fs, 
	PORT_sin => sin_fs, 
	PORT_vout => vout_fs, 
	PORT_nout => nout_fs, 
	PORT_qout => qout_fs, 
	PORT_sout => sout_fs, 
	PORT_spike_flag => spike_flag_fs
	);

	RS_0 : RSexci
	PORT MAP(
		clk => CLK, 
		PORT_Iin => Iin_rs, 
		PORT_vin => vin_rs, 
		PORT_nin => nin_rs, 
		PORT_qin => qin_rs, 
		PORT_sin => sin_rs, 
		PORT_vout => vout_rs, 
		PORT_nout => nout_rs, 
		PORT_qout => qout_rs, 
		PORT_sout => sout_rs, 
		PORT_spike_flag => spike_flag_rs
	);

	IB_0 : IB
	PORT MAP(
		clk => CLK, 
		PORT_Iin => Iin_ib, 
		PORT_vin => vin_ib, 
		PORT_nin => nin_ib, 
		PORT_qin => qin_ib, 
		PORT_uin => uin_ib, 
		PORT_sin => sin_ib, 
		PORT_vout => vout_ib, 
		PORT_nout => nout_ib, 
		PORT_qout => qout_ib, 
		PORT_uout => uout_ib, 
		PORT_sout => sout_ib, 
		PORT_spike_flag => spike_flag_ib
	);

	LTS_0 : LTS
	PORT MAP(
		clk => CLK, 
		PORT_Iin => Iin_lts, 
		PORT_vin => vin_lts, 
		PORT_nin => nin_lts, 
		PORT_qin => qin_lts, 
		PORT_uin => uin_lts, 
		PORT_sin => sin_lts, 
		PORT_vout => vout_lts, 
		PORT_nout => nout_lts, 
		PORT_qout => qout_lts, 
		PORT_uout => uout_lts, 
		PORT_sout => sout_lts, 
		PORT_spike_flag => spike_flag_lts
	);

	v_ram_rs : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_v_rs, 
		dinb => ram_in_v_rs, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_v_rs
	);

	n_ram_rs : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_n_rs, 
		dinb => ram_in_n_rs, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_n_rs
	);

	q_ram_rs : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_q_rs, 
		dinb => ram_in_q_rs, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_q_rs
	);

	v_ram_fs : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_v_fs, 
		dinb => ram_in_v_fs, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_v_fs
	);

	n_ram_fs : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_n_fs, 
		dinb => ram_in_n_fs, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_n_fs
	);

	q_ram_fs : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_q_fs, 
		dinb => ram_in_q_fs, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_q_fs
	);

	v_ram_lts : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_v_lts, 
		dinb => ram_in_v_lts, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_v_lts
	);

	n_ram_lts : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_n_lts, 
		dinb => ram_in_n_lts, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_n_lts
	);

	q_ram_lts : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_q_lts, 
		dinb => ram_in_q_lts, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_q_lts
	);

	u_ram_lts : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_u_lts, 
		dinb => ram_in_u_lts, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_u_lts
	);

	v_ram_ib : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_v_ib, 
		dinb => ram_in_v_ib, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_v_ib
	);

	n_ram_ib : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_n_ib, 
		dinb => ram_in_n_ib, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_n_ib
	);

	q_ram_ib : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_q_ib, 
		dinb => ram_in_q_ib, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_q_ib
	);

	u_ram_ib : blk_ram1
	PORT MAP(
		addra => addrw, 
		dina => ram_in_u_ib, 
		dinb => ram_in_u_ib, 
		addrb => addrr, 
		clka => clk, 
		clkb => clk, 
		wea => wea, 
		web => web, 
		doutb => ram_out_u_ib
	);

END ARCHITECTURE;