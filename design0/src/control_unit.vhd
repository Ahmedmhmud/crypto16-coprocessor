library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
	port(
		ctrl: in std_logic_vector (3 downto 0);
		sel_block: out std_logic_vector (1 downto 0);
		alu_op: out std_logic_vector (2 downto 0);
		shift_op: out std_logic_vector (1 downto 0)
	);
end entity;

architecture behavoiral of control_unit is
begin									  
	process (ctrl) is
	begin
		sel_block <= "11";
		alu_op <= "000";
		shift_op <= "00";
		
		if(ctrl <= x"7") then
			sel_block <= "00";
			alu_op <= ctrl(2 downto 0);
		elsif(ctrl <= x"A") then
			sel_block <= "01";
			shift_op <= ctrl(1 downto 0);
		elsif(ctrl <= x"B") then
			sel_block <= "10";
		else
			sel_block <= "11";
		end if;
	end process;
end architecture;