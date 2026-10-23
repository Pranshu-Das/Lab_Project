library ieee;
use ieee.std_logic_1164.all;

entity seven_seg_decoder is
    port (
        code_in : in  std_logic_vector(3 downto 0);  -- 4-bit input code
        seg_out : out std_logic_vector(6 downto 0)   -- Segments a to g (active high)
    );
end entity;

architecture behavioral of seven_seg_decoder is
begin
    -- Purely combinational decoder: seg_out = a b c d e f g, '1' = segment on
    process(code_in)
    begin
        case code_in is
            when "0000" => seg_out <= "1111110";  -- 0
            when "0001" => seg_out <= "0110000";  -- 1
            when "0010" => seg_out <= "1101101";  -- 2
            when "0011" => seg_out <= "1111001";  -- 3
            when "0100" => seg_out <= "0110011";  -- 4
            when "0101" => seg_out <= "1011011";  -- 5
            when "0110" => seg_out <= "1011111";  -- 6
            when "0111" => seg_out <= "1110000";  -- 7
            when "1000" => seg_out <= "1111111";  -- 8
            when "1001" => seg_out <= "1111011";  -- 9
            when "1010" => seg_out <= "0000001";  -- minus (g only)
            when others => seg_out <= "0000000";  -- blank (1011 to 1111)
        end case;
    end process;
end architecture;