library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity InstrFetch is
Port ( clk : in STD_LOGIC;
       branch_adress : in STD_LOGIC_VECTOR(15 downto 0);
       jmp_adress : in STD_LOGIC_VECTOR(15 downto 0);
       jmp : in STD_LOGIC;
       branch : in STD_LOGIC;
       instruction : out STD_LOGIC_VECTOR(15 downto 0);
       index_next : out STD_LOGIC_VECTOR(15 downto 0) );
end InstrFetch;

architecture Behavioral of InstrFetch is

type ROM_MEM is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);

signal ROM : ROM_MEM := 
    ( b"010_000_001_0000000",   --0     lw $1, 0($0)
      b"001_000_010_0000010",   --1     addi $2, $0, 2
      b"000_000_000_011_0_000", --2     add $3, $0, $0
      b"000_000_000_100_0_000", --3     add $4, $0, $0
      b"001_000_111_0000001",   --4     addi $7, $0, 1
      b"000_000_001_101_0_000", --5     add $5, $0, $1
      b"000_101_010_101_0_001", --6     sub $5, $5, $2
      b"110_101_000_1111110",   --7     bg $5, $0, -2
      b"100_101_000_0010001",   --8     beq $5, $0, 17
      b"001_000_011_0000001",   --9     addi $3, $0, 1
      b"000_000_001_101_0_000", --10     add $5, $0, $1
      b"001_010_010_0000001",   --11    addi $2, $2, 1
      b"000_101_010_101_0_001", --12    sub $5, $5, $2
      b"110_101_000_1111110",   --13    bg $5, $0, -2
      b"101_000_101_1111011",   --14    bneq $5, $0, -5
      b"000_001_010_001_0_001", --15    sub $1, $1, $2
      b"001_000_110_0000001",   --16    addi $6, $0, 1
      b"110_001_000_1111101",   --17    bg $1, $0, -3
      b"000_000_110_001_0_000", --18    add $1, $0, $6
      b"101_001_111_1110001",   --19    bneq $1, $7, -15
      b"000_000_011_100_0_000", --20    add $5, $0, $3
      b"001_000_001_0000010",   --21    addi $1, $0, 2
      b"000_101_001_101_0_001", --22    sub $5, $5, $1
      b"110_101_000_1111110",   --23    bg $5, $0, -2
      b"100_101_000_0000011",   --24    beq $5, $0, 3
      b"111_0000000010111",     --25    jmp 23
      b"001_011_011_0000001",   --26    addi $3, $3, 1
      b"111_0000000001111",     --27    jmp 15
      b"001_000_100_0000001",   --28    addi $4, $0, 1
      b"001_000_011_011_0_000",   --29    add $3, $0, $3
      b"001_000_100_100_0_000",   --30    add $4, $0, $4
      others => x"0000" );
      
signal PC : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal next_instr : STD_LOGIC_VECTOR(15 downto 0);
signal mux_temp1 : STD_LOGIC_VECTOR(15 downto 0);
signal mux_temp2 : STD_LOGIC_VECTOR(15 downto 0);
signal indx_next_temp : STD_LOGIC_VECTOR(15 downto 0);
begin
    
    -- PC
    process(clk)
    begin
        if rising_edge(clk) then
            PC <= mux_temp2;
        end if;
    end process;
    
    -- Next instruction
    indx_next_temp <= PC + 1;
    index_next <= indx_next_temp;
    
    -- ROM -> instructiune
    instruction <= ROM(conv_integer(unsigned(PC)));
    
    -- MUX 1
    process(branch)
    begin
        if branch = '0' then
            mux_temp1 <= indx_next_temp;
        else
            mux_temp1 <= branch_adress;
        end if;
    end process;
    
    -- MUX 2
    process(jmp)
    begin
        if jmp = '0' then
            mux_temp2 <= mux_temp1;
        else
            mux_temp2 <= jmp_adress;
        end if;
    end process;
end Behavioral;
