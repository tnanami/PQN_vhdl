LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY uart_rxd_ctrl IS
	PORT (
		CLK : IN STD_LOGIC;
		UART_RXD : IN STD_LOGIC;
		RECEIVED_DATA : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		RECEIVED_DONE : OUT STD_LOGIC
	);
END uart_rxd_ctrl;
ARCHITECTURE Behavioral OF uart_rxd_ctrl IS

CONSTANT  bit_counter_max : NATURAL := 50; -- =  2000000 baud rate / 100MHz clock
CONSTANT  bit_delay_max : NATURAL := 25; -- = bit_counter_max/2 

CONSTANT index_max : NATURAL := 8;
SIGNAL index : NATURAL;
SIGNAL data : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL counter0 : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
TYPE MAIN_STATE_TYPE IS (READY, DELAY, RECEIVING, WAITING);
SIGNAL MAIN_STATE : MAIN_STATE_TYPE := READY;

BEGIN

	main_ctrl : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			CASE MAIN_STATE IS
				WHEN READY => 
					index <= 0;
					RECEIVED_DONE <= '0';
					data <= (OTHERS => '0');
					IF (UART_RXD = '0') THEN
						MAIN_STATE <= DELAY;
					END IF;
				WHEN DELAY => 
				    IF(counter0 < bit_delay_max)THEN
				        counter0 <= (OTHERS => '0');
				        MAIN_STATE <= WAITING;
				    ELSE
				        counter0 <= counter0 + 1;
				    END IF;
				WHEN WAITING => 
					IF (counter0 = bit_counter_max - 2) THEN
						counter0 <= (OTHERS => '0');
					    MAIN_STATE <= RECEIVING;
					ELSE
					    counter0 <= counter0 + 1;
					END IF;
		        WHEN RECEIVING =>
		            IF (index < index_max) THEN
		                index <= index + 1;
		                data(index) <= UART_RXD;
		                counter0 <= (OTHERS => '0');
		                MAIN_STATE <= WAITING;
                    ELSE
                        RECEIVED_DATA <= data;
                        RECEIVED_DONE <= '1';
                        MAIN_STATE <= READY;
                    END IF;
				WHEN OTHERS => 
					MAIN_STATE <= READY;
			END CASE;
		END IF;
	END PROCESS; 

END BEHAVIORAL;