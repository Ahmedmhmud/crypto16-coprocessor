library ieee;
use ieee.std_logic_1164.all;

entity crypto16_coprocessor_TB is
end entity;

architecture sim of crypto16_coprocessor_TB is
    signal Ra, Rb, Rd, ctrl : std_logic_vector(3 downto 0) := (others => '0');
    signal clk, res : std_logic := '0';
begin
    dut : entity crypto16_coprocessor
        port map (
            Ra => Ra,
            Rb => Rb,
            Rd => Rd,
            ctrl => ctrl,
            clk => clk,
            res => res
        );

    clk_gen : process
    begin
        while now < 600 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    stim : process
    begin
        -- Reset for two rising edges to clear the register file and control state
        res <= '1';
        Ra <= (others => '0');
        Rb <= (others => '0');
        Rd <= (others => '0');
        ctrl <= "0000";
		wait for 10 ns;
        res <= '0';

        ctrl <= "0000";
        Ra <= "0000";
        Rb <= "0000";
        Rd <= "0000";
        wait until rising_edge(clk);

        -- 1: NOT R0 => R1, expected write value = FFFF
        ctrl <= "0101";
        Ra <= "0000";
        Rb <= "0000";
        Rd <= "0001";
        wait until rising_edge(clk);

        -- 2: SHL8 R1(BBus) => R2, expected write value = FF00
        ctrl <= "1010";
        Ra <= "0000";
        Rb <= "0001";
        Rd <= "0010";
        wait until rising_edge(clk);

        -- 3: ROR4 R2(BBus) => R3, expected write value = 0FF0
        ctrl <= "1001";
        Ra <= "0000";
        Rb <= "0010";
        Rd <= "0011";
        wait until rising_edge(clk);

        -- 4: ADD R1 + R3 => R4, expected write value = 0FEF
        ctrl <= "0000";
        Ra <= "0001";
        Rb <= "0011";
        Rd <= "0100";
        wait until rising_edge(clk);

        -- 5: LUT(R4[7:0]) with upper byte pass-through => R5, expected write value = 0F56
        ctrl <= "1011";
        Ra <= "0100";
        Rb <= "0000";
        Rd <= "0101";
        wait until rising_edge(clk);

        -- 6: Ctrl=0111 drives wrt low in the following cycle (no write expected next edge)
        ctrl <= "0111";
        Ra <= "0101";
        Rb <= "0001";
        Rd <= "0110";
        wait until rising_edge(clk);

        -- 7: Resume write path with XOR R1 xor R5 => R7
        ctrl <= "0100";
        Ra <= "0001";
        Rb <= "0101";
        Rd <= "0111";
        wait until rising_edge(clk);

        wait for 20 ns;
        report "crypto16coprocessor stimulus completed.";
        wait;
    end process;
end architecture;