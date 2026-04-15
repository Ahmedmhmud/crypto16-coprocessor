library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
		
Driver: process

begin
  
	
a_tb <= std_logic_vector(to_unsigned(10, 16));
        
b_tb <= std_logic_vector(to_unsigned(20, 16));
   

cin_tb <= '0';
        
wait for 20 ns;

  

        
cin_tb <= '1';
        
wait for 20 ns;



a_tb <= x"FFFF";        
b_tb <= x"0001";
        
cin_tb <= '0';
 

wait for 20 ns; --  sum=0000, cout=1

   

a_tb <= x"0010";
        
b_tb <= x"0101";
        
wait for 20 ns;

  

report "16-bit Adder Testbench Finished Successfully";
        
wait;
    
end process;			
	
	
end architecture;
