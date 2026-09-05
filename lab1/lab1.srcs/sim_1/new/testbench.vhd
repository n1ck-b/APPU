library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench is
end testbench;

architecture sim of testbench is

    signal E1: std_logic;
    signal E2: std_logic;
    signal A: std_logic_vector(3 downto 0);
    signal Y_parallel: std_logic_vector(15 downto 0);
    signal Y_sequential: std_logic_vector(15 downto 0);

    component DecoderParallel
        Port(
            E1: in std_logic;
            E2: in std_logic;
            A: in std_logic_vector(3 downto 0);
            Y: out std_logic_vector(15 downto 0)
        );
    end component;
    
    component DecoderSequential
        Port(
            E1: in std_logic;
            E2: in std_logic;
            A: in std_logic_vector(3 downto 0);
            Y: out std_logic_vector(15 downto 0)
        );
    end component;
    
begin 

    uut_parallel: DecoderParallel
        port map(
            E1 => E1,
            E2 => E2,
            A => A,
            Y => Y_parallel
        );
        
    uut_sequential: DecoderSequential
        port map(
            E1 => E1,
            E2 => E2,
            A => A,
            Y => Y_sequential
        );
     
     
     sim_process : process
     begin
        
        E1 <= '0';
        E2 <= '0';
        wait for 10ns;
        
        for i in 0 to 15 loop
            A <= std_logic_vector(to_unsigned(i, 4));
            wait for 10ns;
        end loop;
        
        E1 <= '1';
        E2 <= '0';
        wait for 10ns;
        
        for i in 0 to 15 loop
            A <= std_logic_vector(to_unsigned(i, 4));
            wait for 10ns;
        end loop;
        
        E1 <= '0';
        E2 <= '1';
        wait for 10ns;
        
        for i in 0 to 15 loop
            A <= std_logic_vector(to_unsigned(i, 4));
            wait for 10ns;
        end loop;
        
        E1 <= '1';
        E2 <= '1';
        wait for 10ns;
        
        for i in 0 to 15 loop
            A <= std_logic_vector(to_unsigned(i, 4));
            wait for 10ns;
        end loop;
        
     end process;

end sim;
