library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg_scroll is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        start   : in  std_logic;
        seg_out : out std_logic_vector(6 downto 0); -- Connects directly to segments a-g
        dp_out  : out std_logic;                    -- Connects to hardware DP
        sel_out : out std_logic_vector(3 downto 0)  -- Connects to hardware S1-S4
    );
end entity;

architecture behavioral of seven_seg_scroll is

    -- ===== Shared-contract constants =====
    constant MUX_LIMIT        : integer := 4;         -- SIM   (BOARD = 50000)
    constant SCROLL_LIMIT     : integer := 40;        -- SIM   (BOARD = 25000000)
    constant BLANK            : std_logic_vector(3 downto 0) := "1110";
    constant SEL_ACTIVE_LOW   : std_logic := '0';     -- set '1' in lab if needed
    constant SEG_ACTIVE_LOW   : std_logic := '1';     -- common anode: segments on = '0'

    -- Part B stream: 3 9 6 1 - 3 9 6 2  (25B3961, minus, 25B3962)
    constant N : integer := 9;
    type stream_t is array (0 to N-1) of std_logic_vector(3 downto 0);
    constant STREAM : stream_t := ("0011","1001","0110","0001","1010",
                                   "0011","1001","0110","0010");

    -- Internal display buffer storing 4-bit encoded values
    type display_buffer_t is array (0 to 3) of std_logic_vector(3 downto 0);
    signal current_digits : display_buffer_t;

    -- ===== Shared-contract signals =====
    signal mux_tick    : std_logic;
    signal scroll_tick : std_logic;
    signal running     : std_logic;
    signal digit_idx   : integer range 0 to 3 := 0;
    signal code_now    : std_logic_vector(3 downto 0);
    signal sel_raw     : std_logic_vector(3 downto 0);

    -- Output path signals
    signal seg_raw : std_logic_vector(6 downto 0);
    signal seg_reg : std_logic_vector(6 downto 0) := (others => '0');
    signal sel_reg : std_logic_vector(3 downto 0) := (others => '0');

    -- ===== Pranav's declarations go here at the merge (mux_cnt, scroll_cnt, idx, mux_state_t ...) =====

    -- ===== TEMPORARY STUB signal (delete at merge) =====
    signal stub_cnt : integer range 0 to MUX_LIMIT-1 := 0;

begin

    -- ===== SCROLL ENGINE (paste from Part A): tick generators, start logic, scroll process, mux FSM =====

    -- ----- TEMPORARY STUB START (delete at merge) -----
    -- fixed screen: 3 9 6 1  (index 0 = rightmost S1)
    current_digits <= ("0001","0110","1001","0011");

    -- mux_tick every MUX_LIMIT clocks
    stub_tick_proc: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                stub_cnt <= 0;
                mux_tick <= '0';
            elsif stub_cnt = MUX_LIMIT-1 then
                stub_cnt <= 0;
                mux_tick <= '1';
            else
                stub_cnt <= stub_cnt + 1;
                mux_tick <= '0';
            end if;
        end if;
    end process;

    -- digit_idx counts 0,1,2,3
    stub_idx_proc: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                digit_idx <= 0;
            elsif mux_tick = '1' then
                if digit_idx = 3 then
                    digit_idx <= 0;
                else
                    digit_idx <= digit_idx + 1;
                end if;
            end if;
        end if;
    end process;

    -- matching one-hot select
    stub_sel_proc: process(digit_idx)
    begin
        case digit_idx is
            when 0 => sel_raw <= "0001";
            when 1 => sel_raw <= "0010";
            when 2 => sel_raw <= "0100";
            when others => sel_raw <= "1000";
        end case;
    end process;

    code_now <= current_digits(digit_idx);
    -- ----- TEMPORARY STUB END -----

    -- ===== Decoder instance =====
    dec_inst: entity work.seven_seg_decoder
        port map (code_in => code_now, seg_out => seg_raw);

    -- ===== Output register: segments and selects update on the same edge (no ghosting) =====
    out_reg_proc: process(clk)
    begin
        if rising_edge(clk) then
            seg_reg <= seg_raw;
            sel_reg <= sel_raw;
        end if;
    end process;

    -- ===== Outputs with polarity =====
    seg_out <= not seg_reg when SEG_ACTIVE_LOW = '1' else seg_reg;
    sel_out <= not sel_reg when SEL_ACTIVE_LOW = '1' else sel_reg;
    dp_out  <= SEG_ACTIVE_LOW;   -- "off" for either polarity

end architecture;