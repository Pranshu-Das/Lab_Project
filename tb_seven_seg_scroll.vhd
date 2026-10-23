library ieee;
use ieee.std_logic_1164.all;

entity tb_seven_seg_scroll is
end entity;

architecture sim of tb_seven_seg_scroll is
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal start   : std_logic := '0';
    signal seg_out : std_logic_vector(6 downto 0);
    signal dp_out  : std_logic;
    signal sel_out : std_logic_vector(3 downto 0);
begin
    uut: entity work.seven_seg_scroll
        port map (clk => clk, reset => reset, start => start,
                  seg_out => seg_out, dp_out => dp_out, sel_out => sel_out);

    clk <= not clk after 10 ns;   -- 50 MHz

    stim: process
    begin
        reset <= '1'; start <= '0';
        wait for 100 ns;          -- 5 clock cycles
        reset <= '0';
        wait for 100 ns;
        start <= '1';
        wait for 30 us;           -- more than 2 full scroll loops (13 x 40 x 2 clocks = 20.8 us)
        report "Part B simulation finished" severity note;
        wait;
    end process;

    -- sel_out must always be one-hot once running (assumes SEL_ACTIVE_LOW = '0' in simulation)
    check_sel: process
    begin
        wait for 400 ns;
        loop
            wait until falling_edge(clk);
            assert (sel_out = "0001" or sel_out = "0010" or
                    sel_out = "0100" or sel_out = "1000")
                report "sel_out is not one-hot" severity error;
        end loop;
    end process;
end architecture;