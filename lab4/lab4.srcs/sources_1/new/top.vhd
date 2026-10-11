library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
    port (
        sysclk_p : in  std_logic;
        sysclk_n : in  std_logic;
        
        dipswitch : in  std_logic_vector(3 downto 0);
        
        pushbuttons : in  std_logic_vector(4 downto 0);
        
        ledsmain : out std_logic_vector(3 downto 0);
        
        ledsboard : out std_logic_vector(3 downto 0)
    );
end entity top;

architecture Structural of top is

    component clk_div
        generic (
            DIVIDER_LIMIT : integer := 100000000
        );
        port (
            clk_in : in  std_logic;
            reset : in  std_logic;
            clk_out : out std_logic
        );
    end component;

    component ShiftRegister
        port (
            load_shift : in  std_logic;
            serial : in  std_logic;
            clk : in  std_logic;
            clear : in  std_logic;
            output_control : in  std_logic;
            A, B, C, D : in  std_logic;
            QA, QB, QC, QD : out std_logic;
            QD_cascade : out std_logic
        );
    end component;

    signal clk_200mhz : std_logic;

    signal clk_slow : std_logic;

    signal rst_n : std_logic;

begin

    -- Сброс с тумблера dipswitch(0)
    rst_n <= dipswitch(0);

    -- Буфер IBUFDS для приёма дифференциального такта 200 МГц
    clk_buf : IBUFDS
        generic map (
            DIFF_TERM => FALSE,
            IBUF_LOW_PWR => TRUE,
            IOSTANDARD => "LVDS_25"
        )
        port map (
            I  => sysclk_p,
            IB => sysclk_n,
            O  => clk_200mhz
        );

    -- Делитель частоты
    divider_inst : clk_div
        generic map (
            DIVIDER_LIMIT => 100000000
        )
        port map (
            clk_in  => clk_200mhz,
            reset   => rst_n,
            clk_out => clk_slow
        );

    -- Сдвиговый регистр
    shift_reg_inst : ShiftRegister
        port map (
            clk => clk_slow,
            clear => rst_n,
            load_shift => dipswitch(1),  -- тумблер режима
            serial => dipswitch(2),  -- тумблер serial
            output_control => dipswitch(3),  -- тумблер OC
            A => pushbuttons(0),-- кнопка A (P6)
            B => pushbuttons(1),-- кнопка B (R5)
            C => pushbuttons(2),-- кнопка C (U6)
            D => pushbuttons(3),-- кнопка D (U5)
            QA => ledsmain(0),   -- светодиод QA (M26)
            QB => ledsmain(1),   -- светодиод QB (T24)
            QC => ledsmain(2),   -- светодиод QC (T25)
            QD => ledsmain(3),   -- светодиод QD (R26)
            QD_cascade => ledsboard(0)   -- каскадный выход на внешний светодиод (F25)
        );

    ledsboard(3 downto 1) <= "000";

end architecture Structural;