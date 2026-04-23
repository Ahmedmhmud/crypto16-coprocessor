library ieee;																				 
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
use work.all;

entity Shifter_TB is
end entity;		 

architecture sim of Shifter_TB is 

signal T_in, T_out: std_logic_vector(15 downto 0);
signal T_ctrl: std_logic_vector(1 downto 0);


begin	
	
	Com: entity Shifter
                port map(T_in , T_ctrl, T_out);
		
	process	
	begin
		
		        -- Test 1: ROR 8
        T_in <= "1111111100000000";
        T_ctrl <= "00";
        wait for 10 ns;
		
		
		        -- Test 2: ROR 4
        T_in <= "1111111100000000";
        T_ctrl <= "01";
        wait for 10 ns;
		
		        -- Test 3: SLL 8
        T_in <= "1011001110001111";
        T_ctrl <= "10";
        wait for 10 ns;	
		
		        -- Test 3: 
        T_in <= "1011001110001111";
        T_ctrl <= "11" ;  --- not listed as control suppose to output zeros
		wait for 10 ns;
		
	end process;
	
end architecture;