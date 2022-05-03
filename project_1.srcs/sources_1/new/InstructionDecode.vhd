library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity InstructionDecode is
    Port ( clk : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR(15 downto 0);
           WD : in STD_LOGIC_VECTOR(15 downto 0);
           regWrite : in STD_LOGIC;
           regDst : in STD_LOGIC;
           extOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC );
end InstructionDecode;

architecture Behavioral of InstructionDecode is

type reg_mem is array(0 to 15) of std_logic_vector(15 downto 0);

-- registrele sunt initiate cu 0
signal reg_file : reg_mem := ( others => x"0000" );
signal WA : STD_LOGIC_VECTOR(2 downto 0);

begin

    RD1 <= reg_file(conv_integer(unsigned(instr(12 downto 9))));
    RD2 <= reg_file(conv_integer(unsigned(instr(9 downto 7))));
    
    process(clk, regWrite)
    begin
        if rising_edge(clk) then
            if regWrite = '1' then
                reg_file(conv_integer(unsigned(WA))) <= WD;
            end if;
        end if;
    end process;
    
    process(instr(6 downto 0), extOp)
    begin
        case extOp is
            when '0' => ext_imm <= "000000000" & instr(6 downto 0);
            when others => ext_imm <= instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6 downto 0);
        end case;
    end process;
    
    process(instr(9 downto 4), regDst)
    begin
        case regDst is
            when '0' => WA <= instr(9 downto 7);
            when others => WA <= instr(6 downto 4);
        end case;
    end process;
    
    func <= instr(2 downto 0);
    sa <= instr(3);
end Behavioral;
