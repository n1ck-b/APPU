library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity lab2_file_tb is
end entity lab2_file_tb;

architecture file_tb of lab2_file_tb is

    component ShiftRegister
        port(
            load_shift : in std_logic;
            serial : in std_logic;
            clk : in std_logic;
            clear : in std_logic;
            output_control : in std_logic;
            A, B, C, D : in std_logic;
            QA, QB, QC, QD : out std_logic;
            QD_cascade : out std_logic
        );
    end component;

    signal load_shift : std_logic := '1';
    signal serial : std_logic := '0';
    signal clk : std_logic := '0';
    signal clear : std_logic := '1';
    signal output_control : std_logic := '0';
    signal A, B, C, D : std_logic := '0';
    signal QA, QB, QC, QD : std_logic;
    signal QD_cascade : std_logic;

    file test_file : text;

begin

    uut: ShiftRegister
        port map (
            load_shift => load_shift,
            serial => serial,
            clk => clk,
            clear => clear,
            output_control => output_control,
            A => A, B => B, C => C, D => D,
            QA => QA, QB => QB, QC => QC, QD => QD,
            QD_cascade => QD_cascade
        );

    clk_process : process
    begin
        wait for 10 ns;
        clk <= not clk;
    end process;

    test_process : process
        variable current_line : line;
        variable clear_v : std_logic;
        variable load_shift_v : std_logic;
        variable output_control_v : std_logic;
        variable serial_v : std_logic;
        variable A_v, B_v, C_v, D_v : std_logic;
        
        variable exp_QA, exp_QB, exp_QC, exp_QD : std_logic;
        variable exp_QD_cascade : std_logic;
        
        variable err_cnt : integer := 0;
        variable file_status: file_open_status;
    begin
        wait for 20 ns;

        file_open(file_status, test_file, "test_file_register.txt", read_mode);
        
        assert file_status = open_ok
            report "FILE NOT FOUND! Check path to test_file_register.txt"
            severity failure;

        while not endfile(test_file) loop
            readline(test_file, current_line);

            read(current_line, clear_v);
            read(current_line, load_shift_v);
            read(current_line, output_control_v);
            read(current_line, serial_v);
            read(current_line, A_v);
            read(current_line, B_v);
            read(current_line, C_v);
            read(current_line, D_v);

            read(current_line, exp_QA);
            read(current_line, exp_QB);
            read(current_line, exp_QC);
            read(current_line, exp_QD);
            read(current_line, exp_QD_cascade);

            wait until clk = '1';
            clear <= clear_v;
            load_shift <= load_shift_v;
            output_control <= output_control_v;
            serial <= serial_v;
            A <= A_v;
            B <= B_v;
            C <= C_v;
            D <= D_v;

            wait until falling_edge(clk);
            wait for 2 ns;

            if (QA /= exp_QA) or (QB /= exp_QB) or 
               (QC /= exp_QC) or (QD /= exp_QD) or 
               (QD_cascade /= exp_QD_cascade) then
               
                err_cnt := err_cnt + 1;
                report "ERROR at step :" & LF &
                       "Inputs:   clear=" & std_logic'image(clear) & 
                               " load_shift=" & std_logic'image(load_shift) & 
                               " output_control=" & std_logic'image(output_control) & 
                               " serial=" & std_logic'image(serial) & 
                               " A=" & std_logic'image(A) & 
                               " B=" & std_logic'image(B) & 
                               " C=" & std_logic'image(C) & 
                               " D=" & std_logic'image(D) & LF &
                       "Expected: QA=" & std_logic'image(exp_QA) & 
                               " QB=" & std_logic'image(exp_QB) & 
                               " QC=" & std_logic'image(exp_QC) & 
                               " QD=" & std_logic'image(exp_QD) & 
                               " QD cascade=" & std_logic'image(exp_QD_cascade) & LF &
                       "Got:      QA=" & std_logic'image(QA) & 
                               " QB=" & std_logic'image(QB) & 
                               " QC=" & std_logic'image(QC) & 
                               " QD=" & std_logic'image(QD) & 
                               " QD cascade=" & std_logic'image(QD_cascade)
                    severity error;
            end if;

        end loop;

        file_close(test_file);

        if err_cnt = 0 then
            report "All test passed" & LF severity note;
        else
            report "Test finished with " & integer'image(err_cnt) & " errors" & LF severity failure;
        end if;

        wait;
    end process;

end architecture file_tb;