library ieee;
use ieee.std_logic_1164.all;

entity Full_Adder is
	port(
	a,b,cin : in std_logic;

	sum,cout : out std_logic	
	);	
end entity;


architecture DataFlow of Full_Adder is
begin

	sum  <= a xor b xor cin;
	cout <= (a and b) or (b and cin) or (cin and a);
	
end architecture;
