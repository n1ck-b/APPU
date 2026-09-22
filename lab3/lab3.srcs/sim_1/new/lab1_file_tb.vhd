library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity lab1_file_tb is
end lab1_file_tb;

architecture file_tb of lab1_file_tb is

    component DecoderParallel 
        port (
            E1: in std_logic;
            E2: in std_logic;
            A: in std_logic_vector(3 downto 0);
            Y: out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal E1: std_logic := '1';
    signal E2: std_logic := '1';
    signal A: std_logic_vector(3 downto 0) := (others => '0');
    signal Y: std_logic_vector(15 downto 0);
    
    file test_file: text;
    
    function to_str(slv : std_logic_vector) return string is
        variable res : string(1 to slv'length);
        variable idx : integer := 1;
    begin
        for i in slv'range loop
            case slv(i) is
                when '0' => res(idx) := '0';
                when '1' => res(idx) := '1';
                when 'Z' => res(idx) := 'Z';
                when others => res(idx) := 'X';
            end case;
            idx := idx + 1;
        end loop;
        return res;
    end function;

begin

    UUT: DecoderParallel
        port map(
            E1 => E1,
            E2 => E2,
            A => A,
            Y => Y
        );
        
    
    process
        variable current_line: line;
        variable E1_v, E2_v: std_logic;
        variable A_v: std_logic_vector(3 downto 0);
        variable Y_expected: std_logic_vector(15 downto 0);
        variable file_status: file_open_status;
        variable is_correct: boolean;
        variable line_num: integer := 0;
    begin
    
        file_open(file_status, test_file, "test_file_decoder.txt", read_mode);
        
        assert file_status = open_ok
            report "FILE NOT FOUND! Check path to test_file_decoder.txt"
            severity failure;
            
        report "Simulation started" & LF severity note;
        
        while not endfile(test_file) loop
            line_num := line_num + 1;
            readline(test_file, current_line);
            
            read(current_line, E1_v, is_correct);
            if is_correct then read(current_line, E2_v, is_correct); end if;
            if is_correct then read(current_line, A_v, is_correct); end if;
            if is_correct then read(current_line, Y_expected, is_correct); end if;
            
            if not is_correct then
                report "Corrupted data in line " & integer'image(line_num) & 
                       " Invalid character encountered. Skipping line." & LF
                    severity error;
                next;
            end if;
            
            E1 <= E1_v;
            E2 <= E2_v;
            A <= A_v;
            
            wait for 10 ns;
            
            if Y /= Y_expected then
                report "Error in line :" & integer'image(line_num) & LF &
                       " E1 = " & std_logic'image(E1) & 
                       " E2 = " & std_logic'image(E2) & 
                       " A = " & to_str(A) &
                       " Expected Y = " & to_str(Y_expected) & 
                       " Got Y = " & to_str(Y) & LF
                    severity error;
            end if;
            
        end loop;
        
        file_close(test_file);
        report "Simulation finished" & LF severity note;
        wait;
        
    end process;

end file_tb;