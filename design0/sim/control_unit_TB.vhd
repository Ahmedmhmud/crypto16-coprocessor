library ieee;
use ieee.std_logic_1164.all;

entity control_unit_TB is
end entity;

architecture sim of control_unit_TB is
    signal ctrl : std_logic_vector(3 downto 0) := (others => '0');
    signal sel_block : std_logic_vector(1 downto 0);
    signal alu_en, shifter_en, luu_en : std_logic;
begin
    dut : entity control_unit
        port map (ctrl, sel_block, alu_en, shifter_en, luu_en);

    process
    begin
        -- ALU class
        ctrl <= x"0";
        wait for 10 ns;

        -- Shifter class
        ctrl <= x"8";
        wait for 10 ns;

        -- LUT class
        ctrl <= x"B";
        wait for 10 ns;

        -- Invalid class
        ctrl <= x"F";
        wait for 10 ns;

        wait;
    end process;
end architecture;
