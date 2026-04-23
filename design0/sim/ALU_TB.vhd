library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_pkg.all;

entity ALU_TB is 
end entity;		

architecture sim of ALU_TB is 

Signal ABus_tb,BBus_tb : std_logic_vector(15 downto 0) := (others => '0'); 
signal Ctrl_tb   : std_logic_vector(2 downto 0)  := (others => '0');
    
signal Result_tb : std_logic_vector(15 downto 0);

begin

	UUT : entity ALU 
		port map(
		ABus   => ABus_tb,
		BBus   => BBus_tb,
		Ctrl   => Ctrl_tb,
		Result => Result_tb
		); 
		
Driver : process is
	begin
	
	-- 1.(ADD): 50 + 30 = 80
        
	ABus_tb <= std_logic_vector(to_unsigned(50, 16));
        
	BBus_tb <= std_logic_vector(to_unsigned(30, 16));
        
	Ctrl_tb <= ALU_ADD;
        
	wait for 20 ns;

 
	
	-- 2.(SUB): 50 - 30 = 20
       
	Ctrl_tb <= ALU_SUB;
     
	wait for 20 ns;

 
	
	-- 3.(AND): 0xF0F0 AND 0x0F0F = 0x0000
    
	ABus_tb <= x"F0F0";
      
	BBus_tb <= x"0F0F";
  
	Ctrl_tb <= ALU_AND;
      
	wait for 20 ns;


	
	-- 4.(OR): 0xF0F0 OR 0x0F0F = 0xFFFF
    
	Ctrl_tb <= ALU_OR;
      
	wait for 20 ns;

 
	
	-- 5.(XOR): 0xAAAA XOR 0xAAAA = 0x0000
   
	ABus_tb <= x"AAAA";
   
	BBus_tb <= x"AAAA";
     
	Ctrl_tb <= ALU_XOR;
      
	wait for 20 ns;

  
	
	-- 6.(NOT): 0x0000 = 0xFFFF
  
	ABus_tb <= x"0000";
     
	Ctrl_tb <= ALU_NOT;
     
	wait for 20 ns;

 
	
	-- 7.(MOVE): 0x1234
  
	ABus_tb <= x"1234";
      
	Ctrl_tb <= ALU_MOVE;
       
	wait for 20 ns;

 
	
	report "ALU Testbench with Package Finished Successfully!";
     
		wait;	
		
	end process;
	
end architecture;
