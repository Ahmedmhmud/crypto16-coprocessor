library ieee;
use ieee.std_logic_1164.all;

package alu_pkg is
	
    constant ALU_ADD  : std_logic_vector(3 downto 0) := "0000";
    constant ALU_SUB  : std_logic_vector(3 downto 0) := "0001";
    constant ALU_AND  : std_logic_vector(3 downto 0) := "0010";
    constant ALU_OR   : std_logic_vector(3 downto 0) := "0011";
    constant ALU_XOR  : std_logic_vector(3 downto 0) := "0100";
    constant ALU_NOT  : std_logic_vector(3 downto 0) := "0101";
    constant ALU_MOVE : std_logic_vector(3 downto 0) := "0110";
	
end package;