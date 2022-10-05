LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY uart_txd_ctrl IS
	PORT (
		CLK : IN STD_LOGIC;
		SEND_START : IN STD_LOGIC;
		SEND_DATA : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		UART_TXD : OUT STD_LOGIC;
		SEND_READY : OUT STD_LOGIC
	);
END uart_txd_ctrl;
ARCHITECTURE Behavioral OF uart_txd_ctrl IS

    CONSTANT bit_counter_max : NATURAL := 100; -- = 100MHz clock / 1000000 baud rate
	CONSTANT start_bit : std_logic_vector(0 DOWNTO 0) := "0";
	CONSTANT stop_bit : std_logic_vector(0 DOWNTO 0) := "1";
 
	SIGNAL data : std_logic_vector(9 DOWNTO 0) := (OTHERS => '0');
	SIGNAL index : NATURAL;
	CONSTANT index_max : NATURAL := 10;
	SIGNAL counter0 : std_logic_vector(17 DOWNTO 0) := (OTHERS => '0');
	TYPE MAIN_STATE_TYPE IS (READY, UPDATE_UART_TX, WAITING,ENDING);
	SIGNAL MAIN_STATE : MAIN_STATE_TYPE := READY;

BEGIN
	MAIN_CTRL : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			CASE MAIN_STATE IS
				WHEN READY => 
					index <= 0;
					SEND_READY <= '1';
					IF (SEND_START = '1') THEN
						data <= stop_bit & SEND_DATA & start_bit;
						SEND_READY <= '0';
						MAIN_STATE <= UPDATE_UART_TX;
					END IF;
				WHEN UPDATE_UART_TX => 
					UART_TXD <= data(index);
					MAIN_STATE <= WAITING;
				WHEN WAITING => 
					IF (counter0 = bit_counter_max - 2) THEN
						counter0 <= (OTHERS => '0');
						IF (index < index_max-1) THEN
							index <= index + 1;
							MAIN_STATE <= UPDATE_UART_TX;
						ELSE
							MAIN_STATE <= ENDING;
						END IF;
					ELSE
						counter0 <= counter0 + 1;
					END IF;
		        WHEN ENDING =>
					IF (counter0 = bit_counter_max) THEN
					    counter0 <= (OTHERS => '0');
                        MAIN_STATE <= READY;
                    ELSE
                        counter0 <= counter0 + 1;
                    END IF;
				WHEN OTHERS => 
					MAIN_STATE <= READY;
			END CASE;
		END IF;
	END PROCESS; 
END Behavioral;