library ieee;
use ieee.std_logic_1164.all;

entity crypto16_coprocessor is
	port(
		Ra, Rb, Rd, ctrl: in std_logic_vector (3 downto 0);
		clk, res: in std_logic
	);
end entity;

architecture behavioral of crypto16_coprocessor is
signal ctrl_temp, Rd_temp: std_logic_vector (3 downto 0);
signal ABus, BBus, Result: std_logic_vector (15 downto 0);
signal wrt: std_logic;
begin
	-- Combinational logic declaration
	combinational: entity combinational
		port map(ABus, BBus, ctrl, Result);
	
	-- Register file declaration
	register_file: entity register_file
		port map(clk, res, wrt, Ra, Rb, Rd, Result, ABus, BBus);
		
	process (clk, res) is
	begin
		if(rising_edge(clk)) then
			if(res = '1') then
				ctrl_temp <= (others => '0');
	  			Rd_temp <= (others => '0');
			else
				Rd_temp <= Rd;
				ctrl_temp <= ctrl;
				if(ctrl_temp = "0111") then
					wrt <= '0';
				else
					wrt <= '1';		 
				end if;
			end if;
		end if;
	end process;
end architecture;
