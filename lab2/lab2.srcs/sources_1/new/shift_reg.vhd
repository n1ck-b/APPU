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
    
    signal reg_A_in: std_logic;
    signal reg_A_out: std_logic;
    signal reg_A_S_in: std_logic;
    
    signal reg_B_in: std_logic;
    signal reg_B_out: std_logic;
    signal reg_B_S_in: std_logic;
    
    signal reg_C_in: std_logic;
    signal reg_C_out: std_logic;
    signal reg_C_S_in: std_logic;
    
    signal reg_D_in: std_logic;
    signal reg_D_out: std_logic;
    signal reg_D_S_in: std_logic;

begin
    reg_A_in <= (A and load_shift) nor (not(load_shift) and serial);
    reg_A_S_in <= not reg_A_in;
    QA <= reg_A_out when output_control = '0' else 'Z';
    
    reg_A: RsTrigger
        port map(
            S => reg_A_S_in,
            R => reg_A_in,
            clk => clk,
            CLR => clear,
            Q => reg_A_out,
            not_Q => open
        );
        
        
    reg_B_in <= (B and load_shift) nor (not(load_shift) and reg_A_out);
    reg_B_S_in <= not reg_B_in;
    QB <= reg_B_out when output_control = '0' else 'Z';
    
    reg_B: RsTrigger
        port map(
            S => reg_B_S_in,
            R => reg_B_in,
            clk => clk,
            CLR => clear,
            Q => reg_B_out,
            not_Q => open
        );
        
        
    reg_C_in <= (C and load_shift) nor (not(load_shift) and reg_B_out);
    reg_C_S_in <= not reg_C_in;
    QC <= reg_C_out when output_control = '0' else 'Z';
    
    reg_C: RsTrigger
        port map(
            S => reg_C_S_in,
            R => reg_C_in,
            clk => clk,
            CLR => clear,
            Q => reg_C_out,
            not_Q => open
        );
        
        
    reg_D_in <= (D and load_shift) nor (not(load_shift) and reg_C_out);
    reg_D_S_in <= not reg_D_in;
    QD <= reg_D_out when output_control = '0' else 'Z';
    QD_cascade <= reg_D_out;
    
    reg_D: RsTrigger
        port map(
            S => reg_D_S_in,
            R => reg_D_in,
            clk => clk,
            CLR => clear,
            Q => reg_D_out,
            not_Q => open
        );
     
end Structural;
