library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
  Port ( CLK : in std_logic;
         ALURes : in std_logic_vector (15 downto 0);
         RD2 : in std_logic_vector (15 downto 0);
         MemWrite : in std_logic;
         MemData : out std_logic_vector(15 downto 0) );
end MEM;

architecture Behavioral of MEM is

--memorie de 32 cuvinte de 16 biti
type ram_mem is array (0 to 4) of std_logic_vector(15 downto 0);

--initializam memoria cu cateva valori care trebuie calculate
signal ram : ram_mem := 
    ( x"00AA",
      x"0BA7",
      x"783A",
      x"3100",
      x"0100",
      others => x"0000" );
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if MemWrite = '1' then
                ram(conv_integer(unsigned(ALURes))) <= RD2;
            end if;
        end if;
        MemData <= ram(conv_integer(unsigned(ALURes)));
    end process;
end Behavioral;
