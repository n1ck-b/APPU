library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JkTrigger is
    port(
        J: in std_logic;
        K: in std_logic;
        clk: in std_logic;
        R: in std_logic;
        S: in std_logic;
        Q: out std_logic;
        not_Q: out std_logic
    );
end JkTrigger;

architecture Behavioral of JkTrigger is
    signal Q_int: std_logic := '0';
begin
    process(clk, R, S)
    begin
        if R = '1' then
            Q_int <= '0';
        elsif S = '1' then
            Q_int <= '1';
        elsif clk'event and clk = '1' then
            if J = '0' and K = '0' then
                Q_int <= Q_int;
            elsif J = '0' and K = '1' then
                Q_int <= '0';
            elsif J = '1' and K = '0' then
                Q_int <= '1';
            else
                Q_int <= not Q_int;
            end if;
        end if;
        
    end process;
    
    Q <= Q_int;
    not_Q <= not Q_int;
end Behavioral;
