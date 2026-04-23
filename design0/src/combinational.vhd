library ieee;
use ieee.std_logic_1164.all; 

entity combinational is
	
	port(
	ABUS , BBUS : in std_logic_vector(15 downto 0);
	CTRL : in std_logic_vector(3 downto 0);
	
	Result : out std_logic_vector(15 downto 0)
	);
	
end entity;


architecture rtl of combinational is

signal alu_out , shifter_out : std_logic_vector(15 downto 0);
signal LUT_out_temp : std_logic_vector(7 downto 0);
signal sel_block : std_logic_vector(1 downto 0);
signal alu_op : std_logic_vector(2 downto 0);
signal shift_op : std_logic_vector(1 downto 0);

begin
	
	ControlUnit: entity control_unit
		port map (
			ctrl => CTRL,
			sel_block => sel_block,
			alu_op => alu_op,
			shift_op => shift_op
		);
	
	ALU: entity alu
		port map ( ABUS , BBUS , alu_op , alu_out );
		
		
	Shifter: entity shifter
		port map ( BBUS , shift_op , shifter_out );
		
		
	nonLinearLUT: entity nonLinearLUT
		port map ( ABUS(7 downto 0) , LUT_out_temp );	
	
	process(sel_block, alu_out, shifter_out, ABUS, LUT_out_temp) is
	begin
		
		if(sel_block = "00") then
			Result <= alu_out;
		elsif(sel_block = "01") then
			Result <= shifter_out;
		elsif(sel_block = "10") then
			Result <= ABUS(15 downto 8) & LUT_out_temp;
		else
			Result <= x"0000";
		end if;
		
		
	end process;
	
	
end architecture;
