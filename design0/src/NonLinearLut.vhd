library ieee;
use ieee.std_logic_1164.all;

entity NonlinearLut is
	port(
	LutIn :in std_logic_vector (7 downto 0);
	LutOut : out std_logic_vector (7 downto 0)
	);
end entity ;

architecture arch of NonlinearLut is 
signal S_Box1,S_Box2 : std_logic_vector (3 downto 0);							
begin 
	
	S_Box1 <= LutIn(7 downto 4);	
	
	S_Box2 <= LutIn(3 downto 0);
	
	with S_Box1 select
	LutOut(7 downto 4) <= "0001" when "0000",
						  "1011" when "0001",
						  "1001" when "0010",
						  "1100" when "0011",
						  "1101" when "0100",
						  "0110" when "0101",
						  "1111" when "0110",
						  "0011" when "0111",
						  "1110" when "1000",
						  "1000" when "1001",
						  "0111" when "1010",
						  "0100" when "1011",
						  "1010" when "1100",
						  "0010" when "1101",
						  "0101" when "1110", 
						  "0000" when "1111",
						  "0000" when others;	 
						
	with S_Box2 select
	LutOut(3 downto 0) <= "1111" when "0000",
						  "0000" when "0001",
						  "1101" when "0010",
						  "0111" when "0011",
						  "1011" when "0100",
						  "1110" when "0101",
						  "0101" when "0110",
						  "1010" when "0111",
						  "1001" when "1000",
						  "0010" when "1001",
						  "1100" when "1010",
						  "0001" when "1011",
						  "0011" when "1100",
						  "0100" when "1101",
						  "1000" when "1110", 
						  "0110" when "1111",
						  "0000" when others;

end architecture ;	
