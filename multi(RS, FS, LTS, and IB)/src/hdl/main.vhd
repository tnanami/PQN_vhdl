------------------------------------------------------
-- Author: Giuseppe Leo
-- This project includes UART transmitter/receiver components
-- and a PQN unit containing 4 PQN modules (FS, RS, IB and LTS). They work in parallel 
-- and each one performs a real-time simulation of 100 PQN neurons.
-- The PQN model is a qualitative neuron model designed to faithfully
-- reproduce the electrophysiological responses of actual neurons.
------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY main IS
	GENERIC (PQN_BIT_WIDTH : NATURAL := 18);
	PORT (
		CLK : IN STD_LOGIC; -- clock
		UART_RXD : IN STD_LOGIC; -- UART receiver pin
		UART_TXD : OUT STD_LOGIC -- UART transmitter pin
	);
END main;

ARCHITECTURE Behavioral OF main IS

	-- clock generator
	-- generate 100 MHz clock from on-board 12MHz clock
	COMPONENT clk_generator
		PORT (
			clk_in1 : IN STD_LOGIC;
			clk_out1 : OUT STD_LOGIC
		);
	END COMPONENT;

	-- generate triger signal that becomes 1 every 0.1 ms
	COMPONENT triger_generator
		PORT (
			clk : IN STD_LOGIC;
			triger : OUT STD_LOGIC
		);
	END COMPONENT;

	-- PQN unit
	COMPONENT pqn_unit IS
		PORT (
			clk : IN STD_LOGIC;
			triger : IN STD_LOGIC;
			uart_rxd_I0 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_rxd_I1 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_rxd_I2 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_rxd_I3 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_txd_v0 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_txd_v1 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_txd_v2 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_txd_v3 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0)
		);
	END COMPONENT;

	-- UART transmitter
	-- transmit v0 (ib neuron), v1 (lts), v2 (rs) and v3 (fs)
	-- v is a membrane potential of the target neuron
	-- I is the input stimulus received at the receiver and given to the neuron
	-- both signals are represented by 18-bit and encoded into 3 byte data through UART communication
	-- signals are sent every 0.1 ms
	COMPONENT v_transmitter
		PORT (
			clk : IN STD_LOGIC;
			triger : IN STD_LOGIC;
			uart_txd : OUT STD_LOGIC;
			uart_txd_v0 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_txd_v1 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_txd_v2 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_txd_v3 : IN STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0)
		);
	END COMPONENT;

	-- UART receiver
	-- receive I0 (ib), I1 (lts), I2 (rs), I3 (fs) (input stimuli)
	COMPONENT I_receiver
		PORT (
			clk : IN STD_LOGIC;
			triger : IN STD_LOGIC;
			uart_rxd : IN STD_LOGIC;
			uart_rxd_I0 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_rxd_I1 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_rxd_I2 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0);
			uart_rxd_I3 : OUT STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL clk100MHz : STD_LOGIC;
	SIGNAL triger : STD_LOGIC := '0';
	SIGNAL uart_rxd_I0 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL uart_rxd_I1 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL uart_rxd_I2 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL uart_rxd_I3 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
 
	SIGNAL uart_txd_v0 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL uart_txd_v1 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL uart_txd_v2 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL uart_txd_v3 : STD_LOGIC_VECTOR(PQN_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
 
BEGIN
	clk_generator_0 : clk_generator
	PORT MAP(
		clk_in1 => CLK, 
		clk_out1 => CLK100MHz
	);

	pqn_unit_0 : pqn_unit
	PORT MAP(
		clk => clk100MHz, 
		triger => triger, 
		uart_rxd_I0 => uart_rxd_I0, 
		uart_rxd_I1 => uart_rxd_I1, 
		uart_rxd_I2 => uart_rxd_I2, 
		uart_rxd_I3 => uart_rxd_I3, 
		uart_txd_v0 => uart_txd_v0, 
		uart_txd_v1 => uart_txd_v1, 
		uart_txd_v2 => uart_txd_v2, 
		uart_txd_v3 => uart_txd_v3
	);

	triger_generator_0 : triger_generator
	PORT MAP(
		clk => CLK100MHz, 
		triger => triger
	);

	v_transmitter_0 : v_transmitter
	PORT MAP(
		clk => clk100MHz, 
		triger => triger, 
		uart_txd => uart_txd, 
		uart_txd_v0 => uart_txd_v0, 
		uart_txd_v1 => uart_txd_v1, 
		uart_txd_v2 => uart_txd_v2, 
		uart_txd_v3 => uart_txd_v3
	);

	I_receiver_0 : I_receiver
	PORT MAP(
		clk => clk100MHz, 
		triger => triger, 
		uart_rxd => uart_rxd, 
		uart_rxd_I0 => uart_rxd_I0, 
		uart_rxd_I1 => uart_rxd_I1, 
		uart_rxd_I2 => uart_rxd_I2, 
		uart_rxd_I3 => uart_rxd_I3 
	);

END Behavioral;