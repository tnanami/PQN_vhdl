LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY I_receiver IS
	GENERIC (PQN_BIT_WIDTH : NATURAL := 18);
	PORT (
		CLK : IN STD_LOGIC;
		TRIGER : IN STD_LOGIC;
		UART_RXD : IN STD_LOGIC;
		UART_RXD_I0 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_RXD_I1 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_RXD_I2 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_RXD_I3 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0)
	);
END I_receiver;

ARCHITECTURE Behavioral OF I_receiver IS

	COMPONENT uart_rxd_ctrl
		PORT (
			clk : IN STD_LOGIC;
			uart_rxd : IN STD_LOGIC;
			received_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			received_done : OUT STD_LOGIC
		);
	END COMPONENT;
 
	COMPONENT fifo_I IS
		PORT (
			clk : IN STD_LOGIC;
			din : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			wr_en : IN STD_LOGIC;
			rd_en : IN STD_LOGIC;
			dout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			full : OUT STD_LOGIC;
			empty : OUT STD_LOGIC;
			data_count : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL received_done : STD_LOGIC := '0'; 
	SIGNAL received_data : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL received_data0 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL received_data1 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL received_data2 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL received_data3 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	TYPE STATE_TYPE IS (RECEIVEib0, RECEIVEib1, RECEIVEib2, RECEIVElts0, RECEIVElts1, RECEIVElts2, RECEIVErs0, RECEIVErs1, RECEIVErs2, RECEIVEfs0, RECEIVEfs1, RECEIVEfs2, END0);
	SIGNAL STATE : STATE_TYPE := RECEIVEib0;
	TYPE FIFO_STATE_TYPE IS (READY, PROCESS0, PROCESS1, PROCESS2);
	SIGNAL FIFO_STATE0 : FIFO_STATE_TYPE := READY;
	SIGNAL FIFO_STATE1 : FIFO_STATE_TYPE := READY;
	SIGNAL FIFO_STATE2 : FIFO_STATE_TYPE := READY;
	SIGNAL FIFO_STATE3 : FIFO_STATE_TYPE := READY;
 
	SIGNAL fifo_din0 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_dout0 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_wr_en0 : STD_LOGIC := '0';
	SIGNAL fifo_rd_en0 : STD_LOGIC := '0';
	SIGNAL fifo_full0 : STD_LOGIC := '0';
	SIGNAL fifo_empty0 : STD_LOGIC := '0';
	SIGNAL fifo_data_count0 : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
 
	SIGNAL fifo_din1 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_dout1 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_wr_en1 : STD_LOGIC := '0';
	SIGNAL fifo_rd_en1 : STD_LOGIC := '0';
	SIGNAL fifo_full1 : STD_LOGIC := '0';
	SIGNAL fifo_empty1 : STD_LOGIC := '0';
	SIGNAL fifo_data_count1 : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
 
	SIGNAL fifo_din2 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_dout2 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_wr_en2 : STD_LOGIC := '0';
	SIGNAL fifo_rd_en2 : STD_LOGIC := '0';
	SIGNAL fifo_full2 : STD_LOGIC := '0';
	SIGNAL fifo_empty2 : STD_LOGIC := '0';
	SIGNAL fifo_data_count2 : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
 
	SIGNAL fifo_din3 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_dout3 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL fifo_wr_en3 : STD_LOGIC := '0';
	SIGNAL fifo_rd_en3 : STD_LOGIC := '0';
	SIGNAL fifo_full3 : STD_LOGIC := '0';
	SIGNAL fifo_empty3 : STD_LOGIC := '0';
	SIGNAL fifo_data_count3 : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');

BEGIN
	DATA_CTRL : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			CASE STATE IS
				WHEN RECEIVEib0 => 
					IF (received_data = "00001010" AND received_done = '1') THEN
						fifo_din0 <= "000000000000001010";
						fifo_wr_en0 <= '1';
						fifo_din1 <= "000000000000001010";
						fifo_wr_en1 <= '1';
						fifo_din2 <= "000000000000001010";
						fifo_wr_en2 <= '1';
						fifo_din3 <= "000000000000001010";
						fifo_wr_en3 <= '1';
					ELSIF (received_done = '1') THEN
						received_data0(17 DOWNTO 10) <= received_data;
						STATE <= RECEIVEib1;
					ELSE
						fifo_wr_en0 <= '0';
						fifo_wr_en1 <= '0';
						fifo_wr_en2 <= '0';
						fifo_wr_en3 <= '0';
					END IF;
				WHEN RECEIVEib1 => 
					IF (received_done = '1') THEN
						received_data0(9 DOWNTO 2) <= received_data;
						STATE <= RECEIVEib2;
					END IF;
				WHEN RECEIVEib2 => 
					IF (received_done = '1') THEN
						received_data0(1 DOWNTO 0) <= received_data(1 DOWNTO 0);
						STATE <= RECEIVElts0;
					END IF; 
				WHEN RECEIVElts0 => 
					IF (received_done = '1') THEN
						received_data1(17 DOWNTO 10) <= received_data;
						STATE <= RECEIVElts1;
					END IF;
					fifo_din0 <= received_data0; 
					fifo_wr_en0 <= '1';
				WHEN RECEIVElts1 => 
					IF (received_done = '1') THEN
						received_data1(9 DOWNTO 2) <= received_data;
						STATE <= RECEIVElts2;
					END IF;
				WHEN RECEIVElts2 => 
					IF (received_done = '1') THEN
						received_data1(1 DOWNTO 0) <= received_data(1 DOWNTO 0);
						STATE <= RECEIVErs0;
					END IF; 
				WHEN RECEIVErs0 => 
					IF (received_done = '1') THEN
						received_data2(17 DOWNTO 10) <= received_data;
						STATE <= RECEIVErs1;
					END IF;
					fifo_din1 <= received_data1; 
					fifo_wr_en1 <= '1';
				WHEN RECEIVErs1 => 
					IF (received_done = '1') THEN
						received_data2(9 DOWNTO 2) <= received_data;
						STATE <= RECEIVErs2;
					END IF;
				WHEN RECEIVErs2 => 
					IF (received_done = '1') THEN
						received_data2(1 DOWNTO 0) <= received_data(1 DOWNTO 0);
						STATE <= RECEIVEfs0;
					END IF; 
				WHEN RECEIVEfs0 => 
					IF (received_done = '1') THEN
						received_data3(17 DOWNTO 10) <= received_data;
						STATE <= RECEIVEfs1;
					END IF;
					fifo_din2 <= received_data2; 
					fifo_wr_en2 <= '1';
				WHEN RECEIVEfs1 => 
					IF (received_done = '1') THEN
						received_data3(9 DOWNTO 2) <= received_data;
						STATE <= RECEIVEfs2;
					END IF;
				WHEN RECEIVEfs2 => 
					IF (received_done = '1') THEN
						received_data3(1 DOWNTO 0) <= received_data(1 DOWNTO 0);
						STATE <= END0;
					END IF; 
				WHEN END0 => 
					fifo_din3 <= received_data3; 
					fifo_wr_en3 <= '1';
					STATE <= RECEIVEib0;
				WHEN OTHERS => 
					STATE <= RECEIVEib0;
			END CASE;
		END IF;
	END PROCESS;

	FIFO_OUT_CTRL0 : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			CASE FIFO_STATE0 IS
				WHEN READY => 
					IF (TRIGER = '1') THEN
						fifo_rd_en0 <= '1';
						FIFO_STATE0 <= PROCESS0;
					END IF;
				WHEN PROCESS0 => 
					IF (FIFO_DOUT0 /= "000000000000001010") THEN
						UART_RXD_I0 <= fifo_dout0;
					ELSE
						fifo_rd_en0 <= '0';
						FIFO_STATE0 <= READY;
					END IF; 
				WHEN OTHERS => 
					FIFO_STATE0 <= READY;
			END CASE;
		END IF;
	END PROCESS;
 
	FIFO_OUT_CTRL1 : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			CASE FIFO_STATE1 IS
				WHEN READY => 
					IF (TRIGER = '1') THEN
						fifo_rd_en1 <= '1';
						FIFO_STATE1 <= PROCESS0;
					END IF;
				WHEN PROCESS0 => 
					IF (FIFO_DOUT1 /= "000000000000001010") THEN
						UART_RXD_I1 <= fifo_dout1;
					ELSE
						fifo_rd_en1 <= '0';
						FIFO_STATE1 <= READY; 
					END IF; 
				WHEN OTHERS => 
					FIFO_STATE1 <= READY;
			END CASE;
		END IF;
	END PROCESS;
 
	FIFO_OUT_CTRL2 : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			CASE FIFO_STATE2 IS
				WHEN READY => 
					IF (TRIGER = '1') THEN
						fifo_rd_en2 <= '1';
						FIFO_STATE2 <= PROCESS0;
					END IF;
				WHEN PROCESS0 => 
					IF (FIFO_DOUT2 /= "000000000000001010") THEN
						UART_RXD_I2 <= fifo_dout2;
					ELSE
						fifo_rd_en2 <= '0';
						FIFO_STATE2 <= READY; 
					END IF; 
				WHEN OTHERS => 
					FIFO_STATE2 <= READY;
			END CASE;
		END IF;
	END PROCESS;
 
	FIFO_OUT_CTRL3 : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			CASE FIFO_STATE3 IS
				WHEN READY => 
					IF (TRIGER = '1') THEN
						fifo_rd_en3 <= '1';
						FIFO_STATE3 <= PROCESS0;
					END IF;
				WHEN PROCESS0 => 
					IF (FIFO_DOUT3 /= "000000000000001010") THEN
						UART_RXD_I3 <= fifo_dout3;
					ELSE
						fifo_rd_en3 <= '0';
						FIFO_STATE3 <= READY; 
					END IF; 
				WHEN OTHERS => 
					FIFO_STATE3 <= READY;
			END CASE;
		END IF;
	END PROCESS;
 
	uart_rxd_ctrl_0 : uart_rxd_ctrl
	PORT MAP(
		clk => CLK, 
		uart_rxd => UART_RXD, 
		received_data => received_data, 
		received_done => received_done
		);

		fifo_0 : fifo_I
		PORT MAP(
			CLK => CLK, 
			din => fifo_din0, 
			wr_en => fifo_wr_en0, 
			rd_en => fifo_rd_en0, 
			dout => fifo_dout0, 
			full => fifo_full0, 
			empty => fifo_empty0, 
			data_count => fifo_data_count0
		);
 
		fifo_1 : fifo_I
		PORT MAP(
			CLK => CLK, 
			din => fifo_din1, 
			wr_en => fifo_wr_en1, 
			rd_en => fifo_rd_en1, 
			dout => fifo_dout1, 
			full => fifo_full1, 
			empty => fifo_empty1, 
			data_count => fifo_data_count1
		);
 
		fifo_2 : fifo_I
		PORT MAP(
			CLK => CLK, 
			din => fifo_din2, 
			wr_en => fifo_wr_en2, 
			rd_en => fifo_rd_en2, 
			dout => fifo_dout2, 
			full => fifo_full2, 
			empty => fifo_empty2, 
			data_count => fifo_data_count2
		);
 
		fifo_3 : fifo_I
		PORT MAP(
			CLK => CLK, 
			din => fifo_din3, 
			wr_en => fifo_wr_en3, 
			rd_en => fifo_rd_en3, 
			dout => fifo_dout3, 
			full => fifo_full3, 
			empty => fifo_empty3, 
			data_count => fifo_data_count3
		);
 
END Behavioral;