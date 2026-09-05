library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecoderParallel is
  Port ( 
    E1: in std_logic;
    E2: in std_logic;
    A: in std_logic_vector(3 downto 0);
    Y: out std_logic_vector(15 downto 0)
  );
end DecoderParallel;

architecture Behavioral of DecoderParallel is
    signal E: std_logic;
    signal not_A: std_logic_vector(3 downto 0);
    signal buf_A: std_logic_vector(3 downto 0);
begin
    E <= not E1 and not E2;
    
    not_A <= not A;
    
    buf_A <= not(not_A);
    
    Y(0) <= not(not_A(0) and not_A(1) and not_A(2) and not_A(3) and E);
    Y(1) <= not(buf_A(0) and not_A(1) and not_A(2) and not_A(3) and E);
    Y(2) <= not(not_A(0) and buf_A(1) and not_A(2) and not_A(3) and E);
    Y(3) <= not(buf_A(0) and buf_A(1) and not_A(2) and not_A(3) and E);
    Y(4) <= not(not_A(0) and not_A(1) and buf_A(2) and not_A(3) and E);
    Y(5) <= not(buf_A(0) and not_A(1) and buf_A(2) and not_A(3) and E);
    Y(6) <= not(not_A(0) and buf_A(1) and buf_A(2) and not_A(3) and E);
    Y(7) <= not(buf_A(0) and buf_A(1) and buf_A(2) and not_A(3) and E);
    Y(8) <= not(not_A(0) and not_A(1) and not_A(2) and buf_A(3) and E);
    Y(9) <= not(buf_A(0) and not_A(1) and not_A(2) and buf_A(3) and E);
    Y(10) <= not(not_A(0) and buf_A(1) and not_A(2) and buf_A(3) and E);
    Y(11) <= not(buf_A(0) and buf_A(1) and not_A(2) and buf_A(3) and E);
    Y(12) <= not(not_A(0) and not_A(1) and buf_A(2) and buf_A(3) and E);
    Y(13) <= not(buf_A(0) and not_A(1) and buf_A(2) and buf_A(3) and E);
    Y(14) <= not(not_A(0) and buf_A(1) and buf_A(2) and buf_A(3) and E);
    Y(15) <= not(buf_A(0) and buf_A(1) and buf_A(2) and buf_A(3) and E);
end Behavioral;