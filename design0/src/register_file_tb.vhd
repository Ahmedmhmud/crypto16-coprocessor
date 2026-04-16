library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file_tb is
end entity;  

architecture sim of register_file_tb is 
--intialize all signals to 0
signal clk, res, wrt : std_logic := '0';
signal Ra, Rb, Rd : std_logic_vector(3 downto 0) := (others => '0');
signal result : std_logic_vector(15 downto 0) := (others => '0');
signal ABus, BBus : std_logic_vector(15 downto 0);
begin  	 
	--instatiate component 
	U1: entity register_file
		port map(clk=>clk,res=>res,wrt=>wrt,Ra=>Ra,Rb=>Rb,Rd=>Rd,result=>result,ABus=>ABus,BBus=>BBus);
		
	--simulate the clock to vibrate every 5ns until 200 ns
	clk_sim: process
    begin
	while now < 200 ns loop
	clk <= '0'; wait for 5 ns;
	clk <= '1'; wait for 5 ns;
	end loop;
    wait;
    end process; 
	
	--simulate the register file 
    reg_sim: process
    begin
	--set the reset input to 1 for 10ns at first,then to 0 until the end of simulation
    res <= '1'; wait for 10 ns;
	res <= '0'; wait for 10 ns;
	
	--set the write to 1 after 20 ns from the beginning of the simulation
    wrt <= '1';
	
    --after 20 ns(from beginning) assign a value to the result and change the value of Rd & wait for 10 ns
    Rd <= "0101"; 
    result <= x"AAAA";
    wait for 10 ns;	
	
    --after 30 ns(from beginning) assign a new value to the result and change the value of Rd & wait for 10 ns
    Rd <= "1010";     
    result <= x"BBBB";
    wait for 10 ns;
	
	--after 40 ns(from beginning) set the write to 0 and assign a value to Ra,Rb & wait for 20 ns 
    wrt <= '0';
    Ra <= "0101"; 
    Rb <= "1010";    
    wait for 20 ns;
    wait;
    end process;
end architecture;
