library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity combinational_TB is
end combinational_TB;

architecture sim of combinational_TB is

signal ABUS , BBUS : std_logic_vector(15 downto 0);
signal CTRL : std_logic_vector(3 downto 0);
	
signal Result : std_logic_vector(15 downto 0);
	
begin
	
	UUT: entity combinational
		port map ( ABUS , BBUS , CTRL , Result );
		
		
	--MUX selection tests
	
	process is
	begin
	
	--ALU	
	ABUS <= std_logic_vector(to_unsigned(50, 16));
	BBUS <= std_logic_vector(to_unsigned(30, 16));
	
	CTRL <= "0001"; --ALU_sub op_code
	
	wait for 20 ns;		-- expected: 20
	
	
	--Shifter
	BBUS <= x"FF00";
	
	CTRL <= "1001";	 -- shifter ROR4
	
	wait for 20 ns; -- expected: Ox0FF0
	
	
	--non_linear LUT
	ABUS <= x"0000";
	
	CTRL <= "1011"; -- LUT op_code
	
	wait for 20 ns; --expected: Ox001F
	
	
	-- CTRL = 7 or an out of range value
	ABUS <= x"0011";
	BBUS <= X"1010";
	
	CTRL <= "0111"; 
	
	wait ; -- expected: Ox0000
	
	end process;
	
end sim;
