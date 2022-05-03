library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity ExecutionUnit is
    Port ( RD1: in STD_LOGIC_VECTOR(15 downto 0);
           RD2: in STD_LOGIC_VECTOR(15 downto 0);
           index_next: in STD_LOGIC_VECTOR(15 downto 0);
           Ext_Imm: in STD_LOGIC_VECTOR(15 downto 0);
           ALUSrc: in STD_LOGIC;
           sa: in STD_LOGIC;
           func: in STD_LOGIC_VECTOR(2 downto 0);
           ALUOp: in STD_LOGIC_VECTOR(1 downto 0);
           Zero: out STD_LOGIC;
           notZero : out STD_LOGIC;
           greater : out STD_LOGIC;
           ALURes: out STD_LOGIC_VECTOR(15 downto 0);
           BAdress: out STD_LOGIC_VECTOR(15 downto 0)  );
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is
signal rez: std_logic_vector(15 downto 0);
signal temp: STD_LOGIC_VECTOR(15 downto 0);
begin
    -- calculul adresei de branch
    BAdress <= Ext_Imm + index_next;
    
    process(RD1, RD2, ALUSrc, sa, func, ALUOp)
    begin
        --selectam sursa
        if(ALUSrc = '0') then
                temp <= RD2;
        else
            temp <= Ext_Imm;
        end if;
        case(ALUOp) is
            when "10" => 
                case(func) is
                    when "000" => ALURes <= RD1+temp;
                    when "001" => ALURes <= RD1-temp;
                    when "010" => 
                        if sa = '1' then
                            ALURes <= RD1(14 downto 0) & "0";
                        else
                            ALURes <= RD1;
                        end if;
                   when "011" =>
                         if sa = '1' then
                               ALURes <= "0" & RD1(15 downto 1);
                           else
                               ALURes <= RD1;
                           end if;
                   when "100" => ALURes <= RD1 and temp;
                   when "101" => ALURes <= RD1 or temp;
                   -- when "110" => ALURes <= std_logic_vector(unsigned(RD1) * unsigned(temp));    -- am ales inmultirea si impartirea pentru
                   -- when others => ALURes <= std_logic_vector(unsigned(RD1) \ unsigned(temp));   -- operatiile de tip r
                   when others => null;                                                           -- in program folosesc scaderi repetate
               end case;
           when "11" =>
               ALURes <= RD1 or temp;
           when "00" =>
               ALURes <= RD1 + temp;
           when "01" =>
               rez <= RD1 - temp;
               -- setam semnalele pentru beq si bneq
               if(rez = x"0000") then
                    Zero <= '1';
                    notZero <= '0';
               else
                    Zero <= '0';
                    notZero <= '1';
               end if;
               -- setam semnalul pentru bg
               if(rez > x"0000") then
                    greater <= '1';
               else
                    greater <= '0';
               end if;
           end case;
    end process;
end Behavioral;
