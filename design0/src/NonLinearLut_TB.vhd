library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity NonlinearLut_TB is
end entity ;

architecture arch of NonlinearLut_TB is
	component NonlinearLut
    	PORT(
         	lutIn : IN  std_logic_vector(7 downto 0);
         	lutOut : OUT  std_logic_vector(7 downto 0)
        	);
    end component;
	
signal 	lutIn : std_logic_vector(7 downto 0):= x"00"; 
signal 	lutOut : std_logic_vector(7 downto 0);	
begin 
	
	LUT :entity NonlinearLut
		port map(
		lutIn => lutIn ,lutOut => lutOut) ;	  
		
	sim_Process : process 
	begin		 
	--	lutIn <=x"00";
	--	wait for 10 ns ;
	--	lutIn <=x"01";
	--	wait for 10 ns ;
	--	lutIn <=x"02";
	--	wait for 10 ns ;
	--	lutIn <=x"03";
	--	wait for 10 ns ;
	--	lutIn <=x"04";
	--	wait for 10 ns ;
	--	lutIn <=x"05";
	--	wait for 10 ns ;
	--	lutIn <=x"06";
	--	wait for 10 ns ;
	--	lutIn <=x"07";
	--	wait for 10 ns ;
	--	lutIn <=x"08";
	--	wait for 10 ns ;
	--	lutIn <=x"09";
	--	wait for 10 ns ;
	--	lutIn <=x"0A";
	--	wait for 10 ns ;
	--	lutIn <=x"0B";
	--	wait for 10 ns ;
	--	lutIn <=x"0C";
	--	wait for 10 ns ;
	--	lutIn <=x"0D";
	--	wait for 10 ns ;
	--	lutIn <=x"0E";
	--	wait for 10 ns ;
	--	lutIn <=x"0F";
	--	wait for 10 ns ;
		
		for i in 0 to 15 loop 
			lutIn <= std_logic_vector(to_unsigned(i,8));	
		 wait for 100 ns ;
		end loop;
		wait;
	end process	;			
	
end architecture ;	
