library ieee;
use ieee.std_logic_1164.all;


entity Adder_16bit is
	port(
	A,B : in std_logic_vector(15 downto 0);
	cin : in std_logic;
	
	sum  : out std_logic_vector(15 downto 0);
	cout : out std_logic
	);
	
 end entity;
	
architecture struct of Adder_16bit is 
component Full_Adder is
        
	port (a, b, cin : in std_logic; 
	sum, cout : out std_logic);
    
end component;

Signal carry : std_logic_vector(16 downto 0);  

begin
	carry(0) <= cin;
	
	G : for i in 0 to 15 generate
		FA : Full_Adder port map(
		a    => A(i),
		b    => B(i),
		cin  => carry(i),
		sum  => sum(i),
		cout => carry(i+1)
		);
	end generate;
	
	 cout <= carry(16);
end architecture;
