library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_div is
    generic (
        DIVIDER_LIMIT : integer := 100000000
    );
    port (
        clk_in : in  std_logic;
        reset : in  std_logic;
        clk_out : out std_logic
    );
end entity clk_div;

architecture Behavioral of clk_div is
    signal counter : integer range 0 to DIVIDER_LIMIT := 0;
    signal clk_slow : std_logic := '0';
begin

    process(clk_in, reset)
    begin
        if reset = '0' then
            counter  <= 0;
            clk_slow <= '0';
        elsif rising_edge(clk_in) then
            if counter = DIVIDER_LIMIT - 1 then
                counter  <= 0;
                clk_slow <= not clk_slow;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_slow;

end architecture Behavioral;