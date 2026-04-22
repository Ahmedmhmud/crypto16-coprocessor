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
signal sel_block : std_logic_vector(1 downto 0);
signal alu_en, shifter_en, luu_en : std_logic;

begin
	
	ControlUnit: entity work.control_unit(behavoiral)
		port map (
			ctrl => CTRL,
			sel_block => sel_block,
			alu_en => alu_en,
			shifter_en => shifter_en,
			luu_en => luu_en
		);
	
	ALU: entity work.alu(struct)
		port map (
			ABus => ABUS,
			BBus => BBUS,
			Ctrl => CTRL,
			Result => alu_out
		);
		
		
	Shifter: entity work.shifter(rtl)
		port map (
			shiftinput => BBUS,
			shift_Ctrl => CTRL,
			shiftout => shifter_out
		);
		
		
	nonLinearLUT: entity work.nonLinearLUT(arch)
		port map (
			LutIn => ABUS(7 downto 0),
			LutOut => LUT_out_temp
		);
		
		
	LUT_out <= ABUS(15 downto 8) & LUT_out_temp;
	
	
	process(sel_block, alu_en, shifter_en, luu_en, alu_out, shifter_out, LUT_out) is
	begin
		
		if(alu_en = '1' and sel_block = "00") then
			Result <= alu_out;
		elsif(shifter_en = '1' and sel_block = "01") then
			Result <= shifter_out;
		elsif(luu_en = '1' and sel_block = "10") then
			Result <= LUT_out;
		else
			Result <= x"0000";
		end if;
		
		
	end process;
	
	
end architecture;
