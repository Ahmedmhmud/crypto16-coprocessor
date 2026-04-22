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

signal alu_out , shifter_out , LUT_out : std_logic_vector(15 downto 0);
signal LUT_out_temp : std_logic_vector(7 downto 0);

begin
	
	ALU: entity alu
		port map ( ABUS , BBUS , CTRL , alu_out );
		
		
	Shifter: entity shifter
		port map ( BBUS , CTRL , shifter_out );
		
		
	nonLinearLUT: entity nonLinearLUT
		port map ( ABUS(7 downto 0) , LUT_out_temp );
		
		
	LUT_out <= ABUS(15 downto 8) & LUT_out_temp;
	
	
	process(CTRL , alu_out , shifter_out , LUT_out) is
	begin
		
		if( CTRL >= x"0" and CTRL <= x"7" ) then
			Result <= alu_out;
		elsif( CTRL >= x"8" and CTRL <= x"A" ) then
			Result <= shifter_out;
		elsif( CTRL = x"B" ) then
			Result <= LUT_out;
		else
			Result <= x"0000";
		end if;
		
		
	end process;
	
	
end architecture;
