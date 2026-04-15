library ieee;
use ieee.std_logic_1164.all;


entity ALU is 
	port(
		A : in std_logic_vector(15 downto 0);
		B : in std_logic_vector(15 downto 0);
		OP : in std_logic_vector(3 downto 0);
		
		RESULT : out std_logic_vector(15 downto 0)	
		);
end entity;		
		