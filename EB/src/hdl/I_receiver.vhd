LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY I_receiver IS
    GENERIC (PQN_BIT_WIDTH : NATURAL := 18);
	PORT (
        CLK : IN STD_LOGIC;
        TRIGER : IN STD_LOGIC;
        UART_RXD : IN STD_LOGIC;
        UART_RXD_I : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0)
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
        din : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC;
        data_count : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
      );
    END COMPONENT;

    SIGNAL received_done : STD_LOGIC := '0';    
    SIGNAL received_data : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL received_data18 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    TYPE STATE_TYPE IS (READY, READ0, READ1, READ2);
    SIGNAL STATE : STATE_TYPE := READY;
    TYPE FIFO_STATE_TYPE IS (READY, PROCESS0, PROCESS1, PROCESS2);
    SIGNAL FIFO_STATE : FIFO_STATE_TYPE := READY;
        
    SIGNAL fifo_din : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fifo_dout : STD_LOGIC_VECTOR(PQN_BIT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fifo_wr_en : STD_LOGIC := '0';
    SIGNAL fifo_rd_en : STD_LOGIC := '0';
    SIGNAL fifo_full : STD_LOGIC := '0';
    SIGNAL fifo_empty : STD_LOGIC := '0';
    SIGNAL fifo_data_count : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');

BEGIN

    DATA_CTRL : PROCESS (CLK)
    BEGIN
        IF (rising_edge(CLK)) THEN
            CASE STATE IS
                WHEN READY => 
                    IF (received_data = "00001010" and received_done ='1' ) THEN
                        fifo_din <= "000000000000001010"; 
                        fifo_wr_en <= '1';
                    ELSIF(received_done ='1') THEN
                        received_data18(17 downto 10) <= received_data;
                        STATE <= READ0;
                    ELSE
                        fifo_wr_en <= '0';
                    END IF;
                WHEN READ0 =>
                    IF (received_done ='1') THEN
                        received_data18(9 downto 2) <= received_data;
                        STATE <= READ1;
                    END IF; 
                 WHEN READ1 =>
                    IF (received_done ='1') THEN
                        received_data18(1 downto 0) <= received_data(1 downto 0);
                        STATE <= READ2;
                    END IF;           
                WHEN READ2 =>
                    fifo_din <= received_data18;     
                    fifo_wr_en <= '1';
                    STATE <= READY;
            	WHEN OTHERS =>
                    STATE <= READY;
            END CASE;
        END IF;
    END PROCESS;

    FIFO_OUT_CTRL : PROCESS (CLK)
    BEGIN
        IF (rising_edge(CLK)) THEN
            CASE FIFO_STATE IS
                WHEN READY => 
                    IF (TRIGER ='1') THEN
                        fifo_rd_en <= '1';
                        FIFO_STATE <= PROCESS0;
                    END IF;
                WHEN PROCESS0 =>
                    IF( FIFO_DOUT /= "000000000000001010")THEN
                        UART_RXD_I <= fifo_dout;
                    ELSE
                        fifo_rd_en <= '0';
                        FIFO_STATE <= READY;    
                    END IF;          
            	WHEN OTHERS =>
                    FIFO_STATE <= READY;
            END CASE;
        END IF;
    END PROCESS;
    
	uart_rxd_ctrl_0 : uart_rxd_ctrl
	PORT MAP(
        clk => CLK, 
        uart_rxd =>  UART_RXD,
        received_data =>  received_data, 
        received_done =>  received_done
	);

    fifo_0 :  fifo_I
	PORT MAP(
		CLK => CLK, 
		din => fifo_din,
		wr_en => fifo_wr_en,
        rd_en => fifo_rd_en,
        dout => fifo_dout,
        full => fifo_full,
        empty => fifo_empty,
        data_count => fifo_data_count
	);
	
END Behavioral;