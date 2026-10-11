library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_tb is
end entity top_tb;

architecture sim of top_tb is

    component top
        port (
            sysclk_p : in  std_logic;
            sysclk_n : in  std_logic;
            dipswitch : in  std_logic_vector(3 downto 0);
            pushbuttons : in  std_logic_vector(4 downto 0);
            ledsmain : out std_logic_vector(3 downto 0);
            ledsboard : out std_logic_vector(3 downto 0)
        );
    end component;

    signal sysclk_p : std_logic := '0';
    signal sysclk_n : std_logic := '1';
    signal dipswitch : std_logic_vector(3 downto 0) := "0000";
    signal pushbuttons : std_logic_vector(4 downto 0) := "00000";
    signal ledsmain : std_logic_vector(3 downto 0);
    signal ledsboard : std_logic_vector(3 downto 0);

    constant CLK_PERIOD : time := 5 ns;

begin

    uut : top
        port map (
            sysclk_p    => sysclk_p,
            sysclk_n    => sysclk_n,
            dipswitch   => dipswitch,
            pushbuttons => pushbuttons,
            ledsmain    => ledsmain,
            ledsboard   => ledsboard
        );

    clk_process : process
    begin
        sysclk_p <= '0';
        sysclk_n <= '1';
        wait for CLK_PERIOD / 2;
        sysclk_p <= '1';
        sysclk_n <= '0';
        wait for CLK_PERIOD / 2;
    end process;

    stim_process : process
    begin
        -- начальное состояние: сброс (dipswitch(0) = '0')
        dipswitch(0) <= '0'; -- clear
        dipswitch(1) <= '1'; -- load_shift
        dipswitch(2) <= '0'; -- serial
        dipswitch(3) <= '0'; -- output_control (выходы включены)
        pushbuttons  <= "00000";
        wait for 40 ns;

        -- Снимаем сброс (dipswitch(0) = '1')
        dipswitch(0) <= '1';
        wait for 40 ns;

        -- Параллельная загрузка слова 1010
        pushbuttons(3 downto 0) <= "0101"; -- D=0, C=1, B=0, A=1
        dipswitch(1) <= '1';              -- load_shift = 1 (Load)
        wait for 80 ns;                   -- ждем срабатывания медленного такта

        -- Переходим в режим сдвига, подаем serial = 1
        dipswitch(1) <= '0'; -- load_shift = 0 (Shift)
        dipswitch(2) <= '1'; -- serial = 1
        wait for 160 ns;     -- наблюдаем последовательный сдвиг единиц на ledsmain

        -- Подаем serial = 0
        dipswitch(2) <= '0'; -- serial = 0
        wait for 160 ns;     -- наблюдаем сдвиг нулей

        -- Проверяем Output Control (перевод в 'Z')
        dipswitch(3) <= '1'; -- OC = 1
        wait for 80 ns;      -- ledsmain должны стать 'Z', а ledsboard(0) показывать каскад

        dipswitch(3) <= '0'; -- возвращаем выходы
        wait for 80 ns;

        wait;
    end process;

end architecture sim;