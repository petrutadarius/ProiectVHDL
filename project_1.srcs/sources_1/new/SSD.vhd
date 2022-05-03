library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
    Port ( number : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is

signal outp0 : std_logic_vector (6 downto 0) := b"1000000";
signal outp1 : std_logic_vector (6 downto 0) := b"1111001";
signal outp2 : std_logic_vector (6 downto 0) := b"0100100";
signal outp3 : std_logic_vector (6 downto 0) := b"0110000";
signal outp4 : std_logic_vector (6 downto 0) := b"0011001";
signal outp5 : std_logic_vector (6 downto 0) := b"0010010";
signal outp6 : std_logic_vector (6 downto 0) := b"0000010";
signal outp7 : std_logic_vector (6 downto 0) := b"1111000";
signal outp8 : std_logic_vector (6 downto 0) := b"0000000";
signal outp9 : std_logic_vector (6 downto 0) := b"0010000";
signal outp10 : std_logic_vector (6 downto 0) := b"0001000";
signal outp11 : std_logic_vector (6 downto 0) := b"0000011";
signal outp12 : std_logic_vector (6 downto 0) := b"1000110";
signal outp13 : std_logic_vector (6 downto 0) := b"0100001";
signal outp14 : std_logic_vector (6 downto 0) := b"0000110";
signal outp15 : std_logic_vector (6 downto 0) := b"0001110";

signal s : std_logic_vector (15 downto 0);
signal o : std_logic_vector (3 downto 0);

begin
    process(s(15 downto 14), number)
    begin
        case s(15 downto 14) is
            when "00" => o <= number(3 downto 0);
            when "01" => o <= number(7 downto 4);
            when "10" => o <= number(11 downto 8);
            when others => o <= number(15 downto 12);
        end case;
    end process;
    
    process(s(15 downto 14))
    begin
        case s(15 downto 14) is
            when "00" => an <= b"1110";
            when "01" => an <= b"1101";
            when "10" => an <= b"1011";
            when others => an <= b"0111";
        end case;
    end process;
        
    process(o)
    begin
        case o is
            when "0000" => cat <= outp0;
            when "0001" => cat <= outp1;
            when "0010" => cat <= outp2;
            when "0011" => cat <= outp3;
            when "0100" => cat <= outp4;
            when "0101" => cat <= outp5;
            when "0110" => cat <= outp6;
            when "0111" => cat <= outp7;
            when "1000" => cat <= outp8;
            when "1001" => cat <= outp9;
            when "1010" => cat <= outp10;
            when "1011" => cat <= outp11;
            when "1100" => cat <= outp12;
            when "1101" => cat <= outp13;
            when "1110" => cat <= outp14;
            when others => cat <= outp15;
        end case;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            s <= s + 1;
        end if;
    end process;
end Behavioral;
