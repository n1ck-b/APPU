library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JkTriggerTb is
end JkTriggerTb;

architecture sim of JkTriggerTb is

    component JkTrigger
        port(
            J: in std_logic;
            K: in std_logic;
            clk: in std_logic;
            R: in std_logic;
            S: in std_logic;
            Q: out std_logic;
            not_Q: out std_logic
        );
    end component;
    
    signal j: std_logic := '1';
    signal k: std_logic := '1';
    signal r: std_logic := '1';
    signal s: std_logic := '1';
    signal clk: std_logic := '0';
    signal q: std_logic;
    signal not_q: std_logic;

begin
    
    uut: JkTrigger
        port map(
            J => j,
            K => k,
            clk => clk,
            R => r,
            S => s,
            Q => q,
            not_Q => not_q
        );
    
    process
    begin
        wait for 10ns;
        clk <= not clk;
    end process;
    
    process
    begin
        wait for 20ns;
        r <= '0';
        
        wait for 20ns;
        r <= '1';
        
        wait for 40ns;
        s <= '0';
        
        wait for 20ns;
        s <= '1';
        j <= '0';
        
        wait for 20ns;
        j <= '1';
        k <= '0';

        wait for 20ns;
        k <= '1';
        
        wait;
    end process;

end sim;