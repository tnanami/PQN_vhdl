-- UART transmitter
-- transmit v (membrane potential of a neuron) and I (stimulus input)
-- both signals are represented by 18-bit and encoded into 3 byte data through UART communication
-- packets are sent every 0.1 ms depending on the TRIGER signal
-- a single packet is composed of following seven byte data
-- v(17 downto 11), v1(10 downto 4), v2(3 downto 0), I0(17 downto 11), I1(10 downto 4), I2(3 downto 0), 10(LF)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY v_transmitter IS
	GENERIC (PQN_BIT_WIDTH : NATURAL := 18);
	PORT (
		CLK : IN STD_LOGIC;
		TRIGER : IN STD_LOGIC;
		UART_TXD : OUT STD_LOGIC;
		UART_TXD_V : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
		UART_TXD_I : IN STD_LOGIC_VECTOR(27 DOWNTO 0)
	);
END v_transmitter;
ARCHITECTURE Behavioral OF v_transmitter IS

	COMPONENT uart_txd_ctrl
		PORT (
			clk : IN STD_LOGIC;
			send_start : IN STD_LOGIC;
			send_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			uart_txd : OUT STD_LOGIC;
			send_ready : OUT STD_LOGIC
		);
	END COMPONENT;
	TYPE STATE_TYPE IS (STANDBY, SEND_MEASURING0, SEND_MEASURING1, SEND_MEASURING2, SEND_MEASURING3, SEND_MEASURING4, SEND_MEASURING5, SEND_MEASURING6, SEND_MEASURING7, END0, END1);
	SIGNAL STATE : STATE_TYPE := STANDBY;
	SIGNAL counter0 : NATURAL := 0;
	SIGNAL counter1 : NATURAL := 0;
	SIGNAL send_start : STD_LOGIC := '0';
	SIGNAL send_ready : STD_LOGIC := '0';
	SIGNAL send_data : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL v_copied : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
	SIGNAL I_copied : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
	SIGNAL send_counter_max : NATURAL := 1;
    SIGNAL data_num_max : NATURAL := 1;

BEGIN
	uart_txd_ctrl_0 : uart_txd_ctrl
	PORT MAP(
		CLK => CLK, 
		send_start => send_start, 
		send_data => send_data, 
		uart_txd => uart_txd, 
		send_ready => send_ready
	);

	processor : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			CASE STATE IS
				WHEN STANDBY => 
					SEND_START <= '0';
					IF (TRIGER = '1') THEN
						STATE <= SEND_MEASURING0;
						v_copied <= UART_TXD_V;
						I_copied <= UART_TXD_I;
						counter0 <= 0;
					END IF;
				WHEN SEND_MEASURING0 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(27 DOWNTO 21);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURING1;
						END IF;
					END IF;
				WHEN SEND_MEASURING1 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(20 DOWNTO 14);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURING2;
						END IF;
					END IF;
				WHEN SEND_MEASURING2 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(13 DOWNTO 7);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURING3;
						END IF;
					END IF;
				WHEN SEND_MEASURING3 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(6 DOWNTO 0);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURING4;
						END IF;
					END IF;
				WHEN SEND_MEASURING4 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & I_copied(27 DOWNTO 21);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURING5;
						END IF;
					END IF;
				WHEN SEND_MEASURING5 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & I_copied(20 DOWNTO 14);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURING6;
						END IF;
					END IF;
				WHEN SEND_MEASURING6 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & I_copied(13 DOWNTO 7);
							send_start <= '1';
							counter0 <= 0;
				            STATE <= SEND_MEASURING7;
						END IF;
					END IF;
				WHEN SEND_MEASURING7 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & I_copied(6 DOWNTO 0);
							send_start <= '1';
							counter0 <= 0;
						    STATE <= END0;
						END IF;
					END IF;
				WHEN END0 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "00001010";
							send_start <= '1';
							counter0 <= 0;
							STATE <= STANDBY;
						END IF;
					END IF;
				WHEN OTHERS => 
					STATE <= STANDBY;
			END CASE;
		END IF;
	END PROCESS;
END Behavioral;