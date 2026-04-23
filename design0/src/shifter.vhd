library ieee;																				 
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;

entity Shifter is
	port(
	
	shiftinput:in std_logic_vector(15 downto 0);
	shift_Ctrl:in std_logic_vector(1 downto 0);
	shiftout:out std_logic_vector(15 downto 0)
	
	);
end entity;		 

architecture rtl of Shifter is
signal shift_calc : std_logic_vector(15 downto 0);
begin
	
	with  shift_Ctrl select
	
	shift_calc <= std_logic_vector(unsigned(shiftinput) ror 8) when "00",
				std_logic_vector(unsigned(shiftinput) ror 4) when "01",
				  std_logic_vector(unsigned(shiftinput) sll 8) when "10",
			   (others => '0')  when others ;

end architecture;