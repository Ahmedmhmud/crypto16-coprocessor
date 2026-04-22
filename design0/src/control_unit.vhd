library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
	port(
		ctrl: in std_logic_vector (3 downto 0);
		sel_block: out std_logic_vector (1 downto 0);
		alu_en, shifter_en, luu_en: out	std_logic
	);
end entity;

architecture behavoiral of control_unit is
begin									  
	process (ctrl) is
	begin
		sel_block <= "11";
		alu_en <= '0';
		shifter_en <= '0';
		luu_en <= '0';
		
		if(ctrl <= x"7") then
			sel_block <= "00";
			alu_en <= '1';
		elsif(ctrl <= x"A") then
			sel_block <= "01";
			shifter_en <= '1';
		elsif(ctrl <= x"B") then
			sel_block <= "10";
			luu_en <= '1';
		else
			sel_block <= "11";
		end if;
	end process;
end architecture;