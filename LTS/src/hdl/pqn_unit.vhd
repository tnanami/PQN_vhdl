LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY pqn_unit IS
	GENERIC (PQN_BIT_WIDTH : NATURAL := 18);
	PORT (
		CLK : IN STD_LOGIC;
		TRIGER : IN STD_LOGIC;
		UART_RXD_I : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
		UART_TXD_V : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
		UART_TXD_I : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0)
	);
END pqn_unit;

ARCHITECTURE Behavioral OF pqn_unit IS

    -- PQN engine
    -- This calculates the values of state variables at the next time 
    -- step from the current values of the state variables
	COMPONENT LTS IS
		PORT (
			clk : IN STD_LOGIC;
			PORT_Iin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
			PORT_vin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
			PORT_nin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
			PORT_qin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
			PORT_uin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
			PORT_sin : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
			PORT_vout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
			PORT_nout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
			PORT_qout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
			PORT_uout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
			PORT_sout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
		    PORT_spike_flag : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
		);
	END COMPONENT;
    
    -- FIFO memory for state variables
    COMPONENT fifo_state_variables IS
        PORT (
            clk : IN STD_LOGIC;
            srst : IN STD_LOGIC;
            din : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
            wr_en : IN STD_LOGIC;
            rd_en : IN STD_LOGIC;
            dout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
            full : OUT STD_LOGIC;
            empty : OUT STD_LOGIC;
            data_count : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
        );
    END COMPONENT; 
    
    -- number of neurons simulated by this PQN unit
	CONSTANT N0 : NATURAL := 9993;

	SIGNAL counter0 : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Iin : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL vin : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL nin : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL qin : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL uin : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL sin : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL vout : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL nout : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL qout : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL uout : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL sout : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL spike_flag : STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');

	SIGNAL fifo_srst : STD_LOGIC;
	SIGNAL fifo_wr_en : STD_LOGIC;
	SIGNAL fifo_rd_en : STD_LOGIC;
	SIGNAL fifo_v_full : STD_LOGIC;
	SIGNAL fifo_v_empty : STD_LOGIC;
	SIGNAL fifo_v_din : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_v_dout : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_v_data_count : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_n_full : STD_LOGIC;
	SIGNAL fifo_n_empty : STD_LOGIC;
	SIGNAL fifo_n_din : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_n_dout : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_n_data_count : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_q_full : STD_LOGIC;
	SIGNAL fifo_q_empty : STD_LOGIC;
	SIGNAL fifo_q_din : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_q_dout : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_q_data_count : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_u_full : STD_LOGIC;
	SIGNAL fifo_u_empty : STD_LOGIC;
	SIGNAL fifo_u_din : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_u_dout : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_u_data_count : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');

	TYPE STATE_TYPE IS (SET, READY, RUN);
	SIGNAL STATE : STATE_TYPE := SET;

BEGIN

	LTS_0 : LTS
	PORT MAP(
		clk => CLK, 
		PORT_Iin => Iin, 
		PORT_vin => vin, 
		PORT_nin => nin, 
		PORT_qin => qin, 
		PORT_uin => uin, 
		PORT_sin => sin, 
		PORT_vout => vout, 
		PORT_nout => nout, 
		PORT_qout => qout, 
		PORT_uout => uout, 
		PORT_sout => sout,
		PORT_spike_flag => spike_flag 
	);

    -- controller for the PQN unit
	pqn_ctrl : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			CASE STATE IS
				WHEN SET => 
					IF (counter0 < N0) THEN
						counter0 <= counter0 + 1;
						fifo_wr_en <= '1';
						fifo_rd_en <= '0';
						fifo_v_din <= (OTHERS => '0');
						fifo_n_din <= (OTHERS => '0');
						fifo_q_din <= (OTHERS => '0');
						fifo_u_din <= (OTHERS => '0');
					ELSE
						counter0 <= (OTHERS => '0');
						fifo_wr_en <= '0';
						fifo_rd_en <= '0';
						STATE <= READY;
					END IF;
				WHEN READY => 
					IF (TRIGER = '1') THEN
						fifo_rd_en <= '1';
						STATE <= RUN;
					ELSE
						counter0 <= (OTHERS => '0');
						fifo_wr_en <= '0';
						fifo_rd_en <= '0';
					END IF;
				WHEN RUN => 
					IF (counter0 < N0 + 6) THEN
						counter0 <= counter0 + 1;
						IF (counter0 = 1) THEN
							UART_TXD_V <= fifo_v_dout;
							UART_TXD_I <= UART_RXD_I;
							Iin <= UART_RXD_I;
						ELSE
							Iin <= (OTHERS => '0');
						END IF;
						IF (counter0 < N0 - 1) THEN
							fifo_rd_en <= '1';
						ELSE
							fifo_rd_en <= '0';
						END IF;
						IF (counter0 < N0 + 1 AND counter0 > 0) THEN
							vin <= fifo_v_dout;
							nin <= fifo_n_dout;
							qin <= fifo_q_dout;
							uin <= fifo_u_dout;
						END IF;
						IF (counter0 >= 6) THEN
							fifo_wr_en <= '1';
							fifo_v_din <= vout;
							fifo_n_din <= nout;
							fifo_q_din <= qout;
							fifo_u_din <= uout;
						ELSE
							fifo_wr_en <= '0';
						END IF;
					ELSE
						counter0 <= (OTHERS => '0');
						fifo_wr_en <= '0';
						fifo_rd_en <= '1';
						--STATE <= READY;
					END IF;
				WHEN OTHERS => 
					STATE <= READY;
			END CASE;
		END IF;
	END PROCESS;

	fifo_v : fifo_state_variables
	PORT MAP(
		clk => CLK, 
		srst => fifo_srst, 
		din => fifo_v_din, 
		wr_en => fifo_wr_en, 
		rd_en => fifo_rd_en, 
		dout => fifo_v_dout, 
		full => fifo_v_full, 
		empty => fifo_v_empty, 
		data_count => fifo_v_data_count
	);
 
	fifo_n : fifo_state_variables
	PORT MAP(
		clk => CLK, 
		srst => fifo_srst, 
		din => fifo_n_din, 
		wr_en => fifo_wr_en, 
		rd_en => fifo_rd_en, 
		dout => fifo_n_dout, 
		full => fifo_n_full, 
		empty => fifo_n_empty, 
		data_count => fifo_n_data_count
	);
 
	fifo_q : fifo_state_variables
	PORT MAP(
		clk => CLK, 
		srst => fifo_srst, 
		din => fifo_q_din, 
		wr_en => fifo_wr_en, 
		rd_en => fifo_rd_en, 
		dout => fifo_q_dout, 
		full => fifo_q_full, 
		empty => fifo_q_empty, 
		data_count => fifo_q_data_count
	);
 
	fifo_u : fifo_state_variables
	PORT MAP(
		clk => CLK, 
		srst => fifo_srst, 
		din => fifo_u_din, 
		wr_en => fifo_wr_en, 
		rd_en => fifo_rd_en, 
		dout => fifo_u_dout, 
		full => fifo_u_full, 
		empty => fifo_u_empty, 
		data_count => fifo_u_data_count
	);
 
END Behavioral;