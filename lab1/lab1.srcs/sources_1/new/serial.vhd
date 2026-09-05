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

architecture serial of DecoderSerial is
begin
    process(A, E1, E2)
    begin
    
        Y <= (others => '1');
        
        if E1 = '0' and E2 = '0' then
            case A is
                when "0000" => Y(0) <= '1';
                when "0001" => Y(1) <= '1';
                when "0010" => Y(2) <= '1';
                when "0011" => Y(3) <= '1';
                when "0100" => Y(4) <= '1';
                when "0101" => Y(5) <= '1';
                when "0110" => Y(6) <= '1';
                when "0111" => Y(7) <= '1';
                when "1000" => Y(8) <= '1';
                when "1001" => Y(9) <= '1';
                when "1010" => Y(10) <= '1';
                when "1011" => Y(11) <= '1';
                when "1100" => Y(12) <= '1';
                when "1101" => Y(13) <= '1';
                when "1110" => Y(14) <= '1';
                when "1111" => Y(15) <= '1';
                when others => Y <= (others => '1');
            end case;
        end if;
    end process;
end serial;
