library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
    
entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
     Port ( en : out STD_LOGIC;
            input : in STD_LOGIC;
            clk : in STD_LOGIC);
end component;

component SSD is
    Port ( number : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component InstrFetch is
    Port ( clk : in STD_LOGIC;
           branch_adress : in STD_LOGIC_VECTOR(15 downto 0);
           jmp_adress : in STD_LOGIC_VECTOR(15 downto 0);
           jmp : in STD_LOGIC;
           branch : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR(15 downto 0);
           index_next : out STD_LOGIC_VECTOR(15 downto 0) );
end component;

component ControlUnit is
    Port ( instr : in STD_LOGIC_VECTOR(2 downto 0);
           regDst : out STD_LOGIC;
           extOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           branchEqual : out STD_LOGIC;
           branchNotEqual : out STD_LOGIC;
           branchGreater : out STD_LOGIC;
           jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
           memWrite : out STD_LOGIC;
           memToReg : out STD_LOGIC;
           regWrite : out STD_LOGIC );
end component;

component InstructionDecode is
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
end component;

component ExecutionUnit is
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
end component;

component MEM is
      Port ( CLK : in std_logic;
             ALURes : in std_logic_vector (15 downto 0);
             RD2 : in std_logic_vector (15 downto 0);
             MemWrite : in std_logic;
             MemData : out std_logic_vector(15 downto 0) );
end component;

--semnal pentru MPG
signal en : STD_LOGIC;

--semnale pentru IF
signal br_adr : STD_LOGIC_VECTOR(15 downto 0);
signal j_adr : STD_LOGIC_VECTOR(15 downto 0);
signal instr : STD_LOGIC_VECTOR(15 downto 0);
signal indx_nxt : STD_LOGIC_VECTOR(15 downto 0);

--semnal pentru SSD
signal to_be_showed : STD_LOGIC_VECTOR(15 downto 0);

--semnale pentru CU
signal regDst : STD_LOGIC;
signal extOp : STD_LOGIC;
signal ALUSrc : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
signal regWrite : STD_LOGIC;
signal branchEqual : STD_LOGIC;
signal branchNotEqual : STD_LOGIC;
signal branchGreater : STD_LOGIC;
signal jump : STD_LOGIC;
signal memWrite : STD_LOGIC;
signal memToReg : STD_LOGIC;
signal PCSrc : STD_LOGIC;

--semnale pentru ID
signal RD1 : STD_LOGIC_VECTOR (15 downto 0);
signal RD2 : STD_LOGIC_VECTOR (15 downto 0);
signal Ext_Imm : STD_LOGIC_VECTOR (15 downto 0);
signal func : STD_LOGIC_VECTOR (2 downto 0);
signal sa : STD_LOGIC;

--semnale pentr EU
signal ALURes : STD_LOGIC_VECTOR(15 downto 0);
signal Zero : STD_LOGIC;
signal notZero : STD_LOGIC;
signal greater : STD_LOGIC;

--semnal pentru MEM
signal MemData: STD_LOGIC_VECTOR(15 downto 0);

--semnal pentru WB
signal WD : STD_LOGIC_VECTOR (15 downto 0);

--semnale controlate de mpg
signal regWrite1 : STD_LOGIC;
signal memWrite1 : STD_LOGIC;

begin
    --Semnal de decizie pentru branch           
    PCSrc <= (branchEqual and Zero) or (branchNotEqual and notZero) or (branchGreater and greater);
    
    --partea de WB
    process(memToReg)
    begin
        if(memToReg = '0') then
            WD <= ALURes;
        else
            WD <= MemData;
        end if;
    end process;
    
    --calculul adresei de jump
    j_adr <= indx_nxt(15 downto 13) & instr(12 downto 0);
    
    --pentru controlarea scrierii in blocul de registre/ memorie
    --here can appear some problems!
    process(clk, regWrite, memWrite)
    begin
        if rising_edge(clk) then
            if en = '1' then
                regWrite1 <= regWrite;
                memWrite1 <= memWrite;
            end if;
        end if;
    end process;
    
    --maparea componentelor
    MPG1: MPG port map(en, btn(0), clk);
    instr_f: InstrFetch port map(en, br_adr, j_adr, jump, PCSrc, instr, indx_nxt);
    SSD1: SSD port map(to_be_showed, clk, cat, an);
    CU1 : ControlUnit port map(instr(15 downto 13) ,regDst ,extOp ,ALUSrc ,branchEqual 
                                ,branchNotEqual, branchGreater, jump ,ALUOp ,memWrite ,memToReg ,regWrite );     
    ID1 : InstructionDecode port map(clk, instr, WD, regWrite1, regDst, extOp, RD1, RD2, ext_imm, func, sa);
    EU1: ExecutionUnit port map ( RD1, RD2,indx_nxt, Ext_Imm, ALUSrc, sa, func, ALUOp, Zero, notZero, greater, ALURes, br_adr);    
    MEM1: MEM port map (clk, ALURes, RD2, MemWrite1, MemData);
    
    --ne ocupam de afisare
    process(sw(7 downto 5))
    begin
        case sw(7 downto 5) is
            when "000" => to_be_showed <= instr;
            when "001" => to_be_showed <= indx_nxt;
            when "010" => to_be_showed <= RD1;
            when "011" => to_be_showed <= RD2;
            when "100" => to_be_showed <= Ext_Imm;
            when "101" => to_be_showed <= ALURes;
            when "110" => to_be_showed <= MemData;
            when others => to_be_showed <= WD;
        end case;
    end process;
end Behavioral;