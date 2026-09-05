library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecoderSerial is
    Port(
        E1: in std_logic;
        E2: in std_logic;
        A: in std_logic_vector(3 downto 0);
        Y: out std_logic_vector(15 downto 0)
    );
end DecoderSerial;

architecture Behavioral of DecoderSerial is
begin
    process(A, E1, E2)
        variable E: std_logic;
    begin
        E := not E1 and not E2;
        
        if E = '1' then
            Y(0) <= not(not A(0) and not A(1) and not A(2) and not A(3));
            Y(1) <= not(A(0) and not A(1) and not A(2) and not A(3));
            Y(2) <= not(not A(0) and A(1) and not A(2) and not A(3));
            Y(3) <= not(A(0) and A(1) and not A(2) and not A(3));
            Y(4) <= not(not A(0) and not A(1) and A(2) and not A(3));
            Y(5) <= not(A(0) and not A(1) and A(2) and not A(3));
            Y(6) <= not(not A(0) and A(1) and A(2) and not A(3));
            Y(7) <= not(A(0) and A(1) and A(2) and not A(3));
            Y(8) <= not(not A(0) and not A(1) and not A(2) and A(3));
            Y(9) <= not(A(0) and not A(1) and not A(2) and A(3));
            Y(10) <= not(not A(0) and A(1) and not A(2) and A(3));
            Y(11) <= not(A(0) and A(1) and not A(2) and A(3));
            Y(12) <= not(not A(0) and not A(1) and A(2) and A(3));
            Y(13) <= not(A(0) and not A(1) and A(2) and A(3));
            Y(14) <= not(not A(0) and A(1) and A(2) and A(3));
            Y(15) <= not(A(0) and A(1) and A(2) and A(3));
        end if;
    end process;
end Behavioral;
