-- UART transmitter
-- transmit v (membrane potential of a neuron)
-- each signal is represented by 18-bit and encoded into 3 byte data through UART communication
-- packets are sent every 0.1 ms depending on the TRIGER signal
-- a single packet is composed of following 13 byte data
-- v0(17 downto 11), v0(10 downto 4), v0(3 downto 0), v1(17 downto 11),
-- v1(10 downto 4), v1(3 downto 0), v2(17 downto 11), v2(10 downto 4),
-- v2(3 downto 0), v3(17 downto 11), v3(10 downto 4), v3(3 downto 0), 10(LF)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY v_transmitter IS
	GENERIC (PQN_BIT_WIDTH : NATURAL := 18);
	PORT (
		CLK : IN STD_LOGIC;
		TRIGER : IN STD_LOGIC;
		UART_TXD : OUT STD_LOGIC;
		UART_TXD_V0 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_TXD_V1 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_TXD_V2 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
		UART_TXD_V3 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0)
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
	TYPE STATE_TYPE IS (STANDBY, SEND_MEASURINGib0, SEND_MEASURINGib1, SEND_MEASURINGib2, SEND_MEASURINGlts0, SEND_MEASURINGlts1, SEND_MEASURINGlts2, SEND_MEASURINGrs0, SEND_MEASURINGrs1, SEND_MEASURINGrs2, SEND_MEASURINGfs0, SEND_MEASURINGfs1, SEND_MEASURINGfs2, SEND_MEASURINGi0, SEND_MEASURINGi1, SEND_MEASURINGi2, END0, END1);
	SIGNAL STATE : STATE_TYPE := STANDBY;
	SIGNAL counter0 : NATURAL := 0;
	SIGNAL counter1 : NATURAL := 0;
	SIGNAL send_start : STD_LOGIC := '0';
	SIGNAL send_ready : STD_LOGIC := '0';
	SIGNAL send_data : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL v_copied : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL I_copied : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
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
						STATE <= SEND_MEASURINGib0;
						v_copied <= UART_TXD_V0;
						counter0 <= 0;
					END IF;
				WHEN SEND_MEASURINGib0 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(17 DOWNTO 11);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURINGib1;
						END IF;
					END IF;
				WHEN SEND_MEASURINGib1 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(10 DOWNTO 4);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURINGib2;
						END IF;
					END IF;
				WHEN SEND_MEASURINGib2 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(3 DOWNTO 0) & "000";
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURINGlts0;
							v_copied <= UART_TXD_V1;
						END IF;
					END IF;
				WHEN SEND_MEASURINGlts0 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(17 DOWNTO 11);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURINGlts1;
						END IF;
					END IF;
				WHEN SEND_MEASURINGlts1 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(10 DOWNTO 4);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURINGlts2;
						END IF;
					END IF;
				WHEN SEND_MEASURINGlts2 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(3 DOWNTO 0) & "000";
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURINGrs0;
							v_copied <= UART_TXD_V2;
						END IF;
					END IF;
				WHEN SEND_MEASURINGrs0 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(17 DOWNTO 11);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURINGrs1;
						END IF;
					END IF;
				WHEN SEND_MEASURINGrs1 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(10 DOWNTO 4);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURINGrs2;
						END IF;
					END IF;
				WHEN SEND_MEASURINGrs2 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(3 DOWNTO 0) & "000";
							send_start <= '1';
							counter0 <= 0;
							v_copied <= UART_TXD_V3;
							STATE <= SEND_MEASURINGfs0;
						END IF;
					END IF;
				WHEN SEND_MEASURINGfs0 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(17 DOWNTO 11);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURINGfs1;
						END IF;
					END IF;
				WHEN SEND_MEASURINGfs1 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(10 DOWNTO 4);
							send_start <= '1';
							counter0 <= 0;
							STATE <= SEND_MEASURINGfs2;
						END IF;
					END IF;
				WHEN SEND_MEASURINGfs2 => 
					IF (counter0 < send_counter_max) THEN
						send_start <= '0';
						counter0 <= counter0 + 1;
					ELSIF (counter0 = send_counter_max) THEN
						IF (send_ready = '1') THEN
							send_data <= "1" & v_copied(3 DOWNTO 0) & "000";
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