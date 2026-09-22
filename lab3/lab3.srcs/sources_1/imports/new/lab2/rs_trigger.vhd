library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RsTrigger is
    port(
        clk: in std_logic;
        R: in std_logic;
        S: in std_logic;
        CLR: in std_logic;
        Q: out std_logic;
        not_Q: out std_logic
    );
end RsTrigger;

architecture Structural of RsTrigger is

    signal clk_jk: std_logic;
    signal not_clr: std_logic;

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

begin

    clk_jk <= not clk;

    trigger: JkTrigger
        port map(
            clk => clk_jk,
            K => R,
            J => S,
            Q => Q,
            not_Q => not_Q,
            S => '1',
            R => CLR
        );
    
end Structural;
