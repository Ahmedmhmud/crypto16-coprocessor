library ieee;
use ieee.std_logic_1164.all;

entity Adder_16bit_TB is
end entity;


architecture sim of Adder_16bit_TB is

Signal A_tb,B_tb,sum_tb : std_logic_vector(15 downto 0) := (others => '0');
Signal cin_tb,cout_tb : std_logic := '0';  

begin
UUT : entity Adder_16bit 
		port map(
		A    => A_tb,
		B    => B_tb,
		cin  => cin_tb,
		sum  => sum_tb,
		cout => cout_tb
		);
		
A_tb <= x"1010";      
B_tb <= x"0010";

Cin_tb <= '0';			
	
	
end architecture;
