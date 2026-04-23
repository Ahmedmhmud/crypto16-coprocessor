library ieee;
use ieee.std_logic_1164.all;

package alu_pkg is
	
    constant ALU_ADD  : std_logic_vector(2 downto 0) := "000";
    constant ALU_SUB  : std_logic_vector(2 downto 0) := "001";
    constant ALU_AND  : std_logic_vector(2 downto 0) := "010";
    constant ALU_OR   : std_logic_vector(2 downto 0) := "011";
    constant ALU_XOR  : std_logic_vector(2 downto 0) := "100";
    constant ALU_NOT  : std_logic_vector(2 downto 0) := "101";
    constant ALU_MOVE : std_logic_vector(2 downto 0) := "110";
	
end package;