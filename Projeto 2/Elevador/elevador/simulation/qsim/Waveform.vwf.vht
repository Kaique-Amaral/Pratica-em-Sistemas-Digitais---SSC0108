-- Copyright (C) 2025  Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Altera and sold by Altera or its authorized distributors.  Please
-- refer to the Altera Software License Subscription Agreements 
-- on the Quartus Prime software download page.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "11/13/2025 15:35:13"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          elevador
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY elevador_vhd_vec_tst IS
END elevador_vhd_vec_tst;
ARCHITECTURE elevador_arch OF elevador_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL and_atual : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL andar_req : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL BTN_CLOCK : STD_LOGIC;
SIGNAL CLOCK : STD_LOGIC;
SIGNAL HEX0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL HEX3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL LEDR : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL RESET : STD_LOGIC;
COMPONENT elevador
	PORT (
	and_atual : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	andar_req : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	BTN_CLOCK : IN STD_LOGIC;
	CLOCK : IN STD_LOGIC;
	HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	LEDR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	RESET : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : elevador
	PORT MAP (
-- list connections between master ports and signals
	and_atual => and_atual,
	andar_req => andar_req,
	BTN_CLOCK => BTN_CLOCK,
	CLOCK => CLOCK,
	HEX0 => HEX0,
	HEX1 => HEX1,
	HEX2 => HEX2,
	HEX3 => HEX3,
	LEDR => LEDR,
	RESET => RESET
	);
-- andar_req[3]
t_prcs_andar_req_3: PROCESS
BEGIN
	andar_req(3) <= '0';
WAIT;
END PROCESS t_prcs_andar_req_3;
-- andar_req[2]
t_prcs_andar_req_2: PROCESS
BEGIN
	andar_req(2) <= '0';
	WAIT FOR 2000000 ps;
	andar_req(2) <= '1';
	WAIT FOR 11000000 ps;
	andar_req(2) <= '0';
WAIT;
END PROCESS t_prcs_andar_req_2;
-- andar_req[1]
t_prcs_andar_req_1: PROCESS
BEGIN
	andar_req(1) <= '0';
	WAIT FOR 2000000 ps;
	andar_req(1) <= '1';
	WAIT FOR 11000000 ps;
	andar_req(1) <= '0';
WAIT;
END PROCESS t_prcs_andar_req_1;
-- andar_req[0]
t_prcs_andar_req_0: PROCESS
BEGIN
	andar_req(0) <= '0';
	WAIT FOR 2000000 ps;
	andar_req(0) <= '1';
	WAIT FOR 21000000 ps;
	andar_req(0) <= '0';
WAIT;
END PROCESS t_prcs_andar_req_0;

-- CLOCK
t_prcs_CLOCK: PROCESS
BEGIN
LOOP
	CLOCK <= '0';
	WAIT FOR 500000 ps;
	CLOCK <= '1';
	WAIT FOR 500000 ps;
	IF (NOW >= 30000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_CLOCK;

-- RESET
t_prcs_RESET: PROCESS
BEGIN
	RESET <= '0';
WAIT;
END PROCESS t_prcs_RESET;
END elevador_arch;
