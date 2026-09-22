library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab1_ref_tb is
end entity lab1_ref_tb;

architecture ref_tb of lab1_ref_tb is

    component DecoderParallel
        port (
            E1 : in std_logic;
            E2 : in std_logic;
            A : in std_logic_vector(3 downto 0);
            Y : out std_logic_vector(15 downto 0)
        );
    end component;

    component DecoderSequential
        port (
            E1 : in std_logic;
            E2 : in std_logic;
            A : in std_logic_vector(3 downto 0);
            Y : out std_logic_vector(15 downto 0)
        );
    end component;

    signal E1 : std_logic := '1';
    signal E2 : std_logic := '1';
    signal A : std_logic_vector(3 downto 0) := (others => '0');

    signal Y_uut : std_logic_vector(15 downto 0);
    signal Y_ref : std_logic_vector(15 downto 0);

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

    uut_inst : DecoderParallel
        port map (
            E1 => E1,
            E2 => E2,
            A => A,
            Y => Y_uut
        );

    ref_inst : DecoderSequential
        port map (
            E1 => E1,
            E2 => E2,
            A => A,
            Y => Y_ref
        );

    process
        variable err_count : integer := 0;
    begin
        wait for 10 ns;

        -- E1: 0 и 1
        for e1_val in 0 to 1 loop
            -- E2: 0 и 1
            for e2_val in 0 to 1 loop
                -- A: от 0 до 15
                for a_val in 0 to 15 loop

                    if e1_val = 0 then E1 <= '0'; else E1 <= '1'; end if;
                    if e2_val = 0 then E2 <= '0'; else E2 <= '1'; end if;
                    A <= std_logic_vector(to_unsigned(a_val, 4));

                    wait for 10 ns;

                    if Y_uut /= Y_ref then
                        err_count := err_count + 1;
                        report "Mismatch at test : " & LF &
                               "Inputs: E1=" & std_logic'image(E1) & 
                               " E2=" & std_logic'image(E2) & 
                               " A=" & to_str(A) & LF &
                               " UUT output: " & to_str(Y_uut) & LF &
                               " REF output: " & to_str(Y_ref)
                            severity error;
                    end if;

                end loop;
            end loop;
        end loop;

        if err_count = 0 then
            report "Tests matched with reference" & LF severity note;
        else
            report "Found " & integer'image(err_count) & 
                   " mismatches" & LF severity failure;
        end if;

        wait;
    end process;

end architecture ref_tb;