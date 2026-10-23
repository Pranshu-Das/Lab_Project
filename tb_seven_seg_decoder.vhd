library ieee;
use ieee.std_logic_1164.all;

entity tb_seven_seg_decoder is
end entity;

architecture sim of tb_seven_seg_decoder is
    signal code_in : std_logic_vector(3 downto 0) := "0000";
    signal seg_out : std_logic_vector(6 downto 0);
begin
    uut: entity work.seven_seg_decoder
        port map (code_in => code_in, seg_out => seg_out);

    stim: process
    begin
        code_in <= "0000"; wait for 10 ns;
        assert seg_out = "1111110" report "wrong pattern for code 0000" severity error;
        code_in <= "0001"; wait for 10 ns;
        assert seg_out = "0110000" report "wrong pattern for code 0001" severity error;
        code_in <= "0010"; wait for 10 ns;
        assert seg_out = "1101101" report "wrong pattern for code 0010" severity error;
        code_in <= "0011"; wait for 10 ns;
        assert seg_out = "1111001" report "wrong pattern for code 0011" severity error;
        code_in <= "0100"; wait for 10 ns;
        assert seg_out = "0110011" report "wrong pattern for code 0100" severity error;
        code_in <= "0101"; wait for 10 ns;
        assert seg_out = "1011011" report "wrong pattern for code 0101" severity error;
        code_in <= "0110"; wait for 10 ns;
        assert seg_out = "1011111" report "wrong pattern for code 0110" severity error;
        code_in <= "0111"; wait for 10 ns;
        assert seg_out = "1110000" report "wrong pattern for code 0111" severity error;
        code_in <= "1000"; wait for 10 ns;
        assert seg_out = "1111111" report "wrong pattern for code 1000" severity error;
        code_in <= "1001"; wait for 10 ns;
        assert seg_out = "1111011" report "wrong pattern for code 1001" severity error;
        code_in <= "1010"; wait for 10 ns;
        assert seg_out = "0000001" report "wrong pattern for code 1010" severity error;
        code_in <= "1011"; wait for 10 ns;
        assert seg_out = "0000000" report "wrong pattern for code 1011" severity error;
        code_in <= "1100"; wait for 10 ns;
        assert seg_out = "0000000" report "wrong pattern for code 1100" severity error;
        code_in <= "1101"; wait for 10 ns;
        assert seg_out = "0000000" report "wrong pattern for code 1101" severity error;
        code_in <= "1110"; wait for 10 ns;
        assert seg_out = "0000000" report "wrong pattern for code 1110" severity error;
        code_in <= "1111"; wait for 10 ns;
        assert seg_out = "0000000" report "wrong pattern for code 1111" severity error;

        report "Decoder test finished: all 16 codes checked" severity note;
        wait;
    end process;
end architecture;