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
signal wrt: std_logic := '0';
signal res_ff1, res_ff2, res_hybrid: std_logic := '1';
begin
	-- Combinational logic declaration
	combinational: entity combinational
		port map(ABus, BBus, ctrl_temp, Result);
	
	-- Register file declaration
	register_file: entity register_file
		port map(clk, res_hybrid, wrt, Ra, Rb, Rd_temp, Result, ABus, BBus);

	-- Hybrid reset generator: asynchronous assertion, synchronous deassertion
	process (clk, res) is
	begin
		if(res = '1') then
			res_ff1 <= '1';
			res_ff2 <= '1';
		elsif(rising_edge(clk)) then
			res_ff1 <= '0';
			res_ff2 <= res_ff1;
		end if;
	end process;

	res_hybrid <= res_ff2;
		
	-- Input register
	process (clk, res_hybrid) is
	begin
		if(res_hybrid = '1') then
			ctrl_temp <= (others => '0');
	 		Rd_temp <= (others => '0');
			wrt <= '0';
		elsif(rising_edge(clk)) then
			Rd_temp <= Rd;
			ctrl_temp <= ctrl;
			if(ctrl = "0111") then
				wrt <= '0';
			else
				wrt <= '1';		 
			end if;
		end if;
	end process;
end architecture;
