--=============================================================================
--    This file is part of FPGA_NEURAL-Network.
--
--    FPGA_NEURAL-Network is free software: you can redistribute it and/or 
--    modify it under the terms of the GNU General Public License as published 
--    by the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    FPGA_NEURAL-Network is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with FPGA_NEURAL-Network.  
--		If not, see <http://www.gnu.org/licenses/>.

--=============================================================================
--	FILE NAME			: nn_instance.vhd
--	PROJECT				: FPGA_NEURAL-Network
--	ENTITY				: NN_INSTANCE
--	ARCHITECTURE		: structure
--=============================================================================
--	AUTORS(s)			: Agostini, N; Barbosa, F
--	DEPARTMENT      	: Electrical Engineering (UFRGS)
--	DATE					: Dec 12, 2014
--=============================================================================
--	Description:
--	
--=============================================================================

library ieee;
use ieee.std_logic_1164.all;
use work.NN_TYPES_pkg.all;
use work.NN_CONSTANTS_pkg.all;

--=============================================================================
-- Entity declaration for NN_INSTANCE
--=============================================================================
entity NN_INSTANCE is 
	port (
		clk			:	in std_logic;
		NN_start		:	in	std_logic;
		NN_sample 	: 	in std_logic_vector (8 downto 0);
		NN_result 	: 	out std_logic_vector (1 downto 0);
		NN_expected	: 	out std_logic_vector (1 downto 0);
		NN_ready		: 	out std_logic
	);
end NN_INSTANCE;

--=============================================================================
-- architecture declaration
--=============================================================================
architecture structure of NN_INSTANCE is

	-- Signals for the NEURAL NETWORK
	signal	START			: std_logic;
	signal 	CONTROL_IN, CONTROL_HIDDEN, CONTROL_OUT	:std_logic;
	signal	DATA_READY	: std_logic;
	signal	INPUT													: ARRAY_OF_SFIXED (0 to (PERCEPTRONS_INPUT-1)) := A_SAMPLE_INPUT;
	signal	OUTPUT												: ARRAY_OF_SFIXED (0 to (PERCEPTRONS_HIDDEN-1));
	
	
	component GENERIC_NEURAL_NET 
		generic	(
					NUMBER_OF_INPUT_NEURONS : natural;
					NUMBER_OF_HIDDEN_NEURONS : natural;
					NUMBER_OF_OUTPUT_NEURONS : natural;
					WEIGHTS_MATRIX : FIXED_WEIGHTS_MATRIX
					);
		
		port		(
					INPUT													:in ARRAY_OF_SFIXED;
					CONTROL_IN, CONTROL_HIDDEN, CONTROL_OUT	:in std_logic;
					START, CLK											:in std_logic;
					OUTPUT												:out ARRAY_OF_SFIXED;
					DATA_READY											:out std_logic
					);

	end component;
	
--=============================================================================
-- architecture begin
--=============================================================================	
	begin
		CONTROL_IN<='1';
		CONTROL_HIDDEN<='1';
		CONTROL_OUT<='1';
		
		
		GEN_NET: GENERIC_NEURAL_NET 
		generic map	(
						NUMBER_OF_INPUT_NEURONS		=> PERCEPTRONS_INPUT,
						NUMBER_OF_HIDDEN_NEURONS	=> PERCEPTRONS_HIDDEN,
						NUMBER_OF_OUTPUT_NEURONS	=> PERCEPTRONS_OUTPUT,
						WEIGHTS_MATRIX=> FIXED_WEIGHTS_MATRIX_INSTANCE
						)
		
		port map		(
						INPUT => INPUT,
						CONTROL_IN => CONTROL_IN, CONTROL_HIDDEN => CONTROL_IN, CONTROL_OUT => CONTROL_IN,
						START => START, CLK => CLK,
						OUTPUT=>	OUTPUT,
						DATA_READY => DATA_READY
						);

end structure;
--=============================================================================
-- architecture end
--=============================================================================