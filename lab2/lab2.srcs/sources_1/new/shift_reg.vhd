library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegister is
    port(
        load_shift: in std_logic;
        serial: in std_logic;
        clk: in std_logic;
        clear: in std_logic;
        output_control: in std_logic;
        A, B, C, D: in std_logic;
        QA, QB, QC, QD: out std_logic;
        QD_cascade: out std_logic
    );
end ShiftRegister;

architecture Structural of ShiftRegister is

    component RsTrigger
        port(
            clk: in std_logic;
            R: in std_logic;
            S: in std_logic;
            CLR: in std_logic;
            Q: out std_logic;
            not_Q: out std_logic
        );
    end component;
    
    signal parallel_in : std_logic_vector(0 to 3);
    
    signal shift_chain : std_logic_vector(0 to 4);
    
    signal reg_in      : std_logic_vector(0 to 3);
    signal reg_S_in    : std_logic_vector(0 to 3);
begin
    parallel_in <= (A, B, C, D);
    
    shift_chain(0) <= serial;

    GEN_REG: for i in 0 to 3 generate
    begin
        reg_in(i)   <= (parallel_in(i) and load_shift) nor (not(load_shift) and shift_chain(i));
        reg_S_in(i) <= not reg_in(i);
        reg_inst: RsTrigger
            port map(
                clk   => clk,
                R     => reg_in(i),
                S     => reg_S_in(i),
                CLR   => clear,
                Q     => shift_chain(i + 1),
                not_Q => open
            );
    end generate GEN_REG;
    
    QA <= shift_chain(1) when output_control = '0' else 'Z';
    QB <= shift_chain(2) when output_control = '0' else 'Z';
    QC <= shift_chain(3) when output_control = '0' else 'Z';
    QD <= shift_chain(4) when output_control = '0' else 'Z';
    
    QD_cascade <= shift_chain(4);
     
end Structural;
