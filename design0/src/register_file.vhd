library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
	port(
	clk,res,wrt : in std_logic;
	Ra,Rb,Rd : in std_logic_vector(3 downto 0);
	result : in std_logic_vector(15 downto 0);
	ABus,BBus : out std_logic_vector(15 downto 0)
	);	  
end entity;	

architecture rtl of register_file is	
type reg_data is array (0 to 15) of std_logic_vector(15 downto 0);
signal registers : reg_data := (others => (others => '0'));

begin		 
	process(clk,res)
	begin		 
		if(res = '1') then --(Asynchronous operation)		   
			registers <= (others => (others => '0'));	--set all the registers to 0 when reset is on
		elsif rising_edge(clk) then --(Synchronous operation)
			if(wrt = '1') then
				registers(to_integer(unsigned(Rd))) <= result; -- assign the result value in Rd register 
			end if;	   
			-- take the values stored in Ra&Rb
			ABUS <= registers(to_integer(unsigned(Ra)));
            BBUS <= registers(to_integer(unsigned(Rb)));
		end if;
	end process;  
	end architecture;
	
	
