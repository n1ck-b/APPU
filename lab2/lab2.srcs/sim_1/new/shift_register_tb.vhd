library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegisterTb is
end entity;

architecture sim of ShiftRegisterTb is

    component ShiftRegister
        port(
            load_shift: in std_logic;
            serial: in std_logic;
            clk: in std_logic;
            clear: in std_logic;
            output_control: in std_logic;
            A, B, C, D: in std_logic;
            QA, QB, QC, QD: out std_logic;
            QD_cascade: out std_logic
        );
    end component;
    
    signal load_shift: std_logic := '1';
    signal serial: std_logic := '0';
    signal clk: std_logic := '0';
    signal clear: std_logic := '1';
    signal output_control: std_logic := '0';
    signal A, B, C, D: std_logic := '0';
    signal QA, QB, QC, QD: std_logic;
    signal QD_cascade: std_logic;

begin

    uut: ShiftRegister
        port map (
            load_shift => load_shift,
            serial => serial,
            clk => clk,
            clear => clear,
            output_control => output_control,
            A => A, 
            B => B, 
            C => C, 
            D => D,
            QA => QA, 
            QB => QB, 
            QC => QC, 
            QD => QD,
            QD_cascade => QD_cascade
        );
        
    process
    begin
        wait for 10ns;
        clk <= not clk;
    end process;
    
    process
    begin
        wait for 20ns;
        -- cброс (CLEAR = 0), OC = 0
        output_control <= '0';
        clear <= '0';
        wait for 10ns;
        clear <= '1';
        wait for 20ns;
        
        -- gараллельная загрузка 1010, OC = 0
        output_control <= '0';
        load_shift <= '1';
        A <= '1'; 
        B <= '0'; 
        C <= '1'; 
        D <= '0';
        wait until falling_edge(clk);
        
        -- gараллельная загрузка 1101, OC = 1
        wait until clk = '1';
        output_control <= '1';
        A <= '1'; 
        B <= '1'; 
        C <= '0'; 
        D <= '1';
        wait until falling_edge(clk);
        
        -- cдвиг, SERIAL = 1, OC = 0
        wait until clk = '1';
        output_control <= '0';
        load_shift <= '0';
        serial <= '1';
        wait until falling_edge(clk);
        
        -- cдвиг, SERIAL = 0, OC = 0
        wait until clk = '1';
        serial <= '0';
        wait until falling_edge(clk);
        
        -- cдвиг, SERIAL = 1, OC = 1
        wait until clk = '1';
        output_control <= '1';
        serial <= '1';
        wait until falling_edge(clk);
        
        -- сдвиг, SERIAL = 0, OC = 1
        wait until clk = '1';
        serial <= '0';
        wait until falling_edge(clk);
        
        -- хранение: LOAD = 1
        wait until clk = '1';
        output_control <= '0';
        load_shift <= '1';
        A <= '0'; 
        B <= '0'; 
        C <= '0'; 
        D <= '0';
        wait for 10ns;
        
        -- параллельная загрузка 1111, OC = 0
        wait until clk = '1';
        A <= '1'; 
        B <= '1'; 
        C <= '1'; 
        D <= '1';
        wait until falling_edge(clk);
        
        -- сброс при OC = 1
        wait for 10ns;
        output_control <= '1';
        clear <= '0';
        wait for 10ns;
        clear <= '1';
        wait for 40ns;
        wait;
    end process;

end sim;