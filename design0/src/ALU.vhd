library ieee;
use ieee.std_logic_1164.all;
use work.alu_pkg.all;

entity ALU is 
	port(
		ABus : in std_logic_vector(15 downto 0);
		BBus : in std_logic_vector(15 downto 0);
		Ctrl : in std_logic_vector(2 downto 0);
		
		Result : out std_logic_vector(15 downto 0)	
		);
end entity;		

architecture struct of ALU is

signal adder_b_in : std_logic_vector(15 downto 0);
    
signal adder_cin  : std_logic;
    
signal adder_sum  : std_logic_vector(15 downto 0);
    
signal adder_cout : std_logic;

begin 

adder_b_in <= not BBus when (Ctrl = ALU_SUB) else BBus;
adder_cin <= '1' when (Ctrl = ALU_SUB) else '0';
	
arithmetic_unit : entity Adder_16bit 
	port map (
        
	A    => ABus,
        
	B    => adder_b_in,
        
	cin  => adder_cin,
        
	sum  => adder_sum,
        
	cout => adder_cout
);
	
process(Ctrl, ABus, BBus, adder_sum)
    
begin
	case Ctrl is
   
		when ALU_ADD  => Result <= adder_sum;             
		when ALU_SUB  => Result <= adder_sum;           
		when ALU_AND  => Result <= ABus and BBus;           
		when ALU_OR   => Result <= ABus or BBus;             
		when ALU_XOR  => Result <= ABus xor BBus; 
            
		when ALU_NOT  => Result <= not ABus;      
            
		when ALU_MOVE => Result <= ABus;          
           
		when others   => Result <= (others => '0');
        
		end case;
    
end process;
	
end architecture;
